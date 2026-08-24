import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _wall = Color(0xFF3F4254);
const _sky = Color(0xFF22273A);
const _sand = Color(0xFFE9DFC6);
const _duneFar = Color(0xFFD9CCAB);
const _duneLine = Color(0x669D8B64);
const _sandLine = Color(0x338A7852);
const _sandGrain = Color(0x1F6B5B3E);
const _moon = Color(0xFFF6EFDA);
const _bone = Color(0xFFF2EBD8);
const _boneDim = Color(0xFFE3D9BF);
const _stoneLine = Color(0x3D8A7852);
const _stoneCrack = Color(0x6633251D);
const _crackPale = Color(0x3DEFE3C8);
const _rimLight = Color(0x59F6EFDA);
const _chip = Color(0x5933251D);
const _pool = Color(0x2EFFF3D2);
const _wood = Color(0xFF6F4B33);

void paintDuneHouse(Sketch s) {
  _room(s);
  _nightOpening(s);
  _sandFloor(s);
  _pillar(s);
  _maskShrine(s);
}

double _pulse(Sketch s, double speed, double phase, double rest) =>
    s.live ? 0.5 + 0.5 * math.sin(s.t * speed + phase) : rest;

void _room(Sketch s) {
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 63));
  s.fillArea(wall, _wall, amp: 0.35);
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 62, 102, 102));
  s.fillArea(floor, _sand, amp: 0.35);
  final crackA = Path()
    ..moveTo(11, 22)
    ..lineTo(14, 27)
    ..lineTo(12.5, 32);
  s.ink(crackA, width: 1.05, color: _crackPale, amp: 0.35);
  final crackB = Path()
    ..moveTo(86.5, 12)
    ..lineTo(84, 17)
    ..lineTo(85.8, 22.5);
  s.ink(crackB, width: 1.05, color: _crackPale, amp: 0.35);
  s.strokeLine(
    const Offset(9, 48),
    const Offset(12, 52),
    width: 1.0,
    color: _crackPale,
    amp: 0.35,
  );
  final crackC = Path()
    ..moveTo(84, 40)
    ..lineTo(86.5, 45)
    ..lineTo(85, 50);
  s.ink(crackC, width: 1.0, color: _crackPale, amp: 0.35);
  for (final dash in const [
    [Offset(43, 54), Offset(46, 54.2)],
    [Offset(57, 52), Offset(59.6, 52.1)],
    [Offset(30, 56.5), Offset(32.4, 56.6)],
  ]) {
    s.strokeLine(dash[0], dash[1], width: 0.95, color: _crackPale, amp: 0.25);
  }
}

Path _holePath() => Path()
  ..moveTo(29, 47)
  ..lineTo(24.5, 38)
  ..lineTo(28, 30)
  ..lineTo(24, 20)
  ..lineTo(31, 11.5)
  ..lineTo(41, 14)
  ..lineTo(49, 8.5)
  ..lineTo(59, 12.5)
  ..lineTo(69, 9)
  ..lineTo(76, 16.5)
  ..lineTo(72.5, 25)
  ..lineTo(77, 33)
  ..lineTo(71.5, 42)
  ..lineTo(63, 46.5)
  ..lineTo(51, 43.5)
  ..lineTo(39, 47.5)
  ..close();

void _nightOpening(Sketch s) {
  final hole = _holePath();
  s.fillArea(hole, _sky, amp: 0.4);
  s.canvas.save();
  s.canvas.clipPath(hole);
  _stars(s);
  _farDunes(s);
  _crescent(s);
  s.strokeLine(
    const Offset(74.6, 17.2),
    const Offset(71.6, 24.4),
    width: 1.2,
    color: _rimLight,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(70.2, 10.4),
    const Offset(74.8, 15.4),
    width: 1.1,
    color: _rimLight,
    amp: 0.3,
  );
  s.canvas.restore();
  s.ink(hole, width: 2.4, amp: 0.5, rough: true);
  for (final tick in const [
    [Offset(23.2, 19.4), Offset(20.8, 18.2)],
    [Offset(77.2, 33.4), Offset(79.8, 34.6)],
    [Offset(23.6, 38.6), Offset(21.2, 40.0)],
  ]) {
    s.strokeLine(tick[0], tick[1], width: 1.1, color: _chip, amp: 0.3);
  }
}

void _stars(Sketch s) {
  const pts = [
    [Offset(33.5, 16.5), 0.8, 0.0],
    [Offset(43, 12.5), 0.62, 1.6],
    [Offset(29.5, 25.5), 0.7, 3.1],
    [Offset(55.5, 14.5), 0.6, 4.2],
    [Offset(71.5, 30.5), 0.72, 2.2],
  ];
  for (final p in pts) {
    final k = _pulse(s, 1.5, p[2] as double, 0.65);
    s.dot(
      p[0] as Offset,
      (p[1] as double) * (0.8 + 0.25 * k),
      color: _moon.withValues(alpha: 0.45 + 0.55 * k),
    );
  }
  final tw = _pulse(s, 1.8, 5.1, 0.6);
  s.sparkle(
    const Offset(36.5, 21.5),
    1.7 * (0.8 + 0.25 * tw),
    width: 1.0,
    color: _moon.withValues(alpha: 0.35 + 0.45 * tw),
  );
}

