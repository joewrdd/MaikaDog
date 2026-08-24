import 'dart:ui';

import '../core/food_character.dart';
import '../core/sketch.dart';

const bakeryBunch = CharacterFamily(
  name: 'Bakery Bunch',
  tagline: 'Warm crumbs, warmer hearts.',
  slug: 'bakery_bunch',
  members: [bagi, croix, doni, twist, loaf],
);

const bagi = FoodCharacter(
  id: 'bagi',
  name: 'Bagi',
  family: 'Bakery Bunch',
  title: 'The Crusty Artist',
  story:
      'Paints exclusively in warm tones and refuses to explain the beret. '
      'Bagi says every score mark is a brushstroke the oven approved.',
  accent: Color(0xFFD9A05B),
  moodLore: {
    CharacterMood.signature: 'Considering the canvas. The canvas is lunch.',
    CharacterMood.joy: 'The gallery loved it. Conducting the applause.',
    CharacterMood.yum: 'Butter is simply paint you can eat.',
    CharacterMood.sleepy: 'Leaning on the easel, beret over one eye.',
    CharacterMood.hype: 'Inspiration struck. Paint everywhere.',
  },
  painter: _paintBagi,
  motion: MotionProfile(style: PerformanceStyle.bow),
);

void _paintBagi(Sketch s, CharacterMood mood) {
  const crust = Color(0xFFD9A05B);
  const score = Color(0xFFF3D9AD);
  const beret = Color(0xFFBF4638);
  s.groundShadow(const Offset(50, 88), 13);
  s.posed(
    mood,
    () {
      s.legs(mood, const Offset(50, 80), spread: 9, len: 5.5);
      final body = Path()
        ..moveTo(50, 19)
        ..cubicTo(56, 19, 58.5, 24, 58.5, 32)
        ..lineTo(58.5, 70)
        ..cubicTo(58.5, 78, 55, 82, 50, 82)
        ..cubicTo(45, 82, 41.5, 78, 41.5, 70)
        ..lineTo(41.5, 32)
        ..cubicTo(41.5, 24, 44, 19, 50, 19)
        ..close();
      s.fillArea(body, crust);
      s.shade(body, lift: const Offset(-2, -2.4));
      s.grain(body, dots: 7);
      s.ink(body, width: 2.7);
      for (final y in const [28.0, 58.0, 68.0]) {
        s.strokeLine(
          Offset(44, y + 2.6),
          Offset(56, y - 2.6),
          width: 2.2,
          color: score,
          amp: 0.4,
        );
      }
      final beretTilt = mood == CharacterMood.sleepy ? 3.4 : 0.0;
      final hat = Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset(45, 19.5 + beretTilt * 0.7),
            width: 17,
            height: 7.5,
          ),
        );
      s.fillArea(hat, beret, amp: 0.5);
      s.ink(hat, width: 1.8, amp: 0.5);
      s.strokeLine(
        Offset(45, 15.6 + beretTilt * 0.7),
        Offset(46.5, 13.4 + beretTilt * 0.7),
        width: 1.8,
      );
      if (mood == CharacterMood.joy || mood == CharacterMood.hype) {
        s.moodArms(mood, const Offset(43, 52), const Offset(57, 52), len: 9);
        final tip = mood == CharacterMood.joy
            ? s.polar(const Offset(57, 52), 313, 9.7)
            : s.polar(const Offset(57, 52), 335, 9.9);
        s.strokeLine(tip, tip + const Offset(2.6, -4.4), width: 1.6);
        s.dot(tip + const Offset(3.1, -5.4), 1.5, color: beret);
      } else if (mood == CharacterMood.signature) {
        s.arm(const Offset(43, 52), 152, 8.5);
        s.arm(const Offset(57, 50), 8, 9, bendDeg: -12);
        final hand = s.polar(const Offset(57, 50), 8, 9);
        s.strokeLine(hand, hand + const Offset(2.2, -5), width: 1.6);
        s.dot(hand + const Offset(2.7, -6), 1.5, color: beret);
      } else {
        s.moodArms(mood, const Offset(43, 52), const Offset(57, 52), len: 8.5);
      }
      s.moodFace(
        const Offset(50, 40),
        mood,
        spread: 8.5,
        mouthDrop: 6.5,
        scale: 0.88,
      );
      switch (mood) {
        case CharacterMood.signature:
          s.sparkle(const Offset(69, 30), 2.2);
        case CharacterMood.joy:
          s.musicNote(const Offset(70, 26));
          s.dot(const Offset(66, 40), 1.2, color: Inks.sky);
          s.dot(const Offset(72, 46), 1.2, color: Inks.rose);
        case CharacterMood.yum:
          final butter = Path()
            ..addRRect(
              RRect.fromRectAndRadius(
                Rect.fromCenter(
                  center: const Offset(52, 15),
                  width: 8,
                  height: 4.6,
                ),
                const Radius.circular(1),
              ),
            );
          s.fillArea(butter, const Color(0xFFFBE28B), amp: 0.25);
          s.ink(butter, width: 1.3, amp: 0.25);
          s.heart(const Offset(68, 34), 2.3);
        case CharacterMood.sleepy:
          s.zzz(const Offset(67, 26));
        case CharacterMood.hype:
          for (final splat in const [
            [Offset(28, 34), Inks.sky],
            [Offset(24, 52), Inks.rose],
            [Offset(31, 66), Inks.sun],
            [Offset(70, 60), Inks.leaf],
          ]) {
            s.dot(splat[0] as Offset, 1.6, color: splat[1] as Color);
            s.popTicks(
              splat[0] as Offset,
              2.4,
              count: 3,
              len: 1.4,
              width: 1,
              color: Inks.inkSoft,
            );
          }
          s.speedLines(const Offset(26, 76), 190, len: 7);
      }
    },
    pose: mood == CharacterMood.sleepy
        ? const MoodPose(dy: 2, rot: -0.1, sy: 0.95)
        : null,
  );
}

