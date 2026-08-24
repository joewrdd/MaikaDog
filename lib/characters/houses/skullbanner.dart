import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _beam = Color(0xFF453022);
const _wall = Color(0xFF564B47);
const _mortar = Color(0x52201412);
const _stoneLite = Color(0x16FFE4C4);
const _stoneDark = Color(0x1A140A0E);
const _floor = Color(0xFF6A4733);
const _plankSeam = Color(0x5527160D);
const _rug = Color(0xFF6E3F38);
const _rugLine = Color(0x4DC9A15A);
const _cloth = Color(0xFF2E2830);
const _gold = Color(0xFFC9A15A);
const _bone = Color(0xFFEDE0C4);
const _iron = Color(0xFF4A342A);
const _guard = Color(0xFF35251E);
const _steamPuff = Color(0x59F1E4CC);
const _flameCore = Color(0xFFE07048);
const _halo = Color(0x30F6B84C);
const _steel = Color(0xFF9A9088);
const _steelShine = Color(0x66FFF6E9);
const _grip = Color(0xFF54382A);
const _tableTop = Color(0xFF7C5136);
const _tableLeg = Color(0xFF5C3B26);
const _meat = Color(0xFFB05C42);

void paintSkullbannerHouse(Sketch s) {
  _room(s);
  _bullBanner(s);
  _candle(s, 27, 0.4);
  _candle(s, 73, 2.3);
  _greatsword(s);
  _feastTable(s);
}

void _room(Sketch s) {
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 63));
  s.fillArea(wall, _wall, amp: 0.35);
  const liteBlocks = [
    Rect.fromLTRB(62.5, 7.6, 87.5, 15.6),
    Rect.fromLTRB(76.5, 16.4, 101, 24.6),
    Rect.fromLTRB(-2, 34.6, 17.5, 42.4),
  ];
  const darkBlocks = [
    Rect.fromLTRB(56.5, 25.5, 91.5, 33.5),
    Rect.fromLTRB(66.5, 43.6, 93.5, 51.4),
    Rect.fromLTRB(10.5, 52.6, 41.5, 60.6),
  ];
  for (final r in liteBlocks) {
    s.fillArea(Path()..addRect(r), _stoneLite, amp: 0.35);
  }
  for (final r in darkBlocks) {
    s.fillArea(Path()..addRect(r), _stoneDark, amp: 0.35);
  }
  for (var i = 0; i < 5; i++) {
    final y = 16.0 + i * 9;
    s.strokeLine(
      Offset(-1, y),
      Offset(101, y),
      width: 1.4,
      color: _mortar,
      amp: 0.45,
    );
  }
  const jointRows = [
    [24.0, 62.0, 88.0],
    [12.0, 40.0, 76.0],
    [30.0, 56.0, 92.0],
    [18.0, 46.0, 82.0],
    [34.0, 66.0, 94.0],
    [10.0, 42.0, 72.0],
  ];
  for (var i = 0; i < jointRows.length; i++) {
    final top = 7.0 + 9.0 * i;
    for (final x in jointRows[i]) {
      s.strokeLine(
        Offset(x, top + 1.2),
        Offset(x, top + 7.8),
        width: 1.3,
        color: _mortar,
        amp: 0.4,
      );
    }
  }
  s.curve(
    const Offset(80.5, 17.2),
    const Offset(82.3, 19.4),
    const Offset(81.4, 21.8),
    width: 1.1,
    color: _mortar,
    amp: 0.4,
  );
  s.curve(
    const Offset(31.5, 45.4),
    const Offset(29.8, 47.2),
    const Offset(30.8, 49.6),
    width: 1.1,
    color: _mortar,
    amp: 0.4,
  );
  for (var i = 0; i < 3; i++) {
    final x = 79.5 + i * 2.4;
    s.strokeLine(
      Offset(x, 37.6 + i * 0.4),
      Offset(x + 1.6, 43.2 + i * 0.4),
      width: 1.1,
      color: _mortar,
      amp: 0.3,
    );
  }
  s.grain(wall, dots: 14, r: 0.6, color: const Color(0x1E140A0E));
  final beam = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 6.5));
  s.fillArea(beam, _beam, amp: 0.3);
  s.strokeLine(
    const Offset(-1, 6.6),
    const Offset(101, 6.6),
    width: 1.7,
    amp: 0.3,
  );
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 61, 102, 102));
  s.fillArea(floor, _floor, amp: 0.35);
  s.strokeLine(
    const Offset(-1, 61.2),
    const Offset(101, 61.2),
    width: 1.9,
    amp: 0.35,
  );
  for (final y in const [70.5, 80.0, 89.5]) {
    s.strokeLine(
      Offset(-1, y),
      Offset(101, y),
      width: 1.3,
      color: _plankSeam,
      amp: 0.35,
    );
  }
  const plankTicks = [
    [Offset(34, 62.4), Offset(34, 69.6)],
    [Offset(78, 62.4), Offset(78, 69.6)],
    [Offset(22, 71.6), Offset(22, 79.0)],
    [Offset(92, 71.6), Offset(92, 79.0)],
    [Offset(14, 81.0), Offset(14, 88.6)],
    [Offset(88, 81.0), Offset(88, 88.6)],
    [Offset(38, 90.6), Offset(38, 99.0)],
    [Offset(74, 90.6), Offset(74, 99.0)],
  ];
  for (final tick in plankTicks) {
    s.strokeLine(tick[0], tick[1], width: 1.2, color: _plankSeam, amp: 0.3);
  }
  s.grain(floor, dots: 10, r: 0.55, color: const Color(0x2427160D));
  final rug = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 78.5), width: 46, height: 16),
    );
  s.fillArea(rug, _rug, amp: 0.45);
  s.ink(rug, width: 1.5, color: const Color(0x8033251D), amp: 0.45);
  final rugInner = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 78.5), width: 38, height: 11),
    );
  s.ink(rugInner, width: 1.1, color: _rugLine, amp: 0.45);
}