void _farDunes(Sketch s) {
  final band = Path()
    ..moveTo(22, 41)
    ..quadraticBezierTo(30, 35.5, 38, 38.8)
    ..quadraticBezierTo(47, 42, 56, 38)
    ..quadraticBezierTo(66, 34.5, 78, 40)
    ..lineTo(78, 50)
    ..lineTo(22, 50)
    ..close();
  s.fillArea(band, _duneFar, amp: 0.3);
  s.curve(
    const Offset(30, 42.5),
    const Offset(36, 41),
    const Offset(42, 43),
    width: 1.05,
    color: _duneLine,
    amp: 0.3,
  );
  s.curve(
    const Offset(52, 43.5),
    const Offset(60, 41.5),
    const Offset(68, 43.8),
    width: 1.05,
    color: _duneLine,
    amp: 0.3,
  );
  final spireA = Path()
    ..moveTo(31.2, 39.6)
    ..lineTo(32.9, 29.8)
    ..lineTo(34.9, 39.9)
    ..close();
  s.fillArea(spireA, _bone, amp: 0.2);
  s.ink(spireA, width: 1.05, color: Inks.inkSoft, amp: 0.2);
  final spireB = Path()
    ..moveTo(37.0, 40.6)
    ..lineTo(38.2, 33.4)
    ..lineTo(39.8, 40.8)
    ..close();
  s.fillArea(spireB, _bone, amp: 0.2);
  s.ink(spireB, width: 1.05, color: Inks.inkSoft, amp: 0.2);
  final spireC = Path()
    ..moveTo(60.3, 39.6)
    ..lineTo(61.2, 34.6)
    ..lineTo(62.4, 39.8)
    ..close();
  s.fillArea(spireC, _bone, amp: 0.2);
  s.ink(spireC, width: 1.0, color: Inks.inkSoft, amp: 0.2);
  s.strokeLine(
    const Offset(32.3, 33.6),
    const Offset(30.6, 31.4),
    width: 1.0,
    color: Inks.inkSoft,
    amp: 0.2,
  );
}

void _crescent(Sketch s) {
  const c = Offset(66.5, 19.5);
  final glow = _pulse(s, 0.7, 0.4, 0.5);
  s.dot(c, 8.6, color: _moon.withValues(alpha: 0.08 + 0.06 * glow));
  s.dot(c, 5.4, color: _moon);
  s.dot(const Offset(64.6, 17.8), 5.0, color: _sky);
  s.ring(
    c,
    7.3,
    width: 1.05,
    color: _moon.withValues(alpha: 0.14 + 0.08 * glow),
    amp: 0.5,
  );
}

void _sandFloor(Sketch s) {
  s.strokeLine(
    const Offset(-1, 62.2),
    const Offset(101, 62.2),
    width: 1.7,
    amp: 0.4,
  );
  final pool = Path()
    ..moveTo(35, 62.8)
    ..lineTo(69, 62.8)
    ..lineTo(75, 80)
    ..lineTo(29, 80)
    ..close();
  s.fillArea(pool, _pool, amp: 0.5);
  for (final r in const [
    [Offset(18, 69.5), Offset(31, 67.4), Offset(44, 69.8)],
    [Offset(54, 74.5), Offset(67, 72.2), Offset(80, 74.8)],
    [Offset(10, 83.5), Offset(27, 80.8), Offset(43, 83.9)],
    [Offset(57, 87.5), Offset(71, 85.2), Offset(86, 87.8)],
    [Offset(26, 93.5), Offset(38, 91.6), Offset(50, 93.8)],
  ]) {
    s.curve(r[0], r[1], r[2], width: 1.25, color: _sandLine, amp: 0.45);
  }
  final floor = Path()..addRect(const Rect.fromLTRB(0, 63, 100, 100));
  s.grain(floor, dots: 16, r: 0.55, color: _sandGrain);
}

