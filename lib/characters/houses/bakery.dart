import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _wall = Color(0xFFF2DFC1);
const _floor = Color(0xFFD8A87E);
const _plank = Color(0x338A5B37);
const _wood = Color(0xFFB9835A);
const _woodDeep = Color(0xFF97684A);
const _crust = Color(0xFFCF9052);
const _croissantGold = Color(0xFFDFA458);
const _score = Color(0xFFF6E7C8);
const _oven = Color(0xFF7C5B4A);
const _ovenTop = Color(0xFF66493B);
const _ovenDark = Color(0xFF3B2721);
const _glowBright = Color(0xFFFFD98F);
const _flame = Color(0xFFE2762F);
const _pin = Color(0xFFCE9A62);
const _sack = Color(0xFFE2CDA0);
const _cuff = Color(0xFFD6BE8D);
const _flour = Color(0xFFFAF1DE);
const _rug = Color(0xFFEDDBB2);
const _rugRing = Color(0xFFCE7D5F);
const _wheat = Color(0xFFB9853E);

void paintBakeryHouse(Sketch s) {
  _room(s);
  s.groundShadow(const Offset(89.5, 79.8), 11);
  s.groundShadow(const Offset(11.2, 91.0), 9.5);
  _shelf(s);
  _clock(s);
  _rail(s);
  _drawOven(s);
  _drawSack(s);
}

void _clock(Sketch s) {
  s.dot(const Offset(13.5, 40), 4.5, color: Inks.cream);
  s.ring(const Offset(13.5, 40), 4.5, width: 2.0, amp: 0.25);
  s.strokeLine(
    const Offset(13.5, 40),
    const Offset(13.5, 37.1),
    width: 1.3,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(13.5, 40),
    const Offset(15.5, 41.0),
    width: 1.3,
    amp: 0.15,
  );
  s.dot(const Offset(13.5, 40), 0.6);
}

void _room(Sketch s) {
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 64));
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 62, 102, 102));
  s.fillArea(wall, _wall, amp: 0.35);
  s.grain(wall, dots: 16, r: 0.7, color: const Color(0x12805C33));
  s.fillArea(floor, _floor, amp: 0.35);
  for (final y in const [70.4, 78.9, 87.3]) {
    s.strokeLine(
      Offset(-1, y),
      Offset(101, y),
      width: 1.1,
      color: _plank,
      amp: 0.5,
    );
  }
  for (final (x, y1, y2) in const [
    (26.0, 63.4, 69.7),
    (68.0, 63.4, 69.7),
    (48.0, 71.2, 78.2),
    (14.0, 71.2, 78.2),
    (58.0, 79.6, 86.6),
    (30.0, 79.6, 86.6),
  ]) {
    s.strokeLine(
      Offset(x, y1),
      Offset(x, y2),
      width: 1.05,
      color: _plank,
      amp: 0.35,
    );
  }
  s.strokeLine(
    const Offset(-1, 62),
    const Offset(101, 62),
    width: 1.8,
    amp: 0.35,
  );
  final rugOuter = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 83.5), width: 46, height: 12.5),
    );
  s.fillArea(rugOuter, _rug, amp: 0.4);
  s.ink(rugOuter, width: 1.6, amp: 0.4);
  final rugInner = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 83.5), width: 36, height: 8),
    );
  s.ink(rugInner, width: 1.3, color: _rugRing, amp: 0.4);
  for (final (side, y) in const [
    (-1.0, 80.9),
    (-1.0, 83.3),
    (-1.0, 85.7),
    (1.0, 80.9),
    (1.0, 83.3),
    (1.0, 85.7),
  ]) {
    final x = 50 + side * 23.2;
    s.strokeLine(
      Offset(x, y),
      Offset(x + side * 2.6, y - 0.4),
      width: 1.1,
      amp: 0.25,
    );
  }
}

