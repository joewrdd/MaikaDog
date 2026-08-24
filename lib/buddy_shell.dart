import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import 'buddy_brain.dart';
import 'cast.dart';
import 'characters/houses/houses.dart';
import 'field_notes.dart';
import 'progression.dart';
import 'sidekick.dart';
import 'yard.dart';

const _ink = Color(0xFF33251D);
const _paper = Color(0xFFFFF6E9);
const _golden = Color(0xFFE5B266);
const _ballGreen = Color(0xFFB9D45B);
const _blush = Color(0xFFF08A70);

const _cardPaper = BoxDecoration(
  color: _paper,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(22),
    bottomLeft: Radius.circular(19),
    bottomRight: Radius.circular(21),
  ),
  border: Border.fromBorderSide(BorderSide(color: _ink, width: 1.8)),
  boxShadow: [
    BoxShadow(color: Color(0x3833251D), blurRadius: 10, offset: Offset(0, 4)),
  ],
);

Future<void> _exportCard(GlobalKey boundaryKey, String filename) async {
  try {
    final boundary =
        boundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) return;
    final image = await boundary.toImage(pixelRatio: 3);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) return;
    final home = Platform.environment['HOME'] ?? '.';
    final path = '$home/Desktop/$filename.png';
    await File(path).writeAsBytes(data.buffer.asUint8List());
    await Process.run('open', ['-R', path]);
  } catch (_) {}
}

class BuddyShell extends StatefulWidget {
  const BuddyShell({super.key, required this.brain});

  final BuddyBrain brain;

  @override
  State<BuddyShell> createState() => _BuddyShellState();
}

