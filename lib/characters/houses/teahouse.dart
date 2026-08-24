import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _wall = Color(0xFFEFE3C4);
const _floor = Color(0xFFCCC18E);
const _wood = Color(0xFF6F4B33);
const _woodMid = Color(0xFF8A5F41);
const _kumiko = Color(0x996F4B33);
const _seam = Color(0x66435C39);
const _weave = Color(0x14574F2E);
const _glowPaper = Color(0xFFFAEECB);
const _glowHalo = Color(0x2EF6B84C);
const _glowSoft = Color(0x20F6B84C);
const _lanternHalo = Color(0x2BF6B84C);
const _lanternPaper = Color(0xFFFBE7A9);
const _ribs = Color(0x59684024);
const _glaze = Color(0xFF7E99AD);
const _iron = Color(0xFF6E4B36);
const _ironDark = Color(0xFF5C3D2B);
const _trunk = Color(0xFF5C3B26);
const _canopyGrain = Color(0x4D2E4F29);
const _cushion = Color(0xFFDB8C74);
const _cushionTuft = Color(0x668F4038);
const _scrollPaper = Color(0xFFFDF6E6);

void paintTeahouseHouse(Sketch s) {
  _room(s);
  _window(s);
  _scroll(s);
  _lantern(s);
  _shelfCorner(s);
  _zabuton(s);
}

void _room(Sketch s) {
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 64));
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 62, 102, 102));
  s.fillArea(wall, _wall, amp: 0.35);
  s.fillArea(floor, _floor, amp: 0.35);
  final leftPost = Path()..addRect(const Rect.fromLTRB(-2, 4, 4.5, 62.6));
  final rightPost = Path()..addRect(const Rect.fromLTRB(95.5, 4, 102, 62.6));
  s.fillArea(leftPost, _wood, amp: 0.3);
  s.fillArea(rightPost, _wood, amp: 0.3);
  s.strokeLine(
    const Offset(4.5, 7.5),
    const Offset(4.5, 61.5),
    width: 1.4,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(95.5, 7.5),
    const Offset(95.5, 61.5),
    width: 1.4,
    amp: 0.3,
  );
  final beam = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 7));
  s.fillArea(beam, _wood, amp: 0.3);
  s.strokeLine(const Offset(-1, 7), const Offset(101, 7), width: 1.7, amp: 0.3);
  s.strokeLine(
    const Offset(-1, 62),
    const Offset(101, 62),
    width: 1.8,
    amp: 0.35,
  );
  s.hatch(floor, angleDeg: 0, gap: 6.4, width: 1, color: _weave);
  s.strokeLine(
    const Offset(33, 63.4),
    const Offset(33, 81.2),
    width: 1.4,
    color: _seam,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(67, 63.4),
    const Offset(67, 81.2),
    width: 1.4,
    color: _seam,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(-1, 82),
    const Offset(101, 82),
    width: 1.4,
    color: _seam,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(50, 82.8),
    const Offset(50, 101),
    width: 1.4,
    color: _seam,
    amp: 0.3,
  );
  final pool = Path()
    ..moveTo(37, 62.6)
    ..lineTo(63, 62.6)
    ..lineTo(67.5, 79)
    ..lineTo(32.5, 79)
    ..close();
  s.fillArea(pool, _glowSoft, amp: 0.4);
}

void _window(Sketch s) {
  final halo = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(25.8, 9.8, 74.2, 46.2),
        const Radius.circular(3),
      ),
    );
  s.fillArea(halo, _glowHalo, amp: 0.35);
  final paper = Path()..addRect(const Rect.fromLTRB(28, 12, 72, 44));
  s.fillArea(paper, _glowPaper, amp: 0.25);
  s.dot(const Offset(50, 28), 13, color: _glowSoft);
  for (var i = 1; i < 5; i++) {
    final x = 28 + 8.8 * i;
    s.strokeLine(
      Offset(x, 12.6),
      Offset(x, 43.4),
      width: 1.25,
      color: _kumiko,
      amp: 0.2,
    );
  }
  for (var i = 1; i < 4; i++) {
    final y = 12 + 8.0 * i;
    s.strokeLine(
      Offset(28.6, y),
      Offset(71.4, y),
      width: 1.25,
      color: _kumiko,
      amp: 0.2,
    );
  }
  s.ink(paper, width: 2.2, amp: 0.3);
  s.strokeLine(
    const Offset(26, 45.8),
    const Offset(74, 45.8),
    width: 2,
    color: _wood,
    amp: 0.3,
  );
}

void _scroll(Sketch s) {
  s.strokeLine(
    const Offset(87.7, 7.6),
    const Offset(87.7, 15.4),
    width: 1.1,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(84.3, 15.8),
    const Offset(91.1, 15.8),
    width: 1.9,
    color: _wood,
    amp: 0.2,
  );
  final strip = Path()..addRect(const Rect.fromLTRB(85.1, 16.2, 90.3, 35.4));
  s.fillArea(strip, _scrollPaper, amp: 0.25);
  s.ink(strip, width: 1.3, amp: 0.25);
  s.strokeLine(
    const Offset(84.3, 35.8),
    const Offset(91.1, 35.8),
    width: 1.9,
    color: _wood,
    amp: 0.2,
  );
  s.curve(
    const Offset(87.7, 19.3),
    const Offset(86.6, 23.3),
    const Offset(88.3, 27.3),
    width: 1.4,
    color: Inks.ink,
    amp: 0.3,
  );
  s.dot(const Offset(87.2, 30.2), 0.85, color: Inks.ink);
  s.dot(const Offset(89.2, 33.3), 0.8, color: Inks.rose);
}

