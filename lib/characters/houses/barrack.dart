import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _panel = Color(0xFFC8BDA2);
const _girder = Color(0xFF9F9172);
const _frame = Color(0xFF97896A);
const _seam = Color(0x593F3524);
const _corrugation = Color(0x1A40321F);
const _rivet = Color(0x7333251D);
const _floorWood = Color(0xFFB69C72);
const _plankSeam = Color(0x4D53412B);
const _sky = Color(0xFFF8F1DC);
const _field = Color(0xFFDCC985);
const _flowerWash = Color(0x33D5503F);
const _fieldLine = Color(0x4D8A7A4A);
const _flower = Color(0xFFD5503F);
const _blinkHalo = Color(0x33D5503F);
const _scarfRed = Color(0xFFC7463C);
const _scarfDeep = Color(0xFFA83A32);
const _scarfFold = Color(0x66701F1A);
const _stencil = Color(0xCCB8402F);
const _olive = Color(0xFF7B7852);
const _oliveDark = Color(0xFF5E5C3D);
const _crate = Color(0xFF8A6547);
const _crateLine = Color(0x66513A26);
const _canvas = Color(0xFFD9C89E);
const _canvasCrease = Color(0x59806B42);
const _blanketOlive = Color(0xFF8B885E);
const _strap = Color(0xB354432F);
const _ironDark = Color(0xFF54432F);
const _pool = Color(0x1CF6B84C);
const _grain = Color(0x1233251D);

void paintBarrackHouse(Sketch s) {
  _room(s);
  _window(s);
  _emblem(s);
  _scarf(s);
  _cot(s);
  _radio(s);
}

void _room(Sketch s) {
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 62));
  s.fillArea(wall, _panel, amp: 0.35);
  final panels = Path()..addRect(const Rect.fromLTRB(-2, 7, 102, 61.5));
  s.hatch(panels, angleDeg: 90, gap: 4.6, width: 1.1, color: _corrugation);
  for (final x in const [20.0, 45.0, 70.0, 95.0]) {
    s.strokeLine(
      Offset(x, 8),
      Offset(x, 61),
      width: 1.5,
      color: _seam,
      amp: 0.3,
    );
    for (final y in const [12.0, 26.5, 41.0, 55.5]) {
      s.dot(Offset(x, y), 0.62, color: Inks.inkSoft);
    }
  }
  final girder = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 7));
  s.fillArea(girder, _girder, amp: 0.3);
  s.strokeLine(const Offset(-1, 7), const Offset(101, 7), width: 1.7, amp: 0.3);
  for (var x = 6.0; x <= 98; x += 9.2) {
    s.dot(Offset(x, 4.1), 0.55, color: _rivet);
  }
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 62, 102, 102));
  s.fillArea(floor, _floorWood, amp: 0.35);
  s.strokeLine(
    const Offset(-1, 62.1),
    const Offset(101, 62.1),
    width: 1.8,
    amp: 0.35,
  );
  for (final y in const [75.0, 88.0]) {
    s.strokeLine(
      Offset(-1, y),
      Offset(101, y),
      width: 1.3,
      color: _plankSeam,
      amp: 0.3,
    );
  }
  for (final seg in const [
    [32.0, 62.6, 75.0],
    [68.0, 62.6, 75.0],
    [12.0, 75.5, 88.0],
    [88.0, 75.5, 88.0],
    [50.0, 88.5, 101.0],
  ]) {
    s.strokeLine(
      Offset(seg[0], seg[1]),
      Offset(seg[0], seg[2]),
      width: 1.3,
      color: _plankSeam,
      amp: 0.3,
    );
  }
  final pool = Path()
    ..moveTo(23, 62.6)
    ..lineTo(44, 62.6)
    ..lineTo(49, 80)
    ..lineTo(18, 80)
    ..close();
  s.fillArea(pool, _pool, amp: 0.3);
  s.grain(floor, dots: 16, r: 0.6, color: _grain);
}

