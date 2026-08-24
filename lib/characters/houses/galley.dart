import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _wall = Color(0xFFBE8A57);
const _floor = Color(0xFF96683E);
const _beam = Color(0xFF6E4226);
const _rib = Color(0xFF7C4E2C);
const _plankSeam = Color(0x4D5A3A22);
const _floorSeam = Color(0x59432A18);
const _nail = Color(0x6633251D);
const _brass = Color(0xFFD1A14E);
const _skyGlass = Color(0xFFD6E9F1);
const _sea = Color(0xFF5E8FB4);
const _seaLight = Color(0x8CE8F3F8);
const _glowPool = Color(0x1CF6D89A);
const _iron = Color(0xFF5C3D2B);
const _ironSoft = Color(0x8C5C3D2B);
const _lanternGlass = Color(0xFFFBE0A0);
const _halo = Color(0x2BF6B84C);
const _flagCloth = Color(0xFF463229);
const _flagCream = Color(0xFFFFFDF6);
const _chestWood = Color(0xFF8F5A34);
const _barrelWood = Color(0xFFA9713F);
const _stave = Color(0x40432A18);
const _plate = Color(0xFFF3E6C8);
const _meat = Color(0xFFAB4F2E);
const _meatGrain = Color(0x4D6E3320);
const _bone = Color(0xFFF6EEDC);

void paintGalleyHouse(Sketch s) {
  _hull(s);
  _porthole(s);
  _flag(s);
  _lantern(s);
  _chest(s);
  _barrel(s);
}

void _hull(Sketch s) {
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 60));
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 60, 102, 102));
  s.fillArea(wall, _wall, amp: 0.35);
  s.fillArea(floor, _floor, amp: 0.35);
  for (final y in const [16.5, 25.5, 34.5, 43.5, 52.5]) {
    s.strokeLine(
      Offset(-1, y),
      Offset(101, y),
      width: 1.1,
      color: _plankSeam,
      amp: 0.35,
    );
  }
  for (final j in const [
    Offset(10, 25.5),
    Offset(33, 16.5),
    Offset(30, 43.5),
    Offset(69, 16.5),
    Offset(88, 34.5),
  ]) {
    s.strokeLine(
      j,
      Offset(j.dx, j.dy + 9),
      width: 1.05,
      color: _plankSeam,
      amp: 0.3,
    );
  }
  final ribL = Path()
    ..moveTo(22.6, 7.4)
    ..quadraticBezierTo(20.9, 33, 22.6, 59.8)
    ..lineTo(26.1, 59.8)
    ..quadraticBezierTo(24.4, 33, 26.1, 7.4)
    ..close();
  final ribR = Path()
    ..moveTo(73.9, 7.4)
    ..quadraticBezierTo(75.6, 33, 73.9, 59.8)
    ..lineTo(77.4, 59.8)
    ..quadraticBezierTo(79.1, 33, 77.4, 7.4)
    ..close();
  s.fillArea(ribL, _rib, amp: 0.3);
  s.fillArea(ribR, _rib, amp: 0.3);
  s.ink(ribL, width: 1.5, amp: 0.3);
  s.ink(ribR, width: 1.5, amp: 0.3);
  for (final n in const [
    Offset(24.3, 14),
    Offset(22.7, 33),
    Offset(24.3, 52),
    Offset(75.7, 14),
    Offset(77.3, 33),
    Offset(75.7, 52),
  ]) {
    s.dot(n, 0.55, color: _nail);
  }
  final beam = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 7));
  s.fillArea(beam, _beam, amp: 0.3);
  s.strokeLine(const Offset(-1, 7), const Offset(101, 7), width: 1.7, amp: 0.3);
  s.strokeLine(
    const Offset(-1, 60),
    const Offset(101, 60),
    width: 1.8,
    amp: 0.35,
  );
  for (final y in const [70.0, 80.5, 91.0]) {
    s.strokeLine(
      Offset(-1, y),
      Offset(101, y),
      width: 1.2,
      color: _floorSeam,
      amp: 0.35,
    );
  }
  for (final j in const [
    [30.0, 60.6, 70.0],
    [66.0, 70.0, 80.5],
    [38.0, 80.5, 91.0],
    [76.0, 91.0, 101.0],
  ]) {
    s.strokeLine(
      Offset(j[0], j[1]),
      Offset(j[0], j[2]),
      width: 1.1,
      color: _floorSeam,
      amp: 0.3,
    );
  }
  final pool = Path()
    ..moveTo(38, 60.4)
    ..lineTo(62, 60.4)
    ..lineTo(66.5, 76.5)
    ..lineTo(33.5, 76.5)
    ..close();
  s.fillArea(pool, _glowPool, amp: 0.4);
  s.grain(floor, dots: 10, color: const Color(0x12281608), r: 0.6);
}