class _BuddyShellState extends State<BuddyShell>
    with SingleTickerProviderStateMixin {
  static const _fps = 12;
  static const _perfDuration = 1.15;
  static const _morphDuration = 0.42;
  static const _turnDuration = 0.4;

  late final Ticker _ticker;
  int _tick = 0;
  double? _perfStart;
  int _seenNonce = 0;
  double? _morphStart;
  late CharacterMood _prevMood = widget.brain.mood;
  late CharacterMood _lastMood = widget.brain.mood;
  double _landPulse = 0;
  BuddyMode _lastMode = BuddyMode.idle;
  double? _turnInStart;
  double? _turnBackStart;
  double? _walkStart;
  bool _ballDrag = false;
  bool _dragging = false;
  bool _suppressTap = false;
  Offset _downScreen = Offset.zero;
  VelocityTracker? _dragVel;
  double? _barkStart;
  int _seenBark = 0;
  double? _flightStart;
  Offset _flightVel = Offset.zero;
  Offset _flightFrom = Offset.zero;
  bool _yardMenuOpen = false;

  double get _now => _tick / _fps;

  @override
  void initState() {
    super.initState();
    _seenNonce = widget.brain.performNonce;
    widget.brain.addListener(_onBrain);
    _ticker = createTicker((elapsed) {
      final tick = elapsed.inMilliseconds * _fps ~/ 1000;
      if (tick != _tick) {
        setState(() {
          _tick = tick;
          if (_landPulse > 0) {
            _landPulse = (_landPulse - 0.34).clamp(0.0, 1.0);
          }
        });
      }
    })..start();
  }

  void _onBrain() {
    final brain = widget.brain;
    if (brain.performNonce != _seenNonce) {
      _seenNonce = brain.performNonce;
      if (brain.mode == BuddyMode.tossed) {
        _landPulse = 1;
      } else {
        _perfStart ??= _now;
      }
    }
    if (brain.barkNonce != _seenBark) {
      _seenBark = brain.barkNonce;
      _barkStart = _now;
    }
    if (brain.mood != _lastMood) {
      _prevMood = _lastMood;
      _lastMood = brain.mood;
      _morphStart = _now;
    }
    if (brain.mode != _lastMode) {
      final entering =
          brain.mode == BuddyMode.walking || brain.mode == BuddyMode.fetching;
      final leaving =
          _lastMode == BuddyMode.walking || _lastMode == BuddyMode.fetching;
      if (entering && !leaving) {
        _turnInStart = _now;
        _walkStart = _now;
        _turnBackStart = null;
      } else if (leaving && !entering) {
        _turnBackStart = _now;
        _turnInStart = null;
        _walkStart = null;
      }
      _lastMode = brain.mode;
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.brain.removeListener(_onBrain);
    _ticker.dispose();
    super.dispose();
  }

  double? get _barkPhase {
    final start = _barkStart;
    if (start == null) return null;
    final phase = (_now - start) / 1.15;
    if (phase >= 1) return null;
    return phase;
  }

  double? get _perfPhase {
    final start = _perfStart;
    if (start == null) return null;
    final phase =
        (_now - start) * widget.brain.character.motion.tempo / _perfDuration;
    if (phase >= 1) return null;
    return phase;
  }

  (CharacterMood, double, double) get _morph {
    final start = _morphStart;
    if (start == null) return (widget.brain.mood, 1, 1);
    final phase = (_now - start) / _morphDuration;
    if (phase >= 1) return (widget.brain.mood, 1, 1);
    if (phase < 0.4) {
      final a = phase / 0.4;
      return (_prevMood, 1 + 0.14 * a, 1 - 0.3 * a);
    }
    final a = easeOutBack((phase - 0.4) / 0.6);
    return (widget.brain.mood, 1.14 - 0.14 * a, 0.7 + 0.3 * a);
  }

  bool get _traveling =>
      widget.brain.mode == BuddyMode.walking ||
      widget.brain.mode == BuddyMode.fetching;

  (double turn, double turnSquash) get _turn {
    final inStart = _turnInStart;
    if (inStart != null && _traveling) {
      final t = ((_now - inStart) / _turnDuration).clamp(0.0, 1.0);
      return (t, 1 - 0.14 * bell(t));
    }
    final backStart = _turnBackStart;
    if (backStart != null) {
      final t = ((_now - backStart) / _turnDuration).clamp(0.0, 1.0);
      if (t >= 1) return (0, 1);
      return (1 - t, 1 - 0.14 * bell(t));
    }
    return (_traveling ? 1 : 0, 1);
  }

  double get _dogSize =>
      widget.brain.dashboardOpen ||
          widget.brain.statusOpen ||
          widget.brain.fieldNotesOpen ||
          widget.brain.dogTagOpen
      ? 116.0
      : 148.0;

  bool _overEditable(Offset local) {
    final box = context.findRenderObject();
    if (box is! RenderBox) return false;
    final result = BoxHitTestResult();
    box.hitTest(result, position: local);
    return result.path.any((e) => e.target is RenderEditable);
  }

  void _pointerDown(PointerDownEvent event) {
    if (event.buttons & kPrimaryButton == 0 ||
        _overEditable(event.localPosition)) {
      return;
    }
    _suppressTap = false;
    _ballDrag = _hitBall(event.localPosition);
    _dragging = false;
    _downScreen = widget.brain.pos + event.localPosition;
    _dragVel = VelocityTracker.withKind(event.kind)
      ..addPosition(event.timeStamp, _downScreen);
    if (widget.brain.mode != BuddyMode.idle) widget.brain.dragBy(Offset.zero);
  }

  void _pointerMove(PointerMoveEvent event) {
    final vel = _dragVel;
    if (vel == null) return;
    final screen = widget.brain.pos + event.localPosition;
    vel.addPosition(event.timeStamp, screen);
    if (_ballDrag) return;
    if (!_dragging) {
      final travel = screen - _downScreen;
      if (travel.distance < 6) return;
      _dragging = true;
      widget.brain.dragBy(travel);
      return;
    }
    widget.brain.dragBy(event.delta);
  }

  void _pointerUp(PointerUpEvent event) {
    final vel = _dragVel;
    if (vel == null) return;
    _dragVel = null;
    final v = vel.getVelocity().pixelsPerSecond;
    final brain = widget.brain;
    if (_ballDrag) {
      _ballDrag = false;
      if (v.distance > 350 &&
          brain.mode == BuddyMode.idle &&
          !brain.anyPanelOpen) {
        _suppressTap = true;
        setState(() {
          _flightStart = _now;
          _flightVel = v;
          _flightFrom = _ballWindowPos();
        });
        brain.throwBall(v);
      }
    } else if (_dragging) {
      _dragging = false;
      _suppressTap = true;
      brain.dragEnd(v);
    }
  }

  void _pointerCancel(PointerCancelEvent event) {
    _dragVel = null;
    _ballDrag = false;
    if (_dragging) {
      _dragging = false;
      widget.brain.dragEnd(Offset.zero);
    }
  }

  Offset _ballWindowPos() {
    final brain = widget.brain;
    final left = (brain.winSize.width - _dogSize) / 2;
    final top = brain.winSize.height - _dogSize;
    return Offset(left + 0.285 * _dogSize, top + 0.795 * _dogSize);
  }

  bool _hitBall(Offset local) {
    if (widget.brain.mode != BuddyMode.idle || widget.brain.denOpen) {
      return false;
    }
    return (local - _ballWindowPos()).distance < 0.13 * _dogSize;
  }

  @override
  Widget build(BuildContext context) {
    final brain = widget.brain;
    final perfPhase = _perfPhase;
    if (perfPhase == null && _perfStart != null) _perfStart = null;
    final (mood, squashX, squashY) = _morph;
    final landSquash = math.sin(math.pi * _landPulse) * 0.16;
    final (turnValue, turnSquash) = _turn;
    double? walkPhase;
    var stretchAmount = 0.0;
    final walkStart = _walkStart;
    if (_traveling && walkStart != null) {
      final e = _now - walkStart;
      if (e > 0.5 && e < 1.35) {
        stretchAmount = bell(((e - 0.55) / 0.8).clamp(0.0, 1.0));
      }
      if (e > 1.15) {
        walkPhase = ((e - 1.15) * 1.5 * brain.character.motion.tempo) % 1.0;
        stretchAmount = math.min(
          stretchAmount,
          1 - ((e - 1.15) * 2).clamp(0.0, 1.0),
        );
      }
    }
    final flip = turnValue > 0.2 ? brain.walkDir.toDouble() : 1.0;
    final dogSize = _dogSize;
    Widget dog = Transform(
      alignment: Alignment.bottomCenter,
      transform: Matrix4.diagonal3Values(
        (squashX + landSquash) * turnSquash * flip,
        squashY - landSquash,
        1,
      ),
      child: SizedBox.square(
        dimension: dogSize,
        child: Stack(
          children: [
            CustomPaint(
              size: Size.square(dogSize),
              painter: FoodCharacterPainter(
                character: brain.character,
                mood: mood,
                time: _now,
                perf: perfPhase,
                lean: brain.lean,
                walk: walkPhase,
                stretch: stretchAmount,
                turn: turnValue,
                bark: _barkPhase,
              ),
            ),
            if (brain.carryingBall)
              Positioned(
                left: 0.80 * dogSize - 8,
                top: 0.30 * dogSize - 8,
                child: const _BallDot(size: 16),
              ),
          ],
        ),
      ),
    );
    return Material(
      type: MaterialType.transparency,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: _pointerDown,
        onPointerMove: _pointerMove,
        onPointerUp: _pointerUp,
        onPointerCancel: _pointerCancel,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (_suppressTap) {
              _suppressTap = false;
              return;
            }
            brain.perform();
          },
          onSecondaryTap: brain.toggleStatusBoard,
          onLongPressStart: (_) {
            if (!_dragging) brain.setHoldYum(true);
          },
          onLongPressEnd: (_) => brain.setHoldYum(false),
          child: SizedBox(
            width: brain.winSize.width,
            height: brain.winSize.height,
            child: brain.denOpen
                ? _denBody(brain, mood, perfPhase)
                : Stack(children: [_columnBody(brain, dog), ..._flightBall()]),
          ),
        ),
      ),
    );
  }

  List<Widget> _flightBall() {
    final start = _flightStart;
    if (start == null) return const [];
    final t = _now - start;
    if (t > 0.7) {
      _flightStart = null;
      return const [];
    }
    final pos = _flightFrom + _flightVel * (t * 0.35);
    final w = widget.brain.winSize;
    if (pos.dx < -20 ||
        pos.dx > w.width + 20 ||
        pos.dy < -20 ||
        pos.dy > w.height + 20) {
      return const [];
    }
    return [
      Positioned(
        left: pos.dx - 8,
        top: pos.dy - 8,
        child: const _BallDot(size: 16),
      ),
    ];
  }

  final Map<String, FoodCharacter> _peerCast = {};

  FoodCharacter _castFor(YardPeer peer) => _peerCast.putIfAbsent(
    '${peer.breedId}/${peer.coatId}/${peer.accessory}',
    () {
      final breed = dogBreedById(peer.breedId);
      return dogCharacter(
        breed,
        breed.coatById(peer.coatId),
        accessory: DogAccessory.values.byName(peer.accessory),
      );
    },
  );

  List<_YardDog> _yardDogs(
    BuddyBrain brain,
    CharacterMood mood,
    double? perfPhase,
  ) {
    final yard = brain.yard;
    final now = DateTime.now();
    double? phaseOf(DateTime? at) {
      if (at == null) return null;
      final p = now.difference(at).inMilliseconds / 1150;
      return p >= 1 ? null : p;
    }

    final dogs = <_YardDog>[
      _YardDog(
        character: brain.character,
        mood: mood,
        x: yard.selfX,
        flip: yard.selfFlip,
        walkPhase: yard.selfAct == YardAct.walk
            ? (_now * 1.5 * brain.character.motion.tempo) % 1.0
            : null,
        perf: perfPhase,
        bark: _barkPhase,
        name: null,
      ),
      for (final peer in yard.room.peers.values)
        () {
          final leavingAt = peer.leavingAt;
          var x = peer.x;
          var flip = peer.flip;
          var walking = peer.act == YardAct.walk;
          if (leavingAt != null) {
            final gone = now.difference(leavingAt).inMilliseconds / 1000;
            final dir = peer.x < 0.5 ? -1.0 : 1.0;
            x = (peer.x + dir * 0.5 * gone).clamp(-0.15, 1.15);
            flip = dir < 0;
            walking = true;
          }
          return _YardDog(
            character: _castFor(peer),
            mood: peer.mood,
            x: x,
            flip: flip,
            walkPhase: walking ? (_now * 1.5) % 1.0 : null,
            perf: phaseOf(peer.performAt),
            bark: phaseOf(peer.barkAt),
            name: peer.name,
          );
        }(),
    ]..sort((a, b) => a.x.compareTo(b.x));
    return dogs;
  }

  Widget _denChip(String label, VoidCallback onTap, {Color bg = _paper}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(11),
            bottomLeft: Radius.circular(9),
            bottomRight: Radius.circular(11),
          ),
          border: Border.all(color: _ink, width: 1.5),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: _ink,
            decoration: TextDecoration.none,
            fontFamily: '.AppleSystemUIFont',
          ),
        ),
      ),
    );
  }

  Widget _yardControls(BuddyBrain brain) {
    final yard = brain.yard;
    final chips = <Widget>[];
    switch (yard.state) {
      case YardState.closed:
        chips.add(_denChip('open the door', () => yard.openDoor()));
        chips.add(_denChip('visit a den', () => yard.browse()));
      case YardState.hosting:
        chips.add(_denChip('close the door', () => yard.closeAll()));
        if (yard.room.peers.isEmpty) {
          chips.add(_denChip('waiting by the door\u{2026}', () {}));
        }
        for (final peer in yard.room.peers.values.where(
          (p) => p.leavingAt == null,
        )) {
          chips.add(
            _denChip(
              'send ${peer.name} home',
              () => yard.kick(peer.id),
              bg: _blush,
            ),
          );
        }
      case YardState.browsing:
        chips.add(_denChip('never mind', () => yard.closeAll()));
        if (yard.dens.isEmpty) {
          chips.add(_denChip('sniffing around\u{2026}', () {}));
        }
        for (final den in yard.dens.take(3)) {
          chips.add(
            _denChip(
              'knock: ${den.name}',
              () => yard.knock(den.id),
              bg: _golden,
            ),
          );
        }
      case YardState.knocking:
        chips.add(_denChip('knocking\u{2026}', () {}));
        chips.add(_denChip('give up', () => yard.closeAll()));
      case YardState.visiting:
        chips.add(_denChip('walk home', () => yard.closeAll()));
    }
    return Wrap(spacing: 6, runSpacing: 6, children: chips);
  }

  Widget _knockCard(BuddyBrain brain, YardKnock knock) {
    final yard = brain.yard;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 9),
      decoration: BoxDecoration(
        color: _paper,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: _ink, width: 1.6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3833251D),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${knock.name} is at the door!',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: _ink,
              decoration: TextDecoration.none,
              fontFamily: '.AppleSystemUIFont',
            ),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _denChip(
                'let them in',
                () => yard.approve(knock.id),
                bg: _golden,
              ),
              const SizedBox(width: 8),
              _denChip('not now', () => yard.ignore(knock.id)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _denBody(BuddyBrain brain, CharacterMood mood, double? perfPhase) {
    final yard = brain.yard;
    final house = dogHouseById(
      yard.roomLive ? yard.roomHouseId : brain.houseId,
    );
    const radius = BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(22),
      bottomLeft: Radius.circular(19),
      bottomRight: Radius.circular(21),
    );
    return Container(
      margin: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      decoration: const BoxDecoration(
        color: _paper,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Color(0x3833251D),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: _ink, width: 1.8),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: yard.roomLive
                    ? _YardPainter(
                        house: house,
                        dogs: _yardDogs(brain, mood, perfPhase),
                        time: _now,
                      )
                    : _DenPainter(
                        house: house,
                        character: brain.character,
                        mood: mood,
                        time: _now,
                        perf: perfPhase,
                        bark: _barkPhase,
                      ),
              ),
            ),
            if (yard.freshNote != null)
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Center(child: _denChip(yard.freshNote!, () {})),
              ),
            if (yard.state == YardState.hosting && yard.knocks.isNotEmpty)
              Positioned(
                top: 62,
                left: 0,
                right: 0,
                child: Center(child: _knockCard(brain, yard.knocks.first)),
              ),
            if (_yardMenuOpen)
              Positioned(
                left: 10,
                right: 10,
                bottom: 8,
                child: _yardControls(brain),
              ),
            Positioned(
              right: 40,
              top: 8,
              child: GestureDetector(
                onTap: () => setState(() => _yardMenuOpen = !_yardMenuOpen),
                child: Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: yard.doorOpen ? _golden : _paper,
                    border: Border.all(
                      color: yard.doorOpen ? _ink : const Color(0x5933251D),
                    ),
                  ),
                  child: const Icon(Icons.meeting_room, size: 14, color: _ink),
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _paper,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(11),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(12),
                  ),
                  border: Border.all(color: _ink, width: 1.6),
                ),
                child: Text(
                  house.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                    decoration: TextDecoration.none,
                    fontFamily: '.AppleSystemUIFont',
                  ),
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                onTap: brain.toggleDen,
                child: Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _paper,
                    border: Border.all(color: const Color(0x5933251D)),
                  ),
                  child: const Icon(Icons.close, size: 14, color: _ink),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _columnBody(BuddyBrain brain, Widget dog) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (brain.dashboardOpen)
          Expanded(child: _DashboardPanel(brain: brain))
        else if (brain.statusOpen)
          Expanded(child: _StatusPanel(brain: brain))
        else if (brain.fieldNotesOpen)
          Expanded(child: _FieldNotesPanel(brain: brain))
        else if (brain.dogTagOpen)
          Expanded(child: _DogTagPanel(brain: brain))
        else
          SizedBox(
            height: 72,
            child: brain.naming
                ? _NamingField(brain: brain)
                : brain.bubbleText == null
                ? null
                : _SpeechBubble(text: brain.bubbleText!),
          ),
        dog,
      ],
    );
  }
}

