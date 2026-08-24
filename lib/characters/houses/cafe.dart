import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _wall = Color(0xFFD5AC7C);
const _floor = Color(0xFFB07E52);
const _trim = Color(0xFF6E4930);
const _woodMid = Color(0xFF8A5F41);
const _seam = Color(0x265E3A20);
const _plankLine = Color(0x3B5A3418);
const _grainFleck = Color(0x14603C22);
const _board = Color(0xFF44392F);
const _chalk = Color(0xDEFFF2D6);
const _glass = Color(0x669FBFC9);
const _coffee = Color(0xFF6F4423);
const _coffeeTint = Color(0x8C6F4423);
const _beans = Color(0xFF7B4E28);
const _beanDark = Color(0xFF4E2E17);
const _roastLight = Color(0xFF9A6633);
const _brass = Color(0xFFC2924C);
const _millWood = Color(0xFF5F3D28);
const _rug = Color(0xFFAE6350);
const _rugRing = Color(0x8CF6E3C2);
const _halo = Color(0x30F6B84C);
const _pool = Color(0x26F6B84C);
const _bulb = Color(0xFFFFE2A2);
const _gleamSoft = Color(0x59FFFFFF);
const _stripe = Color(0xCCB4614D);

void paintCafeHouse(Sketch s) {
  _room(s);
  _pendant(s);
  _shelf(s);
  _mask(s);
  _clock(s);
  _menuBoard(s);
  _grinder(s);
  _coffeeCup(s);
}

void _room(Sketch s) {
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 62));
  s.fillArea(wall, _wall, amp: 0.35);
  s.grain(wall, dots: 16, r: 0.7, color: _grainFleck);
  for (final x in const [8.0, 19.0, 30.0, 41.0, 52.0, 63.0, 74.0, 85.0, 96.0]) {
    s.strokeLine(
      Offset(x, 7.6),
      Offset(x, 57.0),
      width: 1.05,
      color: _seam,
      amp: 0.45,
    );
  }
  final crown = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 6.2));
  s.fillArea(crown, _trim, amp: 0.3);
  s.strokeLine(
    const Offset(-1, 6.4),
    const Offset(101, 6.4),
    width: 1.6,
    amp: 0.3,
  );
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 60.5, 102, 102));
  s.fillArea(floor, _floor, amp: 0.35);
  for (final y in const [70.5, 79.0, 87.5]) {
    s.strokeLine(
      Offset(-1, y),
      Offset(101, y),
      width: 1.1,
      color: _plankLine,
      amp: 0.5,
    );
  }
  for (final (x, y1, y2) in const [
    (24.0, 63.6, 70.0),
    (58.0, 63.6, 70.0),
    (88.0, 63.6, 70.0),
    (12.0, 71.2, 78.5),
    (42.0, 71.2, 78.5),
    (94.0, 71.2, 78.5),
    (26.0, 88.2, 95.5),
    (70.0, 88.2, 95.5),
  ]) {
    s.strokeLine(
      Offset(x, y1),
      Offset(x, y2),
      width: 1.05,
      color: _plankLine,
      amp: 0.35,
    );
  }
  final base = Path()..addRect(const Rect.fromLTRB(-2, 57.6, 102, 62.4));
  s.fillArea(base, _trim, amp: 0.3);
  s.strokeLine(
    const Offset(-1, 57.6),
    const Offset(101, 57.6),
    width: 1.4,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(-1, 62.5),
    const Offset(101, 62.5),
    width: 1.8,
    amp: 0.35,
  );
  final pool = Path()
    ..moveTo(43, 62.8)
    ..lineTo(59, 62.8)
    ..lineTo(63, 75.5)
    ..lineTo(39, 75.5)
    ..close();
  s.fillArea(pool, _pool, amp: 0.4);
  final rugOuter = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 83), width: 44, height: 13),
    );
  s.fillArea(rugOuter, _rug, amp: 0.4);
  s.ink(rugOuter, width: 1.6, amp: 0.4);
  final rugInner = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 83), width: 34, height: 8.6),
    );
  s.ink(rugInner, width: 1.3, color: _rugRing, amp: 0.4);
}