void _shelf(Sketch s) {
  for (final (ax, bx) in const [(11.0, 15.2), (44.0, 39.8)]) {
    final bracket = Path()
      ..moveTo(ax, 26.2)
      ..lineTo(ax, 31.4)
      ..lineTo(bx, 26.2)
      ..close();
    s.fillArea(bracket, _woodDeep, amp: 0.3);
    s.ink(bracket, width: 1.5, amp: 0.3);
  }
  final board = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(7.5, 23.4, 47.5, 26.6),
        const Radius.circular(1.2),
      ),
    );
  s.fillArea(board, _wood, amp: 0.25);
  s.ink(board, width: 1.9, amp: 0.25);
  final boule = Path()
    ..addOval(Rect.fromCircle(center: const Offset(13.5, 18.7), radius: 4.7));
  s.fillArea(boule, _crust, amp: 0.3);
  s.ink(boule, width: 1.9, amp: 0.3);
  s.curve(
    const Offset(10.8, 17.5),
    const Offset(13.4, 15.3),
    const Offset(16.2, 17.5),
    width: 1.2,
    color: _score,
    amp: 0.2,
  );
  s.curve(
    const Offset(11.5, 20.5),
    const Offset(13.6, 18.7),
    const Offset(15.8, 20.5),
    width: 1.2,
    color: _score,
    amp: 0.2,
  );
  final loaf = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(25, 20.6), width: 12.5, height: 6.6),
    );
  s.fillArea(loaf, _crust, amp: 0.3);
  s.ink(loaf, width: 1.9, amp: 0.3);
  for (final x in const [21.4, 24.6, 27.8]) {
    s.strokeLine(
      Offset(x, 20.3),
      Offset(x + 1.8, 17.9),
      width: 1.25,
      color: _score,
      amp: 0.2,
    );
  }
  _croissant(s, const Offset(35.2, 20.2));
  _croissant(s, const Offset(42.4, 20.5));
}

void _croissant(Sketch s, Offset c) {
  var body = Path()..addOval(Rect.fromCircle(center: c, radius: 2.45));
  for (final (dx, dy, r) in const [
    (-2.5, 0.7, 1.9),
    (2.5, 0.7, 1.9),
    (-4.4, 1.9, 1.3),
    (4.4, 1.9, 1.3),
  ]) {
    body = Path.combine(
      PathOperation.union,
      body,
      Path()..addOval(Rect.fromCircle(center: c + Offset(dx, dy), radius: r)),
    );
  }
  s.fillArea(body, _croissantGold, amp: 0.25);
  s.ink(body, width: 1.7, amp: 0.25);
  s.curve(
    c + const Offset(-1.5, -2.1),
    c + const Offset(-2.75, -0.1),
    c + const Offset(-2.25, 2.1),
    width: 1.15,
    color: _score,
    amp: 0.2,
  );
  s.curve(
    c + const Offset(1.5, -2.1),
    c + const Offset(2.75, -0.1),
    c + const Offset(2.25, 2.1),
    width: 1.15,
    color: _score,
    amp: 0.2,
  );
}

void _rail(Sketch s) {
  s.strokeLine(
    const Offset(51.5, 11.4),
    const Offset(76, 11.4),
    width: 1.9,
    amp: 0.25,
  );
  s.dot(const Offset(52.2, 11.4), 1.15);
  s.dot(const Offset(75.3, 11.4), 1.15);
  for (final x in const [57.0, 69.0, 73.8]) {
    s.curve(
      Offset(x, 11.7),
      Offset(x - 0.7, 13.0),
      Offset(x + 0.5, 13.4),
      width: 1.3,
      amp: 0.2,
    );
  }
  s.ring(const Offset(57, 14.5), 1.1, width: 1.3, amp: 0.2);
  s.strokeLine(
    const Offset(57, 15.6),
    const Offset(57, 21.4),
    width: 3.1,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(57, 15.9),
    const Offset(57, 21.1),
    width: 1.7,
    color: _pin,
    amp: 0.2,
  );
  for (final w in const [8.0, 5.0, 2.2]) {
    final loop = Path()
      ..addOval(
        Rect.fromCenter(center: const Offset(57, 26.4), width: w, height: 10.6),
      );
    s.ink(loop, width: 1.2, amp: 0.2);
  }
  s.ring(const Offset(69, 14.4), 1.1, width: 1.3, amp: 0.2);
  s.dot(const Offset(69, 16.6), 1.95);
  s.dot(const Offset(69, 16.6), 1.2, color: _pin);
  s.strokeLine(
    const Offset(69, 17.4),
    const Offset(69, 18.6),
    width: 2.1,
    amp: 0.2,
  );
  final barrel = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(66.4, 18.4, 71.6, 30.4),
        const Radius.circular(2.3),
      ),
    );
  s.fillArea(barrel, _pin, amp: 0.25);
  s.ink(barrel, width: 1.8, amp: 0.25);
  s.strokeLine(
    const Offset(68.1, 20.4),
    const Offset(68.1, 28.6),
    width: 0.9,
    color: const Color(0x4D8A5B37),
    amp: 0.3,
  );
  s.dot(const Offset(69, 32.1), 1.95);
  s.dot(const Offset(69, 32.1), 1.2, color: _pin);
  s.strokeLine(
    const Offset(73.8, 13.3),
    const Offset(73.8, 14.4),
    width: 1.1,
    amp: 0.2,
  );
  final cutter = s.heartShape(const Offset(73.7, 15.9), 2.1);
  s.ink(cutter, width: 1.35, amp: 0.2);
}

