import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'sketch.dart';

typedef CharacterPaint = void Function(Sketch s, CharacterMood mood);

class FoodCharacter {
  const FoodCharacter({
    required this.id,
    required this.name,
    required this.family,
    required this.title,
    required this.story,
    required this.accent,
    required this.moodLore,
    required this.painter,
    this.motion = const MotionProfile(),
  });

  final String id;
  final String name;
  final String family;
  final String title;
  final String story;
  final Color accent;
  final Map<CharacterMood, String> moodLore;
  final CharacterPaint painter;
  final MotionProfile motion;
}

class CharacterFamily {
  const CharacterFamily({
    required this.name,
    required this.tagline,
    required this.slug,
    required this.members,
  });

  final String name;
  final String tagline;
  final String slug;
  final List<FoodCharacter> members;
}

int characterSeed(String id, CharacterMood mood) =>
    id.codeUnits.fold(29, (acc, unit) => acc * 31 + unit) + mood.index * 101;

class FoodCharacterPainter extends CustomPainter {
  const FoodCharacterPainter({
    required this.character,
    required this.mood,
    this.time,
    this.perf,
    this.lean = 0,
    this.walk,
    this.stretch = 0,
    this.turn = 0,
    this.bark,
  });

  final FoodCharacter character;
  final CharacterMood mood;
  final double? time;
  final double? perf;
  final double lean;
  final double? walk;
  final double stretch;
  final double turn;
  final double? bark;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.shortestSide / 100;
    canvas.save();
    canvas.translate(
      (size.width - unit * 100) / 2,
      (size.height - unit * 100) / 2,
    );
    canvas.scale(unit);
    character.painter(
      Sketch(
        canvas,
        characterSeed(character.id, mood),
        time: time,
        motion: character.motion,
        perf: perf,
        lean: lean,
        walk: walk,
        stretch: stretch,
        turn: turn,
        bark: bark,
      ),
      mood,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(FoodCharacterPainter oldDelegate) =>
      oldDelegate.character != character ||
      oldDelegate.mood != mood ||
      oldDelegate.time != time ||
      oldDelegate.perf != perf ||
      oldDelegate.lean != lean ||
      oldDelegate.walk != walk ||
      oldDelegate.stretch != stretch ||
      oldDelegate.turn != turn ||
      oldDelegate.bark != bark;
}

class FoodCharacterView extends StatelessWidget {
  const FoodCharacterView({
    super.key,
    required this.character,
    this.mood = CharacterMood.signature,
    this.size = 120,
  });

  final FoodCharacter character;
  final CharacterMood mood;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        size: Size.square(size),
        painter: FoodCharacterPainter(character: character, mood: mood),
      ),
    );
  }
}

class AnimatedFoodCharacterView extends StatefulWidget {
  const AnimatedFoodCharacterView({
    super.key,
    required this.character,
    this.mood = CharacterMood.signature,
    this.size = 120,
    this.fps = 10,
    this.interactive = false,
  });

  final FoodCharacter character;
  final CharacterMood mood;
  final double size;
  final int fps;
  final bool interactive;

  @override
  State<AnimatedFoodCharacterView> createState() =>
      AnimatedFoodCharacterViewState();
}

class AnimatedFoodCharacterViewState extends State<AnimatedFoodCharacterView>
    with SingleTickerProviderStateMixin {
  static const _perfDuration = 1.15;
  static const _morphDuration = 0.42;

  late final Ticker _ticker;
  int _tick = 0;
  double? _perfStart;
  double? _morphStart;
  CharacterMood _prevMood = CharacterMood.signature;
  double _dragLean = 0;
  bool _dragging = false;
  double? _springStart;
  double _springFrom = 0;
  bool _holdingYum = false;

  double get _now => _tick / widget.fps;

  @override
  void initState() {
    super.initState();
    _prevMood = widget.mood;
    _ticker = createTicker((elapsed) {
      final tick = elapsed.inMilliseconds * widget.fps ~/ 1000;
      if (tick != _tick) {
        setState(() => _tick = tick);
      }
    })..start();
  }

  @override
  void didUpdateWidget(AnimatedFoodCharacterView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mood != widget.mood) {
      _prevMood = oldWidget.mood;
      _morphStart = _now;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void perform() {
    _perfStart ??= _now;
  }

  double? get _perfPhase {
    final start = _perfStart;
    if (start == null) return null;
    final phase =
        (_now - start) * widget.character.motion.tempo / _perfDuration;
    if (phase >= 1) return null;
    return phase;
  }

  double get _lean {
    if (_dragging) return _dragLean;
    final start = _springStart;
    if (start == null) return 0;
    final elapsed = _now - start;
    final value =
        _springFrom * math.cos(elapsed * 14) * math.exp(-elapsed * 5.5);
    return value.abs() < 0.01 ? 0 : value;
  }

  ({CharacterMood mood, double squashX, double squashY}) get _morph {
    final start = _morphStart;
    if (start == null) {
      return (mood: widget.mood, squashX: 1, squashY: 1);
    }
    final phase = (_now - start) / _morphDuration;
    if (phase >= 1) {
      return (mood: widget.mood, squashX: 1, squashY: 1);
    }
    if (phase < 0.4) {
      final a = phase / 0.4;
      return (mood: _prevMood, squashX: 1 + 0.14 * a, squashY: 1 - 0.3 * a);
    }
    final a = (phase - 0.4) / 0.6;
    final settle = easeOutBack(a);
    return (
      mood: widget.mood,
      squashX: 1.14 - 0.14 * settle,
      squashY: 0.7 + 0.3 * settle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final perfPhase = _perfPhase;
    if (perfPhase == null && _perfStart != null && _now - _perfStart! > 0) {
      _perfStart = null;
    }
    final morph = _morph;
    final mood = _holdingYum ? CharacterMood.yum : morph.mood;
    Widget view = RepaintBoundary(
      child: SizedBox.square(
        dimension: widget.size,
        child: Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.diagonal3Values(morph.squashX, morph.squashY, 1),
          child: CustomPaint(
            size: Size.square(widget.size),
            painter: FoodCharacterPainter(
              character: widget.character,
              mood: mood,
              time: _now,
              perf: perfPhase,
              lean: _lean.clamp(-0.35, 0.35),
            ),
          ),
        ),
      ),
    );
    if (!widget.interactive) return view;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: perform,
      onLongPressStart: (_) => setState(() => _holdingYum = true),
      onLongPressEnd: (_) => setState(() => _holdingYum = false),
      onHorizontalDragStart: (_) {
        _dragging = true;
        _springStart = null;
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragLean = (_dragLean + details.delta.dx * 0.004).clamp(-0.35, 0.35);
        });
      },
      onHorizontalDragEnd: (_) {
        setState(() {
          _dragging = false;
          _springFrom = _dragLean;
          _springStart = _now;
          _dragLean = 0;
        });
      },
      child: view,
    );
  }
}
