import 'dart:math' as math;
import 'dart:ui';

enum CharacterMood { signature, joy, yum, sleepy, hype }

extension CharacterMoodInfo on CharacterMood {
  String get label => switch (this) {
    CharacterMood.signature => 'Signature',
    CharacterMood.joy => 'Joy',
    CharacterMood.yum => 'Yum',
    CharacterMood.sleepy => 'Sleepy',
    CharacterMood.hype => 'Hype',
  };
}

abstract final class Inks {
  static const ink = Color(0xFF33251D);
  static const inkSoft = Color(0x8C33251D);
  static const inkFaint = Color(0x4033251D);
  static const paper = Color(0xFFFFF6E9);
  static const cream = Color(0xFFFFFDF6);
  static const white = Color(0xFFFFFFFF);
  static const blush = Color(0xFFF08A70);
  static const rose = Color(0xFFE8607A);
  static const sun = Color(0xFFF6B84C);
  static const leaf = Color(0xFF5FA25F);
  static const leafDeep = Color(0xFF3F7A46);
  static const sky = Color(0xFF7FB5D8);
  static const tongue = Color(0xFFEF8E7D);
  static const mouthFill = Color(0xFF7C3B33);
}

class MoodPose {
  const MoodPose({
    this.dx = 0,
    this.dy = 0,
    this.rot = 0,
    this.sx = 1,
    this.sy = 1,
  });

  final double dx;
  final double dy;
  final double rot;
  final double sx;
  final double sy;

  static MoodPose of(CharacterMood mood) => switch (mood) {
    CharacterMood.signature => const MoodPose(),
    CharacterMood.joy => const MoodPose(dy: -2, sx: 0.98, sy: 1.04),
    CharacterMood.yum => const MoodPose(rot: 0.05, sy: 0.99),
    CharacterMood.sleepy => const MoodPose(
      dy: 2.2,
      rot: -0.04,
      sx: 1.05,
      sy: 0.92,
    ),
    CharacterMood.hype => const MoodPose(dy: -1, rot: 0.09, sy: 1.03),
  };
}

enum PerformanceStyle { hop, spin, dash, shake, float, wobble, bow, pop }

class MotionProfile {
  const MotionProfile({
    this.tempo = 1,
    this.bounce = 1,
    this.style = PerformanceStyle.hop,
  });

  final double tempo;
  final double bounce;
  final PerformanceStyle style;
}

class PerfPose {
  const PerfPose({
    this.dx = 0,
    this.dy = 0,
    this.rot = 0,
    this.sx = 1,
    this.sy = 1,
    this.lift = 0,
  });

  final double dx;
  final double dy;
  final double rot;
  final double sx;
  final double sy;
  final double lift;
}

double bell(double x) => math.sin(math.pi * x.clamp(0.0, 1.0));

double easeOutBack(double x) {
  const c1 = 1.70158;
  const c3 = c1 + 1;
  final v = x.clamp(0.0, 1.0) - 1;
  return 1 + c3 * v * v * v + c1 * v * v;
}

class Sketch {
  Sketch(
    this.canvas,
    int seed, {
    this.time,
    this.motion = const MotionProfile(),
    this.perf,
    this.lean = 0,
    this.walk,
    this.stretch = 0,
    this.turn = 0,
    this.bark,
  }) : _rng = math.Random(
         time == null ? seed : seed + 9973 * (time * 7).floor(),
       ),
       _phase = (seed % 997) / 997 * 2 * math.pi;

  final Canvas canvas;
  final math.Random _rng;
  final double? time;
  final MotionProfile motion;
  final double? perf;
  final double lean;
  final double? walk;
  final double stretch;
  final double turn;
  final double? bark;

  bool get barking => bark != null;

  double get barkT => (bark ?? 0).clamp(0.0, 1.0);

  bool get walking => walk != null;

  double get gait => walk ?? 0;
  final double _phase;

  bool get live => time != null;

  double get t => time ?? 0;

  bool get performing => perf != null;

  double get perfT => (perf ?? 0).clamp(0.0, 1.0);

  double get breath =>
      live ? math.sin(t * 2 * math.pi / 3.1 * motion.tempo + _phase) : 0;

  bool get blinkNow =>
      live && ((t * motion.tempo / 3.4 + _phase / (2 * math.pi)) % 1) > 0.93;

