import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _wallIndigo = Color(0xFF403C64);
const _wallSpeck = Color(0x2EF0E4CC);
const _floorWood = Color(0xFF57443A);
const _floorSeam = Color(0x3D241812);
const _floorGrain = Color(0x21170F0B);
const _torii = Color(0xFFB0523B);
const _toriiDark = Color(0xFF84392A);
const _screenPaper = Color(0xFFF2E4C1);
const _screenGlow = Color(0x26F6B84C);
const _lattice = Color(0x8C594534);
const _rail = Color(0xFF6F4B33);
const _talisman = Color(0xFFF7EDD3);
const _talismanMark = Color(0xFFC24C3F);
const _blueCore = Color(0xFF6D9BD8);
const _blueDeep = Color(0xFF48699E);
const _blueHalo = Color(0x2E6D9BD8);
const _blueFloor = Color(0x306D9BD8);
const _blueSpark = Color(0xFFA9C6EA);
const _redCore = Color(0xFFD8604C);
const _redDeep = Color(0xFFA03A2C);
const _redHalo = Color(0x2ED8604C);
const _redFloor = Color(0x30D8604C);
const _redSpark = Color(0xFFEAA79B);
const _standWood = Color(0xFF7A5940);
const _cloth = Color(0xFF2E2733);
const _clothSheen = Color(0x4DB9AECB);
const _scroll = Color(0xFFF6EDDA);
const _flameHalo = Color(0x2EF6B84C);

void paintCursedHouse(Sketch s) {
  _room(s);
  _screens(s);
  _toriiFrame(s);
  _talismans(s);
  _blindfoldStand(s);
  _desk(s);
  _orbs(s);
}

void _room(Sketch s) {
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 63));
  s.fillArea(wall, _wallIndigo, amp: 0.35);
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 61.5, 102, 102));
  s.fillArea(floor, _floorWood, amp: 0.35);
  s.strokeLine(
    const Offset(-1, 62),
    const Offset(101, 62),
    width: 1.8,
    amp: 0.35,
  );
  s.strokeLine(
    const Offset(-1, 75.5),
    const Offset(101, 75.5),
    width: 1.1,
    color: _floorSeam,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(-1, 88),
    const Offset(101, 88),
    width: 1.1,
    color: _floorSeam,
    amp: 0.3,
  );
  for (final seam in const [
    [Offset(70, 62.8), Offset(70, 75.1)],
    [Offset(30, 75.9), Offset(30, 87.6)],
    [Offset(82, 75.9), Offset(82, 87.6)],
    [Offset(55, 88.4), Offset(55, 101)],
  ]) {
    s.strokeLine(seam[0], seam[1], width: 1, color: _floorSeam, amp: 0.25);
  }
  s.grain(floor, dots: 16, color: _floorGrain, r: 0.6);
  s.dot(const Offset(32.6, 46.5), 0.55, color: _wallSpeck);
  s.dot(const Offset(67.4, 43), 0.6, color: _wallSpeck);
  s.dot(const Offset(34.2, 53.5), 0.45, color: _wallSpeck);
  s.dot(const Offset(65.2, 51.5), 0.5, color: _wallSpeck);
}

void _screens(Sketch s) {
  for (final x0 in const [12.5, 42.5, 72.5]) {
    final paper = Path()..addRect(Rect.fromLTRB(x0, 20.5, x0 + 15, 61));
    s.fillArea(paper, _screenPaper, amp: 0.28);
    s.dot(Offset(x0 + 7.5, 37), 9, color: _screenGlow);
    s.strokeLine(
      Offset(x0 + 7.5, 21.2),
      Offset(x0 + 7.5, 60.3),
      width: 1.2,
      color: _lattice,
      amp: 0.2,
    );
    for (final y in const [28.5, 36.5, 44.5, 52.5]) {
      s.strokeLine(
        Offset(x0 + 0.6, y),
        Offset(x0 + 14.4, y),
        width: 1.2,
        color: _lattice,
        amp: 0.2,
      );
    }
    s.ink(paper, width: 1.9, amp: 0.3);
    s.strokeLine(
      Offset(x0 - 0.8, 61.3),
      Offset(x0 + 15.8, 61.3),
      width: 2,
      color: _rail,
      amp: 0.25,
    );
  }
}