void _bullBanner(Sketch s) {
  s.strokeLine(
    const Offset(36, 8.5),
    const Offset(64, 8.5),
    width: 2.6,
    color: _iron,
    amp: 0.2,
  );
  s.dot(const Offset(36, 8.5), 1.4, color: _iron);
  s.dot(const Offset(64, 8.5), 1.4, color: _iron);
  final sway = s.live ? math.sin(s.t * 0.7 + 1.3) * 0.028 : 0.0;
  s.canvas.save();
  s.canvas.translate(50, 8.5);
  s.canvas.rotate(sway);
  s.canvas.translate(-50, -8.5);
  s.strokeLine(
    const Offset(41, 8.6),
    const Offset(41, 10.6),
    width: 2.0,
    color: _cloth,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(59, 8.6),
    const Offset(59, 10.6),
    width: 2.0,
    color: _cloth,
    amp: 0.15,
  );
  final banner = Path()
    ..moveTo(37.5, 10.2)
    ..lineTo(62.5, 10.2)
    ..lineTo(62.5, 30)
    ..lineTo(56, 35.5)
    ..lineTo(50, 29.5)
    ..lineTo(44, 35.5)
    ..lineTo(37.5, 30)
    ..close();
  s.fillArea(banner, _cloth, amp: 0.3);
  s.ink(banner, width: 1.7, amp: 0.3);
  final hem = Path()
    ..moveTo(38.2, 29.7)
    ..lineTo(44, 34.6)
    ..lineTo(50, 28.6)
    ..lineTo(56, 34.6)
    ..lineTo(61.8, 29.7);
  s.ink(hem, width: 1.2, color: _gold, amp: 0.3);
  s.curve(
    const Offset(46.2, 18.0),
    const Offset(42.0, 17.6),
    const Offset(42.6, 13.0),
    width: 2.8,
    color: _bone,
    amp: 0.2,
  );
  s.curve(
    const Offset(53.8, 18.0),
    const Offset(58.0, 17.6),
    const Offset(57.4, 13.0),
    width: 2.8,
    color: _bone,
    amp: 0.2,
  );
  s.dot(const Offset(42.6, 13.0), 1.2, color: _bone);
  s.dot(const Offset(57.4, 13.0), 1.2, color: _bone);
  final skull = Path()
    ..moveTo(45.8, 18.4)
    ..quadraticBezierTo(45.6, 15.2, 50, 15.2)
    ..quadraticBezierTo(54.4, 15.2, 54.2, 18.4)
    ..quadraticBezierTo(54.0, 21.0, 52.6, 23.0)
    ..quadraticBezierTo(51.5, 25.2, 50, 25.2)
    ..quadraticBezierTo(48.5, 25.2, 47.4, 23.0)
    ..quadraticBezierTo(46.0, 21.0, 45.8, 18.4)
    ..close();
  s.fillArea(skull, _bone, amp: 0.2);
  s.ink(skull, width: 1.4, amp: 0.2);
  s.dot(const Offset(47.9, 19.4), 1.0, color: _cloth);
  s.dot(const Offset(52.1, 19.4), 1.0, color: _cloth);
  s.dot(const Offset(49.1, 23.4), 0.5, color: _cloth);
  s.dot(const Offset(50.9, 23.4), 0.5, color: _cloth);
  s.dot(const Offset(44, 36.2), 1.0, color: _gold);
  s.dot(const Offset(56, 36.2), 1.0, color: _gold);
  s.canvas.restore();
}