void _porthole(Sketch s) {
  final bob = s.live ? math.sin(s.t * 0.55) * 1.1 : 0.0;
  const c = Offset(50, 29);
  s.dot(c, 13.6, color: _brass);
  final glass = Path()..addOval(Rect.fromCircle(center: c, radius: 10.4));
  s.canvas.save();
  s.canvas.clipPath(glass);
  s.fillArea(
    Path()..addRect(const Rect.fromLTRB(38, 17, 62, 41)),
    _skyGlass,
    amp: 0.25,
  );
  s.fillArea(
    Path()..addRect(Rect.fromLTRB(38, 29.2 + bob, 62, 41)),
    _sea,
    amp: 0.3,
  );
  s.curve(
    Offset(41.5, 32.8 + bob),
    Offset(45, 31.8 + bob),
    Offset(48.5, 32.8 + bob),
    width: 1.1,
    color: _seaLight,
    amp: 0.25,
  );
  s.curve(
    Offset(50, 35.6 + bob),
    Offset(53.5, 34.6 + bob),
    Offset(57, 35.6 + bob),
    width: 1.1,
    color: _seaLight,
    amp: 0.25,
  );
  s.dot(const Offset(56, 22.2), 2.2, color: Inks.sun);
  final drift = s.live ? math.sin(s.t * 0.4) * 1.4 : 0.0;
  s.curve(
    Offset(43 + drift, 24.2),
    Offset(44.4 + drift, 22.6),
    Offset(45.8 + drift, 23.9),
    width: 1.2,
    color: Inks.inkSoft,
    amp: 0.2,
  );
  s.curve(
    Offset(45.8 + drift, 23.9),
    Offset(47.2 + drift, 22.6),
    Offset(48.6 + drift, 24.2),
    width: 1.2,
    color: Inks.inkSoft,
    amp: 0.2,
  );
  s.canvas.restore();
  s.ring(c, 10.4, width: 1.8);
  s.ring(c, 13.4, width: 2.0);
  for (var i = 0; i < 8; i++) {
    s.dot(s.polar(c, 22.5 + i * 45, 11.9), 0.62, color: _iron);
  }
}

void _flag(Sketch s) {
  s.strokeLine(
    const Offset(78.3, 12.4),
    const Offset(94.6, 12.4),
    width: 1.8,
    color: _rib,
    amp: 0.25,
  );
  s.dot(const Offset(78.3, 12.4), 0.95, color: _iron);
  s.dot(const Offset(94.6, 12.4), 0.95, color: _iron);
  final cloth = Path()
    ..moveTo(79.6, 13.2)
    ..lineTo(93.2, 13.2)
    ..quadraticBezierTo(94.2, 19.8, 93, 26.2)
    ..quadraticBezierTo(86.3, 27.6, 79.9, 26.4)
    ..close();
  s.fillArea(cloth, _flagCloth, amp: 0.35);
  s.ink(cloth, width: 1.6, amp: 0.35);
  s.strokeLine(
    const Offset(82.4, 25.2),
    const Offset(90.2, 20.4),
    width: 1.5,
    color: _flagCream,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(82.4, 20.4),
    const Offset(90.2, 25.2),
    width: 1.5,
    color: _flagCream,
    amp: 0.25,
  );
  for (final k in const [
    Offset(82.2, 25.4),
    Offset(90.4, 20.2),
    Offset(82.2, 20.2),
    Offset(90.4, 25.4),
  ]) {
    s.dot(k, 0.75, color: _flagCream);
  }
  var head = Path()
    ..addOval(Rect.fromCircle(center: const Offset(86.3, 21.1), radius: 3.1));
  for (final toe in const [
    Offset(83.9, 18.1),
    Offset(86.3, 17.2),
    Offset(88.7, 18.1),
  ]) {
    head = Path.combine(
      PathOperation.union,
      head,
      Path()..addOval(Rect.fromCircle(center: toe, radius: 1.3)),
    );
  }
  s.fillArea(head, _flagCream, amp: 0.2);
  s.ink(head, width: 1.2, amp: 0.2);
  s.dot(const Offset(85.2, 21.1), 0.62);
  s.dot(const Offset(87.4, 21.1), 0.62);
}

void _lantern(Sketch s) {
  final sway = s.live ? math.sin(s.t * 0.9 + 0.6) * 0.055 : 0.0;
  s.canvas.save();
  s.canvas.translate(15, 7);
  s.canvas.rotate(sway);
  s.canvas.translate(-15, -7);
  s.strokeLine(
    const Offset(15, 7.3),
    const Offset(15, 11.6),
    width: 1.2,
    amp: 0.25,
  );
  s.dot(const Offset(15, 19), 9.4, color: _halo);
  s.strokeLine(
    const Offset(12.4, 12.2),
    const Offset(17.6, 12.2),
    width: 2.6,
    color: _iron,
    amp: 0.2,
  );
  final body = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(11.7, 13, 18.3, 24.2),
        const Radius.circular(2.6),
      ),
    );
  s.fillArea(body, _lanternGlass, amp: 0.3);
  s.ink(body, width: 1.7, amp: 0.3);
  s.strokeLine(
    const Offset(13.9, 13.6),
    const Offset(13.9, 23.7),
    width: 1.05,
    color: _ironSoft,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(16.1, 13.6),
    const Offset(16.1, 23.7),
    width: 1.05,
    color: _ironSoft,
    amp: 0.2,
  );
  final flick = s.live ? math.sin(s.t * 5.3) * 0.22 : 0.0;
  s.dot(const Offset(15, 20), 1.9 + flick, color: Inks.sun);
  s.dot(const Offset(15, 20.4), 1.0 + flick * 0.5, color: Inks.blush);
  s.strokeLine(
    const Offset(13.1, 24.8),
    const Offset(16.9, 24.8),
    width: 2.4,
    color: _iron,
    amp: 0.2,
  );
  s.dot(const Offset(15, 25.9), 0.85, color: _iron);
  s.canvas.restore();
}

