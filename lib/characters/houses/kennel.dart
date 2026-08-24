import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _plank = Color(0xFFE9CFA3);
const _plankLine = Color(0x478A5E36);
const _plankFaint = Color(0x2E8A5E36);
const _skirt = Color(0xFFD3AC7C);
const _skirtLine = Color(0x5E6E4A28);
const _floor = Color(0xFFDDB78A);
const _floorLine = Color(0x389A6B42);
const _frameWood = Color(0xFFAF7C4E);
const _frameDeep = Color(0xFF8F6238);
const _bone = Color(0xFFF8EED9);
const _rug = Color(0xFFF3DCA8);
const _rugLine = Color(0xB3D9A24E);
const _rugEdge = Color(0xA6B98342);
const _bowlRed = Color(0xFFC94F33);
const _bowlDark = Color(0xFF8E3322);
const _kibble = Color(0xFFE3B26B);
const _paw = Color(0xB58A5E36);

void paintKennelHouse(Sketch s) {
  _wallAndFloor(s);
  _window(s);
  _pawPicture(s);
  _hangingBone(s);
  _rugPiece(s);
  _bowl(s);
}

void _wallAndFloor(Sketch s) {
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 64));
  s.fillArea(wall, _plank, amp: 0.35);
  for (final y in const [12.0, 24.0, 36.0, 48.0]) {
    s.strokeLine(
      Offset(-1, y),
      Offset(101, y),
      width: 1.4,
      color: _plankLine,
      amp: 0.35,
    );
  }
  for (final j in const [
    [30.0, 1.0, 11.5],
    [68.0, 12.5, 23.5],
    [12.0, 24.5, 35.5],
    [54.0, 36.5, 47.5],
    [86.0, 48.5, 55.8],
  ]) {
    s.strokeLine(
      Offset(j[0], j[1]),
      Offset(j[0], j[2]),
      width: 1.2,
      color: _plankFaint,
      amp: 0.3,
    );
  }
  for (final g in const [
    [7.0, 19.0, 15.0],
    [36.0, 7.5, 44.0],
    [56.0, 30.5, 64.0],
    [7.0, 42.5, 14.0],
    [60.0, 53.0, 68.0],
  ]) {
    s.curve(
      Offset(g[0], g[1]),
      Offset((g[0] + g[2]) / 2, g[1] + 1.1),
      Offset(g[2], g[1]),
      width: 1.1,
      color: _plankFaint,
      amp: 0.25,
    );
  }
  s.ring(const Offset(12, 41), 1.4, width: 1.0, color: _plankLine);
  s.dot(const Offset(12, 41), 0.5, color: _plankLine);
  final skirt = Path()..addRect(const Rect.fromLTRB(-2, 56.5, 102, 63));
  s.fillArea(skirt, _skirt, amp: 0.3);
  s.strokeLine(
    const Offset(-1, 56.5),
    const Offset(101, 56.5),
    width: 1.4,
    color: _skirtLine,
    amp: 0.3,
  );
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 62, 102, 102));
  s.fillArea(floor, _floor, amp: 0.35);
  final shadow = Path()..addRect(const Rect.fromLTRB(-2, 62, 102, 64.6));
  s.fillArea(shadow, const Color(0x1033251D), amp: 0.3);
  s.strokeLine(
    const Offset(-1, 62.2),
    const Offset(101, 62.2),
    width: 1.6,
    amp: 0.35,
  );
  for (final y in const [72.5, 82.5, 92.5]) {
    s.strokeLine(
      Offset(-1, y),
      Offset(101, y),
      width: 1.2,
      color: _floorLine,
      amp: 0.3,
    );
  }
  for (final j in const [
    [30.0, 62.6, 72.2],
    [14.0, 72.8, 82.2],
    [66.0, 72.8, 82.2],
    [84.0, 82.8, 92.2],
    [48.0, 92.8, 101.0],
  ]) {
    s.strokeLine(
      Offset(j[0], j[1]),
      Offset(j[0], j[2]),
      width: 1.1,
      color: _floorLine,
      amp: 0.25,
    );
  }
  s.grain(floor, dots: 10, color: const Color(0x1A6B4A2C), r: 0.55);
}

void _window(Sketch s) {
  const c = Offset(77, 21);
  final frame = Path()..addOval(Rect.fromCircle(center: c, radius: 10.6));
  s.fillArea(frame, _frameWood, amp: 0.3);
  final sky = Path()..addOval(Rect.fromCircle(center: c, radius: 8.5));
  s.fillArea(sky, Inks.sky, amp: 0.25);
  s.canvas.save();
  s.canvas.clipPath(sky);
  final drift = s.live ? math.sin(s.t * 0.5 + 1) * 1.6 : 0.0;
  s.dot(const Offset(73, 16.4), 2.7, color: Inks.sun);
  s.curve(
    const Offset(80.2, 17.2),
    const Offset(81.3, 16.1),
    const Offset(82.3, 17),
    width: 1.1,
    color: Inks.inkSoft,
    amp: 0.15,
  );
  s.dot(Offset(72 + drift, 24.9), 2.0, color: Inks.cream);
  s.dot(Offset(74.8 + drift, 24.3), 1.6, color: Inks.cream);
  s.canvas.restore();
  s.strokeLine(
    const Offset(77, 12.8),
    const Offset(77, 29.2),
    width: 1.4,
    color: _frameDeep,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(68.8, 21),
    const Offset(85.2, 21),
    width: 1.4,
    color: _frameDeep,
    amp: 0.25,
  );
  s.ring(c, 8.5, width: 1.5, amp: 0.3);
  s.ring(c, 10.6, width: 1.8, amp: 0.3);
}