class _DashboardPanel extends StatelessWidget {
  const _DashboardPanel({required this.brain});

  final BuddyBrain brain;

  @override
  Widget build(BuildContext context) {
    final stats = brain.stats;
    final level = brain.level;
    final next = nextThresholdFor(level);
    final prev = level - 1 < levelThresholds.length
        ? levelThresholds[level - 1]
        : 0;
    final span = next == null ? 1 : (next - prev);
    final progress = next == null
        ? 1.0
        : ((stats.totalTokens - prev) / span).clamp(0.0, 1.0);
    final upcoming = nextUnlocks(level);
    return Container(
      margin: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: _paper,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(22),
          bottomLeft: Radius.circular(19),
          bottomRight: Radius.circular(21),
        ),
        border: Border.all(color: _ink, width: 1.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3833251D),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _golden,
                  shape: BoxShape.circle,
                  border: Border.all(color: _ink, width: 1.8),
                ),
                child: Text(
                  'Lv\n$level',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${brain.petName}’s report',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                    Text(
                      '${formatTokens(stats.totalTokens)} XP total',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0x9933251D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: brain.toggleDashboard,
                child: Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0x5933251D)),
                  ),
                  child: const Icon(Icons.close, size: 14, color: _ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _label(
            next == null
                ? 'MAX LEVEL, SHOW OFF'
                : '${formatTokens((next - stats.totalTokens).clamp(0, next))} TO LV ${level + 1}',
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0x1F33251D),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: _ink, width: 1.4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress == 0 ? 0.02 : progress,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_golden, Color(0xFFF6B84C)],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _chip('today', formatTokens(stats.todayTokens), _ballGreen),
              const SizedBox(width: 8),
              _chip('streak', '${stats.streakDays}d', _blush),
            ],
          ),
          const SizedBox(height: 14),
          _label('LAST 14 DAYS'),
          const SizedBox(height: 4),
          SizedBox(
            height: 56,
            width: double.infinity,
            child: CustomPaint(
              painter: _MiniBarsPainter(values: stats.dailyRecent),
            ),
          ),
          const SizedBox(height: 12),
          _label('COMING UP'),
          const SizedBox(height: 4),
          for (final (lv, label) in upcoming)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x14E5B266),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0x66C98F47)),
                    ),
                    child: Text(
                      'Lv $lv',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFA9741F),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.lock_outline,
                    size: 12,
                    color: Color(0x7333251D),
                  ),
                ],
              ),
            ),
          if (upcoming.isEmpty)
            const Text(
              'Everything is unlocked. Legend.',
              style: TextStyle(fontSize: 12, color: Color(0x9933251D)),
            ),
          const Spacer(),
          Center(
            child: Text(
              'Maika $appVersion',
              style: const TextStyle(fontSize: 10, color: Color(0x5933251D)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 10,
      letterSpacing: 1.1,
      fontWeight: FontWeight.w800,
      color: Color(0x8C33251D),
    ),
  );

  Widget _chip(String label, String value, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.22),
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: _ink, width: 1.3),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label  $value',
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: _ink,
          ),
        ),
      ],
    ),
  );
}

