import 'dart:ui';

import '../core/food_character.dart';
import '../core/sketch.dart';

const orchardFolk = CharacterFamily(
  name: 'Orchard Folk',
  tagline: 'Sun-ripened optimists from the grove.',
  slug: 'orchard_folk',
  members: [berry, zest, avo, peach, pina],
);

const berry = FoodCharacter(
  id: 'berry',
  name: 'Berry',
  family: 'Orchard Folk',
  title: 'The Morning Optimist',
  story:
      'First one awake in the grove, Berry greets every day like a fresh menu. '
      'Keeps a spare daisy on hand for anyone who looks like they need one.',
  accent: Color(0xFFE0472F),
  moodLore: {
    CharacterMood.signature: 'Offering today\'s daisy to a friend.',
    CharacterMood.joy: 'Petal day! Everything is blooming at once.',
    CharacterMood.yum: 'Sweetness overload. Jam levels critical.',
    CharacterMood.sleepy: 'Still covered in dew. Five more minutes.',
    CharacterMood.hype: 'Full seed-trail sprint to the farmers market.',
  },
  painter: _paintBerry,
);

void _paintBerry(Sketch s, CharacterMood mood) {
  const red = Color(0xFFE0472F);
  const seedPale = Color(0xFFF9E9B5);
  s.groundShadow(const Offset(50, 88), 17);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 83), spread: 13, len: 5);
    final body = Path()
      ..moveTo(50, 31)
      ..cubicTo(66, 29, 75, 40, 73, 53)
      ..cubicTo(71, 68, 61, 81, 50, 85)
      ..cubicTo(39, 81, 29, 68, 27, 53)
      ..cubicTo(25, 40, 34, 29, 50, 31)
      ..close();
    s.fillArea(body, red);
    s.shade(body);
    s.grain(body, dots: 8);
    s.ink(body, width: 2.8);
    for (final seed in const [
      Offset(38, 46),
      Offset(50, 43),
      Offset(62, 46),
      Offset(33, 56),
      Offset(67, 56),
      Offset(41, 66),
      Offset(59, 66),
      Offset(50, 74),
    ]) {
      s.strokeLine(
        seed,
        seed + const Offset(0.3, 2.1),
        width: 1.5,
        color: seedPale,
        amp: 0.15,
      );
    }
    final droop = mood == CharacterMood.sleepy ? 3.0 : 0.0;
    for (final tip in [
      Offset(35, 26 + droop),
      Offset(42, 20 + droop * 1.4),
      Offset(52, 17 + droop * 1.6),
      Offset(61, 21 + droop * 1.4),
      Offset(65, 27 + droop),
    ]) {
      final leaflet = Path()
        ..moveTo(48, 32)
        ..quadraticBezierTo(tip.dx - 3, tip.dy + 3, tip.dx, tip.dy)
        ..quadraticBezierTo(tip.dx + 3, tip.dy + 4, 52, 32)
        ..close();
      s.fillArea(leaflet, Inks.leaf, amp: 0.4);
      s.ink(leaflet, width: 1.7, amp: 0.4);
    }
    s.curve(
      const Offset(50, 26),
      const Offset(52, 21),
      const Offset(51, 16),
      width: 2.2,
      color: Inks.leafDeep,
    );
    s.moodArms(mood, const Offset(31, 54), const Offset(69, 54), len: 10);
    s.moodFace(const Offset(50, 52), mood, spread: 11, mouthDrop: 8);
    switch (mood) {
      case CharacterMood.signature:
        final hand = s.polar(const Offset(69, 54), 28, 10);
        s.strokeLine(
          hand,
          hand + const Offset(0.5, 4),
          width: 1.4,
          color: Inks.leafDeep,
        );
        for (var petal = 0; petal < 5; petal++) {
          s.dot(s.polar(hand, petal * 72.0 - 90, 2.6), 1.25, color: Inks.cream);
        }
        s.dot(hand, 1.4, color: Inks.sun);
        s.sparkle(const Offset(30, 30), 2.4);
      case CharacterMood.joy:
        s.confetti(const Rect.fromLTWH(26, 14, 48, 14), count: 10);
      case CharacterMood.yum:
        s.heartTrail(const Offset(71, 34));
      case CharacterMood.sleepy:
        s.zzz(const Offset(68, 30));
        s.sweat(const Offset(36, 44), s: 1.6);
      case CharacterMood.hype:
        s.speedLines(const Offset(23, 56), 180, len: 9);
        s.strokeLine(
          const Offset(18, 68),
          const Offset(24, 67),
          width: 1.6,
          color: seedPale,
          amp: 0.2,
        );
        s.strokeLine(
          const Offset(15, 48),
          const Offset(21, 48),
          width: 1.6,
          color: seedPale,
          amp: 0.2,
        );
        s.sparkle(const Offset(79, 38), 2.6);
    }
  });
}

