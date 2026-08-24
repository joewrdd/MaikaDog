import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'cast.dart';
import 'characters/houses/houses.dart';

enum YardState { closed, hosting, browsing, knocking, visiting }

enum YardAct { idle, walk, sit, sleep }

class YardDen {
  const YardDen({required this.id, required this.name});

  final String id;
  final String name;
}

class YardKnock {
  const YardKnock({required this.id, required this.name, required this.at});

  final String id;
  final String name;
  final DateTime at;
}

class YardPeer {
  YardPeer({required this.id, required this.name});

  final String id;
  String name;
  String sid = '';
  String breedId = 'golden';
  String coatId = 'golden';
  String accessory = 'none';
  CharacterMood mood = CharacterMood.signature;
  double x = 0.5;
  bool flip = false;
  YardAct act = YardAct.idle;
  DateTime lastSeen = DateTime.now();
  DateTime? lastHeartbeat;
  DateTime? lastEvent;
  DateTime? lastHello;
  DateTime? performAt;
  DateTime? barkAt;
  DateTime? leavingAt;
}

class YardSelfState {
  const YardSelfState({
    required this.name,
    required this.breedId,
    required this.coatId,
    required this.accessory,
    required this.mood,
  });

  final String name;
  final String breedId;
  final String coatId;
  final String accessory;
  final CharacterMood mood;
}

abstract final class YardProtocol {
  static const version = 2;
  static const maxFrameBytes = 4096;
  static const heartbeatGap = Duration(milliseconds: 150);
  static const eventGap = Duration(milliseconds: 1500);
  static const helloGap = Duration(seconds: 5);
  static const staleAfter = Duration(seconds: 10);
  static const leaveAnimation = Duration(milliseconds: 1200);

