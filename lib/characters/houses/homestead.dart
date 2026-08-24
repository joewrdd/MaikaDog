import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _wall = Color(0xFFF4E3C0);
const _dome = Color(0xFFE9D2A6);
const _floor = Color(0xFFD0A167);
const _plank = Color(0x4D6E4523);
const _rugEdge = Color(0x8C6E4523);
const _seamFaint = Color(0x2E33251D);
const _trim = Color(0xFF7A4A2E);
const _woodMid = Color(0xFF8A5F41);
const _frame = Color(0xFFB25743);
const _skyPale = Color(0xFFB9D8E6);
const _hillFar = Color(0xFF9CBF74);
const _hillGrain = Color(0x2E2E4F29);
const _glowHalo = Color(0x24F6B84C);
const _glowPool = Color(0x1CF6B84C);
const _gi = Color(0xFFE1893F);
const _giFold = Color(0x408A4A14);
const _belt = Color(0xFF4C6E96);
const _orb = Color(0xFFF3A63E);
const _orbHalo = Color(0x30F6B84C);
const _cushion = Color(0xFFC26350);
const _bowlWhite = Color(0xFFFCF6E8);
const _rug = Color(0xFFDEC489);
const _shadow = Color(0x1A33251D);

void paintHomesteadHouse(Sketch s) {
  _room(s);
  _window(s);
  _shelf(s);
  _giHook(s);
  _stool(s);
  _bowlTower(s);
}

void _room(Sketch s) {
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 62));
  s.fillArea(wall, _wall, amp: 0.35);
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 62, 102, 102));
  s.fillArea(floor, _floor, amp: 0.35);
  final dome = Path()
    ..moveTo(-2, -2)
    ..lineTo(102, -2)
    ..lineTo(102, 14.5)
    ..quadraticBezierTo(50, 4.5, -2, 14.5)
    ..close();
  s.fillArea(dome, _dome, amp: 0.35);
  final domeEdge = Path()
    ..moveTo(-2, 14.5)
    ..quadraticBezierTo(50, 4.5, 102, 14.5);
  s.ink(domeEdge, width: 1.9, amp: 0.35);
  s.curve(
    const Offset(8, 18),
    const Offset(3.8, 39),
    const Offset(7.4, 59.5),
    width: 1.4,
    color: _seamFaint,
    amp: 0.3,
  );
  s.curve(
    const Offset(92, 18),
    const Offset(96.2, 39),
    const Offset(92.6, 59.5),
    width: 1.4,
    color: _seamFaint,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(-1, 62),
    const Offset(101, 62),
    width: 2,
    amp: 0.35,
  );
  s.strokeLine(
    const Offset(-1, 63.9),
    const Offset(101, 63.9),
    width: 1.1,
    color: _plank,
    amp: 0.3,
  );
  for (final y in const [69.0, 77.5, 87.0, 96.0]) {
    s.strokeLine(
      Offset(-1, y),
      Offset(101, y),
      width: 1.1,
      color: _plank,
      amp: 0.3,
    );
  }
  for (final tick in const [
    [Offset(24, 64.4), Offset(24, 68.6)],
    [Offset(76, 64.4), Offset(76, 68.6)],
    [Offset(12, 69.4), Offset(12, 77.1)],
    [Offset(58, 69.4), Offset(58, 77.1)],
    [Offset(88, 77.9), Offset(88, 86.6)],
    [Offset(26, 77.9), Offset(26, 86.6)],
    [Offset(64, 87.4), Offset(64, 95.6)],
    [Offset(16, 96.4), Offset(16, 101)],
    [Offset(84, 96.4), Offset(84, 101)],
  ]) {
    s.strokeLine(tick[0], tick[1], width: 1.1, color: _plank, amp: 0.25);
  }
  final rugOuter = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 80.5), width: 40, height: 12),
    );
  s.fillArea(rugOuter, _rug, amp: 0.45);
  s.ink(rugOuter, width: 1.5, color: _rugEdge, amp: 0.45);
  final rugInner = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(50, 80.5), width: 30.5, height: 8),
    );
  s.ink(rugInner, width: 1.1, color: _plank, amp: 0.4);
  final pool = Path()
    ..moveTo(40, 62.4)
    ..lineTo(60, 62.4)
    ..lineTo(65.5, 76)
    ..lineTo(34.5, 76)
    ..close();
  s.fillArea(pool, _glowPool, amp: 0.4);
}

