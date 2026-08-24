import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _wall = Color(0xFF483C5B);
const _wallTop = Color(0xFF3B3050);
const _floor = Color(0xFF574C6C);
const _seam = Color(0x66241B3A);
const _rim = Color(0xFF6C5E90);
const _rimTick = Color(0x88241B3A);
const _void = Color(0xFF241A3A);
const _glow = Color(0xFFA478DC);
const _glowDeep = Color(0xFF8266C8);
const _mote = Color(0xFFDECCFF);
const _eyeBright = Color(0xFFF0E4FF);
const _eyeDim = Color(0xFFCFB6F6);
const _crystal = Color(0xFF8A6BD4);
const _crystalDeep = Color(0xFF6F55B5);
const _crystalLite = Color(0xFFC4ADF2);
const _baseShadow = Color(0x3B1D1436);
const _grainDark = Color(0x22160F28);
const _grainLite = Color(0x14DECCFF);

void paintGateHouse(Sketch s) {
  final pulse = s.live ? 0.5 + 0.5 * math.sin(s.t * 1.7) : 0.6;
  final crystalPulse = s.live ? 0.5 + 0.5 * math.sin(s.t * 1.7 + 2.2) : 0.5;
  _room(s, pulse);
  _arch(s, pulse);
  _cluster(s, 10.5, -1, crystalPulse);
  _cluster(s, 89.5, 1, crystalPulse);
}

void _room(Sketch s, double pulse) {
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 62));
  s.fillArea(wall, _wall, amp: 0.35);
  final lintel = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 6.5));
  s.fillArea(lintel, _wallTop, amp: 0.3);
  s.strokeLine(
    const Offset(-1, 6.7),
    const Offset(101, 6.7),
    width: 1.6,
    amp: 0.35,
  );
  for (final y in const [17.0, 31.0, 45.0]) {
    s.strokeLine(
      Offset(-1, y),
      Offset(101, y),
      width: 1.3,
      color: _seam,
      amp: 0.45,
    );
  }
  for (final seg in const [
    [14.0, 7.4, 16.4],
    [86.0, 7.4, 16.4],
    [24.0, 17.6, 30.4],
    [76.0, 17.6, 30.4],
    [9.0, 31.6, 44.4],
    [91.0, 31.6, 44.4],
    [20.0, 45.6, 61.4],
    [80.0, 45.6, 61.4],
  ]) {
    s.strokeLine(
      Offset(seg[0], seg[1]),
      Offset(seg[0], seg[2]),
      width: 1.3,
      color: _seam,
      amp: 0.4,
    );
  }
  final crackA = Path()
    ..moveTo(75.5, 46.5)
    ..lineTo(78, 51)
    ..lineTo(76.6, 56);
  s.ink(crackA, width: 1.2, color: _seam, amp: 0.5);
  final crackB = Path()
    ..moveTo(13, 20)
    ..lineTo(15.6, 25)
    ..lineTo(14.2, 30.2);
  s.ink(crackB, width: 1.2, color: _seam, amp: 0.5);
  s.grain(wall, dots: 26, r: 0.6, color: _grainDark);
  s.grain(wall, dots: 12, r: 0.5, color: _grainLite);
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 62, 102, 102));
  s.fillArea(floor, _floor, amp: 0.35);
  s.strokeLine(
    const Offset(-1, 62.2),
    const Offset(101, 62.2),
    width: 1.8,
    amp: 0.35,
  );
  s.strokeLine(
    const Offset(30, 63.8),
    const Offset(30, 78.6),
    width: 1.3,
    color: _seam,
    amp: 0.35,
  );
  s.strokeLine(
    const Offset(70, 63.8),
    const Offset(70, 78.6),
    width: 1.3,
    color: _seam,
    amp: 0.35,
  );
  s.strokeLine(
    const Offset(-1, 79.6),
    const Offset(101, 79.6),
    width: 1.3,
    color: _seam,
    amp: 0.35,
  );
  s.strokeLine(
    const Offset(50, 80.6),
    const Offset(50, 101),
    width: 1.3,
    color: _seam,
    amp: 0.35,
  );
  s.grain(floor, dots: 16, r: 0.55, color: _grainDark);
  final pool = Path()
    ..moveTo(38, 62.4)
    ..lineTo(62, 62.4)
    ..lineTo(66.5, 79)
    ..lineTo(33.5, 79)
    ..close();
  s.fillArea(pool, _glow.withValues(alpha: 0.10 + 0.09 * pulse), amp: 0.4);
}