const croix = FoodCharacter(
  id: 'croix',
  name: 'Croix',
  family: 'Bakery Bunch',
  title: 'The Daydream Crescent',
  story:
      'Convinced of being the moon\'s understudy. Croix rehearses nightly, '
      'floating just a little, and the stars have started playing along.',
  accent: Color(0xFFE0A85F),
  moodLore: {
    CharacterMood.signature: 'Practicing elegant standing. Nailed it.',
    CharacterMood.joy: 'Shedding happy flakes, extremely on purpose.',
    CharacterMood.yum: 'Jam. The moon never had it this good.',
    CharacterMood.sleepy: 'Moonlighting. Literally. The stars showed up.',
    CharacterMood.hype: 'Crescent boost engaged.',
  },
  painter: _paintCroix,
  motion: MotionProfile(tempo: 0.85, style: PerformanceStyle.float),
);

void _paintCroix(Sketch s, CharacterMood mood) {
  const gold = Color(0xFFE0A85F);
  final moon = mood == CharacterMood.sleepy;
  s.groundShadow(const Offset(50, 88), moon ? 10 : 17);
  s.posed(mood, () {
    if (!moon) {
      s.strokeLine(const Offset(33, 68), const Offset(33, 74), width: 2.4);
      s.strokeLine(const Offset(67, 68), const Offset(67, 74), width: 2.4);
      s.dot(const Offset(32.4, 75), 2.1);
      s.dot(const Offset(67.6, 75), 2.1);
    }
    final body = Path()
      ..moveTo(29, 66)
      ..quadraticBezierTo(26.5, 60, 31, 55)
      ..cubicTo(34, 42, 44, 34, 50, 34)
      ..cubicTo(56, 34, 66, 42, 69, 55)
      ..quadraticBezierTo(73.5, 60, 71, 66)
      ..quadraticBezierTo(66, 63, 62, 60)
      ..cubicTo(58, 53, 42, 53, 38, 60)
      ..quadraticBezierTo(34, 63, 29, 66)
      ..close();
    s.fillArea(body, gold);
    s.shade(body, lift: const Offset(-2, -2.6));
    s.grain(body, dots: 7);
    s.ink(body, width: 2.8);
    s.curve(
      const Offset(40, 40),
      const Offset(37, 48),
      const Offset(37, 57),
      width: 1.6,
      color: const Color(0x66B27C3C),
    );
    s.curve(
      const Offset(60, 40),
      const Offset(63, 48),
      const Offset(63, 57),
      width: 1.6,
      color: const Color(0x66B27C3C),
    );
    if (!moon) {
      s.moodArms(mood, const Offset(38, 52), const Offset(62, 52), len: 7.5);
    }
    if (moon) {
      s.eyeArc(const Offset(45.5, 44), 2.4);
      s.eyeArc(const Offset(54.5, 44), 2.4);
      s.mouthSmile(const Offset(50, 50), 5, curveDepth: 2.2);
      s.blushTicks(const Offset(39, 47), s: 0.85);
      s.blushTicks(const Offset(61, 47), s: 0.85);
    } else {
      s.moodFace(
        const Offset(50, 44),
        mood,
        spread: 9,
        mouthDrop: 6,
        scale: 0.9,
      );
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(74, 36), 2.2);
        final scarf = Path()
          ..moveTo(46, 55)
          ..quadraticBezierTo(50, 57.5, 54, 55)
          ..lineTo(53, 58.5)
          ..quadraticBezierTo(50, 60.5, 47, 58.5)
          ..close();
        s.fillArea(scarf, Inks.rose, amp: 0.3);
        s.ink(scarf, width: 1.3, amp: 0.3);
      case CharacterMood.joy:
        for (final flake in const [
          Offset(28, 40),
          Offset(36, 30),
          Offset(64, 30),
          Offset(73, 42),
          Offset(50, 26),
        ]) {
          s.strokeLine(
            flake,
            flake + const Offset(1.8, 2.4),
            width: 1.4,
            color: const Color(0xFFF3D9AD),
            amp: 0.2,
          );
        }
      case CharacterMood.yum:
        s.heart(const Offset(71, 40), 2.5);
      case CharacterMood.sleepy:
        for (final star in const [
          [Offset(27, 28), 4.4],
          [Offset(71, 21), 3.4],
          [Offset(78, 44), 2.7],
        ]) {
          final shape = s.starPath(
            star[0] as Offset,
            star[1] as double,
            innerRatio: 0.5,
          );
          s.fillArea(shape, Inks.sun, amp: 0.15);
          s.ink(shape, width: 1.1, amp: 0.15);
        }
        s.zzz(const Offset(50, 24), s: 2.2);
      case CharacterMood.hype:
        s.speedLines(const Offset(24, 60), 195, len: 9);
        s.sparkle(const Offset(75, 30), 2.6);
    }
  }, pose: moon ? const MoodPose(dy: -7, rot: -0.12) : null);
}