void _window(Sketch s) {
  s.dot(const Offset(50, 27.5), 19, color: _glowHalo);
  final outer = Path()
    ..addOval(Rect.fromCircle(center: const Offset(50, 27.5), radius: 16.2));
  s.fillArea(outer, _frame, amp: 0.3);
  final inner = Path()
    ..addOval(Rect.fromCircle(center: const Offset(50, 27.5), radius: 13.2));
  s.canvas.save();
  s.canvas.clipPath(inner);
  final sky = Path()..addRect(const Rect.fromLTRB(35, 13, 65, 42));
  s.fillArea(sky, _skyPale, amp: 0.3);
  final farHill = Path()
    ..moveTo(33, 42)
    ..lineTo(33, 33.8)
    ..quadraticBezierTo(39.5, 26.6, 46, 32.8)
    ..quadraticBezierTo(50.5, 36.4, 56, 33)
    ..quadraticBezierTo(62, 27.2, 67, 33.8)
    ..lineTo(67, 42)
    ..close();
  s.fillArea(farHill, _hillFar, amp: 0.3);
  s.strokeLine(
    const Offset(40.5, 31.6),
    const Offset(40.5, 29.6),
    width: 1.1,
    color: _trim,
    amp: 0.2,
  );
  s.dot(const Offset(40.5, 28.4), 1.6, color: Inks.leafDeep);
  final nearHill = Path()
    ..moveTo(33, 42)
    ..lineTo(33, 38.2)
    ..quadraticBezierTo(42, 32.6, 51, 37.6)
    ..quadraticBezierTo(59, 41.8, 67, 38.4)
    ..lineTo(67, 42)
    ..close();
  s.fillArea(nearHill, Inks.leaf, amp: 0.3);
  s.grain(nearHill, dots: 6, color: _hillGrain, r: 0.6);
  s.dot(const Offset(41.5, 17.8), 2.2, color: Inks.cream);
  s.dot(const Offset(44.4, 18.7), 1.7, color: Inks.cream);
  s.dot(const Offset(39, 18.7), 1.5, color: Inks.cream);
  s.curve(
    const Offset(55.4, 19),
    const Offset(56.8, 17.2),
    const Offset(58, 18.8),
    width: 1.2,
    color: Inks.inkSoft,
    amp: 0.15,
  );
  s.curve(
    const Offset(58, 18.8),
    const Offset(59.3, 17.3),
    const Offset(60.4, 18.9),
    width: 1.2,
    color: Inks.inkSoft,
    amp: 0.15,
  );
  s.canvas.restore();
  s.strokeLine(
    const Offset(50, 14.9),
    const Offset(50, 40.1),
    width: 1.9,
    color: _frame,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(37.4, 27.5),
    const Offset(62.6, 27.5),
    width: 1.9,
    color: _frame,
    amp: 0.25,
  );
  s.ring(const Offset(50, 27.5), 13.2, width: 1.6, amp: 0.3);
  s.ring(const Offset(50, 27.5), 16.2, width: 2.1, amp: 0.3);
  s.strokeLine(
    const Offset(41.5, 44.7),
    const Offset(58.5, 44.7),
    width: 2.4,
    color: _trim,
    amp: 0.25,
  );
}