const zest = FoodCharacter(
  id: 'zest',
  name: 'Zest',
  family: 'Orchard Folk',
  title: 'The Grove Comedian',
  story:
      'Sharpest wit on the branch. Zest turns every sour moment into a punchline '
      'and swears the pucker face is part of the act.',
  accent: Color(0xFFF2C63F),
  moodLore: {
    CharacterMood.signature: 'Mid-routine, finger guns loaded.',
    CharacterMood.joy: 'The whole grove got the joke.',
    CharacterMood.yum: 'Tried its own juice. Instant regret, zero regrets.',
    CharacterMood.sleepy: 'Even the sprout leaf has gone flat.',
    CharacterMood.hype: 'Electric zest mode. Crowd work at full speed.',
  },
  painter: _paintZest,
  motion: MotionProfile(style: PerformanceStyle.shake),
);

void _paintZest(Sketch s, CharacterMood mood) {
  const rind = Color(0xFFF2C63F);
  s.groundShadow(const Offset(50, 88), 18);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 78), spread: 12, len: 6);
    final oval = Path()
      ..addOval(
        Rect.fromCenter(center: const Offset(50, 63), width: 44, height: 31),
      );
    final nubs = Path.combine(
      PathOperation.union,
      Path()
        ..addOval(Rect.fromCircle(center: const Offset(27, 63), radius: 4.6)),
      Path()
        ..addOval(Rect.fromCircle(center: const Offset(73, 63), radius: 4.6)),
    );
    final body = Path.combine(PathOperation.union, oval, nubs);
    s.fillArea(body, rind);
    s.shade(body);
    s.grain(body, dots: 12);
    s.ink(body, width: 2.7);
    s.gleam(const Offset(41, 55), 7, sweepDeg: 42);
    final leafDroop = mood == CharacterMood.sleepy ? 5.0 : 0.0;
    s.curve(
      const Offset(52, 48),
      const Offset(54, 44),
      Offset(56, 42 + leafDroop * 0.4),
      width: 2,
      color: Inks.leafDeep,
    );
    final leaf = Path()
      ..moveTo(56, 42 + leafDroop * 0.4)
      ..quadraticBezierTo(
        61 + leafDroop * 0.3,
        37 + leafDroop,
        66,
        40 + leafDroop * 1.3,
      )
      ..quadraticBezierTo(61, 43 + leafDroop, 56, 42 + leafDroop * 0.4)
      ..close();
    s.fillArea(leaf, Inks.leaf, amp: 0.3);
    s.ink(leaf, width: 1.6, amp: 0.3);
    if (mood == CharacterMood.signature) {
      s.arm(const Offset(29, 65), 150, 9);
      s.arm(const Offset(72, 61), 356, 10.5, bendDeg: 8);
    } else {
      s.moodArms(mood, const Offset(30, 64), const Offset(70, 64), len: 9);
    }
    if (mood == CharacterMood.signature) {
      s.eyeDot(const Offset(45, 59), 2.4);
      s.eyeWink(const Offset(56, 59), 2.6);
      s.mouthGrin(const Offset(50, 67), 6.4);
      s.blushTicks(const Offset(38, 63), s: 0.9);
      s.blushTicks(const Offset(62, 63), s: 0.9);
    } else if (mood == CharacterMood.yum) {
      s.strokeLine(const Offset(42.5, 57), const Offset(46, 59), width: 1.9);
      s.strokeLine(const Offset(46, 59), const Offset(42.5, 61), width: 1.9);
      s.strokeLine(const Offset(57.5, 57), const Offset(54, 59), width: 1.9);
      s.strokeLine(const Offset(54, 59), const Offset(57.5, 61), width: 1.9);
      s.mouthOoo(const Offset(50, 66), 1.7);
      s.popTicks(
        const Offset(50, 66),
        4.2,
        count: 4,
        len: 2.2,
        startDeg: -40,
        endDeg: 220,
        width: 1.3,
      );
      s.sweat(const Offset(63, 52), s: 1.8);
      s.blushTicks(const Offset(38, 63), s: 1);
      s.blushTicks(const Offset(62, 63), s: 1);
    } else {
      s.moodFace(const Offset(50, 60), mood, spread: 10, mouthDrop: 7);
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(80, 46), 2.2);
      case CharacterMood.joy:
        s.popTicks(
          const Offset(50, 46),
          14,
          count: 6,
          color: Inks.sun,
          startDeg: -165,
          endDeg: -15,
        );
        s.confetti(const Rect.fromLTWH(30, 26, 40, 10), count: 8);
      case CharacterMood.yum:
        break;
      case CharacterMood.sleepy:
        s.zzz(const Offset(70, 40));
      case CharacterMood.hype:
        final bolt = Path()
          ..moveTo(72, 30)
          ..lineTo(67, 38)
          ..lineTo(71, 38.5)
          ..lineTo(66, 47)
          ..lineTo(74, 36.5)
          ..lineTo(70.5, 36)
          ..close();
        s.fillArea(bolt, Inks.sun, amp: 0.2);
        s.ink(bolt, width: 1.3, amp: 0.2);
        s.speedLines(const Offset(21, 60), 180, len: 8);
    }
  });
}