const doni = FoodCharacter(
  id: 'doni',
  name: 'Doni',
  family: 'Bakery Bunch',
  title: 'The Glazed Influencer',
  story:
      'Ten thousand followers and every single one is a sprinkle. Doni '
      'maintains the glaze daily and rolls everywhere for the aesthetic.',
  accent: Color(0xFFF27D9D),
  moodLore: {
    CharacterMood.signature: 'Waving at the feed. The feed waves back.',
    CharacterMood.joy: 'Sprinkles popped off. Iconic.',
    CharacterMood.yum: 'Taste-testing own glaze. Quality control.',
    CharacterMood.sleepy: 'Glaze drooping. Do not post this.',
    CharacterMood.hype: 'Rolling to the drop. Literally rolling.',
  },
  painter: _paintDoni,
  motion: MotionProfile(style: PerformanceStyle.spin),
);

void _paintDoni(Sketch s, CharacterMood mood) {
  const dough = Color(0xFFD79A62);
  const icing = Color(0xFFF27D9D);
  final rolling = mood == CharacterMood.hype;
  s.groundShadow(const Offset(50, 88), 16);
  s.posed(mood, () {
    if (!rolling) {
      s.legs(mood, const Offset(50, 74), spread: 11, len: 6.5);
    }
    final ringBody = Path()
      ..addOval(Rect.fromCircle(center: const Offset(50, 56), radius: 20));
    s.fillArea(ringBody, dough);
    s.shade(ringBody);
    s.ink(ringBody, width: 2.8);
    final drip = mood == CharacterMood.sleepy ? 4.0 : 0.0;
    final glaze = Path()
      ..moveTo(30.5, 52)
      ..cubicTo(31, 40, 39, 36, 50, 36)
      ..cubicTo(61, 36, 69, 40, 69.5, 52)
      ..quadraticBezierTo(68, 57 + drip, 65, 55 + drip * 0.6)
      ..quadraticBezierTo(62.5, 60 + drip, 59, 57)
      ..quadraticBezierTo(55, 62 + drip * 1.4, 50, 58)
      ..quadraticBezierTo(45, 62 + drip, 41, 57)
      ..quadraticBezierTo(37.5, 60 + drip * 0.7, 35, 55)
      ..quadraticBezierTo(32.5, 57 + drip * 0.5, 30.5, 52)
      ..close();
    s.fillArea(glaze, icing);
    s.ink(glaze, width: 1.9, amp: 0.8);
    for (final sprinkle in const [
      [Offset(38, 43), Inks.sun, 24.0],
      [Offset(46, 40), Inks.sky, -30.0],
      [Offset(56, 41), Inks.leaf, 12.0],
      [Offset(63, 46), Inks.cream, -18.0],
      [Offset(42, 49), Inks.cream, 60.0],
      [Offset(58, 50), Inks.sun, -55.0],
    ]) {
      final at = sprinkle[0] as Offset;
      final angle = sprinkle[2] as double;
      s.strokeLine(
        s.polar(at, angle, -1.7),
        s.polar(at, angle, 1.7),
        width: 1.7,
        color: sprinkle[1] as Color,
        amp: 0.1,
      );
    }
    final hole = Path()
      ..addOval(Rect.fromCircle(center: const Offset(50, 56), radius: 6.4));
    s.fillArea(hole, Inks.paper, amp: 0.5);
    s.ink(hole, width: 2, amp: 0.5);
    if (mood == CharacterMood.signature) {
      s.arm(const Offset(31, 60), 152, 8);
      s.arm(const Offset(69, 56), 305, 9, bendDeg: 14);
    } else if (!rolling) {
      s.moodArms(mood, const Offset(31, 60), const Offset(69, 60), len: 8);
    }
    if (mood == CharacterMood.signature) {
      s.eyeDot(const Offset(44.5, 67), 2.2);
      s.eyeWink(const Offset(56, 67), 2.4);
      s.mouthSmile(const Offset(50, 72), 5.4);
      s.blushTicks(const Offset(38, 70), s: 0.8);
      s.blushTicks(const Offset(62, 70), s: 0.8);
    } else {
      s.moodFace(
        const Offset(50, 67),
        mood,
        spread: 10,
        mouthDrop: 5,
        scale: 0.82,
      );
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(76, 40), 2.4);
        s.sparkle(const Offset(25, 34), 1.9);
      case CharacterMood.joy:
        for (final fly in const [
          [Offset(30, 28), Inks.sun],
          [Offset(44, 22), Inks.sky],
          [Offset(58, 21), Inks.leaf],
          [Offset(70, 27), Inks.rose],
        ]) {
          s.strokeLine(
            fly[0] as Offset,
            (fly[0] as Offset) + const Offset(2, -2),
            width: 1.7,
            color: fly[1] as Color,
            amp: 0.1,
          );
        }
        s.popTicks(const Offset(50, 33), 8, count: 5, len: 2.6, width: 1.4);
      case CharacterMood.yum:
        s.heart(const Offset(73, 44), 2.4);
        s.strokeLine(
          const Offset(50, 60.5),
          const Offset(50, 63.5),
          width: 2.2,
          color: icing,
        );
      case CharacterMood.sleepy:
        s.zzz(const Offset(72, 32));
      case CharacterMood.hype:
        s.speedLines(const Offset(23, 52), 180, len: 10, count: 4);
        s.curve(
          const Offset(36, 82),
          const Offset(50, 86),
          const Offset(64, 82),
          width: 1.8,
          color: Inks.inkSoft,
        );
        s.curve(
          const Offset(40, 78.5),
          const Offset(50, 81.5),
          const Offset(60, 78.5),
          width: 1.4,
          color: Inks.inkFaint,
        );
    }
  }, pose: rolling ? const MoodPose(rot: 0.3, dy: -2) : null);
}