void _shelf(Sketch s) {
  final board = Path()..addRect(const Rect.fromLTRB(5.5, 39, 25.5, 42.2));
  s.fillArea(board, _woodMid, amp: 0.3);
  s.ink(board, width: 1.7, amp: 0.3);
  s.strokeLine(
    const Offset(8.4, 42.5),
    const Offset(8.4, 46.6),
    width: 2.8,
    color: _trim,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(22.6, 42.5),
    const Offset(22.6, 46.6),
    width: 2.8,
    color: _trim,
    amp: 0.3,
  );
  const orbC = Offset(15, 32.2);
  final pulse = s.live ? 0.5 + 0.5 * math.sin(s.t * 1.5) : 0.5;
  s.dot(orbC, 7.4 + 1.6 * pulse, color: _orbHalo);
  final cushion = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(9.2, 36.2, 20.8, 39.4),
        const Radius.circular(2.2),
      ),
    );
  s.fillArea(cushion, _cushion, amp: 0.3);
  s.ink(cushion, width: 1.5, amp: 0.3);
  s.dot(orbC, 4.4, color: _orb);
  s.ring(orbC, 4.4, width: 1.6, amp: 0.25);
  s.gleam(const Offset(14.4, 31.6), 2.8, width: 1.4);
}

void _giHook(Sketch s) {
  final sway = s.live ? math.sin(s.t * 0.7 + 1.1) * 0.03 : 0.0;
  s.canvas.save();
  s.canvas.translate(88, 12.5);
  s.canvas.rotate(sway);
  s.canvas.translate(-88, -12.5);
  s.dot(const Offset(88, 13), 1.5, color: _trim);
  final gi = Path()
    ..moveTo(85.5, 14.6)
    ..quadraticBezierTo(82, 15.4, 79.5, 18.5)
    ..lineTo(77.8, 29.5)
    ..quadraticBezierTo(77.8, 31, 79.3, 30.9)
    ..lineTo(82.8, 30.2)
    ..quadraticBezierTo(83.7, 29.8, 83.8, 27.6)
    ..lineTo(83.8, 24)
    ..lineTo(82.8, 44)
    ..quadraticBezierTo(82.8, 45.5, 84.3, 45.5)
    ..lineTo(92.1, 45.5)
    ..quadraticBezierTo(93.6, 45.5, 93.6, 44)
    ..lineTo(92.6, 24)
    ..lineTo(92.6, 27.6)
    ..quadraticBezierTo(92.7, 29.8, 93.6, 30.2)
    ..lineTo(97.1, 30.9)
    ..quadraticBezierTo(98.6, 31, 98.6, 29.5)
    ..lineTo(96.9, 18.5)
    ..quadraticBezierTo(94.4, 15.4, 90.9, 14.6)
    ..close();
  s.fillArea(gi, _gi, amp: 0.3);
  s.ink(gi, width: 1.9, amp: 0.3);
  final under = Path()
    ..moveTo(86.4, 15.2)
    ..lineTo(90, 15.2)
    ..lineTo(88.2, 20.8)
    ..close();
  s.fillArea(under, _belt, amp: 0.2);
  s.strokeLine(
    const Offset(86.2, 15.2),
    const Offset(88.2, 21),
    width: 1.5,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(90.2, 15.2),
    const Offset(88.2, 21),
    width: 1.5,
    amp: 0.2,
  );
  s.dot(const Offset(86.3, 26.9), 2.3, color: Inks.cream);
  s.ring(const Offset(86.3, 26.9), 2.3, width: 1.2, amp: 0.2);
  final beltBand = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(82.6, 33.3, 93.8, 36.4),
        const Radius.circular(1.4),
      ),
    );
  s.fillArea(beltBand, _belt, amp: 0.25);
  s.ink(beltBand, width: 1.4, amp: 0.25);
  s.strokeLine(
    const Offset(90.7, 36.6),
    const Offset(91.9, 41.6),
    width: 1.9,
    color: _belt,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(88.8, 36.6),
    const Offset(88.4, 40.6),
    width: 1.9,
    color: _belt,
    amp: 0.25,
  );
  for (final fold in const [
    [Offset(85.6, 38.2), Offset(85.4, 43.4)],
    [Offset(91.8, 38.4), Offset(92, 43.5)],
    [Offset(80.6, 20.5), Offset(79.3, 28.4)],
    [Offset(95.8, 20.5), Offset(97.1, 28.4)],
  ]) {
    s.strokeLine(fold[0], fold[1], width: 1, color: _giFold, amp: 0.2);
  }
  s.canvas.restore();
}