void _pawPicture(Sketch s) {
  s.canvas.save();
  s.canvas.translate(46, 19.4);
  s.canvas.rotate(-0.05);
  s.canvas.translate(-46, -19.4);
  s.dot(const Offset(46, 12.2), 0.9);
  s.strokeLine(
    const Offset(46, 12.6),
    const Offset(46, 13.9),
    width: 1.1,
    amp: 0.2,
  );
  final outer = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: const Offset(46, 19.4),
          width: 13.4,
          height: 11.2,
        ),
        const Radius.circular(1.2),
      ),
    );
  s.fillArea(outer, _frameWood, amp: 0.3);
  s.ink(outer, width: 1.7, amp: 0.3);
  final inner = Path()
    ..addRect(
      Rect.fromCenter(center: const Offset(46, 19.4), width: 9.4, height: 7.4),
    );
  s.fillArea(inner, const Color(0xFFFBF1DC), amp: 0.25);
  s.ink(inner, width: 1.1, amp: 0.25, color: Inks.inkSoft);
  s.dot(const Offset(46, 20.8), 1.55, color: _paw);
  s.dot(const Offset(44.2, 18.9), 0.75, color: _paw);
  s.dot(const Offset(46, 18.3), 0.8, color: _paw);
  s.dot(const Offset(47.8, 18.9), 0.75, color: _paw);
  s.canvas.restore();
}

void _hangingBone(Sketch s) {
  const hook = Offset(24.5, 12.2);
  s.dot(hook, 1.15);
  final swing = s.live ? math.sin(s.t * 1.5) * 0.07 : 0.0;
  s.canvas.save();
  s.canvas.translate(hook.dx, hook.dy);
  s.canvas.rotate(swing);
  s.canvas.translate(-hook.dx, -hook.dy);
  s.strokeLine(
    const Offset(24.5, 13),
    const Offset(24.5, 23.6),
    width: 1.2,
    amp: 0.25,
  );
  s.dot(const Offset(24.5, 23.9), 0.8);
  s.canvas.translate(24.5, 26.8);
  s.canvas.rotate(-0.14);
  s.canvas.translate(-24.5, -26.8);
  var bone = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: const Offset(24.5, 26.8),
          width: 13.2,
          height: 3.4,
        ),
        const Radius.circular(1.7),
      ),
    );
  for (final k in const [
    Offset(18.7, 24.9),
    Offset(18.7, 28.7),
    Offset(30.3, 24.9),
    Offset(30.3, 28.7),
  ]) {
    bone = Path.combine(
      PathOperation.union,
      bone,
      Path()..addOval(Rect.fromCircle(center: k, radius: 3.05)),
    );
  }
  s.fillArea(bone, _bone, amp: 0.3);
  s.ink(bone, width: 1.8, amp: 0.3);
  s.canvas.restore();
}

void _rugPiece(Sketch s) {
  final rug = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 83.5), width: 50, height: 15),
    );
  s.fillArea(rug, _rug, amp: 0.4);
  final mid = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 83.5), width: 36, height: 10.2),
    );
  s.ink(mid, width: 1.5, amp: 0.35, color: _rugLine);
  final core = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 83.5), width: 21, height: 5.8),
    );
  s.ink(core, width: 1.4, amp: 0.3, color: _rugLine);
  s.ink(rug, width: 1.7, amp: 0.4, color: _rugEdge);
}

void _bowl(Sketch s) {
  final shadow = Path()..addOval(const Rect.fromLTRB(3.6, 90.6, 19.6, 93.6));
  s.fillArea(shadow, const Color(0x1F33251D), amp: 0.3);
  final body = Path()
    ..moveTo(4.4, 85.4)
    ..lineTo(18.8, 85.4)
    ..lineTo(17, 92.2)
    ..quadraticBezierTo(11.6, 93.4, 6.2, 92.2)
    ..close();
  s.fillArea(body, _bowlRed, amp: 0.3);
  s.ink(body, width: 1.7, amp: 0.3);
  final rim = Path()..addOval(const Rect.fromLTRB(3.4, 83.2, 19.8, 87.4));
  s.fillArea(rim, _bowlRed, amp: 0.25);
  s.ink(rim, width: 1.6, amp: 0.25);
  s.canvas.drawOval(
    const Rect.fromLTRB(5.6, 84.2, 17.6, 86.4),
    Paint()..color = _bowlDark,
  );
  s.dot(const Offset(9.2, 85.3), 0.9, color: _kibble);
  s.dot(const Offset(12.4, 85.7), 0.85, color: _kibble);
  s.dot(const Offset(15, 85.2), 0.8, color: _kibble);
  s.gleam(
    const Offset(9.4, 88.6),
    3.4,
    startDeg: 140,
    sweepDeg: 50,
    width: 1.7,
    color: const Color(0x8CFFFFFF),
  );
  s.dot(const Offset(19.2, 91.6), 0.75, color: _kibble);
}