void _toriiFrame(Sketch s) {
  final nuki = Path()..addRect(const Rect.fromLTRB(1.5, 11.8, 98.5, 16.6));
  s.fillArea(nuki, _torii, amp: 0.3);
  s.strokeLine(
    const Offset(2, 16.4),
    const Offset(98, 16.4),
    width: 1.2,
    color: _toriiDark,
    amp: 0.25,
  );
  final leftPillar = Path()..addRect(const Rect.fromLTRB(4.2, 7.5, 9.6, 62.3));
  final rightPillar = Path()
    ..addRect(const Rect.fromLTRB(90.4, 7.5, 95.8, 62.3));
  s.fillArea(leftPillar, _torii, amp: 0.3);
  s.fillArea(rightPillar, _torii, amp: 0.3);
  s.ink(leftPillar, width: 1.7, amp: 0.3);
  s.ink(rightPillar, width: 1.7, amp: 0.3);
  s.strokeLine(
    const Offset(8.5, 10),
    const Offset(8.5, 61.2),
    width: 1.1,
    color: _toriiDark,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(91.5, 10),
    const Offset(91.5, 61.2),
    width: 1.1,
    color: _toriiDark,
    amp: 0.25,
  );
  final kasagi = Path()
    ..moveTo(-2, 3.2)
    ..quadraticBezierTo(50, 6.0, 102, 3.2)
    ..lineTo(102, 8.9)
    ..quadraticBezierTo(50, 10.0, -2, 8.9)
    ..close();
  s.fillArea(kasagi, _torii, amp: 0.3);
  s.ink(kasagi, width: 1.6, amp: 0.3);
  s.curve(
    const Offset(-1, 4.3),
    const Offset(50, 7.0),
    const Offset(101, 4.3),
    width: 2.2,
    color: _toriiDark,
    amp: 0.25,
  );
  final strut = Path()..addRect(const Rect.fromLTRB(47.6, 9.4, 52.4, 12.2));
  s.fillArea(strut, _toriiDark, amp: 0.25);
}

void _talismanAt(Sketch s, Offset pin, double rot, double scale) {
  s.canvas.save();
  s.canvas.translate(pin.dx, pin.dy);
  s.canvas.rotate(rot);
  final strip = Path()
    ..addRect(Rect.fromLTRB(-2.6 * scale, 0.5, 2.6 * scale, 10.6 * scale));
  s.fillArea(strip, _talisman, amp: 0.25);
  s.ink(strip, width: 1.3, amp: 0.25);
  final mark = Path()
    ..moveTo(0, 2.0 * scale)
    ..quadraticBezierTo(-0.5 * scale, 4.2 * scale, 0.3 * scale, 6.4 * scale);
  s.ink(mark, width: 1.2, amp: 0.2);
  s.strokeLine(
    Offset(-1.3 * scale, 3.0 * scale),
    Offset(1.3 * scale, 2.8 * scale),
    width: 1,
    amp: 0.2,
  );
  s.strokeLine(
    Offset(-1.0 * scale, 4.9 * scale),
    Offset(1.0 * scale, 4.7 * scale),
    width: 1,
    amp: 0.2,
  );
  s.dot(Offset(0, 8.4 * scale), 0.9 * scale, color: _talismanMark);
  s.dot(Offset.zero, 0.85 * scale);
  s.canvas.restore();
}

void _talismans(Sketch s) {
  _talismanAt(s, const Offset(34.8, 25.5), -0.16, 1);
  s.strokeLine(
    const Offset(65.5, 16.6),
    const Offset(65.5, 19.4),
    width: 1.1,
    amp: 0.2,
  );
  final sway = s.live ? math.sin(s.t * 1.1 + 1.3) * 0.07 : 0.05;
  _talismanAt(s, const Offset(65.5, 19.4), sway, 1);
  _talismanAt(s, const Offset(93, 38.5), 0.12, 0.85);
}