void _arch(Sketch s, double pulse) {
  final halo = Path()
    ..moveTo(29.5, 61)
    ..lineTo(29.5, 27)
    ..quadraticBezierTo(29.5, 8, 50, 8)
    ..quadraticBezierTo(70.5, 8, 70.5, 27)
    ..lineTo(70.5, 61)
    ..close();
  s.fillArea(halo, _glow.withValues(alpha: 0.08 + 0.10 * pulse), amp: 0.45);
  final outer = Path()
    ..moveTo(32.5, 62.3)
    ..lineTo(32.5, 28)
    ..quadraticBezierTo(32.5, 11, 50, 11)
    ..quadraticBezierTo(67.5, 11, 67.5, 28)
    ..lineTo(67.5, 62.3)
    ..close();
  s.fillArea(outer, _rim, amp: 0.3);
  final inner = Path()
    ..moveTo(36, 62.3)
    ..lineTo(36, 29)
    ..quadraticBezierTo(36, 14.5, 50, 14.5)
    ..quadraticBezierTo(64, 14.5, 64, 29)
    ..lineTo(64, 62.3)
    ..close();
  s.fillArea(inner, _void, amp: 0.25);
  final glowIn = Path()
    ..moveTo(38.5, 61.5)
    ..lineTo(37.8, 44)
    ..quadraticBezierTo(50, 36, 62.2, 44)
    ..lineTo(61.5, 61.5)
    ..close();
  s.fillArea(glowIn, _glow.withValues(alpha: 0.13 + 0.11 * pulse), amp: 0.35);
  s.dot(
    const Offset(50, 50),
    7.5,
    color: _glow.withValues(alpha: 0.12 + 0.09 * pulse),
  );
  s.curve(
    const Offset(41.5, 47),
    const Offset(45.5, 44),
    const Offset(50, 46.5),
    width: 1.6,
    color: _glowDeep.withValues(alpha: 0.6),
    amp: 0.5,
  );
  s.curve(
    const Offset(50.5, 38.5),
    const Offset(55, 35.5),
    const Offset(58.8, 38.5),
    width: 1.5,
    color: _glowDeep.withValues(alpha: 0.55),
    amp: 0.5,
  );
  s.curve(
    const Offset(45, 20.2),
    const Offset(50, 17.6),
    const Offset(55, 20.2),
    width: 1.4,
    color: _glowDeep.withValues(alpha: 0.55),
    amp: 0.4,
  );
  for (var i = 0; i < 3; i++) {
    final f = s.live ? (s.t * 0.09 + i / 3) % 1.0 : 0.18 + i * 0.27;
    final y = 58 - f * 37;
    final x = 44.5 + i * 5.4 + math.sin((f + i * 0.7) * 2 * math.pi) * 1.8;
    final a = (bell(f) * 0.85).clamp(0.0, 1.0);
    s.dot(Offset(x, y), 1.2 - f * 0.45, color: _mote.withValues(alpha: a));
  }
  s.dot(
    const Offset(44.9, 22.4),
    4.4,
    color: _glow.withValues(alpha: 0.30 + 0.12 * pulse),
  );
  s.dot(
    const Offset(43.2, 22.4),
    1.15,
    color: _eyeBright.withValues(alpha: 0.80 + 0.18 * pulse),
  );
  s.dot(
    const Offset(46.6, 22.4),
    1.15,
    color: _eyeBright.withValues(alpha: 0.80 + 0.18 * pulse),
  );
  s.dot(
    const Offset(58.6, 30.5),
    3.4,
    color: _glow.withValues(alpha: 0.22 + 0.10 * (1 - pulse)),
  );
  s.dot(
    const Offset(57.2, 30.5),
    0.9,
    color: _eyeDim.withValues(alpha: 0.62 + 0.28 * (1 - pulse)),
  );
  s.dot(
    const Offset(60.0, 30.5),
    0.9,
    color: _eyeDim.withValues(alpha: 0.62 + 0.28 * (1 - pulse)),
  );
  final innerLine = Path()
    ..moveTo(36, 62.3)
    ..lineTo(36, 29)
    ..quadraticBezierTo(36, 14.5, 50, 14.5)
    ..quadraticBezierTo(64, 14.5, 64, 29)
    ..lineTo(64, 62.3);
  s.ink(
    innerLine,
    width: 3.4,
    color: _glow.withValues(alpha: 0.55 + 0.25 * pulse),
    amp: 0.3,
  );
  s.ink(innerLine, width: 1.6, amp: 0.3);
  final outerLine = Path()
    ..moveTo(32.5, 62.3)
    ..lineTo(32.5, 28)
    ..quadraticBezierTo(32.5, 11, 50, 11)
    ..quadraticBezierTo(67.5, 11, 67.5, 28)
    ..lineTo(67.5, 62.3);
  s.ink(outerLine, width: 2.0, amp: 0.3);
  s.strokeLine(
    const Offset(31.5, 62.2),
    const Offset(68.5, 62.2),
    width: 1.8,
    amp: 0.35,
  );
  s.strokeLine(
    const Offset(47.5, 11.4),
    const Offset(46.7, 14.6),
    width: 1.2,
    color: _rimTick,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(52.5, 11.4),
    const Offset(53.3, 14.6),
    width: 1.2,
    color: _rimTick,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(37.6, 16.4),
    const Offset(40.0, 18.8),
    width: 1.2,
    color: _rimTick,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(62.4, 16.4),
    const Offset(60.0, 18.8),
    width: 1.2,
    color: _rimTick,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(32.8, 37),
    const Offset(35.7, 37),
    width: 1.2,
    color: _rimTick,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(64.3, 37),
    const Offset(67.2, 37),
    width: 1.2,
    color: _rimTick,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(32.8, 49),
    const Offset(35.7, 49),
    width: 1.2,
    color: _rimTick,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(64.3, 49),
    const Offset(67.2, 49),
    width: 1.2,
    color: _rimTick,
    amp: 0.2,
  );
  final mist = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 61), width: 30, height: 5.4),
    );
  s.fillArea(mist, _glow.withValues(alpha: 0.16 + 0.10 * pulse), amp: 0.4);
}

