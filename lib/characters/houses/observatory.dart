import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _wall = Color(0xFF33415F);
const _night = Color(0xFF1D2942);
const _floor = Color(0xFF6B5643);
const _seam = Color(0x3D2B1A0E);
const _rug = Color(0xFF52638C);
const _rugTrim = Color(0xB3EFE0B8);
const _brass = Color(0xFFC08E4C);
const _brassDeep = Color(0xFF8A6132);
const _moon = Color(0xFFF3E5B5);
const _crater = Color(0x40A08850);
const _gold = Color(0xFFF6D98A);
const _chartLine = Color(0x59E8D8AC);

void paintObservatoryHouse(Sketch s) {
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 64));
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 62, 102, 102));
  s.fillArea(wall, _wall, amp: 0.35);
  s.fillArea(floor, _floor, amp: 0.35);
  _planks(s);
  _rugPiece(s);
  s.strokeLine(
    const Offset(-1, 62),
    const Offset(101, 62),
    width: 1.8,
    amp: 0.35,
  );
  _skylight(s);
  _starChart(s);
  _fairyLights(s);
  _starMobile(s);
  _telescope(s);
}

void _starMobile(Sketch s) {
  final sway = s.live ? math.sin(s.t * 0.9 + 1.3) * 1.5 : 0.6;
  final tip = Offset(77.5 + sway, 16.5);
  s.curve(
    const Offset(77.5, 7.2),
    Offset(77.5 + sway * 0.3, 12),
    tip,
    width: 1.0,
    color: Inks.inkSoft,
    amp: 0.15,
  );
  _star4(s, Offset(tip.dx, tip.dy + 1.8), 2.1, 3.1, outline: true);
}

double _pulse(Sketch s, double speed, double phase, double rest) =>
    s.live ? 0.5 + 0.5 * math.sin(s.t * speed + phase) : rest;

void _planks(Sketch s) {
  for (final y in const [70.5, 80.0, 89.5]) {
    s.strokeLine(
      Offset(-2, y),
      Offset(102, y),
      width: 1.1,
      color: _seam,
      amp: 0.5,
    );
  }
  for (final tick in const [
    [Offset(14, 63.5), Offset(14, 70)],
    [Offset(86, 63.5), Offset(86, 70)],
    [Offset(10, 81), Offset(10, 89)],
    [Offset(30, 90.5), Offset(30, 96.5)],
    [Offset(72, 90.5), Offset(72, 96.5)],
  ]) {
    s.strokeLine(tick[0], tick[1], width: 1.0, color: _seam, amp: 0.4);
  }
}

void _rugPiece(Sketch s) {
  final rug = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 80.5), width: 50, height: 16.5),
    );
  s.fillArea(rug, _rug, amp: 0.35);
  s.ink(rug, width: 1.6, amp: 0.35);
  final trim = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 80.5), width: 42, height: 12.5),
    );
  s.ink(trim, width: 1.5, amp: 0.35, color: _rugTrim);
  s.dot(const Offset(31.5, 80), 0.85, color: _gold.withValues(alpha: 0.85));
  s.dot(const Offset(68.5, 80), 0.85, color: _gold.withValues(alpha: 0.85));
  s.dot(const Offset(50, 73.8), 0.85, color: _gold.withValues(alpha: 0.85));
  for (final fringe in const [
    [Offset(24.9, 78.5), Offset(22.7, 78)],
    [Offset(24.6, 80.5), Offset(22.3, 80.5)],
    [Offset(24.9, 82.5), Offset(22.7, 83)],
    [Offset(75.1, 78.5), Offset(77.3, 78)],
    [Offset(75.4, 80.5), Offset(77.7, 80.5)],
    [Offset(75.1, 82.5), Offset(77.3, 83)],
  ]) {
    s.strokeLine(fringe[0], fringe[1], width: 1.1, color: _rugTrim, amp: 0.2);
  }
}

void _skylight(Sketch s) {
  const c = Offset(50, 27.5);
  const r = 18.0;
  final glass = Path()..addOval(Rect.fromCircle(center: c, radius: r));
  s.fillArea(glass, _night, amp: 0.3);
  const moonC = Offset(44, 22.5);
  final glow = _pulse(s, 0.7, 0, 0.5);
  s.dot(moonC, 8.0, color: _moon.withValues(alpha: 0.10 + 0.07 * glow));
  final moon = Path()..addOval(Rect.fromCircle(center: moonC, radius: 5.4));
  s.fillArea(moon, _moon, amp: 0.25);
  s.ink(moon, width: 1.3, amp: 0.25, color: Inks.inkSoft);
  s.dot(const Offset(42.2, 21), 1.2, color: _crater);
  s.dot(const Offset(46.3, 24.2), 0.85, color: _crater);
  s.dot(const Offset(43.6, 25.5), 0.6, color: _crater);
  _star4(s, const Offset(59, 19), 2.5, 0.4, outline: true);
  _star4(s, const Offset(57, 36.5), 1.7, 2.6);
  _starDot(s, const Offset(63.5, 28.5), 1.0, 1.2);
  _starDot(s, const Offset(52, 12.8), 0.85, 3.4);
  _starDot(s, const Offset(36.5, 30), 0.8, 4.4);
  _starDot(s, const Offset(63, 21.5), 0.7, 5.2);
  final k = _pulse(s, 1.6, 1.9, 0.62);
  s.sparkle(
    const Offset(46, 37.5),
    1.8 * (0.75 + 0.3 * k),
    width: 1.1,
    color: _gold.withValues(alpha: 0.45 + 0.5 * k),
  );
  s.gleam(
    c,
    14.4,
    startDeg: -44,
    sweepDeg: 26,
    width: 1.7,
    color: const Color(0x30FFFFFF),
  );
  s.ink(glass, width: 2.4, amp: 0.3);
  s.ring(c, r - 1.8, width: 1.5, color: _brass, amp: 0.3);
}

