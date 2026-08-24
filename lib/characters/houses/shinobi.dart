import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _wall = Color(0xFF67523A);
const _stalk = Color(0xFF75603F);
const _seam = Color(0x66311F0F);
const _nodeShine = Color(0x33FFE3BC);
const _beam = Color(0xFF4B3423);
const _floor = Color(0xFF7E5C3E);
const _plank = Color(0x4D33251D);
const _glowHalo = Color(0x30DA5A4B);
const _glowCore = Color(0x38E06A50);
const _glowHot = Color(0x4FE4664A);
const _glowPool = Color(0x2ADA5A4B);
const _windowPaper = Color(0xFFEFD0A9);
const _muntin = Color(0xB84E3320);
const _board = Color(0xFFAD8B5A);
const _boardNail = Color(0x8833251D);
const _metal = Color(0xFF3C2E24);
const _bladeSteel = Color(0xFF9A948C);
const _edgeShine = Color(0x66FFFFFF);
const _paperStrip = Color(0xFFF7EBD1);
const _sealRed = Color(0xFFCE4B41);
const _vaseGlaze = Color(0xFF74889A);
const _vaseBand = Color(0x593A4C5C);

void paintShinobiHouse(Sketch s) {
  _room(s);
  _window(s);
  _rack(s);
  _talisman(s);
  _flowerVase(s);
}

void _room(Sketch s) {
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 63));
  s.fillArea(wall, _wall, amp: 0.35);
  for (var i = 0; i < 17; i++) {
    final left = -2.0 + i * 6.2;
    if (i.isOdd) {
      final band = Path()..addRect(Rect.fromLTRB(left, 6.2, left + 6.2, 60.4));
      s.fillArea(band, _stalk, amp: 0.3);
    }
    if (i > 0) {
      s.strokeLine(
        Offset(left, 7.6),
        Offset(left, 59.4),
        width: 1.3,
        color: _seam,
        amp: 0.35,
      );
    }
    final nodeA = 12.0 + (i * 7) % 36;
    final nodeB = 16.0 + (i * 13) % 38;
    for (final y in [nodeA, nodeB]) {
      s.strokeLine(
        Offset(left + 0.9, y),
        Offset(left + 5.3, y),
        width: 1.3,
        color: _seam,
        amp: 0.25,
      );
      s.strokeLine(
        Offset(left + 0.9, y - 1.1),
        Offset(left + 5.3, y - 1.1),
        width: 1,
        color: _nodeShine,
        amp: 0.25,
      );
    }
  }
  final beam = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 7));
  s.fillArea(beam, _beam, amp: 0.3);
  s.strokeLine(const Offset(-1, 7), const Offset(101, 7), width: 1.7, amp: 0.3);
  final base = Path()..addRect(const Rect.fromLTRB(-2, 58.8, 102, 63));
  s.fillArea(base, _beam, amp: 0.3);
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 62.4, 102, 102));
  s.fillArea(floor, _floor, amp: 0.35);
  s.strokeLine(
    const Offset(-1, 62.6),
    const Offset(101, 62.6),
    width: 1.8,
    amp: 0.35,
  );
  s.strokeLine(
    const Offset(-1, 75),
    const Offset(101, 75),
    width: 1.3,
    color: _plank,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(-1, 88),
    const Offset(101, 88),
    width: 1.3,
    color: _plank,
    amp: 0.3,
  );
  for (final j in const [
    [30.0, 63.4, 74.4],
    [72.0, 63.4, 74.4],
    [14.0, 75.6, 87.4],
    [52.0, 75.6, 87.4],
    [88.0, 75.6, 87.4],
    [36.0, 88.6, 101.0],
    [66.0, 88.6, 101.0],
  ]) {
    s.strokeLine(
      Offset(j[0], j[1]),
      Offset(j[0], j[2]),
      width: 1.2,
      color: _plank,
      amp: 0.25,
    );
  }
  final pool = Path()
    ..moveTo(40, 63.2)
    ..lineTo(60, 63.2)
    ..lineTo(67, 82)
    ..lineTo(33, 82)
    ..close();
  s.fillArea(pool, _glowPool, amp: 0.4);
}

void _window(Sketch s) {
  const c = Offset(50, 29);
  final pulse = s.live ? math.sin(s.t * 1.5) : 0.0;
  s.dot(c, 20 + pulse * 0.7, color: _glowHalo);
  final paper = Path()..addOval(Rect.fromCircle(center: c, radius: 15));
  s.fillArea(paper, _windowPaper, amp: 0.25);
  s.dot(c, 11 + pulse * 0.6, color: _glowCore);
  s.dot(c, 6.5 + pulse * 0.5, color: _glowHot);
  for (final d in const [-6.0, 0.0, 6.0]) {
    final half = math.sqrt(14.2 * 14.2 - d * d);
    s.strokeLine(
      Offset(c.dx + d, c.dy - half),
      Offset(c.dx + d, c.dy + half),
      width: 1.25,
      color: _muntin,
      amp: 0.2,
    );
    s.strokeLine(
      Offset(c.dx - half, c.dy + d),
      Offset(c.dx + half, c.dy + d),
      width: 1.25,
      color: _muntin,
      amp: 0.2,
    );
  }
  s.ink(paper, width: 2, amp: 0.3);
  s.ring(c, 16.5, width: 2.6, color: _beam, amp: 0.35);
}