void _pendant(Sketch s) {
  final sway = s.live ? math.sin(s.t * 0.9 + 1.3) * 0.035 : 0.0;
  s.canvas.save();
  s.canvas.translate(51, 5.5);
  s.canvas.rotate(sway);
  s.canvas.translate(-51, -5.5);
  s.dot(const Offset(51, 16.8), 9.2, color: _halo);
  s.strokeLine(
    const Offset(51, 5.6),
    const Offset(51, 10.2),
    width: 1.2,
    amp: 0.25,
  );
  s.dot(const Offset(51, 16.6), 1.6, color: _bulb);
  s.ring(
    const Offset(51, 16.6),
    1.6,
    width: 0.9,
    color: Inks.inkSoft,
    amp: 0.15,
  );
  final shade = Path()
    ..moveTo(46.9, 15.1)
    ..quadraticBezierTo(47.0, 10.2, 51.0, 10.0)
    ..quadraticBezierTo(55.0, 10.2, 55.1, 15.1)
    ..close();
  s.fillArea(shade, _brass, amp: 0.25);
  s.ink(shade, width: 1.6, amp: 0.25);
  s.gleam(
    const Offset(49.4, 12.6),
    2.0,
    sweepDeg: 42,
    width: 1.1,
    color: _gleamSoft,
  );
  s.canvas.restore();
}

void _shelf(Sketch s) {
  final vessel = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(8.9, 15.4, 12.7, 21.6),
        const Radius.circular(1.6),
      ),
    );
  s.fillArea(vessel, _glass, amp: 0.25);
  s.strokeLine(
    const Offset(9.3, 20.6),
    const Offset(12.3, 20.6),
    width: 1.3,
    color: _coffeeTint,
    amp: 0.2,
  );
  s.ink(vessel, width: 1.45, amp: 0.25);
  s.dot(const Offset(10.8, 15.2), 1.0);
  s.strokeLine(
    const Offset(9.6, 16.8),
    const Offset(9.6, 19.8),
    width: 0.95,
    color: _gleamSoft,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(10.8, 21.5),
    const Offset(10.8, 22.6),
    width: 2.2,
    amp: 0.2,
  );
  final globe = Path()
    ..addOval(Rect.fromCircle(center: const Offset(10.8, 25.5), radius: 3.3));
  s.fillArea(globe, _glass, amp: 0.25);
  s.dot(const Offset(10.8, 26.4), 1.8, color: _coffee);
  s.ink(globe, width: 1.55, amp: 0.25);
  s.gleam(
    const Offset(9.7, 24.4),
    2.0,
    sweepDeg: 45,
    width: 1.1,
    color: _gleamSoft,
  );
  s.curve(
    const Offset(14.0, 24.5),
    const Offset(15.4, 25.3),
    const Offset(14.3, 26.7),
    width: 1.3,
    amp: 0.2,
  );
  final jar1 = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(15.8, 21.8, 21.2, 28.9),
        const Radius.circular(1.4),
      ),
    );
  s.fillArea(jar1, _glass, amp: 0.25);
  final beans1 = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(16.4, 24.6, 20.6, 28.4),
        const Radius.circular(1.0),
      ),
    );
  s.fillArea(beans1, _beans, amp: 0.25);
  for (final (x, y) in const [(17.4, 25.6), (19.4, 26.3), (18.2, 27.4)]) {
    s.dot(Offset(x, y), 0.55, color: _beanDark);
  }
  final label = Path()..addRect(const Rect.fromLTRB(16.9, 24.9, 19.9, 26.9));
  s.fillArea(label, Inks.cream, amp: 0.2);
  s.ink(label, width: 1.05, amp: 0.2);
  s.dot(const Offset(18.4, 25.9), 0.6, color: _coffee);
  s.strokeLine(
    const Offset(16.7, 22.6),
    const Offset(16.7, 24.1),
    width: 0.9,
    color: _gleamSoft,
    amp: 0.15,
  );
  s.ink(jar1, width: 1.5, amp: 0.25);
  s.strokeLine(
    const Offset(15.7, 21.9),
    const Offset(21.3, 21.9),
    width: 2.4,
    color: _woodMid,
    amp: 0.2,
  );
  final jar2 = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(22.8, 23.6, 27.6, 28.9),
        const Radius.circular(1.3),
      ),
    );
  s.fillArea(jar2, _glass, amp: 0.25);
  final beans2 = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(23.4, 25.6, 27.0, 28.4),
        const Radius.circular(1.0),
      ),
    );
  s.fillArea(beans2, _roastLight, amp: 0.25);
  for (final (x, y) in const [(24.4, 26.6), (26.1, 27.3)]) {
    s.dot(Offset(x, y), 0.5, color: _beanDark);
  }
  s.strokeLine(
    const Offset(23.6, 24.3),
    const Offset(23.6, 25.5),
    width: 0.9,
    color: _gleamSoft,
    amp: 0.15,
  );
  s.ink(jar2, width: 1.45, amp: 0.25);
  s.strokeLine(
    const Offset(22.7, 23.7),
    const Offset(27.7, 23.7),
    width: 2.3,
    color: _woodMid,
    amp: 0.2,
  );
  final cupLow = Path()
    ..moveTo(30.9, 25.9)
    ..lineTo(35.5, 25.9)
    ..lineTo(34.9, 28.9)
    ..lineTo(31.5, 28.9)
    ..close();
  s.fillArea(cupLow, Inks.cream, amp: 0.25);
  s.ink(cupLow, width: 1.4, amp: 0.25);
  s.ring(const Offset(36.3, 27.3), 1.15, width: 1.25, amp: 0.2);
  final cupTop = Path()
    ..moveTo(31.2, 22.9)
    ..lineTo(35.8, 22.9)
    ..lineTo(35.2, 25.9)
    ..lineTo(31.8, 25.9)
    ..close();
  s.fillArea(cupTop, Inks.cream, amp: 0.25);
  s.ink(cupTop, width: 1.4, amp: 0.25);
  s.ring(const Offset(36.6, 24.3), 1.15, width: 1.25, amp: 0.2);
  final board = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(5.0, 29.0, 39.5, 31.8),
        const Radius.circular(1.2),
      ),
    );
  s.fillArea(board, _woodMid, amp: 0.25);
  s.ink(board, width: 1.8, amp: 0.25);
  final bracketL = Path()
    ..moveTo(8.2, 31.8)
    ..lineTo(8.2, 36.2)
    ..lineTo(12.0, 31.8)
    ..close();
  final bracketR = Path()
    ..moveTo(36.4, 31.8)
    ..lineTo(36.4, 36.2)
    ..lineTo(32.6, 31.8)
    ..close();
  for (final bracket in [bracketL, bracketR]) {
    s.fillArea(bracket, _trim, amp: 0.3);
    s.ink(bracket, width: 1.4, amp: 0.3);
  }
}