class _MiniBarsPainter extends CustomPainter {
  const _MiniBarsPainter({required this.values});

  final List<int> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxV = values.fold<int>(1, math.max);
    final slot = size.width / values.length;
    final barW = slot * 0.62;
    for (var i = 0; i < values.length; i++) {
      final h = math.max(3.0, values[i] / maxV * (size.height - 4));
      final isToday = i == values.length - 1;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(i * slot + (slot - barW) / 2, size.height - h, barW, h),
        const Radius.circular(3),
      );
      canvas.drawRRect(rect, Paint()..color = isToday ? _ballGreen : _golden);
      canvas.drawRRect(
        rect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.1
          ..color = _ink.withValues(alpha: isToday ? 0.9 : 0.45),
      );
    }
  }

  @override
  bool shouldRepaint(_MiniBarsPainter oldDelegate) =>
      oldDelegate.values != values;
}

class _NamingField extends StatefulWidget {
  const _NamingField({required this.brain});

  final BuddyBrain brain;

  @override
  State<_NamingField> createState() => _NamingFieldState();
}

class _NamingFieldState extends State<_NamingField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => widget.brain.finishNaming(_controller.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 4, 6, 4),
        decoration: BoxDecoration(
          color: _paper,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: _ink, width: 1.6),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2E33251D),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 118,
              child: TextField(
                controller: _controller,
                autofocus: true,
                maxLength: 14,
                onSubmitted: (_) => _submit(),
                cursorColor: _ink,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
                decoration: const InputDecoration(
                  hintText: 'name me…',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Color(0x7333251D),
                    fontWeight: FontWeight.w500,
                  ),
                  counterText: '',
                  isDense: true,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: _submit,
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: _golden,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 16, color: _ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _paper,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(13),
            bottomRight: Radius.circular(3),
          ),
          border: Border.all(color: _ink, width: 1.6),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2E33251D),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: _ink,
            decoration: TextDecoration.none,
            fontFamily: '.AppleSystemUIFont',
          ),
        ),
      ),
    );
  }
}

