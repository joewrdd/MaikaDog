import 'dart:math' as math;
import 'dart:ui';

import '../core/sketch.dart';

const _logWall = Color(0xFFD8A672);
const _logSeam = Color(0x7A5A3620);
const _logShade = Color(0x1F4A2A14);
const _logShine = Color(0x2EFFE2B8);
const _knot = Color(0x8A5E3A1E);
const _knotFaint = Color(0x3D5E3A1E);
const _floorWood = Color(0xFFB07E4F);
const _plank = Color(0x4D6E4426);
const _beamWood = Color(0xFF6F4B33);
const _beamGrain = Color(0x40331B0E);
const _stone = Color(0xFFC6BBA9);
const _stoneDark = Color(0xFFB1A694);
const _stoneLine = Color(0x66655241);
const _stoneTintDark = Color(0x145E4C38);
const _stoneTintLight = Color(0x1AFFF8E8);
const _mantelShine = Color(0x30FFDFAE);
const _fireboxDark = Color(0xFF35201A);
const _emberBed = Color(0xFF6E2F1F);
const _flameOuter = Color(0xFFE2703A);
const _flameRim = Color(0x7AC2542A);
const _flameCore = Color(0xFFFDEBB2);
const _fireGlow = Color(0x2EF6B84C);
const _paleForest = Color(0xFFD9E6BE);
const _mist = Color(0x66EAF2D2);
const _canopyFar = Color(0x915FA25F);
const _canopyNear = Color(0xE63F7A46);
const _canopyGrain = Color(0x33203D24);
const _bush = Color(0xCC4E8A50);
const _trunkDark = Color(0xFF5C5136);
const _trunkFaint = Color(0x995C5136);
const _shaft = Color(0x1FFFF0C2);
const _frameWood = Color(0xFF7A5236);
const _mullion = Color(0xFF8A5F3E);
const _windowHalo = Color(0x24CFE3A6);
const _windowPool = Color(0x1AE8D89A);
const _logEnd = Color(0xFFE2B37E);
const _fireLogWood = Color(0xFF7A4A2A);
const _pileWood = Color(0xFFC08A56);
const _pileShadow = Color(0x1A33251D);
const _rugBase = Color(0xFFDFC49A);
const _rugRose = Color(0x7AA5563F);
const _rugLeaf = Color(0x66567A46);
const _rugEdge = Color(0x8C5E3A22);
const _darkOutline = Color(0xFF26202B);
const _darkBlade = Color(0xFF5A5A66);
const _darkEdge = Color(0xC8EDEDF2);
const _darkGrip = Color(0xFF2E2A31);
const _darkGuard = Color(0xFF474049);
const _paleBlade = Color(0xFFEFE9DC);
const _paleEdge = Color(0x40808C96);
const _roseGrip = Color(0xFFC66A6C);
const _goldGuard = Color(0xFFD9A648);

void paintCabinHouse(Sketch s) {
  _room(s);
  _window(s);
  _fireplace(s);
  _swords(s);
  _logEnds(s);
  _woodPile(s);
  _rug(s);
  _floorGlow(s);
}

double _flick(Sketch s) =>
    s.live ? 0.5 * math.sin(s.t * 6.3) + 0.5 * math.sin(s.t * 9.1 + 1.7) : 0.0;