  PerfPose get perfPose {
    if (!performing) return const PerfPose();
    final p = perfT;
    final k = motion.bounce;
    switch (motion.style) {
      case PerformanceStyle.hop:
        if (p < 0.16) {
          final a = p / 0.16;
          return PerfPose(
            sy: 1 - 0.10 * k * bell(a),
            sx: 1 + 0.07 * k * bell(a),
          );
        }
        if (p < 0.62) {
          final a = (p - 0.16) / 0.46;
          final rise = bell(a);
          return PerfPose(
            dy: -13 * k * rise,
            sy: 1 + 0.09 * k * rise,
            sx: 1 - 0.06 * k * rise,
            lift: rise,
          );
        }
        final a = (p - 0.62) / 0.38;
        return PerfPose(
          sy: 1 - 0.11 * k * bell(a) * (1 - a * 0.5),
          sx: 1 + 0.08 * k * bell(a) * (1 - a * 0.5),
        );
      case PerformanceStyle.spin:
        final turn = easeOutBack(p) * 2 * math.pi;
        return PerfPose(rot: turn, dy: -6 * k * bell(p), lift: bell(p) * 0.5);
      case PerformanceStyle.dash:
        final swing = math.sin(2 * math.pi * p) * (1 - p * 0.25);
        return PerfPose(dx: 12 * swing, rot: 0.14 * swing);
      case PerformanceStyle.shake:
        final decay = (1 - p) * (1 - p);
        final rattle = math.sin(p * 11 * math.pi) * decay;
        return PerfPose(dx: 4.6 * k * rattle, rot: 0.07 * rattle);
      case PerformanceStyle.float:
        final rise = bell(p);
        return PerfPose(
          dy: -9 * rise,
          rot: 0.08 * math.sin(2 * math.pi * p),
          lift: rise,
        );
      case PerformanceStyle.wobble:
        final decay = math.pow(1 - p, 1.2).toDouble();
        return PerfPose(
          rot: 0.26 * k * math.sin(p * 6 * math.pi) * decay,
          sy: 1 + 0.05 * k * math.sin(p * 6 * math.pi + 1.2) * decay,
        );
      case PerformanceStyle.bow:
        final lean = math.sin(math.pi * (p / 0.75).clamp(0.0, 1.0));
        return PerfPose(rot: 0.30 * lean, dy: 1.6 * lean);
      case PerformanceStyle.pop:
        final swell = bell(p) * (p < 0.5 ? 1 : 0.85);
        return PerfPose(
          sy: 1 + 0.15 * k * swell,
          sx: 1 + 0.11 * k * swell,
          dy: -2.4 * swell,
        );
    }
  }

  double range(double min, double max) => min + _rng.nextDouble() * (max - min);

  double jitter(double amp) => (_rng.nextDouble() * 2 - 1) * amp;

  Offset polar(Offset from, double angleDeg, double dist) {
    final a = angleDeg * math.pi / 180;
    return from + Offset(math.cos(a), math.sin(a)) * dist;
  }

  Path wobble(Path source, {double amp = 1.0, double step = 7}) {
    final out = Path();
    for (final metric in source.computeMetrics()) {
      final segments = math.max(8, (metric.length / step).round());
      final points = <Offset>[];
      for (var i = 0; i <= segments; i++) {
        final distance = metric.length * i / segments;
        final tangent = metric.getTangentForOffset(distance);
        if (tangent == null) continue;
        final v = tangent.vector;
        final mag = v.distance == 0 ? 1.0 : v.distance;
        final normal = Offset(-v.dy / mag, v.dx / mag);
        final edge = (i == 0 || i == segments) && !metric.isClosed;
        final drift = edge ? 0.0 : jitter(amp);
        points.add(tangent.position + normal * drift);
      }
      if (points.length < 2) continue;
      out.moveTo(points.first.dx, points.first.dy);
      for (var i = 1; i < points.length - 1; i++) {
        final mid = (points[i] + points[i + 1]) / 2;
        out.quadraticBezierTo(points[i].dx, points[i].dy, mid.dx, mid.dy);
      }
      out.lineTo(points.last.dx, points.last.dy);
      if (metric.isClosed) out.close();
    }
    return out;
  }