void _chest(Sketch s) {
  final lid = Path()
    ..moveTo(3.2, 77)
    ..quadraticBezierTo(10.8, 67.8, 18.4, 77)
    ..close();
  s.fillArea(lid, _chestWood, amp: 0.3);
  s.ink(lid, width: 1.7, amp: 0.3);
  final body = Path()..addRect(const Rect.fromLTRB(3.2, 77, 18.4, 88.6));
  s.fillArea(body, _chestWood, amp: 0.3);
  s.ink(body, width: 1.7, amp: 0.3);
  s.curve(
    const Offset(4.4, 73.7),
    const Offset(10.8, 70.3),
    const Offset(17.2, 73.7),
    width: 2,
    color: _brass,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(7.2, 77.5),
    const Offset(7.2, 88.1),
    width: 2,
    color: _brass,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(14.4, 77.5),
    const Offset(14.4, 88.1),
    width: 2,
    color: _brass,
    amp: 0.25,
  );
  s.dot(const Offset(10.8, 79.8), 2.1, color: _brass);
  s.ring(const Offset(10.8, 79.8), 2.1, width: 1.2);
  s.dot(const Offset(10.8, 80.1), 0.6);
  s.dot(const Offset(5.9, 89.9), 1.3, color: Inks.sun);
  s.ring(const Offset(5.9, 89.9), 1.3, width: 0.9);
  s.dot(const Offset(15.9, 90.1), 1.1, color: Inks.sun);
  s.sparkle(const Offset(17.9, 70.6), 2.1);
}

void _barrel(Sketch s) {
  final body = Path()
    ..moveTo(84.6, 66.6)
    ..cubicTo(82.3, 73, 82.3, 81.5, 84.6, 88.6)
    ..lineTo(95.4, 88.6)
    ..cubicTo(97.7, 81.5, 97.7, 73, 95.4, 66.6)
    ..close();
  s.fillArea(body, _barrelWood, amp: 0.3);
  s.ink(body, width: 1.8, amp: 0.3);
  s.curve(
    const Offset(87.9, 67.4),
    const Offset(87.4, 77.6),
    const Offset(87.9, 88),
    width: 1,
    color: _stave,
    amp: 0.3,
  );
  s.curve(
    const Offset(92.1, 67.4),
    const Offset(92.6, 77.6),
    const Offset(92.1, 88),
    width: 1,
    color: _stave,
    amp: 0.3,
  );
  s.curve(
    const Offset(83.5, 71.8),
    const Offset(90, 73.2),
    const Offset(96.5, 71.8),
    width: 2.1,
    color: _iron,
    amp: 0.25,
  );
  s.curve(
    const Offset(83.7, 82.6),
    const Offset(90, 83.9),
    const Offset(96.3, 82.6),
    width: 2.1,
    color: _iron,
    amp: 0.25,
  );
  final plate = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(90, 65.4), width: 12.4, height: 3.6),
    );
  s.fillArea(plate, _plate, amp: 0.2);
  s.ink(plate, width: 1.4, amp: 0.2);
  s.strokeLine(
    const Offset(84.2, 61.4),
    const Offset(95.8, 61.4),
    width: 2.6,
    amp: 0.2,
  );
  for (final k in const [
    Offset(84.4, 60.6),
    Offset(84.4, 62.2),
    Offset(95.6, 60.6),
    Offset(95.6, 62.2),
  ]) {
    s.dot(k, 1.3);
  }
  final meat = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(90, 61.2), width: 9.6, height: 6.2),
    );
  s.fillArea(meat, _meat, amp: 0.25);
  s.ink(meat, width: 1.7, amp: 0.25);
  s.strokeLine(
    const Offset(84.2, 61.4),
    const Offset(85.3, 61.4),
    width: 1.5,
    color: _bone,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(94.7, 61.4),
    const Offset(95.8, 61.4),
    width: 1.5,
    color: _bone,
    amp: 0.15,
  );
  for (final k in const [
    Offset(84.4, 60.6),
    Offset(84.4, 62.2),
    Offset(95.6, 60.6),
    Offset(95.6, 62.2),
  ]) {
    s.dot(k, 0.95, color: _bone);
  }
  s.gleam(
    const Offset(88.4, 59.8),
    2.1,
    sweepDeg: 60,
    width: 1.4,
    color: const Color(0x8CFFFFFF),
  );
  s.grain(meat, dots: 5, color: _meatGrain, r: 0.55);
  s.steam(const Offset(90.2, 56.6), h: 8, sway: 2, width: 1.4);
}
