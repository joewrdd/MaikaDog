import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _wall = Color(0xFFEBD9B6);
const _floor = Color(0xFFB5906F);
const _wood = Color(0xFF7C523A);
const _woodDark = Color(0xFF5F3D2A);
const _woodLight = Color(0xFF9F7048);
const _rug = Color(0xFFC57A5F);
const _rugEdge = Color(0xFF8A4632);
const _rugRing = Color(0x59FFF3DC);
const _shadeWarm = Color(0xFFEFA845);
const _glowRim = Color(0x12F6B84C);
const _glowFar = Color(0x1FF6B84C);
const _glowMid = Color(0x30F6B84C);
const _glowCore = Color(0x45F6B84C);
const _pool = Color(0x2BF6B84C);
const _mote = Color(0x73F6B84C);
const _teal = Color(0xFF5E8F86);
const _plum = Color(0xFF8E6B93);
const _brick = Color(0xFFB65C4E);
const _shadow = Color(0x2133251D);
const _plank = Color(0x2633251D);

void _spine(
  Sketch s,
  double x,
  double bottom,
  double w,
  double h,
  Color c, {
  bool tick = false,
}) {
  final p = Path()..addRect(Rect.fromLTWH(x, bottom - h, w, h));
  s.fillArea(p, c, amp: 0.2);
  s.ink(p, width: 1.2, amp: 0.2);
  if (tick) {
    s.strokeLine(
      Offset(x + 0.7, bottom - h * 0.72),
      Offset(x + w - 0.7, bottom - h * 0.72),
      width: 0.9,
      color: Inks.inkFaint,
      amp: 0.15,
    );
  }
}

void _row(
  Sketch s,
  double left,
  double bottom,
  List<(double, double, Color)> books,
) {
  var x = left;
  var i = 0;
  for (final (w, h, c) in books) {
    _spine(s, x, bottom, w, h, c, tick: i.isOdd);
    x += w + 0.4;
    i++;
  }
}

void _lying(Sketch s, double x, double bottom, double len, Color c) {
  final p = Path()..addRect(Rect.fromLTWH(x, bottom - 2.7, len, 2.7));
  s.fillArea(p, c, amp: 0.2);
  s.ink(p, width: 1.2, amp: 0.2);
}

void _bookcase(Sketch s) {
  final ground = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(11.5, 75.8), width: 18, height: 3.4),
    );
  s.fillArea(ground, _shadow, amp: 0.3);
  final box = Path()..addRect(const Rect.fromLTRB(3.5, 8.5, 19.5, 75));
  s.fillArea(box, _wood, amp: 0.3);
  for (final top in const [12.0, 27.0, 42.0, 57.0]) {
    final cavity = Path()..addRect(Rect.fromLTRB(5.5, top, 17.5, top + 12.5));
    s.fillArea(cavity, _woodDark, amp: 0.25);
  }
  _row(s, 5.9, 24.5, const [
    (3.2, 10.0, Inks.rose),
    (3.0, 8.6, _teal),
    (3.4, 11.0, Inks.sun),
  ]);
  _row(s, 5.9, 39.5, const [
    (3.4, 10.4, Inks.sky),
    (3.0, 9.0, _brick),
    (2.9, 10.0, Inks.leaf),
  ]);
  _row(s, 5.6, 54.5, const [
    (2.6, 9.0, _plum),
    (2.9, 10.4, Inks.sun),
    (2.6, 8.4, Inks.sky),
    (2.4, 9.6, Inks.rose),
  ]);
  _lying(s, 6.0, 69.5, 10.0, _plum);
  _lying(s, 6.8, 66.8, 9.0, Inks.sun);
  _lying(s, 7.4, 64.1, 7.5, _teal);
  for (final top in const [24.5, 39.5, 54.5, 69.5]) {
    final board = Path()..addRect(Rect.fromLTRB(4.5, top, 18.5, top + 2.2));
    s.fillArea(board, _woodLight, amp: 0.2);
    s.ink(board, width: 1.1, amp: 0.2);
  }
  s.ink(box, width: 2.0, amp: 0.3);
  final pot = Path()
    ..moveTo(7.8, 4.8)
    ..lineTo(13.2, 4.8)
    ..lineTo(12.4, 8.6)
    ..lineTo(8.6, 8.6)
    ..close();
  s.fillArea(pot, _brick, amp: 0.25);
  s.ink(pot, width: 1.3, amp: 0.25);
  s.curve(
    const Offset(10.5, 4.8),
    const Offset(9.2, 2.6),
    const Offset(8.2, 1.6),
    width: 1.5,
    color: Inks.leafDeep,
    amp: 0.3,
  );
  s.curve(
    const Offset(10.5, 4.8),
    const Offset(11.8, 2.4),
    const Offset(13.0, 1.8),
    width: 1.5,
    color: Inks.leaf,
    amp: 0.3,
  );
  s.dot(const Offset(8.2, 1.6), 1.0, color: Inks.leaf);
  s.dot(const Offset(13.0, 1.8), 0.9, color: Inks.leafDeep);
}

