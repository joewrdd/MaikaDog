import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _wall = Color(0xFFF1DDB0);
const _floor = Color(0xFFE2C58C);
const _plank = Color(0x2E8F6C42);
const _sandDot = Color(0x298F6C42);
const _drift = Color(0xFF8A6A44);
const _frame = Color(0xFFB08D5E);
const _skyLight = Color(0xFFDCEFF7);
const _sea = Color(0xFF8FBEDC);
const _horizon = Color(0x8C4A7FA6);
const _foam = Color(0xCCEAF4F9);
const _board = Color(0xFFA9D0C3);
const _bucket = Color(0xFFCF4A38);
const _bucketRim = Color(0xFFAF3A2C);
const _mat = Color(0xFFF0DFB6);
const _matEdge = Color(0x668F6C42);
const _matRing = Color(0x408F6C42);
const _shadow = Color(0x1A33251D);

Offset _q(Offset a, Offset c, Offset b, double t) =>
    a * ((1 - t) * (1 - t)) + c * (2 * (1 - t) * t) + b * (t * t);

void _shell(Sketch s, Offset apex, Color color) {
  final p = Path()
    ..moveTo(apex.dx, apex.dy)
    ..quadraticBezierTo(
      apex.dx - 2.1,
      apex.dy + 1.4,
      apex.dx - 1.8,
      apex.dy + 3.1,
    )
    ..quadraticBezierTo(apex.dx, apex.dy + 4.4, apex.dx + 1.8, apex.dy + 3.1)
    ..quadraticBezierTo(apex.dx + 2.1, apex.dy + 1.4, apex.dx, apex.dy)
    ..close();
  s.fillArea(p, color, amp: 0.2);
  s.ink(p, width: 1.4, amp: 0.2);
}