const twist = FoodCharacter(
  id: 'twist',
  name: 'Twist',
  family: 'Bakery Bunch',
  title: 'The Knotted Yogi',
  story:
      'Arms permanently in lotus, salt for patience. Twist teaches a class '
      'called Advanced Sitting and only unknots for truly big feelings.',
  accent: Color(0xFFB26A3A),
  moodLore: {
    CharacterMood.signature: 'Grounded. The knot is the pose.',
    CharacterMood.joy: 'One arm escaped the knot. Big feelings.',
    CharacterMood.yum: 'Mustard: controversial, correct.',
    CharacterMood.sleepy: 'The knot loosened. Deep rest achieved.',
    CharacterMood.hype: 'FULLY UNKNOTTED. Tell everyone.',
  },
  painter: _paintTwist,
  motion: MotionProfile(style: PerformanceStyle.wobble),
);

void _paintTwist(Sketch s, CharacterMood mood) {
  const dough = Color(0xFFB26A3A);
  const strand = Color(0xFF8F5227);
  final seated =
      mood == CharacterMood.signature || mood == CharacterMood.sleepy;
  s.groundShadow(const Offset(50, 88), 16);
  s.posed(mood, () {
    if (!seated) {
      s.legs(mood, const Offset(50, 78), spread: 11, len: 6);
    }
    final body = Path()
      ..moveTo(50, 30)
      ..cubicTo(62, 30, 72, 40, 73, 55)
      ..cubicTo(74, 68, 68, 80, 50, 80)
      ..cubicTo(32, 80, 26, 68, 27, 55)
      ..cubicTo(28, 40, 38, 30, 50, 30)
      ..close();
    s.fillArea(body, dough);
    s.shade(body);
    s.grain(body, dots: 6);
    s.ink(body, width: 2.8);
    final loosen = mood == CharacterMood.sleepy ? 4.0 : 0.0;
    s.curve(
      Offset(36, 74 - loosen * 0.4),
      Offset(52 - loosen, 58),
      const Offset(58, 37.5),
      width: 2.6,
      color: strand,
      amp: 0.7,
    );
    s.curve(
      Offset(64, 74 - loosen * 0.4),
      Offset(48 + loosen, 58),
      const Offset(42, 37.5),
      width: 2.6,
      color: strand,
      amp: 0.7,
    );
    for (final hole in [const Offset(39.5, 63.5), const Offset(60.5, 63.5)]) {
      final gap = Path()
        ..addOval(Rect.fromCircle(center: hole, radius: 5.4 + loosen * 0.4));
      s.fillArea(gap, Inks.paper, amp: 0.5);
      s.ink(gap, width: 2, amp: 0.5);
    }
    for (final salt in const [
      Offset(37, 40),
      Offset(58, 36),
      Offset(68, 50),
      Offset(31, 54),
      Offset(48, 73),
      Offset(66, 70),
    ]) {
      s.strokeLine(
        salt,
        salt + const Offset(1.7, 1),
        width: 1.7,
        color: Inks.cream,
        amp: 0.1,
      );
    }
    if (mood == CharacterMood.joy) {
      s.arm(const Offset(70, 46), 308, 9.5, bendDeg: 14);
    } else if (mood == CharacterMood.hype) {
      s.arm(const Offset(30, 46), 205, 9, bendDeg: -22);
      s.arm(const Offset(70, 46), 335, 10, bendDeg: 18);
    } else if (mood == CharacterMood.yum) {
      s.moodArms(mood, const Offset(33, 52), const Offset(67, 52), len: 7.5);
    }
    s.moodFace(
      const Offset(50, 46),
      mood,
      spread: 9.5,
      mouthDrop: 6.5,
      scale: 0.92,
    );
    if (seated) {
      s.curve(
        const Offset(38, 82),
        const Offset(50, 77.5),
        const Offset(62, 82),
        width: 2.4,
      );
      s.curve(
        const Offset(42, 84.5),
        const Offset(50, 81),
        const Offset(58, 84.5),
        width: 2,
      );
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(74, 30), 2.2);
        s.sparkle(const Offset(26, 34), 1.8);
      case CharacterMood.joy:
        s.popTicks(const Offset(50, 26), 10, count: 5, color: Inks.sun);
      case CharacterMood.yum:
        s.dot(const Offset(71, 36), 1.8, color: Inks.sun);
        s.curve(
          const Offset(71, 36),
          const Offset(73, 40),
          const Offset(71.5, 44),
          width: 1.8,
          color: Inks.sun,
        );
        s.heart(const Offset(29, 34), 2.2);
      case CharacterMood.sleepy:
        s.zzz(const Offset(70, 30));
      case CharacterMood.hype:
        s.popTicks(const Offset(50, 24), 11, count: 6);
        s.speedLines(const Offset(22, 60), 185, len: 7);
        for (final salt in const [Offset(28, 26), Offset(72, 22)]) {
          s.strokeLine(
            salt,
            salt + const Offset(1.6, -1.4),
            width: 1.6,
            color: Inks.cream,
            amp: 0.1,
          );
        }
    }
  });
}