void _wallShelf(Sketch s) {
  _row(s, 28.0, 25.0, const [
    (3.2, 10.2, _teal),
    (3.0, 8.8, Inks.rose),
    (3.4, 10.8, Inks.sun),
    (2.8, 9.4, Inks.sky),
    (3.2, 10.0, _brick),
    (3.0, 8.6, Inks.leaf),
  ]);
  final lean = Path()
    ..moveTo(49.8, 25.0)
    ..lineTo(52.6, 25.0)
    ..lineTo(49.7, 16.4)
    ..lineTo(46.9, 16.4)
    ..close();
  s.fillArea(lean, _plum, amp: 0.2);
  s.ink(lean, width: 1.2, amp: 0.2);
  _lying(s, 58.0, 25.0, 11.0, Inks.sky);
  _lying(s, 58.8, 22.3, 9.6, Inks.rose);
  final mug = Path()..addRect(const Rect.fromLTWH(62.4, 16.5, 3.4, 3.1));
  s.fillArea(mug, _brick, amp: 0.2);
  s.ink(mug, width: 1.2, amp: 0.2);
  s.ring(const Offset(66.6, 18.0), 1.1, width: 1.1);
  s.steam(const Offset(64.1, 15.8), h: 6, sway: 1.6);
  final board = Path()..addRect(const Rect.fromLTRB(26, 25, 74, 27.6));
  s.fillArea(board, _woodLight, amp: 0.2);
  s.ink(board, width: 1.4, amp: 0.2);
  s.strokeLine(const Offset(29, 27.6), const Offset(29, 30.6), width: 1.6);
  s.strokeLine(const Offset(71, 27.6), const Offset(71, 30.6), width: 1.6);
}

void _lamp(Sketch s, double wave) {
  s.dot(const Offset(89, 35), 21 + wave * 1.4, color: _glowRim);
  s.dot(const Offset(89, 35), 17 + wave * 1.2, color: _glowFar);
  s.dot(const Offset(89, 35), 12 + wave * 0.8, color: _glowMid);
  s.dot(const Offset(89, 35), 8 + wave * 0.5, color: _glowCore);
  final pool = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(88, 89.5), width: 24, height: 8),
    );
  s.fillArea(pool, _pool, amp: 0.4);
  final ground = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(89, 87.2), width: 13, height: 3),
    );
  s.fillArea(ground, _shadow, amp: 0.3);
  s.strokeLine(
    const Offset(89, 39.5),
    const Offset(89, 84.5),
    width: 2.0,
    amp: 0.25,
  );
  final base = Path()
    ..moveTo(85.0, 86.8)
    ..lineTo(93.0, 86.8)
    ..lineTo(91.4, 83.6)
    ..lineTo(86.6, 83.6)
    ..close();
  s.fillArea(base, _woodDark, amp: 0.25);
  s.ink(base, width: 1.4, amp: 0.25);
  s.dot(const Offset(89, 41.2), 1.5, color: Inks.sun);
  final shade = Path()
    ..moveTo(83.2, 40)
    ..lineTo(94.8, 40)
    ..lineTo(92.6, 28.5)
    ..lineTo(85.4, 28.5)
    ..close();
  s.fillArea(shade, _shadeWarm, amp: 0.25);
  s.ink(shade, width: 1.7, amp: 0.25);
  s.strokeLine(
    const Offset(87.4, 30.2),
    const Offset(86.6, 38.2),
    width: 0.9,
    color: Inks.inkFaint,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(90.6, 30.2),
    const Offset(91.4, 38.2),
    width: 0.9,
    color: Inks.inkFaint,
    amp: 0.15,
  );
  s.strokeLine(const Offset(89, 28.5), const Offset(89, 26.6), width: 1.6);
}