void _blindfoldStand(Sketch s) {
  s.strokeLine(
    const Offset(6.8, 89.8),
    const Offset(17.2, 89.8),
    width: 2.8,
    color: _standWood,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(12, 89),
    const Offset(12, 72),
    width: 3,
    color: _standWood,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(5.8, 71.8),
    const Offset(18.2, 71.8),
    width: 2.8,
    color: _standWood,
    amp: 0.25,
  );
  s.dot(const Offset(5.8, 71.8), 0.9);
  s.dot(const Offset(18.2, 71.8), 0.9);
  final wrap = Path()
    ..moveTo(6.6, 71.8)
    ..quadraticBezierTo(10.4, 68.6, 14.6, 71.6)
    ..lineTo(14.0, 74.4)
    ..quadraticBezierTo(10.4, 76.0, 7.2, 74.0)
    ..close();
  s.fillArea(wrap, _cloth, amp: 0.3);
  s.ink(wrap, width: 1.3, amp: 0.3);
  s.curve(
    const Offset(8.4, 70.6),
    const Offset(10.5, 69.8),
    const Offset(12.6, 70.6),
    width: 1,
    color: _clothSheen,
    amp: 0.2,
  );
  s.curve(
    const Offset(8.2, 73.8),
    const Offset(7.0, 78.8),
    const Offset(8.8, 84.0),
    width: 3,
    color: _cloth,
    amp: 0.3,
  );
  s.curve(
    const Offset(13.2, 74.2),
    const Offset(14.6, 77.6),
    const Offset(13.6, 80.6),
    width: 3,
    color: _cloth,
    amp: 0.3,
  );
  s.curve(
    const Offset(8.8, 84.0),
    const Offset(9.2, 85.4),
    const Offset(8.2, 86.2),
    width: 2.1,
    color: _cloth,
    amp: 0.25,
  );
  s.curve(
    const Offset(7.8, 74.6),
    const Offset(7.0, 78.6),
    const Offset(8.4, 82.8),
    width: 0.9,
    color: _clothSheen,
    amp: 0.2,
  );
}

void _desk(Sketch s) {
  final top = Path()..addRect(const Rect.fromLTRB(80.5, 73.6, 99.5, 76.9));
  s.fillArea(top, _standWood, amp: 0.3);
  s.ink(top, width: 1.6, amp: 0.3);
  s.strokeLine(
    const Offset(83.2, 77.2),
    const Offset(83.2, 84.6),
    width: 2.8,
    color: _rail,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(96.8, 77.2),
    const Offset(96.8, 84.6),
    width: 2.8,
    color: _rail,
    amp: 0.25,
  );
  final roll = Path()..addRect(const Rect.fromLTRB(82.6, 70.4, 90.8, 73.4));
  s.fillArea(roll, _scroll, amp: 0.25);
  s.ink(roll, width: 1.3, amp: 0.25);
  s.dot(const Offset(83.2, 71.9), 1.05, color: _torii);
  s.curve(
    const Offset(84.4, 71.4),
    const Offset(87.2, 72.2),
    const Offset(90.0, 71.4),
    width: 1,
    color: _lattice,
    amp: 0.2,
  );
  final flicker = s.live ? 1 + 0.12 * math.sin(s.t * 6.3 + 1.7) : 1.0;
  s.strokeLine(
    const Offset(94.8, 73.4),
    const Offset(94.8, 70.2),
    width: 2.4,
    color: _scroll,
    amp: 0.2,
  );
  s.dot(const Offset(94.8, 68.4), 2.8 * flicker, color: _flameHalo);
  s.dot(const Offset(94.8, 68.4), 1.15 * flicker, color: Inks.sun);
}

void _orb(
  Sketch s,
  Offset base,
  double phase,
  Color core,
  Color deep,
  Color halo,
  Color pool,
  Color spark,
) {
  final bob = s.live ? math.sin(s.t * 1.5 + phase) * 1.7 : 0.0;
  final drift = s.live ? math.sin(s.t * 0.7 + phase * 1.8) * 0.8 : 0.0;
  final c = Offset(base.dx + drift, base.dy + bob);
  final poolPath = Path()
    ..addOval(
      Rect.fromCenter(center: Offset(base.dx, 65.8), width: 15, height: 4),
    );
  s.fillArea(poolPath, pool, amp: 0.35);
  s.dot(c, 6.3, color: halo);
  s.dot(c, 2.7, color: core);
  s.ring(c, 4.0, width: 1.3, color: deep, amp: 0.2);
  s.dot(Offset(c.dx - 0.9, c.dy - 1.0), 0.7, color: Inks.white);
  s.sparkle(Offset(c.dx + 4.8, c.dy - 4.4), 1.9, color: spark, width: 1.3);
}

void _orbs(Sketch s) {
  _orb(
    s,
    const Offset(16, 30.5),
    0.4,
    _blueCore,
    _blueDeep,
    _blueHalo,
    _blueFloor,
    _blueSpark,
  );
  _orb(
    s,
    const Offset(84.5, 28),
    2.5,
    _redCore,
    _redDeep,
    _redHalo,
    _redFloor,
    _redSpark,
  );
}