void _stool(Sketch s) {
  s.canvas.drawOval(
    Rect.fromCenter(center: const Offset(90.5, 91.2), width: 14, height: 2.8),
    Paint()..color = _shadow,
  );
  s.strokeLine(
    const Offset(85.6, 83.2),
    const Offset(84.8, 90.6),
    width: 2.4,
    color: _trim,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(95.4, 83.2),
    const Offset(96.2, 90.6),
    width: 2.4,
    color: _trim,
    amp: 0.3,
  );
  final top = Path()
    ..addOval(
      Rect.fromCenter(center: const Offset(90.5, 81.5), width: 13, height: 4.6),
    );
  s.fillArea(top, _woodMid, amp: 0.3);
  s.ink(top, width: 1.6, amp: 0.3);
  final cup = Path()
    ..moveTo(87.6, 75.8)
    ..quadraticBezierTo(87.9, 78.9, 88.8, 79.8)
    ..lineTo(92.2, 79.8)
    ..quadraticBezierTo(93.1, 78.9, 93.4, 75.8)
    ..quadraticBezierTo(90.5, 77.1, 87.6, 75.8)
    ..close();
  s.fillArea(cup, _bowlWhite, amp: 0.25);
  s.ink(cup, width: 1.4, amp: 0.25);
  s.curve(
    const Offset(88, 77.6),
    const Offset(90.5, 78.5),
    const Offset(93, 77.6),
    width: 1.3,
    color: _belt,
    amp: 0.2,
  );
  s.steam(const Offset(90.5, 74.6), h: 7.5, sway: 1.8, width: 1.4);
}

void _bowlTower(Sketch s) {
  s.canvas.drawOval(
    Rect.fromCenter(center: const Offset(10.8, 92.2), width: 17, height: 3.4),
    Paint()..color = _shadow,
  );
  for (final rim in const [
    Offset(10.5, 84),
    Offset(11.3, 77),
    Offset(10.1, 70),
    Offset(10.9, 63),
  ]) {
    _bowl(s, rim);
  }
  final rice = Path()
    ..moveTo(6.6, 63)
    ..quadraticBezierTo(7, 59.2, 10.9, 58.7)
    ..quadraticBezierTo(14.8, 59.2, 15.2, 63)
    ..quadraticBezierTo(10.9, 64.6, 6.6, 63)
    ..close();
  s.fillArea(rice, Inks.white, amp: 0.3);
  s.ink(rice, width: 1.5, amp: 0.3);
  s.dot(const Offset(9.4, 61.2), 0.5, color: Inks.inkFaint);
  s.dot(const Offset(12.4, 60.6), 0.5, color: Inks.inkFaint);
  s.strokeLine(
    const Offset(11.6, 60.4),
    const Offset(17.9, 54.2),
    width: 1.15,
    color: _trim,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(10, 59.9),
    const Offset(16.1, 52.7),
    width: 1.15,
    color: _trim,
    amp: 0.2,
  );
}

void _bowl(Sketch s, Offset rim) {
  final cx = rim.dx;
  final y = rim.dy;
  final body = Path()
    ..moveTo(cx - 7.2, y)
    ..quadraticBezierTo(cx - 7.6, y + 5.4, cx - 3.8, y + 7.6)
    ..lineTo(cx + 3.8, y + 7.6)
    ..quadraticBezierTo(cx + 7.6, y + 5.4, cx + 7.2, y)
    ..quadraticBezierTo(cx, y + 2.2, cx - 7.2, y)
    ..close();
  s.fillArea(body, _bowlWhite, amp: 0.3);
  s.ink(body, width: 1.6, amp: 0.3);
  s.curve(
    Offset(cx - 6.8, y + 3),
    Offset(cx, y + 4.9),
    Offset(cx + 6.8, y + 3),
    width: 1.8,
    color: _belt,
    amp: 0.25,
  );
}