void _drawOven(Sketch s) {
  final flick = s.live ? math.sin(s.t * 5.3) : 0.0;
  final flick2 = s.live ? math.sin(s.t * 7.9 + 1.7) : 0.0;
  final flick3 = s.live ? math.sin(s.t * 6.1 + 3.4) : 0.0;
  final pipe = Path()..addRect(const Rect.fromLTRB(87, 10.4, 91.2, 33.8));
  s.fillArea(pipe, _ovenTop, amp: 0.3);
  s.ink(pipe, width: 1.7, amp: 0.3);
  final cap = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(85.4, 7.8, 92.8, 11.0),
        const Radius.circular(1.1),
      ),
    );
  s.fillArea(cap, _ovenTop, amp: 0.3);
  s.ink(cap, width: 1.7, amp: 0.3);
  s.steam(const Offset(89.2, 7.2), h: 6.5, sway: 2.0, width: 1.5);
  final body = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(80, 33.5, 99, 76.5),
        const Radius.circular(3.6),
      ),
    );
  s.fillArea(body, _oven, amp: 0.3);
  s.shade(body, lift: const Offset(-2, -2.6));
  s.ink(body, width: 2.3, amp: 0.3);
  final slab = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(78.8, 31.6, 100.2, 35.0),
        const Radius.circular(1.4),
      ),
    );
  s.fillArea(slab, _ovenTop, amp: 0.25);
  s.ink(slab, width: 1.9, amp: 0.25);
  final window = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(83.6, 40.0, 95.4, 52.6),
        const Radius.circular(2.4),
      ),
    );
  s.fillArea(window, _ovenDark, amp: 0.25);
  final glowOuter = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(84.8, 41.2, 94.2, 51.6),
        const Radius.circular(2.0),
      ),
    );
  s.fillArea(
    glowOuter,
    Inks.sun.withValues(alpha: 0.40 + 0.08 * flick),
    amp: 0.3,
  );
  final glowInner = Path()
    ..addOval(
      Rect.fromCenter(
        center: const Offset(89.5, 49.0),
        width: 7.8,
        height: 5.6,
      ),
    );
  s.fillArea(
    glowInner,
    _glowBright.withValues(alpha: 0.58 + 0.12 * flick),
    amp: 0.3,
  );
  final hs = 1 + 0.11 * flick2;
  final hs2 = 1 + 0.12 * flick3;
  final flameMain = Path()
    ..moveTo(87.7, 52.1)
    ..quadraticBezierTo(87.1, 49.7, 89.2, 52.1 - 6.1 * hs)
    ..quadraticBezierTo(91.7, 49.5, 91.3, 52.1)
    ..close();
  s.fillArea(flameMain, _flame, amp: 0.3);
  final flameCore = Path()
    ..moveTo(88.5, 52.1)
    ..quadraticBezierTo(88.3, 50.5, 89.3, 52.1 - 3.3 * hs)
    ..quadraticBezierTo(90.6, 50.4, 90.2, 52.1)
    ..close();
  s.fillArea(flameCore, _glowBright, amp: 0.25);
  final flameSide = Path()
    ..moveTo(85.5, 52.1)
    ..quadraticBezierTo(85.1, 50.5, 86.1, 52.1 - 3.1 * hs2)
    ..quadraticBezierTo(87.2, 50.5, 86.9, 52.1)
    ..close();
  s.fillArea(flameSide, _flame.withValues(alpha: 0.85), amp: 0.3);
  s.dot(Offset(93.2, 51.2), 0.75 + 0.1 * flick2, color: _flame);
  s.dot(const Offset(94.0, 50.3), 0.5, color: Inks.sun);
  s.ink(window, width: 2.0, amp: 0.25);
  s.gleam(
    const Offset(86.9, 43.2),
    2.6,
    sweepDeg: 46,
    width: 1.3,
    color: const Color(0x66FFFFFF),
  );
  s.strokeLine(
    const Offset(85.2, 56.4),
    const Offset(93.8, 56.4),
    width: 2.3,
    amp: 0.2,
  );
  s.dot(const Offset(85.0, 56.4), 1.2);
  s.dot(const Offset(94.0, 56.4), 1.2);
  final drawer = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(83.2, 60.6, 95.8, 71.8),
        const Radius.circular(2.0),
      ),
    );
  s.fillArea(drawer, _ovenTop, amp: 0.3);
  s.ink(drawer, width: 1.7, amp: 0.3);
  s.strokeLine(
    const Offset(87.6, 66.2),
    const Offset(91.4, 66.2),
    width: 2.1,
    amp: 0.2,
  );
  s.dot(const Offset(84.2, 78.0), 1.7);
  s.dot(const Offset(94.8, 78.0), 1.7);
}