const avo = FoodCharacter(
  id: 'avo',
  name: 'Avo',
  family: 'Orchard Folk',
  title: 'The Brunch Guru',
  story:
      'Avo has achieved perfect inner smoothness and carries the proof: '
      'a pit that naps like a baby through everything. Breathe in, spread out.',
  accent: Color(0xFF4F6B3A),
  moodLore: {
    CharacterMood.signature: 'Namaste hands over a sleeping pit.',
    CharacterMood.joy: 'Grove retreat graduation day.',
    CharacterMood.yum: 'Discovered good bread. Enlightenment, again.',
    CharacterMood.sleepy: 'Floating meditation. The pit was right all along.',
    CharacterMood.hype: 'Headband on. Even the pit woke up for this.',
  },
  painter: _paintAvo,
  motion: MotionProfile(tempo: 0.85, style: PerformanceStyle.float),
);

void _paintAvo(Sketch s, CharacterMood mood) {
  const skin = Color(0xFF4F6B3A);
  const flesh = Color(0xFFCBDD8A);
  const pitBrown = Color(0xFF9A6B4C);
  final floating = mood == CharacterMood.sleepy;
  s.groundShadow(const Offset(50, 89), floating ? 11 : 15);
  s.posed(mood, () {
    if (!floating) {
      s.legs(mood, const Offset(50, 84), spread: 13, len: 4.5);
    }
    final body = Path()
      ..moveTo(50, 22)
      ..cubicTo(59, 22, 62, 30, 63, 37)
      ..cubicTo(65, 48, 74, 55, 74, 67)
      ..cubicTo(74, 79, 63, 86, 50, 86)
      ..cubicTo(37, 86, 26, 79, 26, 67)
      ..cubicTo(26, 55, 35, 48, 37, 37)
      ..cubicTo(38, 30, 41, 22, 50, 22)
      ..close();
    final fleshPath = Path()
      ..moveTo(50, 27)
      ..cubicTo(56.5, 27, 58.5, 33, 59.5, 39)
      ..cubicTo(61, 49, 69, 55.5, 69, 66)
      ..cubicTo(69, 76, 60, 82, 50, 82)
      ..cubicTo(40, 82, 31, 76, 31, 66)
      ..cubicTo(31, 55.5, 39, 49, 40.5, 39)
      ..cubicTo(41.5, 33, 43.5, 27, 50, 27)
      ..close();
    s.fillArea(body, skin);
    s.grain(body, dots: 14, color: const Color(0x2E22301A));
    s.ink(body, width: 2.8);
    s.fillArea(fleshPath, flesh);
    s.ink(fleshPath, width: 1.6, color: const Color(0x66557038), amp: 0.7);
    final pit = Path()
      ..addOval(Rect.fromCircle(center: const Offset(50, 66), radius: 9.5));
    s.fillArea(pit, pitBrown);
    s.shade(pit, lift: const Offset(-1.6, -2));
    s.ink(pit, width: 2);
    s.gleam(const Offset(46.5, 62), 4, sweepDeg: 48);
    if (mood == CharacterMood.hype) {
      s.eyeDot(const Offset(46.8, 64.8), 1.3);
      s.eyeDot(const Offset(53.2, 64.8), 1.3);
      s.mouthOoo(const Offset(50, 68.6), 1.2);
    } else {
      s.eyeArc(const Offset(46.8, 65), 1.4, width: 1.5);
      s.eyeArc(const Offset(53.2, 65), 1.4, width: 1.5);
      s.mouthSmile(const Offset(50, 68.2), 3, curveDepth: 1.3);
    }
    if (mood == CharacterMood.hype) {
      final band = Path()
        ..moveTo(40.5, 30)
        ..quadraticBezierTo(50, 27.4, 59.5, 30)
        ..lineTo(59, 33.6)
        ..quadraticBezierTo(50, 31, 41, 33.6)
        ..close();
      s.fillArea(band, Inks.rose, amp: 0.3);
      s.ink(band, width: 1.5, amp: 0.3);
      s.strokeLine(const Offset(59.5, 31), const Offset(64, 29), width: 1.6);
      s.strokeLine(const Offset(59.5, 32), const Offset(64.5, 33), width: 1.6);
    }
    if (mood == CharacterMood.signature) {
      s.arm(const Offset(33, 57), 62, 7.5, bendDeg: 26);
      s.arm(const Offset(67, 57), 118, 7.5, bendDeg: -26);
    } else {
      s.moodArms(mood, const Offset(31, 58), const Offset(69, 58), len: 9);
    }
    s.moodFace(
      const Offset(50, 41),
      mood,
      spread: 9.5,
      mouthDrop: 6,
      scale: 0.92,
    );
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(72, 30), 2.2);
      case CharacterMood.joy:
        s.confetti(
          const Rect.fromLTWH(28, 12, 44, 12),
          count: 9,
          colors: const [Inks.leaf, Inks.sun, Inks.cream, Inks.leafDeep],
        );
      case CharacterMood.yum:
        s.heart(const Offset(70, 30), 2.6);
      case CharacterMood.sleepy:
        s.curve(
          const Offset(41, 87.5),
          const Offset(50, 83.5),
          const Offset(59, 87.5),
          width: 2.4,
        );
        s.curve(
          const Offset(44, 90),
          const Offset(50, 86.5),
          const Offset(56, 90),
          width: 2,
        );
        s.zzz(const Offset(70, 28));
      case CharacterMood.hype:
        s.popTicks(const Offset(50, 26), 10, count: 5);
    }
  }, pose: floating ? const MoodPose(dy: -4.5, rot: -0.03, sy: 0.97) : null);
}