void _rack(Sketch s) {
  final board = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(7, 16, 25.5, 38.4),
        const Radius.circular(1.8),
      ),
    );
  s.fillArea(board, _board, amp: 0.3);
  s.ink(board, width: 1.8, amp: 0.3);
  for (final nail in const [
    Offset(8.9, 17.9),
    Offset(23.6, 17.9),
    Offset(8.9, 36.5),
    Offset(23.6, 36.5),
  ]) {
    s.dot(nail, 0.55, color: _boardNail);
  }
  s.strokeLine(
    const Offset(8.6, 21.4),
    const Offset(23.9, 21.4),
    width: 2.2,
    color: _beam,
    amp: 0.25,
  );
  _kunai(s, 11, -0.06);
  _kunai(s, 16.25, 0.02);
  _kunai(s, 21.5, 0.05);
}

void _kunai(Sketch s, double x, double tilt) {
  final pivot = Offset(x, 20.7);
  s.canvas.save();
  s.canvas.translate(pivot.dx, pivot.dy);
  s.canvas.rotate(tilt);
  s.canvas.translate(-pivot.dx, -pivot.dy);
  s.ring(pivot, 1.5, width: 1.5, color: _metal, amp: 0.2);
  s.strokeLine(
    Offset(x, 22.2),
    Offset(x, 25.2),
    width: 2,
    color: _metal,
    amp: 0.2,
  );
  final blade = Path()
    ..moveTo(x, 24.8)
    ..lineTo(x - 2.25, 27.3)
    ..lineTo(x, 36.6)
    ..lineTo(x + 2.25, 27.3)
    ..close();
  s.fillArea(blade, _bladeSteel, amp: 0.2);
  s.ink(blade, width: 1.4, color: _metal, amp: 0.2);
  s.strokeLine(
    Offset(x + 0.55, 27.8),
    Offset(x + 0.55, 32.4),
    width: 0.9,
    color: _edgeShine,
    amp: 0.15,
  );
  s.canvas.restore();
}

void _talisman(Sketch s) {
  const nail = Offset(84, 10.6);
  final sway = s.live ? math.sin(s.t * 0.9 + 1.1) * 0.055 : 0.0;
  s.dot(nail, 0.95);
  s.canvas.save();
  s.canvas.translate(nail.dx, nail.dy);
  s.canvas.rotate(sway);
  s.canvas.translate(-nail.dx, -nail.dy);
  s.strokeLine(nail, const Offset(84, 13.2), width: 1.1, amp: 0.2);
  final strip = Path()
    ..moveTo(80.3, 13.2)
    ..lineTo(87.9, 13.2)
    ..lineTo(87.9, 33.2)
    ..lineTo(84.1, 35.5)
    ..lineTo(80.3, 33.2)
    ..close();
  s.fillArea(strip, _paperStrip, amp: 0.25);
  s.ink(strip, width: 1.4, amp: 0.25);
  s.strokeLine(
    const Offset(84.1, 16.6),
    const Offset(84.1, 26.2),
    width: 1.9,
    amp: 0.25,
  );
  s.curve(
    const Offset(84.1, 26.2),
    const Offset(83.4, 28.2),
    const Offset(82.3, 28.7),
    width: 1.5,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(82.2, 19.4),
    const Offset(86, 19.4),
    width: 1.25,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(82.5, 22.6),
    const Offset(85.7, 22.6),
    width: 1.25,
    amp: 0.2,
  );
  s.dot(const Offset(84.1, 31.3), 1.25, color: _sealRed);
  s.canvas.restore();
}

void _flowerVase(Sketch s) {
  final body = Path()
    ..moveTo(86.7, 78.2)
    ..lineTo(90.9, 78.2)
    ..cubicTo(93.6, 80.4, 93.4, 86.4, 91.1, 89.8)
    ..lineTo(86.5, 89.8)
    ..cubicTo(84.2, 86.4, 84, 80.4, 86.7, 78.2)
    ..close();
  s.fillArea(body, _vaseGlaze, amp: 0.25);
  s.ink(body, width: 1.6, amp: 0.25);
  s.curve(
    const Offset(85.6, 80.6),
    const Offset(88.8, 81.6),
    const Offset(92, 80.6),
    width: 1.1,
    color: _vaseBand,
    amp: 0.2,
  );
  s.gleam(
    const Offset(87.4, 82.4),
    2.3,
    sweepDeg: 45,
    width: 1.2,
    color: const Color(0x73FFFFFF),
  );
  s.curve(
    const Offset(88.2, 78.4),
    const Offset(85, 73.4),
    const Offset(84.6, 68.9),
    width: 1.5,
    color: Inks.leafDeep,
    amp: 0.3,
  );
  s.curve(
    const Offset(88.8, 78.4),
    const Offset(89.7, 71.4),
    const Offset(89.3, 65.4),
    width: 1.5,
    color: Inks.leafDeep,
    amp: 0.3,
  );
  s.curve(
    const Offset(89.3, 78.4),
    const Offset(92.7, 74.4),
    const Offset(93.3, 70.1),
    width: 1.5,
    color: Inks.leafDeep,
    amp: 0.3,
  );
  s.curve(
    const Offset(87.2, 75.2),
    const Offset(85.4, 74.2),
    const Offset(84.2, 72.2),
    width: 2.4,
    color: Inks.leaf,
    amp: 0.25,
  );
  s.curve(
    const Offset(90.8, 74),
    const Offset(92.4, 73.2),
    const Offset(93.6, 71.4),
    width: 2.4,
    color: Inks.leaf,
    amp: 0.25,
  );
  _blossom(s, const Offset(84.5, 67.8), 1.25);
  _blossom(s, const Offset(89.3, 64.2), 1.35);
  _blossom(s, const Offset(93.3, 69.1), 1.15);
}

void _blossom(Sketch s, Offset c, double k) {
  for (var i = 0; i < 5; i++) {
    final a = -90 + i * 72.0;
    s.dot(s.polar(c, a, 1.55 * k), 1.18 * k, color: Inks.white);
  }
  s.dot(c, 0.92 * k, color: Inks.sun);
}