void _window(Sketch s) {
  final frame = Path()..addRect(const Rect.fromLTRB(19.5, 10.5, 46.5, 36));
  s.fillArea(frame, _frame, amp: 0.3);
  final view = Path()..addRect(const Rect.fromLTRB(23, 14, 43, 32.5));
  s.fillArea(view, _sky, amp: 0.2);
  final field = Path()..addRect(const Rect.fromLTRB(23, 25.8, 43, 32.5));
  s.fillArea(field, _field, amp: 0.2);
  s.strokeLine(
    const Offset(23.4, 25.8),
    const Offset(42.6, 25.8),
    width: 1.1,
    color: _flower,
    amp: 0.2,
  );
  s.strokeLine(
    const Offset(23.6, 26.8),
    const Offset(42.4, 26.8),
    width: 2,
    color: _flowerWash,
    amp: 0.3,
  );
  for (final f in const [
    Offset(24.6, 25.1),
    Offset(27.8, 25.6),
    Offset(31, 25),
    Offset(34.2, 25.7),
    Offset(37.4, 25.1),
    Offset(40.6, 25.6),
  ]) {
    s.dot(f, 0.55, color: _flower);
  }
  for (final f in const [
    Offset(26.4, 27.9),
    Offset(31.2, 28.2),
    Offset(35.8, 27.8),
    Offset(40, 28.1),
  ]) {
    s.dot(f, 0.4, color: _flower);
  }
  s.strokeLine(
    const Offset(24.4, 28.6),
    const Offset(30.4, 28.4),
    width: 1,
    color: _fieldLine,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(34, 30.4),
    const Offset(41, 30.2),
    width: 1,
    color: _fieldLine,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(25.4, 31.8),
    const Offset(30.6, 31.6),
    width: 1,
    color: _fieldLine,
    amp: 0.25,
  );
  final birdA = Path()
    ..moveTo(27, 17.4)
    ..quadraticBezierTo(27.9, 16.4, 28.8, 17.2)
    ..quadraticBezierTo(29.7, 16.4, 30.6, 17.4);
  s.ink(birdA, width: 1, color: Inks.inkSoft, amp: 0.1);
  final birdB = Path()
    ..moveTo(34.4, 19.6)
    ..quadraticBezierTo(35.1, 18.9, 35.8, 19.5)
    ..quadraticBezierTo(36.5, 18.9, 37.2, 19.6);
  s.ink(birdB, width: 1, color: Inks.inkSoft, amp: 0.1);
  s.ink(view, width: 1.2, amp: 0.2);
  s.ink(frame, width: 1.6, amp: 0.25);
  for (final c in const [
    Offset(20.9, 11.9),
    Offset(45.1, 11.9),
    Offset(20.9, 34.6),
    Offset(45.1, 34.6),
  ]) {
    s.dot(c, 0.6, color: _ironDark);
  }
  s.strokeLine(
    const Offset(18.7, 36.9),
    const Offset(47.3, 36.9),
    width: 2,
    color: _ironDark,
    amp: 0.25,
  );
}

void _emblem(Sketch s) {
  final head = Path()
    ..moveTo(54.6, 23)
    ..lineTo(57.5, 16.6)
    ..lineTo(60.4, 23)
    ..close();
  s.fillArea(head, _stencil, amp: 0.25);
  s.strokeLine(
    const Offset(57.5, 23.4),
    const Offset(57.5, 27.2),
    width: 1.5,
    color: _stencil,
    amp: 0.25,
  );
}

void _scarf(Sketch s) {
  final sway = s.live ? math.sin(s.t * 1.1 + 2) * 0.8 : 0.0;
  final back = Path()
    ..moveTo(77.8, 19.8)
    ..quadraticBezierTo(76.6, 27.5, 76.6 + sway * 0.6, 36.5)
    ..lineTo(80.4 + sway * 0.6, 36.2)
    ..quadraticBezierTo(80.2, 27.5, 80.8, 19.8)
    ..close();
  s.fillArea(back, _scarfDeep, amp: 0.3);
  s.ink(back, width: 1.4, amp: 0.3);
  final front = Path()
    ..moveTo(80.4, 19.6)
    ..quadraticBezierTo(79.6 + sway * 0.5, 30, 80 + sway, 43.5)
    ..lineTo(84.8 + sway, 43.2)
    ..quadraticBezierTo(85.4 + sway * 0.5, 30, 84.8, 19.6)
    ..close();
  s.fillArea(front, _scarfRed, amp: 0.3);
  s.ink(front, width: 1.5, amp: 0.3);
  s.strokeLine(
    Offset(82.2 + sway * 0.6, 23),
    Offset(81.9 + sway * 0.8, 34),
    width: 1,
    color: _scarfFold,
    amp: 0.3,
  );
  final bump = Path()
    ..moveTo(77.4, 20.6)
    ..quadraticBezierTo(76.9, 15.2, 81.1, 14.9)
    ..quadraticBezierTo(85.3, 15.2, 84.9, 20.6)
    ..quadraticBezierTo(81.1, 22.3, 77.4, 20.6)
    ..close();
  s.fillArea(bump, _scarfRed, amp: 0.3);
  s.ink(bump, width: 1.5, amp: 0.3);
  s.curve(
    const Offset(78.4, 19.4),
    const Offset(81.1, 20.8),
    const Offset(83.9, 19.4),
    width: 1,
    color: _scarfFold,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(79.8, 13.2),
    const Offset(82.4, 13.2),
    width: 1.3,
    color: _ironDark,
    amp: 0.2,
  );
  s.dot(const Offset(81.1, 14.3), 1.05, color: _ironDark);
  for (final f in [
    [81.2 + sway, 43.6, 81 + sway, 45.4],
    [83.4 + sway, 43.5, 83.4 + sway, 45.2],
  ]) {
    s.strokeLine(
      Offset(f[0], f[1]),
      Offset(f[2], f[3]),
      width: 1.1,
      color: _scarfDeep,
      amp: 0.15,
    );
  }
}