void _mask(Sketch s) {
  s.dot(const Offset(45.0, 15.7), 0.9);
  s.strokeLine(
    const Offset(42.6, 18.9),
    const Offset(45.0, 16.1),
    width: 1.05,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(47.6, 18.9),
    const Offset(45.0, 16.1),
    width: 1.05,
    amp: 0.15,
  );
  final mask = Path()
    ..moveTo(42.0, 19.8)
    ..quadraticBezierTo(41.0, 25.0, 43.4, 27.4)
    ..quadraticBezierTo(44.8, 28.6, 46.2, 27.2)
    ..quadraticBezierTo(48.4, 25.0, 48.8, 21.2)
    ..quadraticBezierTo(49.0, 18.6, 45.4, 18.4)
    ..quadraticBezierTo(42.6, 18.5, 42.0, 19.8)
    ..close();
  s.fillArea(mask, Inks.white, amp: 0.25);
  s.ink(mask, width: 1.7, amp: 0.25);
  s.curve(
    const Offset(42.5, 20.4),
    const Offset(42.0, 23.4),
    const Offset(43.4, 26.2),
    width: 0.9,
    color: Inks.inkFaint,
    amp: 0.15,
  );
  s.dot(const Offset(45.8, 21.3), 1.15);
  s.curve(
    const Offset(42.7, 24.6),
    const Offset(45.1, 26.0),
    const Offset(47.7, 24.0),
    width: 1.25,
    amp: 0.2,
  );
  for (final (x1, y1, x2, y2) in const [
    (43.7, 24.4, 43.8, 25.8),
    (45.1, 24.8, 45.2, 26.2),
    (46.5, 24.3, 46.6, 25.7),
  ]) {
    s.strokeLine(Offset(x1, y1), Offset(x2, y2), width: 0.9, amp: 0.15);
  }
}