void _lantern(Sketch s) {
  final sway = s.live ? math.sin(s.t * 0.8 + 0.7) * 0.045 : 0.0;
  s.canvas.save();
  s.canvas.translate(16.5, 7);
  s.canvas.rotate(sway);
  s.canvas.translate(-16.5, -7);
  s.strokeLine(
    const Offset(16.5, 7.2),
    const Offset(16.5, 11.8),
    width: 1.2,
    amp: 0.25,
  );
  s.dot(const Offset(16.5, 18.5), 9.2, color: _lanternHalo);
  s.strokeLine(
    const Offset(13.8, 12.4),
    const Offset(19.2, 12.4),
    width: 2.8,
    color: _wood,
    amp: 0.2,
  );
  final body = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(11.9, 13.2, 21.1, 24),
        const Radius.circular(4),
      ),
    );
  s.fillArea(body, _lanternPaper, amp: 0.3);
  s.ink(body, width: 1.8, amp: 0.3);
  for (final y in const [15.8, 18.3, 20.8]) {
    s.curve(
      Offset(12.4, y),
      Offset(16.5, y + 1.2),
      Offset(20.6, y),
      width: 1.1,
      color: _ribs,
      amp: 0.2,
    );
  }
  s.strokeLine(
    const Offset(14, 24.6),
    const Offset(19, 24.6),
    width: 2.8,
    color: _wood,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(16.5, 25.9),
    const Offset(16.5, 28.8),
    width: 1.2,
    amp: 0.25,
  );
  s.dot(const Offset(16.5, 29.8), 1.2, color: Inks.rose);
  s.canvas.restore();
}

void _shelfCorner(Sketch s) {
  final board = Path()..addRect(const Rect.fromLTRB(80, 71.4, 100, 74.5));
  s.fillArea(board, _woodMid, amp: 0.3);
  s.ink(board, width: 1.7, amp: 0.3);
  s.strokeLine(
    const Offset(82.8, 74.8),
    const Offset(82.8, 80.7),
    width: 2.8,
    color: _wood,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(97, 74.8),
    const Offset(97, 80.7),
    width: 2.8,
    color: _wood,
    amp: 0.3,
  );
  final pot = Path()
    ..moveTo(89.9, 66.8)
    ..lineTo(97.5, 66.8)
    ..lineTo(96.6, 71.4)
    ..lineTo(90.8, 71.4)
    ..close();
  s.fillArea(pot, _glaze, amp: 0.25);
  s.ink(pot, width: 1.6, amp: 0.25);
  final trunk = Path()
    ..moveTo(93.6, 67.3)
    ..quadraticBezierTo(94.5, 62.7, 92.4, 59);
  s.ink(trunk, width: 2.3, color: _trunk, amp: 0.3);
  s.curve(
    const Offset(93.3, 61.3),
    const Offset(94.7, 60.2),
    const Offset(95.9, 58.6),
    width: 1.6,
    color: _trunk,
    amp: 0.25,
  );
  var canopy = Path()
    ..addOval(Rect.fromCircle(center: const Offset(90.7, 55.4), radius: 4.1));
  for (final puff in const [
    [Offset(95.3, 54.2), 4.4],
    [Offset(92.8, 50.6), 3.6],
  ]) {
    canopy = Path.combine(
      PathOperation.union,
      canopy,
      Path()..addOval(
        Rect.fromCircle(center: puff[0] as Offset, radius: puff[1] as double),
      ),
    );
  }
  s.fillArea(canopy, Inks.leaf);
  s.shade(canopy, lift: const Offset(-1.5, -2), gap: 4);
  s.grain(canopy, dots: 9, color: _canopyGrain, r: 0.7);
  s.ink(canopy, width: 1.8);
  final kettle = Path()
    ..addOval(
      Rect.fromCenter(
        center: const Offset(84.8, 67.7),
        width: 7.4,
        height: 6.2,
      ),
    );
  s.fillArea(kettle, _iron, amp: 0.25);
  s.ink(kettle, width: 1.7, amp: 0.25);
  s.gleam(
    const Offset(83.4, 66.4),
    2.4,
    sweepDeg: 50,
    width: 1.3,
    color: const Color(0x8CFFFFFF),
  );
  s.dot(const Offset(84.8, 64.3), 1.05);
  s.curve(
    const Offset(82.3, 65.2),
    const Offset(84.8, 62),
    const Offset(87.3, 65.2),
    width: 1.5,
    amp: 0.25,
  );
  s.curve(
    const Offset(88, 66.9),
    const Offset(89.7, 66.1),
    const Offset(90.2, 64.7),
    width: 2,
    color: _ironDark,
    amp: 0.2,
  );
  s.dot(const Offset(90.2, 64.6), 1, color: _ironDark);
  s.steam(const Offset(90.2, 63.3), h: 8.5, sway: 2, width: 1.5);
}

void _zabuton(Sketch s) {
  final pad = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(4.5, 87, 18.5, 94.6),
        const Radius.circular(2.6),
      ),
    );
  s.fillArea(pad, _cushion, amp: 0.35);
  s.ink(pad, width: 1.7, amp: 0.35);
  s.strokeLine(
    const Offset(10.4, 89.7),
    const Offset(12.6, 91.5),
    width: 1.1,
    color: _cushionTuft,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(12.6, 89.7),
    const Offset(10.4, 91.5),
    width: 1.1,
    color: _cushionTuft,
    amp: 0.2,
  );
}