void _room(Sketch s) {
  final wall = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 62));
  s.fillArea(wall, _logWall, amp: 0.35);
  final floor = Path()..addRect(const Rect.fromLTRB(-2, 62, 102, 102));
  s.fillArea(floor, _floorWood, amp: 0.35);
  for (final y in const [15.3, 24.6, 33.9, 43.2, 52.5]) {
    s.curve(
      Offset(-1, y - 1.5),
      Offset(50, y - 0.6),
      Offset(101, y - 1.5),
      width: 2.6,
      color: _logShade,
      amp: 0.3,
    );
    s.curve(
      Offset(-1, y),
      Offset(50, y + 0.9),
      Offset(101, y),
      width: 1.7,
      color: _logSeam,
      amp: 0.35,
    );
    s.curve(
      Offset(-1, y + 1.9),
      Offset(50, y + 2.7),
      Offset(101, y + 1.9),
      width: 1.4,
      color: _logShine,
      amp: 0.3,
    );
  }
  s.curve(
    const Offset(-1, 60.6),
    const Offset(50, 61.3),
    const Offset(101, 60.6),
    width: 2.4,
    color: _logShade,
    amp: 0.3,
  );
  for (final k in const [
    Offset(31, 10.6),
    Offset(48, 19.9),
    Offset(26, 38.6),
    Offset(90, 47.9),
    Offset(36, 57.1),
  ]) {
    s.ring(k, 1.5, width: 1.2, color: _knot);
    s.ring(k, 2.6, width: 0.8, color: _knotFaint);
    s.dot(k, 0.55, color: _knot);
  }
  final beam = Path()..addRect(const Rect.fromLTRB(-2, -2, 102, 6.4));
  s.fillArea(beam, _beamWood, amp: 0.3);
  s.strokeLine(
    const Offset(-1, 6.4),
    const Offset(101, 6.4),
    width: 1.8,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(12, 2.2),
    const Offset(44, 2.6),
    width: 1.0,
    color: _beamGrain,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(60, 3.8),
    const Offset(92, 3.4),
    width: 1.0,
    color: _beamGrain,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(-1, 62.2),
    const Offset(101, 62.2),
    width: 1.9,
    amp: 0.35,
  );
  for (final y in const [69.5, 77.5, 85.5, 93.5]) {
    s.curve(
      Offset(-1, y),
      Offset(50, y + 0.7),
      Offset(101, y),
      width: 1.4,
      color: _plank,
      amp: 0.3,
    );
  }
  s.strokeLine(
    const Offset(30, 63),
    const Offset(30, 69.2),
    width: 1.2,
    color: _plank,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(74, 70.2),
    const Offset(74, 77.2),
    width: 1.2,
    color: _plank,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(38, 78.2),
    const Offset(38, 85.2),
    width: 1.2,
    color: _plank,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(64, 86.2),
    const Offset(64, 93.2),
    width: 1.2,
    color: _plank,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(86, 94.2),
    const Offset(86, 101),
    width: 1.2,
    color: _plank,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(21.6, 8),
    const Offset(21.6, 60.5),
    width: 2.6,
    color: _logShade,
    amp: 0.35,
  );
}

void _window(Sketch s) {
  final halo = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(51.6, 9.6, 88.4, 46.4),
        const Radius.circular(3),
      ),
    );
  s.fillArea(halo, _windowHalo, amp: 0.35);
  s.canvas.save();
  s.canvas.clipRect(const Rect.fromLTRB(54, 12, 86, 44));
  final pane = Path()..addRect(const Rect.fromLTRB(53, 11, 87, 45));
  s.fillArea(pane, _paleForest, amp: 0.25);
  final mistBand = Path()..addRect(const Rect.fromLTRB(53, 11, 87, 26));
  s.fillArea(mistBand, _mist, amp: 0.3);
  for (final (c, r) in const [
    (Offset(58, 21), 6.5),
    (Offset(70, 17), 7.5),
    (Offset(82, 22), 6.5),
  ]) {
    final blob = Path()..addOval(Rect.fromCircle(center: c, radius: r));
    s.fillArea(blob, _canopyFar, amp: 0.3);
  }
  s.strokeLine(
    const Offset(61, 44),
    const Offset(60, 21),
    width: 2.0,
    color: _trunkDark,
    amp: 0.35,
  );
  s.strokeLine(
    const Offset(80, 44),
    const Offset(81, 23),
    width: 2.0,
    color: _trunkDark,
    amp: 0.35,
  );
  s.strokeLine(
    const Offset(71.5, 44),
    const Offset(71.5, 30),
    width: 1.1,
    color: _trunkFaint,
    amp: 0.3,
  );
  var canopy = Path()
    ..addOval(Rect.fromCircle(center: const Offset(56, 11.5), radius: 6.5));
  for (final (c, r) in const [
    (Offset(66, 9.5), 7.5),
    (Offset(78, 10.5), 7.0),
    (Offset(87, 13), 6.0),
  ]) {
    canopy = Path.combine(
      PathOperation.union,
      canopy,
      Path()..addOval(Rect.fromCircle(center: c, radius: r)),
    );
  }
  s.fillArea(canopy, _canopyNear, amp: 0.3);
  s.grain(canopy, dots: 8, color: _canopyGrain, r: 0.6);
  var bush = Path()
    ..addOval(Rect.fromCircle(center: const Offset(55, 46), radius: 5.5));
  for (final (c, r) in const [(Offset(74, 47), 6.5), (Offset(87, 45.5), 5.5)]) {
    bush = Path.combine(
      PathOperation.union,
      bush,
      Path()..addOval(Rect.fromCircle(center: c, radius: r)),
    );
  }
  s.fillArea(bush, _bush, amp: 0.3);
  s.strokeLine(
    const Offset(65, 11.5),
    const Offset(59, 44.5),
    width: 4,
    color: _shaft,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(77, 11.5),
    const Offset(71, 44.5),
    width: 3,
    color: _shaft,
    amp: 0.3,
  );
  s.canvas.restore();
  s.strokeLine(
    const Offset(70, 12.4),
    const Offset(70, 43.6),
    width: 2.6,
    color: _mullion,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(54.4, 28),
    const Offset(85.6, 28),
    width: 2.6,
    color: _mullion,
    amp: 0.25,
  );
  final frame = Path()..addRect(const Rect.fromLTRB(52.9, 10.9, 87.1, 45.1));
  s.ink(frame, width: 3.0, color: _frameWood, amp: 0.3);
  final inner = Path()..addRect(const Rect.fromLTRB(54, 12, 86, 44));
  s.ink(inner, width: 2.0, amp: 0.3);
  s.strokeLine(
    const Offset(51.6, 46.8),
    const Offset(88.4, 46.8),
    width: 2.6,
    color: _frameWood,
    amp: 0.3,
  );
  s.strokeLine(
    const Offset(52.4, 48.3),
    const Offset(87.6, 48.3),
    width: 1.1,
    color: Inks.inkSoft,
    amp: 0.3,
  );
}

