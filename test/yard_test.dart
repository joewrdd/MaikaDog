import 'dart:convert';
import 'dart:typed_data';

import 'package:buddy/cast.dart';
import 'package:buddy/yard.dart';
import 'package:flutter_test/flutter_test.dart';

Uint8List _frame(Map<String, dynamic> payload) =>
    Uint8List.fromList(utf8.encode(jsonEncode(payload)));

Map<String, dynamic> _hello({String name = 'Rex'}) => {
  'v': 2,
  't': 'hello',
  'name': name,
  'breed': 'husky',
  'coat': 'husky_night',
  'acc': 'blindfold',
};

void main() {
  group('protocol validation', () {
    test('rejects wrong version, non objects, oversized and garbage', () {
      expect(YardProtocol.decode(_frame({'v': 99, 't': 'hb'})), isNull);
      expect(YardProtocol.decode(_frame({'v': 2})), isNull);
      expect(
        YardProtocol.decode(Uint8List.fromList(utf8.encode('[1,2,3]'))),
        isNull,
      );
      expect(
        YardProtocol.decode(Uint8List.fromList(List.filled(5000, 65))),
        isNull,
      );
      expect(
        YardProtocol.decode(Uint8List.fromList(utf8.encode('not json'))),
        isNull,
      );
      expect(YardProtocol.decode(Uint8List(0)), isNull);
    });

    test('sanitizes hostile names', () {
      expect(YardProtocol.sanitizeName('  Rex  '), 'Rex');
      expect(YardProtocol.sanitizeName('a<script>b'), 'ascriptb');
      expect(YardProtocol.sanitizeName('\x00\x01\x02'), 'a pup');
      expect(YardProtocol.sanitizeName('x' * 80).length, 24);
      expect(YardProtocol.sanitizeName(''), 'a pup');
    });

    test('unknown ids fall back to safe defaults', () {
      expect(YardProtocol.validBreed('dragon'), 'golden');
      expect(YardProtocol.validCoat('golden', 'lava'), 'golden');
      expect(YardProtocol.validAccessory('rocketLauncher'), 'none');
      expect(YardProtocol.validHouse('mansion'), 'kennel');
      expect(YardProtocol.validMood('rage'), CharacterMood.signature);
      expect(YardProtocol.validAct('fly'), YardAct.idle);
      expect(YardProtocol.validX(double.nan), 0.5);
      expect(YardProtocol.validX(99), 1.0);
      expect(YardProtocol.validX(-3), 0.0);
      expect(YardProtocol.validX('left'), 0.5);
    });
  });

  group('room model', () {
    test('hello admits a validated peer and hb updates it', () {
      final room = YardRoom();
      final t0 = DateTime(2026, 7, 19, 12);
      room.apply('p1', _hello(), at: t0);
      final peer = room.peers['p1']!;
      expect(peer.name, 'Rex');
      expect(peer.breedId, 'husky');
      room.apply('p1', {
        'v': 2,
        't': 'hb',
        'mood': 'hype',
        'x': 0.8,
        'flip': true,
        'act': 'walk',
      }, at: t0.add(const Duration(seconds: 1)));
      expect(peer.mood, CharacterMood.hype);
      expect(peer.x, 0.8);
      expect(peer.flip, isTrue);
      expect(peer.act, YardAct.walk);
    });

    test('hb refreshes identity so mid-den skin changes propagate', () {
      final room = YardRoom();
      final t0 = DateTime(2026, 7, 19, 12);
      room.apply('p1', _hello(), at: t0);
      room.apply('p1', {
        'v': 2,
        't': 'hb',
        'name': 'Nova',
        'breed': 'golden',
        'coat': 'golden',
        'acc': 'none',
        'mood': 'joy',
        'x': 0.4,
      }, at: t0.add(const Duration(seconds: 2)));
      final peer = room.peers['p1']!;
      expect(peer.name, 'Rex');
      expect(peer.breedId, 'husky');
      room.apply('p1', {
        'v': 2,
        't': 'hb',
        'name': 'Nova',
        'breed': 'golden',
        'coat': 'golden',
        'acc': 'none',
        'mood': 'joy',
        'x': 0.4,
      }, at: t0.add(const Duration(seconds: 6)));
      expect(peer.name, 'Nova');
      expect(peer.breedId, 'golden');
      expect(peer.coatId, 'golden');
      expect(peer.accessory, 'none');
      room.apply('p1', {
        'v': 2,
        't': 'hb',
        'x': 0.9,
      }, at: t0.add(const Duration(seconds: 12)));
      expect(peer.name, 'Nova');
      expect(peer.breedId, 'golden');
      expect(peer.accessory, 'none');
    });

    test('heartbeat floods are throttled', () {
      final room = YardRoom();
      final t0 = DateTime(2026, 7, 19, 12);
      room.apply('p1', _hello(), at: t0);
      room.apply('p1', {
        'v': 2,
        't': 'hb',
        'x': 0.1,
      }, at: t0.add(const Duration(milliseconds: 300)));
      for (var i = 0; i < 50; i++) {
        room.apply('p1', {
          'v': 2,
          't': 'hb',
          'x': 0.9,
        }, at: t0.add(Duration(milliseconds: 300 + i)));
      }
      expect(room.peers['p1']!.x, 0.1);
    });

    test('bark and perform spam is rate limited', () {
      final room = YardRoom();
      final t0 = DateTime(2026, 7, 19, 12);
      room.apply('p1', _hello(), at: t0);
      room.apply('p1', {'v': 2, 't': 'bark'}, at: t0);
      final firstBark = room.peers['p1']!.barkAt;
      for (var i = 1; i < 20; i++) {
        room.apply('p1', {
          'v': 2,
          't': 'bark',
        }, at: t0.add(Duration(milliseconds: i * 50)));
      }
      expect(room.peers['p1']!.barkAt, firstBark);
      room.apply('p1', {
        'v': 2,
        't': 'bark',
      }, at: t0.add(const Duration(seconds: 2)));
      expect(room.peers['p1']!.barkAt, isNot(firstBark));
    });

    test('room cap refuses extra dogs', () {
      final room = YardRoom(cap: 3);
      final t0 = DateTime(2026, 7, 19, 12);
      room.apply('p1', _hello(name: 'One'), at: t0);
      room.apply('p2', _hello(name: 'Two'), at: t0);
      room.apply('p3', _hello(name: 'Three'), at: t0);
      expect(room.peers.length, 2);
    });

    test('host message from a non host is ignored', () {
      final room = YardRoom();
      final t0 = DateTime(2026, 7, 19, 12);
      room.hostId = 'host';
      room.apply('host', _hello(name: 'Host'), at: t0);
      room.apply('p1', _hello(), at: t0);
      room.apply('p1', {
        'v': 2,
        't': 'host',
        'house': 'teahouse',
      }, at: t0.add(const Duration(seconds: 1)));
      expect(room.houseId, 'kennel');
      room.apply('host', {
        'v': 2,
        't': 'host',
        'house': 'teahouse',
      }, at: t0.add(const Duration(seconds: 1)));
      expect(room.houseId, 'teahouse');
    });

    test('silent peers get evicted after the stale window', () {
      final room = YardRoom();
      final t0 = DateTime(2026, 7, 19, 12);
      room.apply('p1', _hello(), at: t0);
      room.sweep(at: t0.add(const Duration(seconds: 9)));
      expect(room.peers.containsKey('p1'), isTrue);
      final evictAt = t0.add(const Duration(seconds: 11));
      room.sweep(at: evictAt);
      expect(room.peers['p1']!.leavingAt, isNotNull);
      room.sweep(at: evictAt.add(const Duration(seconds: 2)));
      expect(room.peers.containsKey('p1'), isFalse);
    });

    test('bye walks the dog out then removes it', () {
      final room = YardRoom();
      final t0 = DateTime(2026, 7, 19, 12);
      room.apply('p1', _hello(), at: t0);
      room.apply('p1', {
        'v': 2,
        't': 'bye',
      }, at: t0.add(const Duration(seconds: 1)));
      expect(room.peers['p1']!.leavingAt, isNotNull);
      room.sweep(at: t0.add(const Duration(seconds: 3)));
      expect(room.peers.containsKey('p1'), isFalse);
    });

    test('malformed frames never mutate the room', () {
      final room = YardRoom();
      final t0 = DateTime(2026, 7, 19, 12);
      room.apply('p1', _hello(), at: t0);
      final before = room.peers['p1']!.x;
      room.applyBytes(
        'p1',
        Uint8List.fromList(utf8.encode('{"v":1,"t":"hb","x":')),
      );
      room.applyBytes('p1', _frame({'v': 3, 't': 'hb', 'x': 0.9}));
      room.applyBytes('p1', _frame({'v': 2, 't': 'teleport', 'x': 0.9}));
      expect(room.peers['p1']!.x, before);
    });

    test('kick targeting only fires for the aimed session id', () {
      final kick = YardProtocol.decode(YardProtocol.kick('abc123'))!;
      expect(YardProtocol.kickAims(kick, 'abc123'), isTrue);
      expect(YardProtocol.kickAims(kick, 'zzz999'), isFalse);
      expect(YardProtocol.kickAims(kick, ''), isFalse);
      expect(
        YardProtocol.kickAims({'v': 2, 't': 'hb', 'to': 'abc123'}, 'abc123'),
        isFalse,
      );
    });

    test('session ids survive hello and hostile sids are dropped', () {
      final room = YardRoom();
      room.apply('p1', {..._hello(), 'sid': 'abcd1234'});
      expect(room.peers['p1']!.sid, 'abcd1234');
      final room2 = YardRoom();
      room2.apply('p1', {..._hello(), 'sid': 'UPPER-CASE!!'});
      expect(room2.peers['p1']!.sid, '');
      room2.apply('p2', {..._hello(), 'sid': 'x' * 40});
      expect(room2.peers['p2']!.sid, '');
    });

    test('hostile identity payload renders as a safe default dog', () {
      final room = YardRoom();
      room.apply('p1', {
        'v': 2,
        't': 'hello',
        'name': '\x1b[31mEvil\x1b[0m',
        'breed': {'nested': 'object'},
        'coat': 42,
        'acc': ['list'],
      });
      final peer = room.peers['p1']!;
      expect(peer.name, '[31mEvil[0m');
      expect(peer.breedId, 'golden');
      expect(peer.coatId, 'golden');
      expect(peer.accessory, 'none');
    });
  });
}