void _cot(Sketch s) {
  s.curve(
    const Offset(7.4, 47.5),
    const Offset(10.8, 40),
    const Offset(14.2, 47.5),
    width: 2.2,
    color: _ironDark,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(6.6, 79.5),
    const Offset(5.4, 84.2),
    width: 2.2,
    color: _ironDark,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(15, 79.5),
    const Offset(16.2, 84.2),
    width: 2.2,
    color: _ironDark,
    amp: 0.25,
  );
  s.dot(const Offset(5.3, 84.6), 1.1, color: _ironDark);
  s.dot(const Offset(16.3, 84.6), 1.1, color: _ironDark);
  final bundle = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(5, 46.5, 16.6, 80),
        const Radius.circular(3.2),
      ),
    );
  s.fillArea(bundle, _canvas, amp: 0.35);
  s.ink(bundle, width: 1.7, amp: 0.35);
  final blanket = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(5.8, 47.6, 15.8, 54),
        const Radius.circular(2.4),
      ),
    );
  s.fillArea(blanket, _blanketOlive, amp: 0.3);
  s.ink(blanket, width: 1.2, amp: 0.3);
  for (final y in const [59.5, 71.5]) {
    s.strokeLine(
      Offset(5.6, y),
      Offset(16, y),
      width: 1.5,
      color: _strap,
      amp: 0.25,
    );
    s.dot(Offset(13.6, y), 0.75, color: _ironDark);
  }
  s.curve(
    const Offset(7.2, 64.5),
    const Offset(10.8, 65.8),
    const Offset(14.4, 64.5),
    width: 1,
    color: _canvasCrease,
    amp: 0.3,
  );
  s.curve(
    const Offset(7.2, 76),
    const Offset(10.8, 77.2),
    const Offset(14.4, 76),
    width: 1,
    color: _canvasCrease,
    amp: 0.3,
  );
}

void _radio(Sketch s) {
  final crate = Path()..addRect(const Rect.fromLTRB(82, 76, 99, 88.5));
  s.fillArea(crate, _crate, amp: 0.3);
  s.ink(crate, width: 1.7, amp: 0.3);
  s.strokeLine(
    const Offset(82.6, 82.2),
    const Offset(98.4, 82.2),
    width: 1.1,
    color: _crateLine,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(86, 76.6),
    const Offset(86, 88),
    width: 1.1,
    color: _crateLine,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(94.5, 76.6),
    const Offset(94.5, 88),
    width: 1.1,
    color: _crateLine,
    amp: 0.25,
  );
  final sway = s.live ? math.sin(s.t * 1.4 + 0.6) * 0.7 : 0.0;
  s.strokeLine(
    const Offset(96.4, 61.8),
    Offset(97.6 + sway, 43.5),
    width: 1.3,
    amp: 0.25,
  );
  s.dot(Offset(97.6 + sway, 43), 0.8);
  final box = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(83, 62, 98, 76),
        const Radius.circular(1.8),
      ),
    );
  s.fillArea(box, _olive, amp: 0.3);
  s.ink(box, width: 1.8, amp: 0.3);
  s.curve(
    const Offset(86.5, 61.8),
    const Offset(90.5, 58.4),
    const Offset(94.5, 61.8),
    width: 1.7,
    color: _ironDark,
    amp: 0.25,
  );
  for (final y in const [64.8, 66.6, 68.4]) {
    s.strokeLine(
      Offset(85.2, y),
      Offset(90.2, y),
      width: 1,
      color: _oliveDark,
      amp: 0.2,
    );
  }
  s.ring(const Offset(87.2, 71.6), 1.9, width: 1.3, amp: 0.25);
  s.dot(const Offset(87.2, 71.6), 0.55);
  s.ring(const Offset(92.6, 71.6), 1.4, width: 1.2, amp: 0.25);
  s.dot(const Offset(92.6, 71.6), 0.5);
  final on = !s.live || math.sin(s.t * 4.2) > 0.1;
  if (on) {
    s.dot(const Offset(95.3, 65.4), 2.4, color: _blinkHalo);
    s.dot(const Offset(95.3, 65.4), 1.05, color: _flower);
  } else {
    s.dot(const Offset(95.3, 65.4), 0.8, color: Inks.inkSoft);
  }
  s.curve(
    const Offset(83, 75),
    const Offset(80.6, 79.5),
    const Offset(82.6, 84),
    width: 1.2,
    color: _ironDark,
    amp: 0.4,
  );
}