void _clock(Sketch s) {
  s.dot(const Offset(58.5, 22.2), 3.7, color: Inks.cream);
  s.ring(const Offset(58.5, 22.2), 3.7, width: 1.9, amp: 0.25);
  for (final (dx, dy) in const [
    (0.0, -2.4),
    (2.4, 0.0),
    (0.0, 2.4),
    (-2.4, 0.0),
  ]) {
    s.dot(Offset(58.5 + dx, 22.2 + dy), 0.4);
  }
  s.strokeLine(
    const Offset(58.5, 22.2),
    const Offset(58.5, 20.0),
    width: 1.2,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(58.5, 22.2),
    const Offset(60.1, 23.0),
    width: 1.2,
    amp: 0.15,
  );
  s.dot(const Offset(58.5, 22.2), 0.55);
  final swing = s.live ? math.sin(s.t * 2.8) * 0.22 : 0.0;
  s.canvas.save();
  s.canvas.translate(58.5, 25.7);
  s.canvas.rotate(swing);
  s.canvas.translate(-58.5, -25.7);
  s.strokeLine(
    const Offset(58.5, 25.7),
    const Offset(58.5, 30.2),
    width: 1.15,
    amp: 0.15,
  );
  s.dot(const Offset(58.5, 31.0), 1.2, color: _brass);
  s.ring(const Offset(58.5, 31.0), 1.2, width: 1.0, amp: 0.15);
  s.canvas.restore();
}

void _menuBoard(Sketch s) {
  s.dot(const Offset(78, 8.8), 0.85);
  s.strokeLine(
    const Offset(70.5, 11.2),
    const Offset(78, 9.0),
    width: 1.05,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(85.5, 11.2),
    const Offset(78, 9.0),
    width: 1.05,
    amp: 0.2,
  );
  final frame = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(65.5, 10.5, 90.5, 33.5),
        const Radius.circular(1.6),
      ),
    );
  s.fillArea(frame, _woodMid, amp: 0.3);
  s.ink(frame, width: 1.8, amp: 0.3);
  final board = Path()..addRect(const Rect.fromLTRB(67.5, 12.5, 88.5, 31.5));
  s.fillArea(board, _board, amp: 0.25);
  s.ink(board, width: 1.3, amp: 0.25);
  final title = Path()
    ..moveTo(70.8, 16.2)
    ..quadraticBezierTo(72.8, 14.9, 74.6, 16.0)
    ..quadraticBezierTo(76.4, 17.1, 78.2, 15.9)
    ..quadraticBezierTo(79.8, 14.9, 81.6, 16.0);
  s.ink(title, width: 1.5, color: _chalk, amp: 0.2);
  s.strokeLine(
    const Offset(72.5, 18.4),
    const Offset(80.5, 18.4),
    width: 1.05,
    color: _chalk,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(70.4, 21.6),
    const Offset(77.6, 21.4),
    width: 1.15,
    color: _chalk,
    amp: 0.25,
  );
  s.dot(const Offset(84.6, 21.5), 0.7, color: _chalk);
  s.dot(const Offset(86.4, 21.5), 0.7, color: _chalk);
  s.strokeLine(
    const Offset(70.4, 24.8),
    const Offset(76.2, 24.6),
    width: 1.15,
    color: _chalk,
    amp: 0.25,
  );
  s.dot(const Offset(84.6, 24.7), 0.7, color: _chalk);
  s.dot(const Offset(86.4, 24.7), 0.7, color: _chalk);
  final chalkCup = Path()..addRect(const Rect.fromLTRB(70.6, 27.2, 73.8, 29.6));
  s.ink(chalkCup, width: 1.05, color: _chalk, amp: 0.2);
  s.curve(
    const Offset(73.8, 27.8),
    const Offset(75.0, 28.3),
    const Offset(73.8, 28.9),
    width: 0.95,
    color: _chalk,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(71.4, 26.6),
    const Offset(71.7, 25.5),
    width: 0.9,
    color: _chalk,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(73.0, 26.6),
    const Offset(73.3, 25.5),
    width: 0.9,
    color: _chalk,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(83.4, 28.6),
    const Offset(87.0, 28.6),
    width: 1.1,
    color: _chalk,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(67.2, 34.6),
    const Offset(88.8, 34.6),
    width: 2.2,
    color: _trim,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(83.8, 33.6),
    const Offset(86.0, 33.6),
    width: 1.5,
    color: Inks.cream,
    amp: 0.15,
  );
}