void _candle(Sketch s, double cx, double phase) {
  final flick = s.live ? math.sin(s.t * 6.1 + phase) : 0.0;
  final flick2 = s.live ? math.sin(s.t * 9.7 + phase * 2 + 1.1) : 0.0;
  s.dot(Offset(cx, 22.5), 7.6 + flick2 * 0.6, color: _halo);
  s.strokeLine(
    Offset(cx, 31.4),
    Offset(cx, 34.6),
    width: 1.6,
    color: _iron,
    amp: 0.25,
  );
  s.dot(Offset(cx, 35.2), 1.05, color: _iron);
  s.strokeLine(
    Offset(cx - 2.8, 30.6),
    Offset(cx + 2.8, 30.6),
    width: 2.4,
    color: _iron,
    amp: 0.2,
  );
  final body = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(cx - 1.7, 23.4, cx + 1.7, 29.9),
        const Radius.circular(1.1),
      ),
    );
  s.fillArea(body, _bone, amp: 0.25);
  s.ink(body, width: 1.4, amp: 0.25);
  s.dot(Offset(cx - 1.5, 24.4), 0.75, color: _bone);
  final lean = flick * 0.75;
  final h = 4.6 + flick2 * 0.55;
  final tip = Offset(cx + lean, 23.2 - h);
  final flame = Path()
    ..moveTo(cx - 1.5, 21.9)
    ..quadraticBezierTo(cx - 1.7, 19.6, tip.dx, tip.dy)
    ..quadraticBezierTo(cx + 1.7, 19.6, cx + 1.5, 21.9)
    ..quadraticBezierTo(cx + 1.1, 23.3, cx, 23.3)
    ..quadraticBezierTo(cx - 1.1, 23.3, cx - 1.5, 21.9)
    ..close();
  s.fillArea(flame, Inks.sun, amp: 0.2);
  s.dot(Offset(cx + lean * 0.4, 21.6), 0.9, color: _flameCore);
}

void _greatsword(Sketch s) {
  final blade = Path()
    ..moveTo(9.6, 72)
    ..lineTo(6.0, 33.4)
    ..lineTo(13.8, 31.2)
    ..lineTo(17.6, 70.6)
    ..close();
  s.fillArea(blade, _steel, amp: 0.25);
  s.shade(blade, lift: const Offset(-1.8, -2.4), gap: 4.4);
  s.ink(blade, width: 1.9, amp: 0.25);
  s.strokeLine(
    const Offset(12.2, 67),
    const Offset(9.2, 36),
    width: 1.25,
    color: Inks.inkFaint,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(8.2, 66),
    const Offset(6.8, 38),
    width: 1.1,
    color: _steelShine,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(17.0, 48.8),
    const Offset(15.8, 50.0),
    width: 1.3,
    amp: 0.2,
  );
  s.dot(const Offset(13.3, 68.6), 1.05, color: _gold);
  s.strokeLine(
    const Offset(7.6, 73.5),
    const Offset(19.6, 70.7),
    width: 3.6,
    color: _guard,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(14.8, 73.8),
    const Offset(17.2, 85.4),
    width: 3.2,
    color: _grip,
    amp: 0.2,
  );
  for (var i = 0; i < 3; i++) {
    final f = 0.24 + i * 0.26;
    final p = Offset(14.8 + 2.4 * f, 73.8 + 11.6 * f);
    s.strokeLine(
      Offset(p.dx - 1.8, p.dy + 0.4),
      Offset(p.dx + 1.8, p.dy - 0.4),
      width: 1.1,
      color: _gold,
      amp: 0.15,
    );
  }
  s.dot(const Offset(17.6, 86.6), 1.8, color: _iron);
  s.ring(const Offset(17.6, 86.6), 1.8, width: 1.3);
}

void _feastTable(Sketch s) {
  s.strokeLine(
    const Offset(84.2, 76),
    const Offset(84.2, 84.6),
    width: 3,
    color: _tableLeg,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(97.6, 76),
    const Offset(97.6, 84.6),
    width: 3,
    color: _tableLeg,
    amp: 0.25,
  );
  final top = Path()..addRect(const Rect.fromLTRB(80, 72.2, 102, 75.6));
  s.fillArea(top, _tableTop, amp: 0.3);
  s.ink(top, width: 1.7, amp: 0.3);
  final plate = Path()
    ..addOval(
      Rect.fromCenter(
        center: const Offset(90.5, 71.6),
        width: 15.5,
        height: 4.6,
      ),
    );
  s.fillArea(plate, _bone, amp: 0.25);
  s.ink(plate, width: 1.4, amp: 0.25);
  s.strokeLine(
    const Offset(83.8, 66.8),
    const Offset(97.2, 64.9),
    width: 2.3,
    color: _bone,
    amp: 0.2,
  );
  s.dot(const Offset(83.3, 66.9), 1.35, color: _bone);
  s.ring(const Offset(83.3, 66.9), 1.35, width: 1.1);
  s.dot(const Offset(97.7, 64.8), 1.35, color: _bone);
  s.ring(const Offset(97.7, 64.8), 1.35, width: 1.1);
  final meat = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(90.5, 65.6), width: 11, height: 7.6),
    );
  s.fillArea(meat, _meat, amp: 0.3);
  s.shade(meat, lift: const Offset(-1.4, -1.8), gap: 3.6);
  s.ink(meat, width: 1.6, amp: 0.3);
  s.gleam(
    const Offset(87.9, 63.6),
    2.7,
    sweepDeg: 46,
    width: 1.5,
    color: const Color(0x7DFFFFFF),
  );
  s.steam(
    const Offset(88.8, 61.4),
    h: 8,
    sway: 2.2,
    width: 1.4,
    color: _steamPuff,
  );
  s.steam(
    const Offset(92.8, 61.8),
    h: 6.4,
    sway: 1.8,
    width: 1.3,
    color: _steamPuff,
  );
}