void _cluster(Sketch s, double cx, double out, double pulse) {
  s.dot(
    Offset(cx, 84),
    9.5,
    color: _glow.withValues(alpha: 0.10 + 0.10 * pulse),
  );
  final shadow = Path()
    ..addOval(
      Rect.fromCenter(center: Offset(cx, 94.9), width: 18.5, height: 3.6),
    );
  s.fillArea(shadow, _baseShadow, amp: 0.3);
  _shard(s, Offset(cx - out * 4.9, 95), 2.2, 11, -out * 0.8, _crystalDeep);
  _shard(s, Offset(cx + out * 5.1, 95), 2.6, 16, out * 1.9, _crystalDeep);
  _shard(s, Offset(cx, 95.2), 3.4, 24, out * 1.0, _crystal);
  final tip = Offset(cx + out * 1.0, 71.2);
  s.dot(tip, 1.0, color: _mote.withValues(alpha: 0.55 + 0.35 * pulse));
  s.sparkle(
    Offset(cx - out * 4.2, 76.5),
    1.9,
    color: _mote.withValues(alpha: 0.5 + 0.4 * pulse),
  );
  s.dot(Offset(cx - out * 3.4, 90), 0.8, color: _crystalLite);
}

void _shard(
  Sketch s,
  Offset base,
  double halfW,
  double h,
  double lean,
  Color fill,
) {
  final tip = Offset(base.dx + lean, base.dy - h);
  final body = Path()
    ..moveTo(base.dx - halfW, base.dy)
    ..lineTo(tip.dx - halfW * 0.24, tip.dy + h * 0.16)
    ..lineTo(tip.dx, tip.dy)
    ..lineTo(tip.dx + halfW * 0.32, tip.dy + h * 0.2)
    ..lineTo(base.dx + halfW, base.dy)
    ..close();
  s.fillArea(body, fill, amp: 0.25);
  s.ink(body, width: 1.7, amp: 0.25);
  s.strokeLine(
    Offset(tip.dx + halfW * 0.12, tip.dy + h * 0.2),
    Offset(base.dx + halfW * 0.45, base.dy - h * 0.14),
    width: 1.4,
    color: _crystalLite,
    amp: 0.2,
  );
}