  void fillArea(Path shape, Color color, {double amp = 0.8}) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.save();
    canvas.translate(jitter(0.55), jitter(0.55));
    canvas.drawPath(wobble(shape, amp: amp), paint);
    canvas.restore();
  }

  void ink(
    Path shape, {
    double width = 2.6,
    Color color = Inks.ink,
    double amp = 1.0,
    bool rough = false,
  }) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;
    canvas.drawPath(wobble(shape, amp: amp), paint);
    if (rough) {
      final ghost = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width * 0.45
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color.withValues(alpha: 0.3);
      canvas.drawPath(wobble(shape, amp: amp * 2.1), ghost);
    }
  }

  void strokeLine(
    Offset a,
    Offset b, {
    double width = 2.2,
    Color color = Inks.ink,
    double amp = 0.8,
  }) {
    final path = Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy);
    ink(path, width: width, color: color, amp: amp);
  }

  void curve(
    Offset a,
    Offset control,
    Offset b, {
    double width = 2.2,
    Color color = Inks.ink,
    double amp = 0.6,
  }) {
    final path = Path()
      ..moveTo(a.dx, a.dy)
      ..quadraticBezierTo(control.dx, control.dy, b.dx, b.dy);
    ink(path, width: width, color: color, amp: amp);
  }

  void dot(Offset c, double r, {Color color = Inks.ink}) {
    canvas.drawCircle(c, r, Paint()..color = color);
  }

  void ring(
    Offset c,
    double r, {
    double width = 2.0,
    Color color = Inks.ink,
    double amp = 0.7,
  }) {
    final path = Path()..addOval(Rect.fromCircle(center: c, radius: r));
    ink(path, width: width, color: color, amp: amp);
  }

  void hatch(
    Path area, {
    double angleDeg = -34,
    double gap = 4.8,
    double width = 1.2,
    Color color = const Color(0x2933251D),
  }) {
    final bounds = area.getBounds();
    if (bounds.isEmpty) return;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.save();
    canvas.clipPath(area);
    canvas.translate(bounds.center.dx, bounds.center.dy);
    canvas.rotate(angleDeg * math.pi / 180);
    final span = bounds.longestSide;
    for (var y = -span; y <= span; y += gap) {
      canvas.drawLine(
        Offset(-span, y + jitter(0.7)),
        Offset(span, y + jitter(0.7)),
        paint,
      );
    }
    canvas.restore();
  }

  void shade(
    Path body, {
    Offset lift = const Offset(-2.6, -3.4),
    double gap = 4.6,
    Color color = const Color(0x2433251D),
  }) {
    final crescent = Path.combine(
      PathOperation.difference,
      body,
      body.shift(lift),
    );
    hatch(crescent, gap: gap, color: color);
  }

  void grain(
    Path area, {
    int dots = 12,
    double r = 0.5,
    Color color = const Color(0x1C33251D),
  }) {
    final bounds = area.getBounds();
    if (bounds.isEmpty) return;
    final paint = Paint()..color = color;
    var placed = 0;
    var tries = 0;
    while (placed < dots && tries < dots * 9) {
      tries++;
      final p = Offset(
        range(bounds.left, bounds.right),
        range(bounds.top, bounds.bottom),
      );
      if (!area.contains(p)) continue;
      canvas.drawCircle(p, r * range(0.7, 1.35), paint);
      placed++;
    }
  }

  void gleam(
    Offset c,
    double r, {
    double startDeg = -152,
    double sweepDeg = 55,
    double width = 2.4,
    Color color = const Color(0xA8FFFFFF),
  }) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      startDeg * math.pi / 180,
      sweepDeg * math.pi / 180,
      false,
      paint,
    );
  }

  void groundShadow(
    Offset c,
    double halfWidth, {
    Color color = const Color(0x1F33251D),
  }) {
    final settle =
        (1 - breath * 0.03 * motion.bounce) * (1 - perfPose.lift * 0.24);
    canvas.drawOval(
      Rect.fromCenter(
        center: c,
        width: halfWidth * 2 * settle,
        height: halfWidth * 0.42,
      ),
      Paint()..color = color,
    );
  }

  void posed(
    CharacterMood mood,
    void Function() draw, {
    Offset anchor = const Offset(50, 86),
    MoodPose? pose,
  }) {
    final p = pose ?? MoodPose.of(mood);
    final b = breath * motion.bounce;
    final sway = live
        ? math.sin(t * 0.9 * motion.tempo + _phase) * 0.012 * motion.bounce
        : 0.0;
    final act = perfPose;
    final barkRock = barking
        ? -math.sin(barkT * 3 * 2 * math.pi).abs() * 0.055
        : 0.0;
    final strideBob = walking ? -math.sin(4 * math.pi * gait).abs() * 1.6 : 0.0;
    canvas.save();
    canvas.translate(
      anchor.dx + p.dx + act.dx + lean * 7,
      anchor.dy + p.dy + act.dy + strideBob,
    );
    canvas.rotate(p.rot + sway + act.rot + lean * 0.8 + barkRock);
    canvas.scale(
      p.sx * (1 - b * 0.010) * act.sx,
      p.sy * (1 + b * 0.016) * act.sy,
    );
    canvas.translate(-anchor.dx, -anchor.dy);
    draw();
    canvas.restore();
    if (performing) {
      _performanceFlair(anchor);
    }
  }

  void _performanceFlair(Offset anchor) {
    final p = perfT;
    switch (motion.style) {
      case PerformanceStyle.hop:
        if (p > 0.62 && p < 0.95) {
          final a = (p - 0.62) / 0.33;
          final spread = 5 + a * 7;
          final fade = ((1 - a) * 0.35).clamp(0.0, 1.0);
          dot(
            Offset(anchor.dx - spread, anchor.dy - 1.4),
            1.7 * (1 - a * 0.5),
            color: Inks.ink.withValues(alpha: fade),
          );
          dot(
            Offset(anchor.dx + spread, anchor.dy - 1.6),
            1.4 * (1 - a * 0.5),
            color: Inks.ink.withValues(alpha: fade),
          );
        }
      case PerformanceStyle.spin:
        if (p > 0.1 && p < 0.8) {
          curve(
            Offset(anchor.dx - 26, anchor.dy - 34),
            Offset(anchor.dx - 30, anchor.dy - 44),
            Offset(anchor.dx - 22, anchor.dy - 52),
            width: 1.7,
            color: Inks.inkSoft,
          );
          curve(
            Offset(anchor.dx + 26, anchor.dy - 22),
            Offset(anchor.dx + 30, anchor.dy - 12),
            Offset(anchor.dx + 22, anchor.dy - 4),
            width: 1.7,
            color: Inks.inkSoft,
          );
        }
      case PerformanceStyle.dash:
        final swing = math.sin(2 * math.pi * p);
        if (swing.abs() > 0.35) {
          speedLines(
            Offset(anchor.dx - swing.sign * 22, anchor.dy - 28),
            swing > 0 ? 180 : 0,
            len: 8 * swing.abs(),
          );
        }
      case PerformanceStyle.shake:
        if (p < 0.5) {
          popTicks(
            Offset(anchor.dx, anchor.dy - 52),
            9,
            count: 3,
            len: 2.6,
            width: 1.4,
            color: Inks.inkSoft,
          );
        }
      case PerformanceStyle.float:
        if (p > 0.25 && p < 0.85) {
          sparkleAround(Offset(anchor.dx, anchor.dy - 34), 24, count: 3);
        }
      case PerformanceStyle.wobble:
        if (p < 0.6) {
          curve(
            Offset(anchor.dx - 26, anchor.dy - 30),
            Offset(anchor.dx - 30, anchor.dy - 38),
            Offset(anchor.dx - 25, anchor.dy - 44),
            width: 1.5,
            color: Inks.inkFaint,
          );
          curve(
            Offset(anchor.dx + 26, anchor.dy - 30),
            Offset(anchor.dx + 30, anchor.dy - 38),
            Offset(anchor.dx + 25, anchor.dy - 44),
            width: 1.5,
            color: Inks.inkFaint,
          );
        }
      case PerformanceStyle.bow:
        if (p > 0.2 && p < 0.75) {
          sparkle(Offset(anchor.dx + 24, anchor.dy - 48), 2.2);
        }
      case PerformanceStyle.pop:
        if (p > 0.2 && p < 0.7) {
          final a = (p - 0.2) / 0.5;
          popTicks(
            Offset(anchor.dx, anchor.dy - 36),
            20 + a * 10,
            count: 6,
            len: 3 * (1 - a * 0.4),
            startDeg: -200,
            endDeg: 20,
            width: 1.6,
            color: Inks.inkSoft,
          );
        }
    }
  }

  void arm(
    Offset shoulder,
    double angleDeg,
    double len, {
    double bendDeg = 18,
    double width = 2.5,
    Color color = Inks.ink,
    double hand = 1.9,
  }) {
    final elbow = polar(shoulder, angleDeg - bendDeg, len * 0.55);
    final tip = polar(shoulder, angleDeg, len);
    final path = Path()
      ..moveTo(shoulder.dx, shoulder.dy)
      ..quadraticBezierTo(elbow.dx, elbow.dy, tip.dx, tip.dy);
    ink(path, width: width, color: color, amp: 0.5);
    if (hand > 0) dot(tip, hand, color: color);
  }

  void moodArms(
    CharacterMood mood,
    Offset left,
    Offset right, {
    double len = 9,
    double width = 2.5,
    Color color = Inks.ink,
  }) {
    switch (mood) {
      case CharacterMood.signature:
        arm(left, 152, len, width: width, color: color);
        arm(right, 28, len, width: width, color: color);
      case CharacterMood.joy:
        arm(left, 227, len * 1.08, bendDeg: -12, width: width, color: color);
        arm(right, 313, len * 1.08, bendDeg: 12, width: width, color: color);
      case CharacterMood.yum:
        arm(left, 55, len * 0.75, bendDeg: 30, width: width, color: color);
        arm(right, 125, len * 0.75, bendDeg: -30, width: width, color: color);
      case CharacterMood.sleepy:
        arm(left, 118, len * 0.92, bendDeg: 6, width: width, color: color);
        arm(right, 62, len * 0.92, bendDeg: -6, width: width, color: color);
      case CharacterMood.hype:
        arm(left, 205, len * 0.95, bendDeg: -24, width: width, color: color);
        arm(right, 335, len * 1.1, bendDeg: 20, width: width, color: color);
    }
  }

  void legs(
    CharacterMood mood,
    Offset hip, {
    double spread = 10,
    double len = 6,
    double width = 2.6,
    Color color = Inks.ink,
    double foot = 2.4,
  }) {
    if (walking) {
      for (final side in const [-1, 1]) {
        final swing = math.sin(2 * math.pi * gait + (side < 0 ? 0 : math.pi));
        final liftAmount = math.max(0.0, swing) * 0.25;
        final top = Offset(hip.dx + side * spread / 2, hip.dy);
        final tip = polar(top, 90 + swing * 26, len * (1 - liftAmount));
        strokeLine(top, tip, width: width, color: color, amp: 0.4);
        _foot(Offset(tip.dx + side * 0.5, tip.dy), foot, color);
      }
      return;
    }
    if (mood == CharacterMood.hype) {
      final back = Offset(hip.dx - spread * 0.45, hip.dy);
      final front = Offset(hip.dx + spread * 0.45, hip.dy);
      final backTip = polar(back, 132, len * 1.15);
      final frontTip = polar(front, 62, len * 1.05);
      strokeLine(back, backTip, width: width, color: color, amp: 0.4);
      strokeLine(front, frontTip, width: width, color: color, amp: 0.4);
      _foot(backTip, foot, color);
      _foot(frontTip, foot, color);
      return;
    }
    final drop = mood == CharacterMood.sleepy ? len * 0.75 : len;
    for (final side in const [-1, 1]) {
      final top = Offset(hip.dx + side * spread / 2, hip.dy);
      final tip = Offset(top.dx + side * 0.6, top.dy + drop);
      strokeLine(top, tip, width: width, color: color, amp: 0.4);
      _foot(Offset(tip.dx + side * 0.7, tip.dy), foot, color);
    }
  }

  void _foot(Offset at, double size, Color color) {
    canvas.drawOval(
      Rect.fromCenter(center: at, width: size * 2.1, height: size),
      Paint()..color = color,
    );
  }

  void eyeBlink(Offset c, double r) {
    final path = Path()
      ..moveTo(c.dx - r, c.dy + r * 0.15)
      ..quadraticBezierTo(c.dx, c.dy + r * 0.6, c.dx + r, c.dy + r * 0.15);
    ink(path, width: 2.1, amp: 0.2);
  }

  void eyeDot(Offset c, double r) {
    if (blinkNow) {
      eyeBlink(c, r);
      return;
    }
    dot(c, r);
    dot(Offset(c.dx - r * 0.32, c.dy - r * 0.36), r * 0.34, color: Inks.white);
  }

  void eyeArc(Offset c, double r, {double width = 2.2}) {
    final path = Path()
      ..moveTo(c.dx - r, c.dy + r * 0.35)
      ..quadraticBezierTo(c.dx, c.dy - r * 1.15, c.dx + r, c.dy + r * 0.35);
    ink(path, width: width, amp: 0.3);
  }

  void eyeLid(Offset c, double r) {
    final path = Path()
      ..moveTo(c.dx - r, c.dy - r * 0.1)
      ..quadraticBezierTo(c.dx, c.dy + r * 0.75, c.dx + r, c.dy - r * 0.1);
    ink(path, width: 2.1, amp: 0.3);
    strokeLine(
      Offset(c.dx - r * 0.45, c.dy + r * 0.55),
      Offset(c.dx - r * 0.6, c.dy + r * 1.15),
      width: 1.3,
      amp: 0.2,
    );
    strokeLine(
      Offset(c.dx + r * 0.45, c.dy + r * 0.55),
      Offset(c.dx + r * 0.6, c.dy + r * 1.15),
      width: 1.3,
      amp: 0.2,
    );
  }

  void eyeStar(Offset c, double r) {
    if (blinkNow) {
      eyeBlink(c, r);
      return;
    }
    final star = starPath(c, r * 1.35, points: 4, innerRatio: 0.42);
    fillArea(star, Inks.sun, amp: 0.2);
    ink(star, width: 1.4, amp: 0.2);
  }

  void eyeHeart(Offset c, double r) {
    if (blinkNow) {
      eyeBlink(c, r);
      return;
    }
    final path = heartShape(Offset(c.dx, c.dy + r * 0.2), r * 1.15);
    fillArea(path, Inks.rose, amp: 0.2);
    ink(path, width: 1.3, amp: 0.2);
  }

  void eyeWink(Offset c, double r) {
    final path = Path()
      ..moveTo(c.dx - r * 0.9, c.dy - r * 0.5)
      ..quadraticBezierTo(
        c.dx + r * 0.55,
        c.dy,
        c.dx - r * 0.9,
        c.dy + r * 0.6,
      );
    ink(path, width: 2.1, amp: 0.25);
  }

  void eyeSwirl(Offset c, double r) {
    final path = Path();
    var first = true;
    for (var t = 0.0; t <= 1.0; t += 0.05) {
      final angle = t * 4.4 * math.pi;
      final radius = r * (1 - t * 0.78);
      final p = c + Offset(math.cos(angle), math.sin(angle)) * radius;
      if (first) {
        path.moveTo(p.dx, p.dy);
        first = false;
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    ink(path, width: 1.6, amp: 0.15);
  }

  void brow(Offset c, double w, {double tiltDeg = -14}) {
    final half = polar(Offset.zero, tiltDeg, w / 2);
    strokeLine(c - half, c + half, width: 1.9, amp: 0.3);
  }

  void blushTicks(Offset c, {double s = 1, Color color = Inks.blush}) {
    for (var i = -1; i <= 1; i++) {
      final x = c.dx + i * 1.7 * s;
      strokeLine(
        Offset(x - 0.9 * s, c.dy - 1.4 * s),
        Offset(x + 0.9 * s, c.dy + 1.4 * s),
        width: 1.5 * s,
        color: color,
        amp: 0.2,
      );
    }
  }

  void mouthSmile(Offset c, double w, {double curveDepth = 3}) {
    final path = Path()
      ..moveTo(c.dx - w / 2, c.dy - curveDepth * 0.25)
      ..quadraticBezierTo(
        c.dx,
        c.dy + curveDepth,
        c.dx + w / 2,
        c.dy - curveDepth * 0.25,
      );
    ink(path, width: 2.2, amp: 0.3);
  }

  void mouthGrin(Offset c, double w) {
    final path = Path()
      ..moveTo(c.dx - w / 2, c.dy - 1.2)
      ..quadraticBezierTo(c.dx, c.dy + w * 0.62, c.dx + w / 2, c.dy - 1.2);
    ink(path, width: 2.3, amp: 0.3);
    strokeLine(
      Offset(c.dx - w / 2 - 0.4, c.dy - 1.2),
      Offset(c.dx - w / 2 + 1.4, c.dy - 2.2),
      width: 1.6,
      amp: 0.2,
    );
    strokeLine(
      Offset(c.dx + w / 2 + 0.4, c.dy - 1.2),
      Offset(c.dx + w / 2 - 1.4, c.dy - 2.2),
      width: 1.6,
      amp: 0.2,
    );
  }

  void mouthLaugh(Offset c, double w) {
    final path = Path()
      ..moveTo(c.dx - w / 2, c.dy)
      ..quadraticBezierTo(c.dx, c.dy - 1.6, c.dx + w / 2, c.dy)
      ..quadraticBezierTo(c.dx, c.dy + w * 0.82, c.dx - w / 2, c.dy)
      ..close();
    fillArea(path, Inks.mouthFill, amp: 0.25);
    final tongue = Path()
      ..moveTo(c.dx - w * 0.3, c.dy + w * 0.3)
      ..quadraticBezierTo(c.dx, c.dy + w * 0.72, c.dx + w * 0.3, c.dy + w * 0.3)
      ..quadraticBezierTo(c.dx, c.dy + w * 0.42, c.dx - w * 0.3, c.dy + w * 0.3)
      ..close();
    fillArea(tongue, Inks.tongue, amp: 0.2);
    ink(path, width: 1.9, amp: 0.25);
  }

  void mouthTongue(Offset c, double w) {
    final path = Path()
      ..moveTo(c.dx - w / 2, c.dy - 0.6)
      ..quadraticBezierTo(c.dx, c.dy + 2.4, c.dx + w / 2, c.dy - 0.6);
    ink(path, width: 2.2, amp: 0.25);
    final tongue = Path()
      ..moveTo(c.dx + w * 0.02, c.dy + 0.9)
      ..quadraticBezierTo(
        c.dx + w * 0.18,
        c.dy + 3.6,
        c.dx + w * 0.42,
        c.dy + 2.6,
      )
      ..quadraticBezierTo(c.dx + w * 0.5, c.dy + 1.0, c.dx + w * 0.34, c.dy)
      ..close();
    fillArea(tongue, Inks.tongue, amp: 0.2);
    ink(tongue, width: 1.4, amp: 0.2);
  }

  void mouthOoo(Offset c, double r) {
    final path = Path()..addOval(Rect.fromCircle(center: c, radius: r));
    fillArea(path, Inks.mouthFill, amp: 0.25);
    ink(path, width: 1.6, amp: 0.25);
  }

  void mouthWavy(Offset c, double w) {
    final q = w / 4;
    final path = Path()
      ..moveTo(c.dx - w / 2, c.dy)
      ..quadraticBezierTo(c.dx - q, c.dy - 1.7, c.dx, c.dy)
      ..quadraticBezierTo(c.dx + q, c.dy + 1.7, c.dx + w / 2, c.dy);
    ink(path, width: 2.0, amp: 0.25);
  }

  void mouthCat(Offset c, double w) {
    final q = w / 4;
    final path = Path()
      ..moveTo(c.dx - w / 2, c.dy - 1)
      ..quadraticBezierTo(c.dx - q, c.dy + 1.8, c.dx, c.dy - 0.4)
      ..quadraticBezierTo(c.dx + q, c.dy + 1.8, c.dx + w / 2, c.dy - 1);
    ink(path, width: 2.1, amp: 0.25);
  }

  void moodFace(
    Offset center,
    CharacterMood mood, {
    double scale = 1,
    double spread = 9,
    double mouthDrop = 7,
    bool withBlush = true,
    Color blushColor = Inks.blush,
  }) {
    final left = Offset(center.dx - spread / 2, center.dy);
    final right = Offset(center.dx + spread / 2, center.dy);
    final mouth = Offset(center.dx, center.dy + mouthDrop * scale);
    switch (mood) {
      case CharacterMood.signature:
        eyeDot(left, 2.4 * scale);
        eyeDot(right, 2.4 * scale);
        mouthSmile(mouth, 6.6 * scale);
      case CharacterMood.joy:
        eyeArc(left, 2.7 * scale);
        eyeArc(right, 2.7 * scale);
        mouthLaugh(mouth, 7.2 * scale);
      case CharacterMood.yum:
        eyeHeart(left, 2.7 * scale);
        eyeHeart(right, 2.7 * scale);
        mouthTongue(mouth, 6.6 * scale);
      case CharacterMood.sleepy:
        eyeLid(left, 2.6 * scale);
        eyeLid(right, 2.6 * scale);
        mouthOoo(Offset(mouth.dx, mouth.dy + 0.6), 1.7 * scale);
      case CharacterMood.hype:
        eyeStar(left, 2.6 * scale);
        eyeStar(right, 2.6 * scale);
        mouthGrin(mouth, 7.0 * scale);
        brow(
          Offset(left.dx - 0.4, left.dy - 4.6 * scale),
          3.6 * scale,
          tiltDeg: -18,
        );
        brow(
          Offset(right.dx + 0.4, right.dy - 4.6 * scale),
          3.6 * scale,
          tiltDeg: 18,
        );
    }
    if (withBlush) {
      final drop = mood == CharacterMood.yum ? 3.4 : 3.0;
      blushTicks(
        Offset(center.dx - spread / 2 - 4.4 * scale, center.dy + drop * scale),
        s: 0.9 * scale,
        color: blushColor,
      );
      blushTicks(
        Offset(center.dx + spread / 2 + 4.4 * scale, center.dy + drop * scale),
        s: 0.9 * scale,
        color: blushColor,
      );
    }
  }

  Path starPath(
    Offset c,
    double rOuter, {
    int points = 5,
    double innerRatio = 0.45,
    double rotDeg = -90,
  }) {
    final path = Path();
    final rInner = rOuter * innerRatio;
    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? rOuter : rInner;
      final a = (rotDeg + i * 180 / points) * math.pi / 180;
      final p = c + Offset(math.cos(a), math.sin(a)) * r;
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    return path;
  }

  Path heartShape(Offset c, double s) {
    return Path()
      ..moveTo(c.dx, c.dy + s)
      ..cubicTo(
        c.dx - 1.65 * s,
        c.dy + 0.1 * s,
        c.dx - 1.1 * s,
        c.dy - 1.05 * s,
        c.dx,
        c.dy - 0.38 * s,
      )
      ..cubicTo(
        c.dx + 1.1 * s,
        c.dy - 1.05 * s,
        c.dx + 1.65 * s,
        c.dy + 0.1 * s,
        c.dx,
        c.dy + s,
      )
      ..close();
  }

  void sparkle(
    Offset c,
    double r, {
    Color color = Inks.sun,
    double width = 1.7,
  }) {
    for (final dir in const [
      Offset(1, 0),
      Offset(-1, 0),
      Offset(0, 1),
      Offset(0, -1),
    ]) {
      strokeLine(
        c + dir * r * 0.34,
        c + dir * r,
        width: width,
        color: color,
        amp: 0.15,
      );
    }
  }

  void sparkleAround(
    Offset c,
    double radius, {
    int count = 3,
    double size = 2.2,
    Color color = Inks.sun,
  }) {
    for (var i = 0; i < count; i++) {
      final a = range(0, 360);
      final p = polar(c, a, radius * range(0.82, 1.12));
      sparkle(p, size * range(0.75, 1.2), color: color);
    }
  }

  void heart(
    Offset c,
    double s, {
    Color color = Inks.rose,
    bool outlined = true,
  }) {
    final path = heartShape(c, s);
    fillArea(path, color, amp: 0.25);
    if (outlined) ink(path, width: 1.4, amp: 0.25);
  }

  void heartTrail(Offset origin, {double s = 2.2}) {
    heart(origin, s);
    heart(origin + Offset(s * 2.4, -s * 2.2), s * 0.72);
    heart(origin + Offset(s * 0.7, -s * 4.2), s * 0.5);
  }

  void zzz(Offset origin, {double s = 2.6, Color color = Inks.inkSoft}) {
    var at = origin;
    var k = s;
    for (var i = 0; i < 3; i++) {
      final h = k / 2;
      final bob = live
          ? math.sin(t * 1.3 * motion.tempo + _phase + i * 0.9) * 1.1
          : 0.0;
      final z = Path()
        ..moveTo(at.dx - h, at.dy - h + bob)
        ..lineTo(at.dx + h, at.dy - h + bob)
        ..lineTo(at.dx - h, at.dy + h + bob)
        ..lineTo(at.dx + h, at.dy + h + bob);
      ink(z, width: 1.6, color: color, amp: 0.2);
      at += Offset(k * 1.6, -k * 1.9);
      k *= 0.76;
    }
  }

  void sweat(Offset c, {double s = 2.2}) {
    final path = Path()
      ..moveTo(c.dx, c.dy - s)
      ..quadraticBezierTo(c.dx + s * 0.9, c.dy + s * 0.35, c.dx, c.dy + s * 0.8)
      ..quadraticBezierTo(c.dx - s * 0.9, c.dy + s * 0.35, c.dx, c.dy - s)
      ..close();
    fillArea(path, Inks.sky, amp: 0.2);
    ink(path, width: 1.3, amp: 0.2);
  }

  void speedLines(
    Offset origin,
    double angleDeg, {
    int count = 3,
    double len = 8,
    double gap = 3.2,
    Color color = Inks.inkSoft,
    double width = 1.8,
  }) {
    final a = angleDeg * math.pi / 180;
    final perp = Offset(-math.sin(a), math.cos(a));
    for (var i = 0; i < count; i++) {
      final start = origin + perp * ((i - (count - 1) / 2) * gap);
      strokeLine(
        start,
        polar(start, angleDeg, len * range(0.8, 1.2)),
        width: width,
        color: color,
        amp: 0.3,
      );
    }
  }

  void popTicks(
    Offset c,
    double radius, {
    int count = 5,
    double len = 3.4,
    double startDeg = -160,
    double endDeg = -20,
    Color color = Inks.ink,
    double width = 1.8,
  }) {
    for (var i = 0; i < count; i++) {
      final a = startDeg + (endDeg - startDeg) * i / (count - 1);
      strokeLine(
        polar(c, a, radius),
        polar(c, a, radius + len),
        width: width,
        color: color,
        amp: 0.2,
      );
    }
  }

  void steam(
    Offset base, {
    double h = 13,
    double sway = 3,
    double width = 1.8,
    Color color = const Color(0x4633251D),
  }) {
    final wave = live
        ? math.sin(t * 1.7 * motion.tempo + _phase + base.dx * 0.6)
        : 0.0;
    final s1 = sway * (1 + wave * 0.45);
    final path = Path()
      ..moveTo(base.dx, base.dy)
      ..cubicTo(
        base.dx - s1,
        base.dy - h * 0.35,
        base.dx + s1,
        base.dy - h * 0.68,
        base.dx + jitter(1) + wave * 1.4,
        base.dy - h,
      );
    ink(path, width: width, color: color, amp: 0.4);
  }

  void confetti(
    Rect area, {
    int count = 12,
    List<Color> colors = const [Inks.sun, Inks.rose, Inks.sky, Inks.leaf],
  }) {
    for (var i = 0; i < count; i++) {
      final p = Offset(
        range(area.left, area.right),
        range(area.top, area.bottom),
      );
      final color = colors[i % colors.length];
      if (i.isOdd) {
        dot(p, range(0.7, 1.2), color: color);
        continue;
      }
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(range(0, math.pi));
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: 2.6, height: 1.2),
        Paint()..color = color,
      );
      canvas.restore();
    }
  }

  void musicNote(Offset c, {double s = 3, Color color = Inks.ink}) {
    dot(Offset(c.dx - s * 0.35, c.dy + s * 0.9), s * 0.55, color: color);
    strokeLine(
      Offset(c.dx + s * 0.2, c.dy + s * 0.8),
      Offset(c.dx + s * 0.2, c.dy - s),
      width: 1.5,
      color: color,
      amp: 0.15,
    );
    curve(
      Offset(c.dx + s * 0.2, c.dy - s),
      Offset(c.dx + s * 1.1, c.dy - s * 0.75),
      Offset(c.dx + s * 1.0, c.dy - s * 0.1),
      width: 1.5,
      color: color,
      amp: 0.15,
    );
  }
}