void _grinder(Sketch s) {
  s.groundShadow(const Offset(11.5, 91.6), 8.5);
  final body = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(6.8, 79.2, 16.2, 89.8),
        const Radius.circular(1.6),
      ),
    );
  s.fillArea(body, _millWood, amp: 0.3);
  s.ink(body, width: 1.9, amp: 0.3);
  final drawer = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(8.4, 84.6, 14.6, 88.4),
        const Radius.circular(1.0),
      ),
    );
  s.ink(drawer, width: 1.2, color: Inks.inkSoft, amp: 0.25);
  s.dot(const Offset(11.5, 86.5), 0.9, color: _brass);
  final cap = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(6.2, 77.4, 16.8, 79.6),
        const Radius.circular(1.0),
      ),
    );
  s.fillArea(cap, _woodMid, amp: 0.25);
  s.ink(cap, width: 1.6, amp: 0.25);
  final hopper = Path()
    ..moveTo(8.2, 77.4)
    ..quadraticBezierTo(8.4, 73.4, 11.5, 73.1)
    ..quadraticBezierTo(14.6, 73.4, 14.8, 77.4)
    ..close();
  s.fillArea(hopper, _brass, amp: 0.25);
  s.ink(hopper, width: 1.5, amp: 0.25);
  s.gleam(
    const Offset(10.2, 75.4),
    1.7,
    sweepDeg: 42,
    width: 1.0,
    color: _gleamSoft,
  );
  s.curve(
    const Offset(11.5, 72.9),
    const Offset(14.6, 70.2),
    const Offset(16.8, 71.6),
    width: 1.7,
    amp: 0.2,
  );
  s.dot(const Offset(11.5, 72.9), 0.9);
  s.dot(const Offset(17.1, 71.9), 1.35);
  s.dot(const Offset(17.1, 71.9), 0.8, color: _woodMid);
  for (final (x, y, r) in const [
    (18.3, 90.2, 0.7),
    (19.3, 91.6, 0.6),
    (17.2, 91.9, 0.65),
  ]) {
    s.dot(Offset(x, y), r, color: _beans);
  }
}

void _coffeeCup(Sketch s) {
  s.groundShadow(const Offset(88.5, 90.4), 8);
  final saucer = Path()
    ..addOval(
      Rect.fromCenter(
        center: const Offset(88.5, 88.6),
        width: 12.5,
        height: 3.4,
      ),
    );
  s.fillArea(saucer, Inks.cream, amp: 0.2);
  s.ink(saucer, width: 1.6, amp: 0.2);
  final cup = Path()
    ..moveTo(84.9, 82.4)
    ..lineTo(92.1, 82.4)
    ..lineTo(91.2, 87.3)
    ..lineTo(85.8, 87.3)
    ..close();
  s.fillArea(cup, Inks.cream, amp: 0.25);
  s.ink(cup, width: 1.7, amp: 0.25);
  s.curve(
    const Offset(85.2, 82.7),
    const Offset(88.5, 83.7),
    const Offset(91.8, 82.7),
    width: 1.05,
    color: Inks.inkSoft,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(85.5, 84.8),
    const Offset(91.5, 84.8),
    width: 1.25,
    color: _stripe,
    amp: 0.2,
  );
  s.ring(const Offset(93.7, 84.6), 1.7, width: 1.5, amp: 0.2);
  s.steam(const Offset(88.5, 81.0), h: 12, sway: 2.8, width: 1.7);
}