class _BallDot extends StatelessWidget {
  const _BallDot({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _ballGreen,
        shape: BoxShape.circle,
        border: Border.all(color: _ink, width: 1.8),
      ),
      child: CustomPaint(painter: _BallSeamPainter()),
    );
  }
}

class _BallSeamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFFFFDF6);
    final w = size.width;
    canvas.drawArc(
      Rect.fromLTWH(-w * 0.35, w * 0.1, w * 0.8, w * 0.8),
      -0.6,
      1.3,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(w * 0.55, w * 0.1, w * 0.8, w * 0.8),
      math.pi - 0.7,
      1.3,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_BallSeamPainter oldDelegate) => false;
}

class _DenPainter extends CustomPainter {
  const _DenPainter({
    required this.house,
    required this.character,
    required this.mood,
    required this.time,
    this.perf,
    this.bark,
  });

  final DogHouse house;
  final FoodCharacter character;
  final CharacterMood mood;
  final double time;
  final double? perf;
  final double? bark;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 300;
    canvas.save();
    canvas.translate(0, size.height - 300 * scale);
    canvas.scale(scale);
    canvas.save();
    canvas.scale(3);
    house.painter(
      Sketch(
        canvas,
        characterSeed(house.id, CharacterMood.signature),
        time: time,
      ),
    );
    canvas.restore();
    canvas.save();
    canvas.translate(63, 110.9);
    canvas.scale(1.74);
    FoodCharacterPainter(
      character: character,
      mood: mood,
      time: time,
      perf: perf,
      bark: bark,
    ).paint(canvas, const Size(100, 100));
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DenPainter oldDelegate) =>
      oldDelegate.house != house ||
      oldDelegate.character != character ||
      oldDelegate.mood != mood ||
      oldDelegate.time != time ||
      oldDelegate.perf != perf ||
      oldDelegate.bark != bark;
}