void _star4(
  Sketch s,
  Offset c,
  double r,
  double phase, {
  bool outline = false,
}) {
  final k = _pulse(s, 1.6, phase, 0.62);
  final star = s.starPath(
    c,
    r * (0.85 + 0.22 * k),
    points: 4,
    innerRatio: 0.42,
  );
  s.fillArea(star, _gold, amp: 0.2);
  if (outline) s.ink(star, width: 1.1, amp: 0.2, color: Inks.inkSoft);
}

void _starDot(Sketch s, Offset c, double r, double phase) {
  final k = _pulse(s, 1.6, phase, 0.62);
  s.dot(c, r * (0.75 + 0.3 * k), color: _gold.withValues(alpha: 0.5 + 0.5 * k));
}

void _starChart(Sketch s) {
  s.dot(const Offset(14, 17.2), 0.85);
  s.strokeLine(
    const Offset(14, 17.4),
    const Offset(14, 21),
    width: 1.1,
    color: Inks.inkSoft,
    amp: 0.2,
  );
  final frame = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(7.5, 21, 20.5, 35.5),
        const Radius.circular(1.4),
      ),
    );
  s.fillArea(frame, _night, amp: 0.25);
  s.ink(frame, width: 1.7, amp: 0.25);
  const pts = [
    Offset(10.5, 25.5),
    Offset(13.5, 24),
    Offset(16.8, 26),
    Offset(15.2, 30),
    Offset(11.3, 32.3),
  ];
  final line = Path()..moveTo(pts.first.dx, pts.first.dy);
  for (final p in pts.skip(1)) {
    line.lineTo(p.dx, p.dy);
  }
  s.ink(line, width: 0.9, amp: 0.2, color: _chartLine);
  for (final p in pts) {
    s.dot(p, 0.75, color: _gold);
  }
}

void _fairyLights(Sketch s) {
  final wire = Path()
    ..moveTo(-2, 4.5)
    ..quadraticBezierTo(15, 10, 32, 4.8)
    ..quadraticBezierTo(49, 9.2, 66, 4.8)
    ..quadraticBezierTo(83, 10, 102, 4.5);
  s.ink(wire, width: 1.2, amp: 0.25, color: Inks.inkSoft);
  s.dot(const Offset(32, 4.8), 0.8);
  s.dot(const Offset(66, 4.8), 0.8);
  const bulbs = [
    Offset(8.2, 7.7),
    Offset(15, 8.2),
    Offset(21.8, 7.8),
    Offset(42.2, 7.5),
    Offset(49, 7.8),
    Offset(55.8, 7.5),
    Offset(76.4, 7.8),
    Offset(83.5, 8.1),
    Offset(90.8, 7.7),
  ];
  const tones = [Inks.sun, Inks.blush, _moon];
  for (var i = 0; i < bulbs.length; i++) {
    final tone = tones[i % 3];
    final k = _pulse(s, 1.2, i * 1.7, 0.6);
    s.dot(bulbs[i], 2.3, color: tone.withValues(alpha: 0.10 + 0.13 * k));
    s.dot(bulbs[i], 1.05, color: tone.withValues(alpha: 0.72 + 0.28 * k));
  }
}

void _telescope(Sketch s) {
  for (final leg in const [
    [Offset(89.8, 71.5), Offset(83, 88)],
    [Offset(89.8, 71.5), Offset(90.5, 89)],
    [Offset(89.8, 71.5), Offset(96, 86)],
  ]) {
    s.strokeLine(leg[0], leg[1], width: 1.9, amp: 0.15);
  }
  s.dot(const Offset(83, 88.2), 1.1);
  s.dot(const Offset(90.5, 89.2), 1.1);
  s.dot(const Offset(96, 86.2), 1.1);
  final tube = Path()
    ..moveTo(82.8, 57.1)
    ..lineTo(95.3, 74.5)
    ..lineTo(92.7, 76.5)
    ..lineTo(79.2, 59.9)
    ..close();
  s.fillArea(tube, _brass, amp: 0.25);
  s.ink(tube, width: 1.8, amp: 0.25);
  s.dot(const Offset(81, 58.5), 1.2, color: _night);
  s.strokeLine(
    const Offset(85.1, 60.4),
    const Offset(81.7, 63),
    width: 1.5,
    color: _brassDeep,
    amp: 0.15,
  );
  s.strokeLine(
    const Offset(94, 75.5),
    const Offset(95.2, 77),
    width: 2.6,
    color: _brassDeep,
    amp: 0.15,
  );
  s.dot(const Offset(95.5, 77.3), 1.1);
  s.dot(const Offset(89.8, 71.3), 1.7, color: _brassDeep);
}