const loaf = FoodCharacter(
  id: 'loaf',
  name: 'Loaf',
  family: 'Bakery Bunch',
  title: 'The Sourdough Grandpa',
  story:
      'Started from a starter his own grandpa kept alive. Loaf has warm '
      'opinions, warmer crust, and a checkered napkin for emergency naps.',
  accent: Color(0xFFC88F58),
  moodLore: {
    CharacterMood.signature: 'Fresh out of the oven, telling the story again.',
    CharacterMood.joy: 'The whole bakery came to visit.',
    CharacterMood.yum: 'A little butter never hurt anybody.',
    CharacterMood.sleepy: 'Under the napkin. Proofing, allegedly.',
    CharacterMood.hype: 'Fastest rise in fifty years!',
  },
  painter: _paintLoaf,
  motion: MotionProfile(tempo: 0.8, style: PerformanceStyle.bow),
);

void _paintLoaf(Sketch s, CharacterMood mood) {
  const crust = Color(0xFFC88F58);
  const scoreCream = Color(0xFFF3D9AD);
  s.groundShadow(const Offset(50, 88), 18);
  s.posed(mood, () {
    s.legs(mood, const Offset(51, 82), spread: 13, len: 4.5);
    final body = Path()
      ..moveTo(50, 38)
      ..cubicTo(64, 38, 74, 48, 74, 62)
      ..cubicTo(74, 76, 64, 84, 50, 84)
      ..cubicTo(36, 84, 28, 76, 28, 62)
      ..cubicTo(28, 48, 36, 38, 50, 38)
      ..close();
    s.fillArea(body, crust);
    s.shade(body);
    s.grain(body, dots: 10);
    s.ink(body, width: 2.9);
    s.curve(
      const Offset(37, 47),
      const Offset(44, 42),
      const Offset(51, 44),
      width: 2,
      color: scoreCream,
      amp: 0.4,
    );
    s.curve(
      const Offset(46, 52),
      const Offset(54, 47),
      const Offset(61, 49),
      width: 2,
      color: scoreCream,
      amp: 0.4,
    );
    s.curve(
      const Offset(56, 58),
      const Offset(63, 54),
      const Offset(68, 57),
      width: 2,
      color: scoreCream,
      amp: 0.4,
    );
    s.moodArms(mood, const Offset(31, 66), const Offset(71, 66), len: 8.5);
    final slide = mood == CharacterMood.sleepy ? 2.4 : 0.0;
    final askew = mood == CharacterMood.hype ? 1.6 : 0.0;
    if (mood == CharacterMood.signature) {
      s.eyeLid(const Offset(45, 60), 2.2);
      s.eyeLid(const Offset(55, 60), 2.2);
      s.mouthSmile(const Offset(50, 67), 5.6, curveDepth: 2.6);
      s.blushTicks(const Offset(38, 64), s: 0.9);
      s.blushTicks(const Offset(62, 64), s: 0.9);
    } else {
      s.moodFace(
        const Offset(50, 60),
        mood,
        spread: 10,
        mouthDrop: 7,
        scale: 0.95,
      );
    }
    s.ring(Offset(45, 60 + slide), 3.5, width: 1.7);
    s.ring(Offset(55, 60 + slide + askew), 3.5, width: 1.7);
    s.strokeLine(
      Offset(48.5, 60 + slide),
      Offset(51.5, 60 + slide + askew),
      width: 1.5,
    );
    s.strokeLine(Offset(41.5, 59 + slide), const Offset(36, 57), width: 1.4);
    s.strokeLine(
      Offset(58.5, 59 + slide + askew),
      const Offset(64, 57),
      width: 1.4,
    );
    if (mood != CharacterMood.sleepy) {
      s.steam(const Offset(44, 36), h: 11, sway: 2.6);
      s.steam(const Offset(56, 34), h: 13, sway: 3);
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(74, 34), 2.2);
      case CharacterMood.joy:
        s.dot(const Offset(30, 32), 1.4, color: crust);
        s.dot(const Offset(38, 26), 1.2, color: crust);
        s.dot(const Offset(64, 27), 1.3, color: crust);
        s.popTicks(const Offset(50, 32), 10, count: 5, color: Inks.sun);
      case CharacterMood.yum:
        final butter = Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: const Offset(48, 36),
                width: 9,
                height: 5,
              ),
              const Radius.circular(1.2),
            ),
          );
        s.fillArea(butter, const Color(0xFFFBE28B), amp: 0.25);
        s.ink(butter, width: 1.4, amp: 0.25);
        s.strokeLine(
          const Offset(44, 39),
          const Offset(43, 43),
          width: 1.8,
          color: const Color(0xFFFBE28B),
        );
      case CharacterMood.sleepy:
        final napkin = Path()
          ..moveTo(30, 64)
          ..quadraticBezierTo(50, 55, 70, 64)
          ..lineTo(72, 82)
          ..quadraticBezierTo(50, 90, 28, 82)
          ..close();
        s.fillArea(napkin, const Color(0xFFF6EBDD), amp: 0.9);
        s.hatch(
          napkin,
          angleDeg: 0,
          gap: 5.6,
          width: 1.2,
          color: const Color(0x59D06A55),
        );
        s.hatch(
          napkin,
          angleDeg: 90,
          gap: 5.6,
          width: 1.2,
          color: const Color(0x59D06A55),
        );
        s.ink(napkin, width: 2, amp: 0.9);
        s.zzz(const Offset(72, 40));
      case CharacterMood.hype:
        s.speedLines(const Offset(22, 66), 185, len: 8);
        s.sweat(const Offset(68, 46), s: 1.8);
    }
  });
}