void _fireplace(Sketch s) {
  final f = _flick(s);
  final f2 = s.live ? math.sin(s.t * 7.9 + 0.8) : 0.0;
  final breast = Path()..addRect(const Rect.fromLTRB(-2, -2, 20, 71));
  s.fillArea(breast, _stone, amp: 0.3);
  s.strokeLine(
    const Offset(20, -1),
    const Offset(20, 70.5),
    width: 2.0,
    amp: 0.4,
  );
  for (var row = 0; row < 6; row++) {
    final top = -2.0 + row * 7.8 + 0.5;
    final bottom = -2.0 + (row + 1) * 7.8 - 0.5;
    final joint = row.isEven ? 8.6 : 12.2;
    final slabs = [
      Rect.fromLTRB(-2, top, joint - 0.6, bottom),
      Rect.fromLTRB(joint + 0.6, top, 19.2, bottom),
    ];
    for (var i = 0; i < slabs.length; i++) {
      final stone = Path()
        ..addRRect(
          RRect.fromRectAndRadius(slabs[i], const Radius.circular(2.4)),
        );
      final tint = (row + i) % 3;
      if (tint == 0) s.fillArea(stone, _stoneTintDark, amp: 0.25);
      if (tint == 2) s.fillArea(stone, _stoneTintLight, amp: 0.25);
      s.ink(stone, width: 1.4, color: _stoneLine, amp: 0.3);
    }
  }
  for (final r in const [
    Rect.fromLTRB(-2, 49.0, 2.8, 55.8),
    Rect.fromLTRB(-2, 56.8, 2.6, 63.4),
    Rect.fromLTRB(-2, 64.2, 2.8, 70.6),
    Rect.fromLTRB(17.2, 49.0, 20, 55.8),
    Rect.fromLTRB(17.4, 56.8, 20, 63.4),
    Rect.fromLTRB(17.2, 64.2, 20, 70.6),
  ]) {
    final side = Path()
      ..addRRect(RRect.fromRectAndRadius(r, const Radius.circular(1.8)));
    s.ink(side, width: 1.3, color: _stoneLine, amp: 0.25);
  }
  final mantel = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(-2, 43.2, 23.6, 48.2),
        const Radius.circular(1.3),
      ),
    );
  s.fillArea(mantel, _beamWood, amp: 0.25);
  s.ink(mantel, width: 1.8, amp: 0.3);
  s.strokeLine(
    const Offset(-1, 44.3),
    const Offset(22.4, 44.3),
    width: 0.9,
    color: _mantelShine,
    amp: 0.25,
  );
  final box = Path()
    ..addRRect(
      RRect.fromRectAndCorners(
        const Rect.fromLTRB(3.2, 49.6, 16.8, 71),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      ),
    );
  s.fillArea(box, _fireboxDark, amp: 0.25);
  s.ink(box, width: 1.8, amp: 0.3);
  s.dot(const Offset(10, 60), 9.0 * (1 + 0.05 * f), color: _fireGlow);
  final bed = Path()
    ..moveTo(4.6, 70.2)
    ..quadraticBezierTo(10, 67.6, 15.4, 70.2)
    ..lineTo(15.4, 70.8)
    ..lineTo(4.6, 70.8)
    ..close();
  s.fillArea(bed, _emberBed, amp: 0.25);
  s.strokeLine(
    const Offset(5.2, 68.9),
    const Offset(14.8, 67.3),
    width: 2.4,
    color: _fireLogWood,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(5.2, 67.1),
    const Offset(14.8, 68.9),
    width: 2.4,
    color: _fireLogWood,
    amp: 0.25,
  );
  final lean = s.live ? math.sin(s.t * 3.7) * 1.1 : 0.0;
  _flame(
    s,
    const Offset(10, 68.6),
    9.6,
    13.5 * (1 + 0.13 * f),
    lean,
    _flameOuter,
    rim: true,
  );
  _flame(
    s,
    const Offset(10, 68.4),
    6.6,
    9.6 * (1 + 0.16 * f2),
    lean * 0.8,
    Inks.sun,
  );
  _flame(
    s,
    const Offset(10, 68.2),
    3.8,
    5.6 * (1 + 0.2 * f),
    lean * 0.55,
    _flameCore,
  );
  for (var i = 0; i < 3; i++) {
    final ex = const [6.8, 10.2, 13.4][i];
    final glowA = s.live ? 0.55 + 0.3 * math.sin(s.t * 4.6 + i * 2.1) : 0.7;
    s.dot(
      Offset(ex, 69.3),
      0.8,
      color: Inks.sun.withValues(alpha: glowA.clamp(0.0, 1.0)),
    );
  }
  if (s.live) {
    for (var i = 0; i < 2; i++) {
      final ph = (s.t * 0.5 + i * 0.47) % 1.0;
      final sx = 10 + math.sin(ph * 8 + i * 3.1) * 2.2;
      final sy = 65.5 - ph * 13;
      s.dot(
        Offset(sx, sy),
        0.75 * (1 - ph * 0.5),
        color: Inks.sun.withValues(alpha: 0.85 * (1 - ph)),
      );
    }
  }
  final hearth = Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(-2, 71, 22.4, 79.4),
        const Radius.circular(1.6),
      ),
    );
  s.fillArea(hearth, _stoneDark, amp: 0.3);
  s.ink(hearth, width: 1.8, amp: 0.35);
  s.strokeLine(
    const Offset(7.2, 72),
    const Offset(6.6, 78.6),
    width: 1.1,
    color: _stoneLine,
    amp: 0.25,
  );
  s.strokeLine(
    const Offset(14.8, 72),
    const Offset(15.4, 78.6),
    width: 1.1,
    color: _stoneLine,
    amp: 0.25,
  );
}