void _drawSack(Sketch s) {
  final body = Path()
    ..moveTo(6.8, 70.6)
    ..cubicTo(4.0, 74.0, 2.6, 80.5, 3.4, 85.0)
    ..cubicTo(3.9, 88.6, 6.0, 90.8, 11.0, 91.2)
    ..cubicTo(16.2, 90.8, 18.6, 88.4, 19.2, 84.6)
    ..cubicTo(19.9, 80.0, 18.4, 73.8, 15.2, 70.6)
    ..close();
  s.fillArea(body, _sack, amp: 0.4);
  s.shade(body, lift: const Offset(-1.8, -2.2));
  s.ink(body, width: 2.1, amp: 0.4);
  s.curve(
    const Offset(5.2, 76),
    const Offset(4.4, 80),
    const Offset(5.4, 84),
    width: 1.1,
    color: const Color(0x4D8A5B37),
    amp: 0.3,
  );
  s.curve(
    const Offset(17.6, 76),
    const Offset(18.5, 80),
    const Offset(17.5, 84),
    width: 1.1,
    color: const Color(0x4D8A5B37),
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(13.2, 66.4),
    const Offset(16.8, 60.8),
    width: 3.4,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(13.5, 66.1),
    const Offset(16.7, 61.1),
    width: 1.9,
    color: _pin,
    amp: 0.2,
  );
  s.dot(const Offset(17.1, 60.4), 1.6);
  s.dot(const Offset(17.1, 60.4), 0.95, color: _pin);
  final earL = Path()
    ..moveTo(6.4, 67.6)
    ..quadraticBezierTo(3.6, 63.2, 8.0, 64.0)
    ..quadraticBezierTo(9.6, 65.4, 8.8, 67.6)
    ..close();
  final earR = Path()
    ..moveTo(15.6, 67.6)
    ..quadraticBezierTo(18.4, 63.2, 14.0, 64.0)
    ..quadraticBezierTo(12.4, 65.4, 13.2, 67.6)
    ..close();
  for (final ear in [earL, earR]) {
    s.fillArea(ear, _cuff, amp: 0.3);
    s.ink(ear, width: 1.5, amp: 0.3);
  }
  final cuff = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(5.6, 66.8, 16.4, 71.8),
        const Radius.circular(2.2),
      ),
    );
  s.fillArea(cuff, _cuff, amp: 0.35);
  s.ink(cuff, width: 1.7, amp: 0.35);
  s.strokeLine(
    const Offset(5.8, 69.6),
    const Offset(16.2, 69.6),
    width: 1.2,
    color: const Color(0x668A5B37),
    amp: 0.3,
  );
  s.dot(const Offset(14.4, 69.6), 0.9);
  s.strokeLine(
    const Offset(14.4, 69.6),
    const Offset(15.6, 72.4),
    width: 1.0,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(14.4, 69.6),
    const Offset(13.4, 72.2),
    width: 1.0,
    amp: 0.2,
  );
  final patch = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(6.8, 75.6, 15.4, 86.4),
        const Radius.circular(1.5),
      ),
    );
  s.fillArea(patch, _flour, amp: 0.3);
  s.ink(patch, width: 1.2, color: Inks.inkSoft, amp: 0.3);
  s.strokeLine(
    const Offset(11.1, 84.4),
    const Offset(11.1, 78.6),
    width: 1.3,
    color: _wheat,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(11.1, 78.6),
    const Offset(11.1, 77.0),
    width: 1.0,
    color: _wheat,
    amp: 0.2,
  );
  for (final (dx, y) in const [
    (-1.4, 79.6),
    (1.4, 79.6),
    (-1.4, 81.6),
    (1.4, 81.6),
    (-1.4, 83.6),
    (1.4, 83.6),
  ]) {
    s.dot(Offset(11.1 + dx, y), 0.95, color: _wheat);
  }
  final spill = Path()
    ..moveTo(15.4, 90.6)
    ..quadraticBezierTo(16.8, 86.6, 18.8, 88.2)
    ..quadraticBezierTo(19.9, 89.0, 19.7, 90.4)
    ..quadraticBezierTo(17.6, 91.6, 15.4, 90.6)
    ..close();
  s.fillArea(spill, _flour, amp: 0.3);
  s.ink(spill, width: 1.1, color: Inks.inkSoft, amp: 0.3);
  s.dot(const Offset(13.2, 91.2), 0.65, color: _flour);
  s.dot(const Offset(19.2, 91.4), 0.55, color: _flour);
  s.dot(const Offset(7.4, 66.6), 0.7, color: _flour);
  s.dot(const Offset(5.0, 90.6), 0.5, color: _flour);
}