const peach = FoodCharacter(
  id: 'peach',
  name: 'Peach',
  family: 'Orchard Folk',
  title: 'The Soft-Spoken Sweetheart',
  story:
      'Blushes at compliments, compliments everyone anyway. A butterfly adopted '
      'Peach last spring and the two have been inseparable since.',
  accent: Color(0xFFF6A98E),
  moodLore: {
    CharacterMood.signature: 'Quietly introducing the butterfly.',
    CharacterMood.joy: 'Someone said something kind. Petals everywhere.',
    CharacterMood.yum: 'Hands on cheeks, sweetness confirmed.',
    CharacterMood.sleepy: 'Tucked under the leaf, dreaming in pink.',
    CharacterMood.hype: 'Being brave today. Very fast, still blushing.',
  },
  painter: _paintPeach,
);

void _paintPeach(Sketch s, CharacterMood mood) {
  const fuzz = Color(0xFFF6A98E);
  s.groundShadow(const Offset(50, 88), 17);
  s.posed(
    mood,
    () {
      s.legs(mood, const Offset(50, 81), spread: 12, len: 5.5);
      final body = Path.combine(
        PathOperation.union,
        Path()
          ..addOval(Rect.fromCircle(center: const Offset(43, 62), radius: 20)),
        Path()..addOval(
          Rect.fromCircle(center: const Offset(58, 62), radius: 18.5),
        ),
      );
      s.fillArea(body, fuzz);
      s.shade(body);
      s.grain(body, dots: 9, color: const Color(0x21B0543C));
      s.ink(body, width: 2.8);
      s.curve(
        const Offset(50.5, 43.5),
        const Offset(53, 50),
        const Offset(52, 57),
        width: 1.5,
        color: const Color(0x59B0543C),
      );
      final leafDroop = mood == CharacterMood.sleepy ? 6.0 : 0.0;
      s.curve(
        const Offset(52, 43),
        const Offset(53, 39),
        const Offset(55, 37),
        width: 2,
        color: Inks.leafDeep,
      );
      final leaf = Path()
        ..moveTo(55, 37)
        ..quadraticBezierTo(
          60 + leafDroop * 0.4,
          32 + leafDroop,
          65,
          35 + leafDroop * 1.4,
        )
        ..quadraticBezierTo(60, 38 + leafDroop, 55, 37)
        ..close();
      s.fillArea(leaf, Inks.leaf, amp: 0.3);
      s.ink(leaf, width: 1.6, amp: 0.3);
      s.moodArms(mood, const Offset(27, 62), const Offset(73, 62), len: 8.5);
      if (mood == CharacterMood.signature) {
        s.eyeDot(const Offset(45, 58), 2.3);
        s.eyeDot(const Offset(55, 58), 2.3);
        s.mouthSmile(const Offset(50, 65), 4.4, curveDepth: 2.2);
        s.blushTicks(const Offset(38.5, 62), s: 1.25);
        s.blushTicks(const Offset(61.5, 62), s: 1.25);
      } else {
        s.moodFace(
          const Offset(50, 58),
          mood,
          spread: 10,
          mouthDrop: 7,
          blushColor: const Color(0xFFE86A55),
        );
      }
      switch (mood) {
        case CharacterMood.signature:
          s.dot(const Offset(73, 35), 2.2, color: Inks.rose);
          s.dot(const Offset(77, 34), 2.2, color: Inks.sun);
          s.strokeLine(const Offset(75, 33), const Offset(75, 39), width: 1.4);
          s.dot(const Offset(70, 41), 0.5, color: Inks.inkSoft);
          s.dot(const Offset(67, 45), 0.5, color: Inks.inkSoft);
          s.dot(const Offset(65, 49), 0.5, color: Inks.inkSoft);
        case CharacterMood.joy:
          for (final petal in const [
            Offset(28, 30),
            Offset(38, 22),
            Offset(56, 20),
            Offset(68, 26),
            Offset(76, 40),
          ]) {
            final oval = Path()
              ..addOval(
                Rect.fromCenter(center: petal, width: 3.4, height: 2.1),
              );
            s.fillArea(oval, const Color(0xFFFBD9CE), amp: 0.2);
            s.ink(oval, width: 1, amp: 0.2, color: Inks.inkSoft);
          }
        case CharacterMood.yum:
          s.heart(const Offset(71, 34), 2.6);
        case CharacterMood.sleepy:
          s.zzz(const Offset(70, 34));
        case CharacterMood.hype:
          s.speedLines(const Offset(22, 60), 180, len: 9);
          s.sweat(const Offset(67, 44), s: 1.8);
      }
    },
    pose: mood == CharacterMood.sleepy
        ? const MoodPose(dy: 2.6, sx: 1.07, sy: 0.88)
        : null,
  );
}