class _YardDog {
  const _YardDog({
    required this.character,
    required this.mood,
    required this.x,
    required this.flip,
    required this.walkPhase,
    required this.perf,
    required this.bark,
    required this.name,
  });

  final FoodCharacter character;
  final CharacterMood mood;
  final double x;
  final bool flip;
  final double? walkPhase;
  final double? perf;
  final double? bark;
  final String? name;
}

class _YardPainter extends CustomPainter {
  const _YardPainter({
    required this.house,
    required this.dogs,
    required this.time,
  });

  final DogHouse house;
  final List<_YardDog> dogs;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 300;
    final sy = size.height / 300;
    canvas.save();
    canvas.scale(sx * 3, sy * 3);
    house.painter(
      Sketch(
        canvas,
        characterSeed(house.id, CharacterMood.signature),
        time: time,
      ),
    );
    canvas.restore();
    final d = sy;
    final half = 87.0 * d;
    for (final dog in dogs) {
      final cx = (dog.x * size.width).clamp(
        half * 0.62,
        size.width - half * 0.62,
      );
      canvas.save();
      canvas.translate(cx, 110.9 * d);
      canvas.scale((dog.flip ? -1.74 : 1.74) * d, 1.74 * d);
      canvas.translate(-50, 0);
      FoodCharacterPainter(
        character: dog.character,
        mood: dog.mood,
        time: time,
        perf: dog.perf,
        walk: dog.walkPhase,
        bark: dog.bark,
      ).paint(canvas, const Size(100, 100));
      canvas.restore();
      final name = dog.name;
      if (name != null) {
        final tp = TextPainter(
          text: TextSpan(
            text: name,
            style: TextStyle(
              fontSize: 9.5 * d,
              fontWeight: FontWeight.w800,
              color: _ink,
              fontFamily: '.AppleSystemUIFont',
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: 120 * d);
        final w = tp.width + 10 * d;
        final h = tp.height + 4 * d;
        final rect = RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx, 103 * d), width: w, height: h),
          Radius.circular(6 * d),
        );
        canvas.drawRRect(rect, Paint()..color = const Color(0xE6FFF6E9));
        canvas.drawRRect(
          rect,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.1
            ..color = const Color(0x8C33251D),
        );
        tp.paint(canvas, Offset(cx - tp.width / 2, 103 * d - tp.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(_YardPainter oldDelegate) => true;
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({required this.brain});

  final BuddyBrain brain;

  String _ago(DateTime at) {
    final d = DateTime.now().difference(at);
    if (d.inSeconds < 60) return '${d.inSeconds}s';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    return '${d.inHours}h';
  }

  @override
  Widget build(BuildContext context) {
    final live = brain.sessionStatuses();
    final rows =
        <({String label, SessionState state, DateTime at, double ctx})>[];
    final displayed = <String>{};
    for (final s in live) {
      if (s.state == SessionState.idle) continue;
      rows.add((label: s.label, state: s.state, at: s.since, ctx: s.context));
      displayed.add(s.label);
    }
    final claimed = {...displayed};
    for (final e in brain.recentEvents) {
      if (!claimed.add(e.label)) continue;
      final window =
          e.event == SidekickEvent.completed || e.event == SidekickEvent.error
          ? const Duration(hours: 6)
          : const Duration(minutes: 10);
      if (DateTime.now().difference(e.at) >= window) continue;
      rows.add((
        label: e.label,
        state: switch (e.event) {
          SidekickEvent.completed => SessionState.done,
          SidekickEvent.error => SessionState.error,
          _ => SessionState.waiting,
        },
        at: e.at,
        ctx: 0.0,
      ));
      displayed.add(e.label);
    }
    for (final s in live) {
      if (s.state != SessionState.idle) continue;
      if (displayed.contains(s.label)) continue;
      rows.add((label: s.label, state: s.state, at: s.since, ctx: s.context));
    }
    final shown = rows.take(6).toList();
    return Container(
      margin: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: _paper,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(22),
          bottomLeft: Radius.circular(19),
          bottomRight: Radius.circular(21),
        ),
        border: Border.all(color: _ink, width: 1.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3833251D),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${brain.petName}\u{2019}s watch',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
              ),
              GestureDetector(
                onTap: brain.toggleStatusBoard,
                child: Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0x5933251D)),
                  ),
                  child: const Icon(Icons.close, size: 14, color: _ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            'your sessions, as she sees them',
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: Color(0x8C33251D),
            ),
          ),
          const SizedBox(height: 12),
          if (shown.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  'all quiet. go write something!',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0x8C33251D),
                  ),
                ),
              ),
            ),
          for (final row in shown)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: switch (row.state) {
                          SessionState.working => _ballGreen,
                          SessionState.waiting => _blush,
                          SessionState.done => _golden,
                          SessionState.error => const Color(0xFFC0392B),
                          SessionState.idle => const Color(0xFFCFC2AC),
                        },
                        border: Border.all(color: _ink, width: 1.2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: _ink,
                          ),
                        ),
                        Text(
                          switch (row.state) {
                                SessionState.working => 'still working',
                                SessionState.waiting => 'waiting for you',
                                SessionState.done => 'done',
                                SessionState.error => 'hit an error',
                                SessionState.idle => 'open, resting',
                              } +
                              (row.ctx > 0
                                  ? ' \u{00B7} context '
                                        '${(row.ctx * 100).round()}% full'
                                  : ''),
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: switch (row.state) {
                              SessionState.working => const Color(0xFF5E8A3A),
                              SessionState.waiting => const Color(0xFFC0573F),
                              SessionState.done => const Color(0xFFA9741F),
                              SessionState.error => const Color(0xFFC0392B),
                              SessionState.idle => const Color(0x8C33251D),
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      _ago(row.at),
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0x7333251D),
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const Spacer(),
          const Center(
            child: Text(
              'right-click your pup anytime to open this',
              style: TextStyle(fontSize: 10, color: Color(0x5933251D)),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _circleIcon(IconData icon, VoidCallback onTap) => GestureDetector(
  onTap: onTap,
  child: Container(
    width: 26,
    height: 26,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: const Color(0x5933251D)),
    ),
    child: Icon(icon, size: 14, color: _ink),
  ),
);

class _FieldNotesPanel extends StatefulWidget {
  const _FieldNotesPanel({required this.brain});

  final BuddyBrain brain;

  @override
  State<_FieldNotesPanel> createState() => _FieldNotesPanelState();
}

class _FieldNotesPanelState extends State<_FieldNotesPanel> {
  final _cardKey = GlobalKey();

  Widget _rangeChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? _golden : _paper,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: _ink, width: 1.4),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: _ink,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brain = widget.brain;
    final weekly = brain.fieldNotesWeekly;
    final note = buildFieldNote(
      brain.stats,
      weekly: weekly,
      name: brain.petName,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      child: Column(
        children: [
          Row(
            children: [
              _rangeChip(
                'Today',
                !weekly,
                () => brain.setFieldNotesWeekly(false),
              ),
              const SizedBox(width: 6),
              _rangeChip('Week', weekly, () => brain.setFieldNotesWeekly(true)),
              const Spacer(),
              _circleIcon(
                Icons.ios_share,
                () => _exportCard(_cardKey, 'maika-field-notes'),
              ),
              const SizedBox(width: 8),
              _circleIcon(Icons.close, brain.toggleFieldNotes),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RepaintBoundary(
              key: _cardKey,
              child: Container(
                width: double.infinity,
                decoration: _cardPaper,
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 46,
                          height: 46,
                          child: FoodCharacterView(
                            character: brain.character,
                            mood: CharacterMood.joy,
                            size: 46,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.headline,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: _ink,
                                ),
                              ),
                              Text(
                                note.subtitle,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0x8C33251D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    for (final line in note.lines)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: _golden,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: _ink, width: 1),
                                ),
                              ),
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                line,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  height: 1.35,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    Text(
                      note.closer,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.3,
                        fontStyle: FontStyle.italic,
                        color: Color(0xB333251D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '— ${brain.petName}’s field notes',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                        color: Color(0x8C33251D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DogTagPanel extends StatefulWidget {
  const _DogTagPanel({required this.brain});

  final BuddyBrain brain;

  @override
  State<_DogTagPanel> createState() => _DogTagPanelState();
}

class _DogTagPanelState extends State<_DogTagPanel> {
  final _cardKey = GlobalKey();

  String _topStat(Map<String, int> life) {
    if (life.isEmpty) return 'just getting started';
    var bestK = '';
    var bestV = 0;
    life.forEach((k, v) {
      if (v > bestV) {
        bestV = v;
        bestK = k;
      }
    });
    final noun = switch (bestK) {
      'commit' => bestV == 1 ? 'commit' : 'commits',
      'test' => 'test runs',
      'edit' => 'files shaped',
      'delete' => 'cleanups',
      'error' => 'bugs met',
      _ => 'moves',
    };
    return '$bestV $noun';
  }

  Widget _stamp(String label, String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0x14E5B266),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0x66C98F47)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 8.5,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w800,
            color: Color(0x8C33251D),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: _ink,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final brain = widget.brain;
    final stats = brain.stats;
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              _circleIcon(
                Icons.ios_share,
                () => _exportCard(_cardKey, 'maika-dog-tag'),
              ),
              const SizedBox(width: 8),
              _circleIcon(Icons.close, brain.toggleDogTag),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RepaintBoundary(
              key: _cardKey,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: _cardPaper,
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: _golden,
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(color: _ink, width: 1.4),
                              ),
                              child: const Text(
                                'DOG TAG',
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1.4,
                                  fontWeight: FontWeight.w900,
                                  color: _ink,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Lv ${brain.level}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: _ink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Container(
                            width: 132,
                            height: 132,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                colors: [Color(0x33E5B266), Color(0x00E5B266)],
                              ),
                              border: Border.all(
                                color: const Color(0x40C98F47),
                                width: 1.4,
                              ),
                            ),
                            child: Center(
                              child: FoodCharacterView(
                                character: brain.character,
                                mood: CharacterMood.joy,
                                size: 118,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Center(
                          child: Text(
                            brain.displayName,
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              color: _ink,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            '${brain.breedLabel}  ·  ${brain.coatLabel}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0x9933251D),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _stamp('XP total', formatTokens(stats.totalTokens)),
                            _stamp('streak', '${stats.streakDays}d'),
                            _stamp('best run', '${stats.bestStreak}d'),
                            _stamp('fit', brain.fitLabel),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              size: 14,
                              color: Color(0xFFA9741F),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Top trick: ${_topStat(stats.lifetimeEvents)}',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: _ink,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '— ${brain.displayName} on Maika',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0x8C33251D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0x26FFFFFF),
                              Color(0x00FFFFFF),
                              Color(0x1AE5B266),
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