void paintBeachHouse(Sketch s) {
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 64));
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 62, 102, 102));
  s.fillArea(wall, _wall, amp: 0.35);
  for (final x in const [8.0, 22.0, 36.0, 64.0, 78.0, 92.0]) {
    s.strokeLine(
      Offset(x, 7),
      Offset(x, 60.5),
      width: 1.3,
      color: _plank,
      amp: 0.5,
    );
  }
  s.fillArea(floor, _floor, amp: 0.35);
  s.strokeLine(
    const Offset(-1, 62),
    const Offset(101, 62),
    width: 1.8,
    amp: 0.35,
  );
  s.strokeLine(
    const Offset(-1, 64),
    const Offset(101, 64),
    width: 1.0,
    color: _plank,
    amp: 0.4,
  );
  s.grain(floor, dots: 30, r: 0.6, color: _sandDot);
  s.curve(
    const Offset(5, 69),
    const Offset(11, 67.5),
    const Offset(17, 69),
    width: 1.1,
    color: _plank,
    amp: 0.3,
  );
  s.curve(
    const Offset(58, 95.5),
    const Offset(66, 94),
    const Offset(74, 95.5),
    width: 1.1,
    color: _plank,
    amp: 0.3,
  );
  final mat = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 85), width: 54, height: 15),
    );
  s.fillArea(mat, _mat, amp: 0.4);
  s.ink(mat, width: 1.5, amp: 0.45, color: _matEdge);
  final matInner = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 85), width: 43, height: 10.4),
    );
  s.ink(matInner, width: 1.1, amp: 0.45, color: _matRing);

  const a0 = Offset(13, 7.2);
  const a1 = Offset(32, 15.5);
  const a2 = Offset(50, 7.8);
  const b1 = Offset(68, 15.5);
  const b2 = Offset(87, 7.2);
  final string = Path()
    ..moveTo(a0.dx, a0.dy)
    ..quadraticBezierTo(a1.dx, a1.dy, a2.dx, a2.dy)
    ..quadraticBezierTo(b1.dx, b1.dy, b2.dx, b2.dy);
  s.ink(string, width: 1.4, color: _drift, amp: 0.3);
  s.dot(a0, 1.1, color: _drift);
  s.dot(a2, 0.9, color: _drift);
  s.dot(b2, 1.1, color: _drift);
  const shellColors = [
    Inks.cream,
    Inks.blush,
    Inks.sun,
    Inks.sun,
    Inks.blush,
    Inks.cream,
  ];
  var shellIndex = 0;
  for (final seg in const [
    [a0, a1, a2],
    [a2, b1, b2],
  ]) {
    for (final t in const [0.25, 0.5, 0.75]) {
      final at = _q(seg[0], seg[1], seg[2], t);
      s.dot(at, 0.55, color: _drift);
      _shell(s, at + const Offset(0, 0.3), shellColors[shellIndex]);
      shellIndex++;
    }
  }

  const portCenter = Offset(50, 29.4);
  final ringOuter = Path()
    ..addOval(Rect.fromCircle(center: portCenter, radius: 13.0));
  final glass = Path()
    ..addOval(Rect.fromCircle(center: portCenter, radius: 10.9));
  s.fillArea(ringOuter, _frame, amp: 0.25);
  s.ink(ringOuter, width: 2.0, amp: 0.3);
  s.canvas.save();
  s.canvas.clipPath(glass);
  s.fillArea(
    Path()..addRect(const Rect.fromLTRB(37, 17.5, 63, 30.7)),
    _skyLight,
    amp: 0.3,
  );
  s.fillArea(
    Path()..addRect(const Rect.fromLTRB(37, 30.3, 63, 42)),
    _sea,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(38, 30.5),
    const Offset(62, 30.5),
    width: 1.2,
    color: _horizon,
    amp: 0.3,
  );
  s.dot(const Offset(55.5, 24), 2.2, color: Inks.sun);
  s.sparkle(
    const Offset(55.5, 24),
    3.2,
    color: const Color(0xB3F6B84C),
    width: 1.1,
  );
  final bob = s.live ? math.sin(s.t * 1.8) * 0.5 : 0.0;
  final waveDrift = s.live ? math.sin(s.t * 1.1) * 1.2 : 0.0;
  s.strokeLine(
    Offset(43.4, 24.7 + bob),
    Offset(43.4, 30.5 + bob),
    width: 1.0,
    amp: 0.2,
  );
  final sail = Path()
    ..moveTo(43.9, 24.9 + bob)
    ..lineTo(43.9, 29.9 + bob)
    ..lineTo(47.8, 29.4 + bob)
    ..close();
  s.fillArea(sail, Inks.cream, amp: 0.15);
  s.ink(sail, width: 1.1, amp: 0.15);
  final hull = Path()
    ..moveTo(41.2, 30.5 + bob)
    ..lineTo(46.6, 30.5 + bob)
    ..lineTo(45.6, 32.3 + bob)
    ..lineTo(42.2, 32.3 + bob)
    ..close();
  s.fillArea(hull, _drift, amp: 0.15);
  s.strokeLine(
    Offset(51.5 + waveDrift, 35.8),
    Offset(55 + waveDrift, 35.8),
    width: 1.2,
    color: _foam,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(42.5, 37.8),
    const Offset(45.7, 37.8),
    width: 1.2,
    color: _foam,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(47, 39.3),
    const Offset(50, 39.3),
    width: 1.1,
    color: _foam,
    amp: 0.25,
  );
  s.canvas.restore();
  s.ink(glass, width: 1.5, amp: 0.25);
  for (var i = 0; i < 6; i++) {
    s.dot(s.polar(portCenter, i * 60.0, 11.95), 0.75);
  }
  s.gleam(
    portCenter,
    9.3,
    startDeg: -150,
    sweepDeg: 36,
    width: 1.3,
    color: const Color(0x59FFFFFF),
  );

  s.canvas.drawOval(
    Rect.fromCenter(center: const Offset(13.8, 80.6), width: 13, height: 2.8),
    Paint()..color = _shadow,
  );
  final board = Path()
    ..moveTo(8.2, 18.5)
    ..quadraticBezierTo(2.6, 34, 4.2, 52)
    ..quadraticBezierTo(5.4, 68, 9.8, 79.6)
    ..quadraticBezierTo(13.2, 81.4, 16.6, 78.6)
    ..quadraticBezierTo(15.8, 62, 13.4, 46)
    ..quadraticBezierTo(11.6, 30, 8.2, 18.5)
    ..close();
  s.fillArea(board, _board, amp: 0.3);
  s.shade(board, lift: const Offset(-1.8, -2.2));
  s.ink(board, width: 2.0, amp: 0.3);
  s.curve(
    const Offset(8.3, 21.5),
    const Offset(7.6, 48),
    const Offset(12.6, 77.5),
    width: 1.8,
    color: Inks.cream,
    amp: 0.3,
  );

  s.canvas.drawOval(
    Rect.fromCenter(center: const Offset(88.6, 80.4), width: 12.5, height: 3),
    Paint()..color = _shadow,
  );
  s.strokeLine(
    const Offset(90.4, 68.4),
    const Offset(93.9, 61.4),
    width: 1.7,
    color: _drift,
  );
  s.dot(const Offset(94.3, 60.8), 1.5, color: Inks.sun);
  s.ring(const Offset(94.3, 60.8), 1.6, width: 1.1);
  s.curve(
    const Offset(83.6, 68.6),
    const Offset(88.5, 61.6),
    const Offset(93.4, 68.6),
    width: 1.5,
    amp: 0.4,
  );
  final bucketBody = Path()
    ..moveTo(83.4, 69.8)
    ..lineTo(93.6, 69.8)
    ..lineTo(92.3, 79.8)
    ..lineTo(84.7, 79.8)
    ..close();
  s.fillArea(bucketBody, _bucket, amp: 0.25);
  s.ink(bucketBody, width: 1.8, amp: 0.25);
  final bucketRim = Path()
    ..addRect(const Rect.fromLTRB(83.1, 68.2, 93.9, 70.8));
  s.fillArea(bucketRim, _bucketRim, amp: 0.2);
  s.ink(bucketRim, width: 1.3, amp: 0.2);
  _shell(s, const Offset(80.8, 83.2), Inks.blush);
  _shell(s, const Offset(17, 86.6), Inks.sun);
  s.dot(const Offset(84, 83.2), 0.7, color: _sandDot);
  s.dot(const Offset(92.6, 82.6), 0.55, color: _sandDot);
  s.dot(const Offset(87.5, 85.6), 0.6, color: _sandDot);
}