const pina = FoodCharacter(
  id: 'pina',
  name: 'Pina',
  family: 'Orchard Folk',
  title: 'The Spiky-Haired Party',
  story:
      'Grew the mohawk on purpose. Pina claims every gathering officially starts '
      'when the crown walks in, and honestly, the grove agrees.',
  accent: Color(0xFFEFBC45),
  moodLore: {
    CharacterMood.signature: 'Crown up, doors open, playlist ready.',
    CharacterMood.joy: 'Confetti canon of the orchard.',
    CharacterMood.yum: 'Sweet on the inside, always has been.',
    CharacterMood.sleepy: 'Even mohawks need rest days.',
    CharacterMood.hype: 'Shades on. The bass just dropped.',
  },
  painter: _paintPina,
  motion: MotionProfile(style: PerformanceStyle.spin),
);

void _paintPina(Sketch s, CharacterMood mood) {
  const golden = Color(0xFFEFBC45);
  const lattice = Color(0x66C08A2E);
  s.groundShadow(const Offset(50, 88), 15);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 77.5), spread: 12, len: 6.5);
    final body = Path()
      ..addOval(
        Rect.fromCenter(center: const Offset(50, 56), width: 33, height: 46),
      );
    s.fillArea(body, golden);
    s.hatch(body, angleDeg: 34, gap: 8, width: 1.3, color: lattice);
    s.hatch(body, angleDeg: -34, gap: 8, width: 1.3, color: lattice);
    s.shade(body);
    s.ink(body, width: 2.8);
    final droop = mood == CharacterMood.sleepy ? 7.0 : 0.0;
    final lift = mood == CharacterMood.joy ? -3.0 : 0.0;
    final fan = mood == CharacterMood.hype ? 4.0 : 0.0;
    final tips = [
      Offset(30 - fan, 24 + droop + lift * 0.4),
      Offset(39 - fan * 0.5, 16 + droop * 1.3 + lift * 0.7),
      Offset(50, 11 + droop * 1.5 + lift),
      Offset(61 + fan * 0.5, 15 + droop * 1.3 + lift * 0.7),
      Offset(70 + fan, 23 + droop + lift * 0.4),
    ];
    for (var i = 0; i < tips.length; i++) {
      final tip = tips[i];
      final baseX = 44.0 + i * 3;
      final blade = Path()
        ..moveTo(baseX, 34)
        ..quadraticBezierTo(
          (baseX + tip.dx) / 2 - 2,
          (34 + tip.dy) / 2,
          tip.dx,
          tip.dy,
        )
        ..quadraticBezierTo(
          (baseX + tip.dx) / 2 + 2.5,
          (34 + tip.dy) / 2 + 2,
          baseX + 3.4,
          34,
        )
        ..close();
      s.fillArea(blade, i.isEven ? Inks.leaf : Inks.leafDeep, amp: 0.4);
      s.ink(blade, width: 1.6, amp: 0.4);
    }
    s.moodArms(mood, const Offset(35, 58), const Offset(65, 58), len: 9.5);
    if (mood == CharacterMood.hype) {
      for (final lens in const [Offset(44, 52), Offset(56.5, 52)]) {
        final glass = Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: lens, width: 8.4, height: 6),
              const Radius.circular(2.4),
            ),
          );
        s.fillArea(glass, Inks.ink, amp: 0.2);
      }
      s.strokeLine(
        const Offset(48, 51.4),
        const Offset(52.6, 51.4),
        width: 1.8,
      );
      s.strokeLine(const Offset(39.8, 51.4), const Offset(35, 50), width: 1.6);
      s.strokeLine(const Offset(60.7, 51.4), const Offset(65, 50), width: 1.6);
      s.gleam(
        const Offset(43, 51),
        2.4,
        sweepDeg: 40,
        color: const Color(0x7DFFFFFF),
      );
      s.mouthGrin(const Offset(50, 62), 7);
      s.blushTicks(const Offset(39, 58), s: 0.9);
      s.blushTicks(const Offset(61, 58), s: 0.9);
    } else {
      s.moodFace(const Offset(50, 53), mood, spread: 10.5, mouthDrop: 8);
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(74, 26), 2.6);
        s.sparkle(const Offset(27, 33), 1.9);
      case CharacterMood.joy:
        s.confetti(const Rect.fromLTWH(24, 8, 52, 16), count: 14);
      case CharacterMood.yum:
        s.heartTrail(const Offset(72, 40));
      case CharacterMood.sleepy:
        s.zzz(const Offset(71, 36));
      case CharacterMood.hype:
        s.musicNote(const Offset(76, 38));
        s.speedLines(const Offset(22, 58), 180, len: 9);
    }
  });
}