  static String sanitizeName(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[\x00-\x1F\x7F<>`]'), '').trim();
    if (cleaned.isEmpty) return 'a pup';
    return cleaned.length > 24 ? cleaned.substring(0, 24) : cleaned;
  }

  static String validBreed(Object? id) =>
      id is String && dogBreeds.any((b) => b.id == id) ? id : 'golden';

  static String validCoat(String breedId, Object? coatId) {
    final breed = dogBreedById(breedId);
    return coatId is String && breed.coats.any((c) => c.id == coatId)
        ? coatId
        : breed.coats.first.id;
  }

  static String validAccessory(Object? name) =>
      name is String && DogAccessory.values.any((a) => a.name == name)
      ? name
      : 'none';

  static String validHouse(Object? id) =>
      id is String && dogHouses.any((h) => h.id == id) ? id : 'kennel';

  static CharacterMood validMood(Object? name) => CharacterMood.values
      .firstWhere((m) => m.name == name, orElse: () => CharacterMood.signature);

  static YardAct validAct(Object? name) => YardAct.values.firstWhere(
    (a) => a.name == name,
    orElse: () => YardAct.idle,
  );

  static double validX(Object? x) =>
      x is num && x.isFinite ? x.toDouble().clamp(0.0, 1.0) : 0.5;

  static Map<String, dynamic>? decode(Uint8List bytes) {
    if (bytes.isEmpty || bytes.length > maxFrameBytes) return null;
    try {
      final obj = jsonDecode(utf8.decode(bytes, allowMalformed: true));
      if (obj is! Map<String, dynamic>) return null;
      if (obj['v'] != version) return null;
      if (obj['t'] is! String) return null;
      return obj;
    } catch (_) {
      return null;
    }
  }

  static Uint8List _encode(Map<String, dynamic> payload) =>
      Uint8List.fromList(utf8.encode(jsonEncode(payload)));

  static Uint8List hello(YardSelfState self, String sid) => _encode({
    'v': version,
    't': 'hello',
    'sid': sid,
    'name': sanitizeName(self.name),
    'breed': self.breedId,
    'coat': self.coatId,
    'acc': self.accessory,
  });

  static Uint8List kick(String toSid) =>
      _encode({'v': version, 't': 'kick', 'to': toSid});

  static bool kickAims(Map<String, dynamic> msg, String sid) =>
      msg['t'] == 'kick' && sid.isNotEmpty && msg['to'] == sid;

  static String validSid(Object? sid) =>
      sid is String && RegExp(r'^[a-z0-9]{4,16}$').hasMatch(sid) ? sid : '';

  static Uint8List heartbeat(
    YardSelfState self,
    double x,
    bool flip,
    YardAct act,
  ) => _encode({
    'v': version,
    't': 'hb',
    'name': sanitizeName(self.name),
    'breed': self.breedId,
    'coat': self.coatId,
    'acc': self.accessory,
    'mood': self.mood.name,
    'x': double.parse(x.clamp(0.0, 1.0).toStringAsFixed(3)),
    'flip': flip,
    'act': act.name,
  });

  static Uint8List host(String houseId, int cap) =>
      _encode({'v': version, 't': 'host', 'house': houseId, 'cap': cap});

  static Uint8List event(String type) => _encode({'v': version, 't': type});
}

class YardRoom extends ChangeNotifier {
  YardRoom({this.cap = 6});

  final int cap;
  final Map<String, YardPeer> peers = {};
  String houseId = 'kennel';
  String? hostId;

  bool get full => peers.length >= cap - 1;

  void applyBytes(String peerId, Uint8List bytes, {DateTime? at}) {
    final msg = YardProtocol.decode(bytes);
    if (msg == null) return;
    apply(peerId, msg, at: at);
  }

  void apply(String peerId, Map<String, dynamic> msg, {DateTime? at}) {
    final now = at ?? DateTime.now();
    final type = msg['t'] as String;
    final peer = peers[peerId];
    switch (type) {
      case 'hello':
        if (peer == null) {
          if (full) return;
          final fresh = YardPeer(
            id: peerId,
            name: YardProtocol.sanitizeName(msg['name'] as String? ?? ''),
          );
          fresh.breedId = YardProtocol.validBreed(msg['breed']);
          fresh.coatId = YardProtocol.validCoat(fresh.breedId, msg['coat']);
          fresh.accessory = YardProtocol.validAccessory(msg['acc']);
          fresh.sid = YardProtocol.validSid(msg['sid']);
          fresh.lastSeen = now;
          fresh.lastHello = now;
          peers[peerId] = fresh;
          notifyListeners();
          return;
        }
        final lastHello = peer.lastHello;
        if (lastHello != null &&
            now.difference(lastHello) < YardProtocol.helloGap) {
          return;
        }
        peer.name = YardProtocol.sanitizeName(msg['name'] as String? ?? '');
        peer.breedId = YardProtocol.validBreed(msg['breed']);
        peer.coatId = YardProtocol.validCoat(peer.breedId, msg['coat']);
        peer.accessory = YardProtocol.validAccessory(msg['acc']);
        if (peer.sid.isEmpty) {
          peer.sid = YardProtocol.validSid(msg['sid']);
        }
        peer.lastSeen = now;
        peer.lastHello = now;
        notifyListeners();
      case 'hb':
        if (peer == null) {
          apply(peerId, {...msg, 't': 'hello'}, at: now);
          return;
        }
        final lastBeat = peer.lastHeartbeat;
        if (lastBeat != null &&
            now.difference(lastBeat) < YardProtocol.heartbeatGap) {
          return;
        }
        peer.lastHeartbeat = now;
        peer.lastSeen = now;
        final lastIdentity = peer.lastHello;
        if (lastIdentity == null ||
            now.difference(lastIdentity) >= YardProtocol.helloGap) {
          peer.lastHello = now;
          final name = msg['name'];
          if (name is String) peer.name = YardProtocol.sanitizeName(name);
          if (msg['breed'] != null || msg['coat'] != null) {
            peer.breedId = YardProtocol.validBreed(
              msg['breed'] ?? peer.breedId,
            );
            peer.coatId = YardProtocol.validCoat(
              peer.breedId,
              msg['coat'] ?? peer.coatId,
            );
          }
          if (msg['acc'] != null) {
            peer.accessory = YardProtocol.validAccessory(msg['acc']);
          }
        }
        peer.mood = YardProtocol.validMood(msg['mood']);
        peer.x = YardProtocol.validX(msg['x']);
        peer.flip = msg['flip'] == true;
        peer.act = YardProtocol.validAct(msg['act']);
        notifyListeners();
      case 'perform' || 'bark':
        if (peer == null) return;
        final lastEvent = peer.lastEvent;
        if (lastEvent != null &&
            now.difference(lastEvent) < YardProtocol.eventGap) {
          return;
        }
        peer.lastEvent = now;
        peer.lastSeen = now;
        if (type == 'perform') {
          peer.performAt = now;
        } else {
          peer.barkAt = now;
        }
        notifyListeners();
      case 'host':
        if (peerId != hostId) return;
        houseId = YardProtocol.validHouse(msg['house']);
        notifyListeners();
      case 'bye':
        if (peer == null) return;
        peer.leavingAt ??= now;
        peer.lastSeen = now;
        notifyListeners();
      default:
        return;
    }
  }

  void markGone(String peerId, {DateTime? at}) {
    final peer = peers[peerId];
    if (peer == null) return;
    peer.leavingAt ??= at ?? DateTime.now();
    notifyListeners();
  }

  void sweep({DateTime? at}) {
    final now = at ?? DateTime.now();
    var changed = false;
    for (final peer in peers.values) {
      if (peer.leavingAt == null &&
          now.difference(peer.lastSeen) > YardProtocol.staleAfter) {
        peer.leavingAt = now;
        changed = true;
      }
    }
    final before = peers.length;
    peers.removeWhere(
      (_, p) =>
          p.leavingAt != null &&
          now.difference(p.leavingAt!) > YardProtocol.leaveAnimation,
    );
    if (changed || peers.length != before) notifyListeners();
  }

  void clear() {
    peers.clear();
    hostId = null;
    houseId = 'kennel';
    notifyListeners();
  }
}

class YardService extends ChangeNotifier {
  YardService({required this.selfState, required this.localHouseId});

  static const _channel = MethodChannel('maika/yard');
  static const _events = EventChannel('maika/yard/events');
  static const cap = 6;

  final YardSelfState Function() selfState;
  final String Function() localHouseId;

  YardState state = YardState.closed;
  final YardRoom room = YardRoom(cap: cap);
  final List<YardDen> dens = [];
  final List<YardKnock> knocks = [];
  final String _sid = List.generate(
    8,
    (_) => '0123456789abcdefghijklmnopqrstuvwxyz'[_rand.nextInt(36)],
  ).join();
  String? note;
  String? _knockTargetId;
  String? _configuredName;
  StreamSubscription<dynamic>? _sub;
  Timer? _tick;
  Timer? _knockTimeout;
  DateTime _lastSent = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _noteAt = DateTime.fromMillisecondsSinceEpoch(0);

  double selfX = 0.5;
  bool selfFlip = false;
  YardAct selfAct = YardAct.idle;
  double _selfTarget = 0.5;
  DateTime _nextStroll = DateTime.now();

  bool get roomLive =>
      state == YardState.visiting ||
      (state == YardState.hosting && room.peers.isNotEmpty);

  bool get doorOpen => state != YardState.closed;

  String get roomHouseId =>
      state == YardState.visiting ? room.houseId : localHouseId();

  Future<void> _ensureConfigured() async {
    final name = YardProtocol.sanitizeName(selfState().name);
    if (_configuredName == name) return;
    await _channel.invokeMethod('configure', {'name': name, 'cap': cap});
    _configuredName = name;
  }

  void _listen() {
    _sub ??= _events.receiveBroadcastStream().listen(_onEvent);
    _tick ??= Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => _onTick(),
    );
  }

  Future<void> openDoor() async {
    if (state == YardState.hosting) return;
    await _ensureConfigured();
    _listen();
    await closeAll(silent: true);
    await _channel.invokeMethod('openDoor');
    room.clear();
    room.hostId = 'self';
    state = YardState.hosting;
    _say('the door is open');
    notifyListeners();
  }

  Future<void> browse() async {
    if (state == YardState.browsing) return;
    await _ensureConfigured();
    _listen();
    await closeAll(silent: true);
    dens.clear();
    await _channel.invokeMethod('startBrowsing');
    state = YardState.browsing;
    notifyListeners();
  }

  Future<void> knock(String denId) async {
    if (state != YardState.browsing) return;
    final den = dens.where((d) => d.id == denId).firstOrNull;
    if (den == null) return;
    state = YardState.knocking;
    _knockTargetId = denId;
    room.clear();
    room.hostId = denId;
    await _channel.invokeMethod('knock', {
      'id': denId,
      'hello': YardProtocol.hello(selfState(), _sid),
    });
    _knockTimeout?.cancel();
    _knockTimeout = Timer(const Duration(seconds: 30), () {
      if (state != YardState.knocking) return;
      _say('nobody answered the door');
      unawaited(browse());
    });
    notifyListeners();
  }

  Future<void> approve(String knockId) async {
    knocks.removeWhere((k) => k.id == knockId);
    await _channel.invokeMethod('approve', {'id': knockId});
    notifyListeners();
  }

  Future<void> ignore(String knockId) async {
    knocks.removeWhere((k) => k.id == knockId);
    await _channel.invokeMethod('ignore', {'id': knockId});
    notifyListeners();
  }

  Future<void> _stopKnocking() async {
    _knockTimeout?.cancel();
    _knockTimeout = null;
    _knockTargetId = null;
  }

  Future<void> closeAll({bool silent = false}) async {
    if (state == YardState.closed) return;
    if (roomLive) {
      try {
        await _channel.invokeMethod('send', {
          'data': YardProtocol.event('bye'),
        });
      } catch (_) {}
    }
    await _stopKnocking();
    try {
      await _channel.invokeMethod('closeDoor');
      await _channel.invokeMethod('stopBrowsing');
    } catch (_) {}
    room.clear();
    dens.clear();
    knocks.clear();
    state = YardState.closed;
    if (!silent) _say('door closed');
    notifyListeners();
  }

  void performOut() => _sendEvent('perform');

  void barkOut() => _sendEvent('bark');

  void announceHouse() {
    if (state != YardState.hosting) return;
    unawaited(
      _channel
          .invokeMethod('send', {
            'data': YardProtocol.host(localHouseId(), cap),
          })
          .catchError((_) => null),
    );
  }

  Future<void> kick(String peerId) async {
    if (state != YardState.hosting) return;
    final peer = room.peers[peerId];
    if (peer == null || peer.sid.isEmpty) return;
    try {
      await _channel.invokeMethod('send', {
        'data': YardProtocol.kick(peer.sid),
      });
    } catch (_) {}
    room.markGone(peerId);
    _say('${peer.name} was sent home');
  }

  void _sendEvent(String type) {
    if (!roomLive) return;
    unawaited(
      _channel
          .invokeMethod('send', {'data': YardProtocol.event(type)})
          .catchError((_) => null),
    );
  }

  void _say(String text) {
    note = text;
    _noteAt = DateTime.now();
    notifyListeners();
  }

  String? get freshNote =>
      DateTime.now().difference(_noteAt) < const Duration(seconds: 6)
      ? note
      : null;

  void _onEvent(dynamic raw) {
    if (raw is! Map) return;
    final map = Map<String, dynamic>.from(raw);
    switch (map['type']) {
      case 'denFound':
        final id = map['id'] as String?;
        final name = map['name'] as String?;
        if (id == null || dens.any((d) => d.id == id)) return;
        dens.add(
          YardDen(id: id, name: YardProtocol.sanitizeName(name ?? 'a den')),
        );
        notifyListeners();
      case 'denLost':
        dens.removeWhere((d) => d.id == map['id']);
        notifyListeners();
      case 'knock':
        if (state != YardState.hosting || knocks.length >= 3) {
          unawaited(_channel.invokeMethod('ignore', {'id': map['id']}));
          return;
        }
        final bytes = map['hello'];
        final hello = bytes is Uint8List ? YardProtocol.decode(bytes) : null;
        if (hello == null || hello['t'] != 'hello') {
          unawaited(_channel.invokeMethod('ignore', {'id': map['id']}));
          return;
        }
        final id = map['id'] as String;
        knocks.removeWhere((k) => k.id == id);
        knocks.add(
          YardKnock(
            id: id,
            name: YardProtocol.sanitizeName(hello['name'] as String? ?? ''),
            at: DateTime.now(),
          ),
        );
        notifyListeners();
      case 'knockExpired':
        knocks.removeWhere((k) => k.id == map['id']);
        notifyListeners();
      case 'peerState':
        final id = map['id'] as String?;
        if (id == null) return;
        switch (map['state']) {
          case 'connected':
            if (state == YardState.knocking && id == _knockTargetId) {
              _knockTimeout?.cancel();
              state = YardState.visiting;
              unawaited(_channel.invokeMethod('stopBrowsing'));
              _say('you walked in!');
            }
            if (state == YardState.hosting) {
              unawaited(
                _channel.invokeMethod('send', {
                  'data': YardProtocol.host(localHouseId(), cap),
                }),
              );
            }
            if (roomLive) {
              unawaited(
                _channel.invokeMethod('send', {
                  'data': YardProtocol.hello(selfState(), _sid),
                }),
              );
            }
            notifyListeners();
          case 'gone':
            if (state == YardState.visiting && id == room.hostId) {
              _say('the host closed the den');
              unawaited(closeAll(silent: true));
              return;
            }
            room.markGone(id);
            notifyListeners();
        }
      case 'data':
        final id = map['id'] as String?;
        final bytes = map['bytes'];
        if (id == null || bytes is! Uint8List) return;
        if (state == YardState.visiting && id == room.hostId) {
          final msg = YardProtocol.decode(bytes);
          if (msg != null && YardProtocol.kickAims(msg, _sid)) {
            _say('you were sent home');
            unawaited(closeAll(silent: true));
            return;
          }
        }
        room.applyBytes(id, bytes);
      case 'error':
        _say('the yard hiccuped');
        notifyListeners();
    }
  }

  void _onTick() {
    final now = DateTime.now();
    room.sweep(at: now);
    if (!roomLive) {
      selfAct = YardAct.idle;
      return;
    }
    if (now.isAfter(_nextStroll)) {
      _nextStroll = now.add(Duration(milliseconds: 3500 + _rand.nextInt(5500)));
      _selfTarget = 0.12 + _rand.nextDouble() * 0.76;
      if (_rand.nextInt(10) == 0) {
        selfAct = YardAct.sit;
        _selfTarget = selfX;
      }
    }
    final dx = _selfTarget - selfX;
    if (dx.abs() > 0.015) {
      selfX += dx.sign * math.min(dx.abs(), 0.02);
      selfFlip = dx < 0;
      selfAct = YardAct.walk;
      notifyListeners();
    } else if (selfAct == YardAct.walk) {
      selfAct = YardAct.idle;
      notifyListeners();
    }
    final changed = selfAct == YardAct.walk;
    if (changed || now.difference(_lastSent) > const Duration(seconds: 1)) {
      _lastSent = now;
      unawaited(
        _channel
            .invokeMethod('send', {
              'data': YardProtocol.heartbeat(
                selfState(),
                selfX,
                selfFlip,
                selfAct,
              ),
            })
            .catchError((_) => null),
      );
    }
  }

  static final _rand = math.Random();

  void debugAddPhantom() {
    if (!kDebugMode) return;
    final breeds = dogBreeds;
    final breed = breeds[_rand.nextInt(breeds.length)];
    final phantomId = 'phantom-${_rand.nextInt(9999)}';
    room.hostId ??= 'self';
    if (state == YardState.closed) {
      state = YardState.hosting;
    }
    room.apply(phantomId, {
      'v': 1,
      't': 'hello',
      'sid': 'ghost${1000 + _rand.nextInt(8999)}',
      'name': 'Ghost pup',
      'breed': breed.id,
      'coat': breed.coats[_rand.nextInt(breed.coats.length)].id,
      'acc':
          DogAccessory.values[_rand.nextInt(DogAccessory.values.length)].name,
    });
    Timer.periodic(const Duration(milliseconds: 700), (timer) {
      final peer = room.peers[phantomId];
      if (peer == null || state == YardState.closed) {
        timer.cancel();
        return;
      }
      room.apply(phantomId, {
        'v': 1,
        't': 'hb',
        'mood': CharacterMood.values[_rand.nextInt(5)].name,
        'x': _rand.nextDouble(),
        'flip': _rand.nextBool(),
        'act': _rand.nextInt(3) == 0 ? 'walk' : 'idle',
      });
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _tick?.cancel();
    _knockTimeout?.cancel();
    _sub?.cancel();
    super.dispose();
  }
}