void _openBook(Sketch s) {
  final ground = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(12.5, 95.4), width: 15, height: 3),
    );
  s.fillArea(ground, _shadow, amp: 0.3);
  final left = Path()
    ..moveTo(12.5, 87.8)
    ..quadraticBezierTo(9.0, 86.6, 6.2, 88.0)
    ..lineTo(6.8, 94.6)
    ..quadraticBezierTo(9.6, 93.6, 12.5, 94.4)
    ..close();
  final right = Path()
    ..moveTo(12.5, 87.8)
    ..quadraticBezierTo(16.0, 86.6, 18.8, 88.0)
    ..lineTo(18.2, 94.6)
    ..quadraticBezierTo(15.4, 93.6, 12.5, 94.4)
    ..close();
  s.fillArea(left, Inks.cream, amp: 0.25);
  s.ink(left, width: 1.4, amp: 0.25);
  s.fillArea(right, Inks.cream, amp: 0.25);
  s.ink(right, width: 1.4, amp: 0.25);
  s.strokeLine(
    const Offset(12.5, 87.8),
    const Offset(12.5, 94.4),
    width: 1.1,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(7.8, 89.6),
    const Offset(11.0, 89.9),
    width: 0.8,
    color: Inks.inkSoft,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(7.9, 91.2),
    const Offset(11.0, 91.5),
    width: 0.8,
    color: Inks.inkSoft,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(14.0, 89.9),
    const Offset(17.2, 89.6),
    width: 0.8,
    color: Inks.inkSoft,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(14.0, 91.5),
    const Offset(17.1, 91.2),
    width: 0.8,
    color: Inks.inkSoft,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(12.5, 94.4),
    const Offset(14.6, 97.0),
    width: 1.5,
    color: Inks.rose,
    amp: 0.2,
  );
}

void paintNookHouse(Sketch s) {
  final wave = s.live ? math.sin(s.t * 2.2) : 0.0;
  final bob = s.live ? math.sin(s.t * 1.6) : 0.0;
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 64));
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 62, 102, 102));
  s.fillArea(wall, _wall, amp: 0.35);
  s.fillArea(floor, _floor, amp: 0.35);
  s.strokeLine(
    const Offset(-1, 58.5),
    const Offset(101, 58.5),
    width: 1.1,
    color: _plank,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(-1, 62),
    const Offset(101, 62),
    width: 1.8,
    amp: 0.35,
  );
  s.strokeLine(
    const Offset(0, 71),
    const Offset(13, 70.7),
    width: 1.0,
    color: _plank,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(2, 85.7),
    const Offset(12, 85.4),
    width: 1.0,
    color: _plank,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(86, 72),
    const Offset(101, 71.7),
    width: 1.0,
    color: _plank,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(84, 95),
    const Offset(101, 94.7),
    width: 1.0,
    color: _plank,
    amp: 0.3,
  );
  final rug = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 81), width: 62, height: 23),
    );
  s.fillArea(rug, _rug, amp: 0.3);
  s.ink(rug, width: 1.6, amp: 0.3, color: _rugEdge);
  final rugInner = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 81), width: 48, height: 15.5),
    );
  s.ink(rugInner, width: 1.1, amp: 0.3, color: _rugRing);
  _bookcase(s);
  _wallShelf(s);
  _lamp(s, wave);
  _openBook(s);
  s.dot(Offset(82.5, 48 + bob * 1.4), 0.8, color: _mote);
  s.dot(Offset(94.5, 53 - bob * 1.8), 0.6, color: _mote);
}