void _flame(
  Sketch s,
  Offset base,
  double w,
  double h,
  double lean,
  Color color, {
  bool rim = false,
}) {
  final path = Path()
    ..moveTo(base.dx - w / 2, base.dy)
    ..quadraticBezierTo(
      base.dx - w * 0.66,
      base.dy - h * 0.52,
      base.dx + lean - w * 0.08,
      base.dy - h,
    )
    ..quadraticBezierTo(
      base.dx + w * 0.66 + lean * 0.4,
      base.dy - h * 0.48,
      base.dx + w / 2,
      base.dy,
    )
    ..close();
  s.fillArea(path, color, amp: 0.3);
  if (rim) s.ink(path, width: 1.2, color: _flameRim, amp: 0.3);
}

void _swords(Sketch s) {
  _sword(
    s,
    const Offset(2.8, 41.2),
    const Offset(17.2, 12.8),
    _darkOutline,
    _darkBlade,
    _darkEdge,
    _darkGrip,
    _darkGuard,
  );
  _sword(
    s,
    const Offset(17.2, 41.2),
    const Offset(2.8, 12.8),
    Inks.ink,
    _paleBlade,
    _paleEdge,
    _roseGrip,
    _goldGuard,
  );
}

void _sword(
  Sketch s,
  Offset hilt,
  Offset tip,
  Color outline,
  Color blade,
  Color edge,
  Color grip,
  Color guard,
) {
  final delta = tip - hilt;
  final len = delta.distance;
  final u = delta / len;
  final n = Offset(-u.dy, u.dx);
  final guardAt = hilt + u * (len * 0.22);
  final bladeFrom = guardAt + u * 0.6;
  final bladeLen = (tip - bladeFrom).distance;
  final shoulder = bladeFrom + u * (bladeLen * 0.8);
  final bladePath = Path()
    ..moveTo(bladeFrom.dx - n.dx * 1.5, bladeFrom.dy - n.dy * 1.5)
    ..lineTo(shoulder.dx - n.dx * 1.25, shoulder.dy - n.dy * 1.25)
    ..lineTo(tip.dx, tip.dy)
    ..lineTo(shoulder.dx + n.dx * 1.25, shoulder.dy + n.dy * 1.25)
    ..lineTo(bladeFrom.dx + n.dx * 1.5, bladeFrom.dy + n.dy * 1.5)
    ..close();
  s.fillArea(bladePath, blade, amp: 0.2);
  s.ink(bladePath, width: 1.3, color: outline, amp: 0.2);
  s.strokeLine(
    bladeFrom + u * 1.2 + n * 0.55,
    tip - u * 3.0 + n * 0.4,
    width: 0.85,
    color: edge,
    amp: 0.15,
  );
  s.strokeLine(
    guardAt - n * 3.2,
    guardAt + n * 3.2,
    width: 3.4,
    color: outline,
    amp: 0.2,
  );
  s.strokeLine(
    guardAt - n * 2.9,
    guardAt + n * 2.9,
    width: 2.2,
    color: guard,
    amp: 0.2,
  );
  s.strokeLine(
    hilt + u * 0.2,
    guardAt - u * 0.6,
    width: 3.4,
    color: outline,
    amp: 0.2,
  );
  s.strokeLine(
    hilt + u * 0.5,
    guardAt - u * 0.8,
    width: 2.2,
    color: grip,
    amp: 0.2,
  );
  s.dot(hilt, 1.6, color: outline);
  s.dot(hilt, 1.1, color: guard);
}