void _pillar(Sketch s) {
  final shaft = Path()
    ..moveTo(5.5, 89)
    ..lineTo(6.1, 45.5)
    ..lineTo(9, 40.5)
    ..lineTo(11.5, 44.5)
    ..lineTo(14.5, 37.5)
    ..lineTo(16.4, 42.5)
    ..lineTo(16.9, 89)
    ..close();
  s.fillArea(shaft, _bone, amp: 0.35);
  s.shade(shaft, lift: const Offset(-2.4, -3), gap: 4.4);
  s.ink(shaft, width: 2.0, amp: 0.4, rough: true);
  s.strokeLine(
    const Offset(9.4, 47),
    const Offset(9.1, 86.5),
    width: 1.1,
    color: _stoneLine,
    amp: 0.35,
  );
  s.strokeLine(
    const Offset(13.4, 44.5),
    const Offset(13.3, 86.5),
    width: 1.1,
    color: _stoneLine,
    amp: 0.35,
  );
  final crack = Path()
    ..moveTo(12, 57)
    ..lineTo(10.6, 62)
    ..lineTo(12.3, 67.5);
  s.ink(crack, width: 1.05, color: _stoneCrack, amp: 0.3);
  final plinth = Path()..addRect(const Rect.fromLTRB(3, 87.5, 19.4, 93));
  s.fillArea(plinth, _boneDim, amp: 0.3);
  s.ink(plinth, width: 1.8, amp: 0.35);
  final chunk = Path()
    ..moveTo(9.6, 95)
    ..lineTo(15.4, 94.2)
    ..lineTo(16.8, 97.6)
    ..lineTo(10.2, 98.2)
    ..close();
  s.fillArea(chunk, _bone, amp: 0.3);
  s.ink(chunk, width: 1.5, amp: 0.3);
  s.strokeLine(
    const Offset(12.2, 95.2),
    const Offset(12.6, 97.6),
    width: 1.0,
    color: _stoneLine,
    amp: 0.25,
  );
}

void _maskShrine(Sketch s) {
  s.strokeLine(
    const Offset(85, 92.6),
    const Offset(95, 92.6),
    width: 2.4,
    color: _wood,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(90, 92.4),
    const Offset(90, 75.6),
    width: 2.4,
    color: _wood,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(90, 85.8),
    const Offset(86.6, 92.2),
    width: 1.6,
    color: _wood,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(90, 85.8),
    const Offset(93.4, 92.2),
    width: 1.6,
    color: _wood,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(84.6, 74.8),
    const Offset(95.4, 74.8),
    width: 2.6,
    color: _wood,
    amp: 0.2,
  );
  final hornL = Path()
    ..moveTo(85.4, 60.6)
    ..quadraticBezierTo(82.0, 57.4, 81.6, 49.4)
    ..quadraticBezierTo(85.2, 54.4, 88.8, 58.8)
    ..close();
  s.fillArea(hornL, _bone, amp: 0.25);
  s.ink(hornL, width: 1.5, amp: 0.25);
  final hornR = Path()
    ..moveTo(94.6, 60.6)
    ..quadraticBezierTo(98.0, 57.4, 98.4, 49.4)
    ..quadraticBezierTo(94.8, 54.4, 91.2, 58.8)
    ..close();
  s.fillArea(hornR, _bone, amp: 0.25);
  s.ink(hornR, width: 1.5, amp: 0.25);
  final mask = Path()
    ..moveTo(84.4, 68.5)
    ..quadraticBezierTo(83.6, 60.5, 87.2, 58.0)
    ..quadraticBezierTo(90.0, 56.4, 92.8, 58.0)
    ..quadraticBezierTo(96.4, 60.5, 95.6, 68.5)
    ..quadraticBezierTo(94.8, 73.2, 90.0, 73.6)
    ..quadraticBezierTo(85.2, 73.2, 84.4, 68.5)
    ..close();
  s.fillArea(mask, _bone, amp: 0.25);
  s.ink(mask, width: 1.9, amp: 0.3);
  s.dot(const Offset(87.7, 64.2), 1.35);
  s.dot(const Offset(92.3, 64.2), 1.35);
  s.dot(const Offset(87.35, 63.8), 0.45, color: const Color(0x99FFFFFF));
  s.dot(const Offset(91.95, 63.8), 0.45, color: const Color(0x99FFFFFF));
  s.curve(
    const Offset(85.4, 69.2),
    const Offset(90, 70.4),
    const Offset(94.6, 69.2),
    width: 1.1,
    amp: 0.2,
  );
  for (final tooth in const [
    [Offset(86.8, 69.5), Offset(86.8, 71.7)],
    [Offset(88.4, 69.9), Offset(88.4, 72.6)],
    [Offset(90.0, 70.1), Offset(90.0, 73.0)],
    [Offset(91.6, 69.9), Offset(91.6, 72.6)],
    [Offset(93.2, 69.5), Offset(93.2, 71.7)],
  ]) {
    s.strokeLine(tooth[0], tooth[1], width: 1.0, amp: 0.15);
  }
  final maskCrack = Path()
    ..moveTo(86.7, 66.0)
    ..lineTo(86.1, 67.4)
    ..lineTo(86.9, 68.8);
  s.ink(maskCrack, width: 0.95, color: _stoneCrack, amp: 0.25);
  s.gleam(
    const Offset(88.4, 60.4),
    2.6,
    startDeg: -150,
    sweepDeg: 50,
    width: 1.1,
    color: const Color(0x66FFFFFF),
  );
}