void _logEnds(Sketch s) {
  s.strokeLine(
    const Offset(93.2, 7.2),
    const Offset(93.2, 61.4),
    width: 2.2,
    color: _logShade,
    amp: 0.35,
  );
  for (final y in const [10.65, 19.95, 29.25, 38.55, 47.85, 57.15]) {
    final c = Offset(97.6, y);
    final disc = Path()..addOval(Rect.fromCircle(center: c, radius: 3.9));
    s.fillArea(disc, _logEnd, amp: 0.3);
    s.ink(disc, width: 1.6, amp: 0.3);
    s.ring(c, 2.1, width: 0.9, color: _knot);
    s.dot(c, 0.6, color: _knot);
  }
}

void _woodPile(Sketch s) {
  final shadow = Path()..addOval(const Rect.fromLTRB(84.4, 77.6, 99.6, 80.8));
  s.fillArea(shadow, _pileShadow, amp: 0.3);
  for (final c in const [
    Offset(88.9, 75.6),
    Offset(95.4, 75.6),
    Offset(92.1, 70.1),
  ]) {
    final log = Path()..addOval(Rect.fromCircle(center: c, radius: 3.3));
    s.fillArea(log, _pileWood, amp: 0.3);
    s.ink(log, width: 1.6, amp: 0.3);
    s.ring(c, 1.7, width: 0.8, color: _knot);
    s.dot(c, 0.5, color: _knot);
  }
}

void _rug(Sketch s) {
  final base = Path()..addOval(const Rect.fromLTRB(29, 77.4, 71, 91.8));
  s.fillArea(base, _rugBase, amp: 0.4);
  s.ink(base, width: 1.8, color: _rugEdge, amp: 0.4);
  final mid = Path()..addOval(const Rect.fromLTRB(33.6, 79.2, 66.4, 90.0));
  s.ink(mid, width: 1.6, color: _rugRose, amp: 0.4);
  final inner = Path()..addOval(const Rect.fromLTRB(38.4, 81.2, 61.6, 88.2));
  s.ink(inner, width: 1.6, color: _rugLeaf, amp: 0.4);
}

void _floorGlow(Sketch s) {
  final f = _flick(s);
  final warmA = 0.12 + 0.025 * f;
  final pool = Path()..addOval(const Rect.fromLTRB(14, 64.5, 42, 78.5));
  s.fillArea(pool, _flameOuter.withValues(alpha: warmA), amp: 0.4);
  final pool2 = Path()..addOval(const Rect.fromLTRB(18, 66, 32, 75));
  s.fillArea(pool2, Inks.sun.withValues(alpha: warmA * 0.9), amp: 0.4);
  final sunPatch = Path()
    ..moveTo(58, 63.4)
    ..lineTo(82, 63.4)
    ..lineTo(85.5, 73.8)
    ..lineTo(54.5, 73.8)
    ..close();
  s.fillArea(sunPatch, _windowPool, amp: 0.35);
}
