import 'dart:math' as math;
import 'dart:ui';

import '../core/food_character.dart';
import '../core/sketch.dart';

const noodleHouse = CharacterFamily(
  name: 'Noodle House',
  tagline: 'Steam, slurp, and small quiet joys.',
  slug: 'noodle_house',
  members: [shari, miso, bao, nori, pearl],
);

const shari = FoodCharacter(
  id: 'shari',
  name: 'Shari',
  family: 'Noodle House',
  title: 'The Unbothered Master',
  story:
      'Has never once raised its voice, or its arms. When Shari is truly '
      'moved, gravity simply stops applying. The salmon cloak was a gift.',
  accent: Color(0xFFF2845C),
  moodLore: {
    CharacterMood.signature: 'Perfect stillness. Rice aligned.',
    CharacterMood.joy: 'A smile. For Shari this is fireworks.',
    CharacterMood.yum: 'One eye opened. Attachment has formed.',
    CharacterMood.sleepy: 'Identical to signature. That is the lesson.',
    CharacterMood.hype: 'Levitating, serenely. Do not be alarmed.',
  },
  painter: _paintShari,
  motion: MotionProfile(
    tempo: 0.55,
    bounce: 0.3,
    style: PerformanceStyle.float,
  ),
);

void _paintShari(Sketch s, CharacterMood mood) {
  const rice = Color(0xFFF8F2E8);
  const salmon = Color(0xFFF2845C);
  const nori = Color(0xFF3A4A3E);
  final floating = mood == CharacterMood.hype;
  s.groundShadow(const Offset(50, 88), floating ? 9 : 16);
  s.posed(mood, () {
    final rump = Path()
      ..moveTo(35, 58)
      ..cubicTo(33, 70, 36, 80, 50, 80)
      ..cubicTo(64, 80, 67, 70, 65, 58)
      ..quadraticBezierTo(50, 54, 35, 58)
      ..close();
    s.fillArea(rump, rice);
    s.grain(rump, dots: 12, color: const Color(0x30C9BCA4));
    s.ink(rump, width: 2.7);
    final slab = Path()
      ..moveTo(31, 52)
      ..cubicTo(31, 45, 37, 42, 50, 42)
      ..cubicTo(63, 42, 69, 45, 69, 52)
      ..cubicTo(69, 57, 63, 60, 50, 60)
      ..cubicTo(37, 60, 31, 57, 31, 52)
      ..close();
    s.fillArea(slab, salmon);
    s.shade(slab, lift: const Offset(-1.8, -2.2));
    s.ink(slab, width: 2.7);
    s.curve(
      const Offset(37, 47),
      const Offset(41, 51),
      const Offset(38, 56),
      width: 1.6,
      color: const Color(0x8CFCD9C4),
      amp: 0.3,
    );
    s.curve(
      const Offset(48, 45),
      const Offset(52, 50),
      const Offset(49, 57),
      width: 1.6,
      color: const Color(0x8CFCD9C4),
      amp: 0.3,
    );
    s.curve(
      const Offset(59, 47),
      const Offset(63, 51),
      const Offset(60, 56),
      width: 1.6,
      color: const Color(0x8CFCD9C4),
      amp: 0.3,
    );
    final belt = Path()
      ..moveTo(46, 42.5)
      ..lineTo(54, 42.5)
      ..lineTo(54.5, 59.5)
      ..lineTo(45.5, 59.5)
      ..close();
    s.fillArea(belt, nori, amp: 0.4);
    s.ink(belt, width: 1.6, amp: 0.4);
    if (mood == CharacterMood.joy) {
      s.arm(const Offset(37, 66), 227, 6.5, width: 2.2);
      s.arm(const Offset(63, 66), 313, 6.5, width: 2.2);
    } else if (mood == CharacterMood.yum) {
      s.arm(const Offset(38, 67), 55, 5.5, bendDeg: 30, width: 2.2);
      s.arm(const Offset(62, 67), 125, 5.5, bendDeg: -30, width: 2.2);
    }
    if (mood == CharacterMood.yum) {
      s.eyeDot(const Offset(44.5, 67), 2.2);
      s.eyeArc(const Offset(55.5, 67), 2.2);
      s.mouthOoo(const Offset(50, 72.5), 1.5);
      s.blushTicks(const Offset(38, 70), s: 0.85);
      s.blushTicks(const Offset(62, 70), s: 0.85);
    } else if (mood == CharacterMood.joy) {
      s.eyeArc(const Offset(44.5, 67), 2.4);
      s.eyeArc(const Offset(55.5, 67), 2.4);
      s.mouthSmile(const Offset(50, 72.5), 5, curveDepth: 2.4);
      s.blushTicks(const Offset(38, 70), s: 0.85);
      s.blushTicks(const Offset(62, 70), s: 0.85);
    } else {
      s.eyeLid(const Offset(44.5, 67), 2.2);
      s.eyeLid(const Offset(55.5, 67), 2.2);
      s.mouthSmile(const Offset(50, 72.5), 3.6, curveDepth: 1.6);
      s.blushTicks(const Offset(38, 70), s: 0.8);
      s.blushTicks(const Offset(62, 70), s: 0.8);
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(72, 36), 2.2);
      case CharacterMood.joy:
        s.sparkleAround(const Offset(50, 40), 26, count: 4);
      case CharacterMood.yum:
        s.heart(const Offset(70, 38), 2.2);
      case CharacterMood.sleepy:
        s.zzz(const Offset(70, 36), s: 2.2);
      case CharacterMood.hype:
        s.ring(
          const Offset(50, 60),
          30,
          width: 1.6,
          color: const Color(0x59F6B84C),
          amp: 1.4,
        );
        s.sparkleAround(const Offset(50, 58), 33, count: 5);
    }
  }, pose: floating ? const MoodPose(dy: -8) : null);
}

const miso = FoodCharacter(
  id: 'miso',
  name: 'Miso',
  family: 'Noodle House',
  title: 'The Midnight Comforter',
  story:
      'Open latest, judges least. Miso keeps the broth warm for anyone who '
      'wanders in after a long day, and the noodle hair has heard everything.',
  accent: Color(0xFFCE4A3F),
  moodLore: {
    CharacterMood.signature: 'Steam up, door open, come in.',
    CharacterMood.joy: 'A regular came back. Broth overflowing.',
    CharacterMood.yum: 'Quality-slurping its own noodles.',
    CharacterMood.sleepy: 'Noodles down over one eye. Closing soon.',
    CharacterMood.hype: 'Chopstick drumroll for the last order!',
  },
  painter: _paintMiso,
);

void _paintMiso(Sketch s, CharacterMood mood) {
  const bowl = Color(0xFFF7EFE1);
  const bandRed = Color(0xFFCE4A3F);
  const noodle = Color(0xFFEFC15B);
  s.groundShadow(const Offset(50, 88), 19);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 81), spread: 13, len: 4.5);
    final droop = mood == CharacterMood.sleepy ? 6.0 : 0.0;
    for (var i = 0; i < 5; i++) {
      final x = 33.0 + i * 8.2;
      final loop = Path()
        ..moveTo(x, 49)
        ..cubicTo(
          x - 3,
          42 + droop * 0.4,
          x + 1,
          38 + droop + (i.isEven ? 0 : 2.4),
          x + 4,
          42 + droop * 0.5,
        )
        ..quadraticBezierTo(x + 6, 45, x + 6.4, 49);
      s.ink(loop, width: 3.1, color: noodle, amp: 0.5);
    }
    if (mood == CharacterMood.sleepy) {
      final strand = Path()
        ..moveTo(41, 49)
        ..cubicTo(39, 54, 40, 60, 41.5, 64);
      s.ink(strand, width: 3, color: noodle, amp: 0.4);
    }
    final naruto = Path()
      ..addOval(Rect.fromCircle(center: const Offset(37, 43), radius: 3.4));
    s.fillArea(naruto, Inks.cream, amp: 0.2);
    s.ink(naruto, width: 1.5, amp: 0.2);
    s.eyeSwirl(const Offset(37, 43), 1.9);
    final body = Path()
      ..moveTo(28, 50)
      ..lineTo(72, 50)
      ..cubicTo(72, 66, 65, 77, 56, 79)
      ..lineTo(57, 82.5)
      ..lineTo(43, 82.5)
      ..lineTo(44, 79)
      ..cubicTo(35, 77, 28, 66, 28, 50)
      ..close();
    s.fillArea(body, bowl);
    s.shade(body, lift: const Offset(-2.2, -2.6));
    s.ink(body, width: 2.8);
    final band = Path()
      ..moveTo(28.5, 53)
      ..lineTo(71.5, 53)
      ..lineTo(71, 57.5)
      ..lineTo(29, 57.5)
      ..close();
    s.fillArea(band, bandRed, amp: 0.4);
    final wave = Path()..moveTo(31, 55.4);
    for (var x = 31.0; x < 69; x += 6) {
      wave.quadraticBezierTo(x + 1.5, 53.4, x + 3, 55.4);
      wave.quadraticBezierTo(x + 4.5, 57.2, x + 6, 55.4);
    }
    s.ink(wave, width: 1.2, color: bowl, amp: 0.15);
    if (mood == CharacterMood.hype) {
      s.moodArms(mood, const Offset(30, 64), const Offset(70, 64), len: 8.5);
      final hand = s.polar(const Offset(70, 64), 335, 9.4);
      s.strokeLine(
        hand,
        hand + const Offset(3.6, -7.4),
        width: 1.8,
        color: const Color(0xFFB98A55),
      );
      s.strokeLine(
        hand + const Offset(1.8, 0.6),
        hand + const Offset(6.4, -6),
        width: 1.8,
        color: const Color(0xFFB98A55),
      );
    } else if (mood == CharacterMood.signature) {
      s.arm(const Offset(30, 64), 152, 8);
      s.arm(const Offset(70, 64), 28, 8);
      s.strokeLine(
        const Offset(60, 47),
        const Offset(76, 38),
        width: 1.8,
        color: const Color(0xFFB98A55),
      );
      s.strokeLine(
        const Offset(62, 49.5),
        const Offset(78, 41),
        width: 1.8,
        color: const Color(0xFFB98A55),
      );
    } else {
      s.moodArms(mood, const Offset(30, 64), const Offset(70, 64), len: 8);
    }
    if (mood == CharacterMood.sleepy) {
      s.eyeLid(const Offset(56.5, 64), 2.4);
      s.mouthOoo(const Offset(50, 70.5), 1.6);
      s.blushTicks(const Offset(40, 67), s: 0.85);
      s.blushTicks(const Offset(62, 67), s: 0.85);
    } else if (mood == CharacterMood.yum) {
      final slurp = Path()
        ..moveTo(49, 44)
        ..cubicTo(46, 52, 47, 60, 49.5, 67);
      s.ink(slurp, width: 2.8, color: noodle, amp: 0.4);
      s.eyeArc(const Offset(44.5, 63), 2.4);
      s.eyeArc(const Offset(55.5, 63), 2.4);
      s.mouthOoo(const Offset(50, 68.5), 1.8);
      s.blushTicks(const Offset(38, 66), s: 0.9);
      s.blushTicks(const Offset(62, 66), s: 0.9);
    } else {
      s.moodFace(
        const Offset(50, 63),
        mood,
        spread: 11,
        mouthDrop: 6.5,
        scale: 0.9,
      );
    }
    if (mood != CharacterMood.sleepy) {
      s.steam(const Offset(40, 36), h: 12, sway: 2.6);
      s.steam(const Offset(52, 33), h: 14, sway: 3);
      s.steam(const Offset(63, 37), h: 10, sway: 2.2);
    } else {
      s.steam(const Offset(58, 36), h: 9, sway: 2);
      s.zzz(const Offset(72, 30), s: 2.4);
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(24, 40), 2);
      case CharacterMood.joy:
        s.popTicks(const Offset(50, 30), 14, count: 6, color: Inks.sun);
      case CharacterMood.yum:
        s.heart(const Offset(70, 34), 2.4);
      case CharacterMood.sleepy:
        break;
      case CharacterMood.hype:
        s.popTicks(const Offset(50, 30), 13, count: 5);
        s.musicNote(const Offset(24, 34), s: 2.4);
    }
  });
}

const bao = FoodCharacter(
  id: 'bao',
  name: 'Bao',
  family: 'Noodle House',
  title: 'The Steamed Little Sibling',
  story:
      'Youngest in the kitchen, softest by a mile. Bao\'s topknot pleats '
      'boing when happy and the whole restaurant has learned to watch for it.',
  accent: Color(0xFFF2E3C9),
  moodLore: {
    CharacterMood.signature: 'Small wave. Big day.',
    CharacterMood.joy: 'Pleats fully boinged.',
    CharacterMood.yum: 'Got into the soy sauce again.',
    CharacterMood.sleepy: 'Melted into a mochi puddle.',
    CharacterMood.hype: 'Sugar rush. Nobody can catch the bun.',
  },
  painter: _paintBao,
  motion: MotionProfile(bounce: 1.35),
);

void _paintBao(Sketch s, CharacterMood mood) {
  const skin = Color(0xFFF2E3C9);
  const pleat = Color(0xFFC9A87C);
  final puddle = mood == CharacterMood.sleepy;
  s.groundShadow(const Offset(50, 88), puddle ? 20 : 15);
  s.posed(
    mood,
    () {
      if (!puddle) {
        s.legs(mood, const Offset(50, 80), spread: 11, len: 5);
      }
      final body = Path()
        ..moveTo(50, 34)
        ..cubicTo(63, 34, 70, 44, 70, 60)
        ..cubicTo(70, 74, 62, 82, 50, 82)
        ..cubicTo(38, 82, 30, 74, 30, 60)
        ..cubicTo(30, 44, 37, 34, 50, 34)
        ..close();
      s.fillArea(body, skin);
      s.shade(body, lift: const Offset(-2, -2.6));
      s.ink(body, width: 2.8);
      final boing = mood == CharacterMood.joy ? -2.4 : 0.0;
      for (var i = 0; i < 5; i++) {
        final a = -90.0 + (i - 2) * 26;
        final base = s.polar(const Offset(50, 37), a + 180, -6.5);
        final tip = s.polar(Offset(50, 30 + boing), a + 180, -1);
        s.curve(
          base,
          Offset((base.dx + tip.dx) / 2 + (i - 2) * 1.4, base.dy - 4),
          tip,
          width: 1.7,
          color: pleat,
          amp: 0.3,
        );
      }
      s.dot(Offset(50, 29.5 + boing), 2.2, color: pleat);
      if (mood == CharacterMood.signature) {
        s.arm(const Offset(33, 62), 152, 7.5, width: 2.3);
        s.arm(const Offset(67, 60), 300, 7.5, bendDeg: 14, width: 2.3);
      } else if (!puddle) {
        s.moodArms(
          mood,
          const Offset(33, 62),
          const Offset(67, 62),
          len: 7.5,
          width: 2.3,
        );
      }
      s.moodFace(
        const Offset(50, 56),
        mood,
        spread: 10,
        mouthDrop: 7.5,
        scale: 1.02,
      );
      if (mood == CharacterMood.yum) {
        s.dot(const Offset(63, 61), 1.7, color: const Color(0xFF6B4231));
      }
      switch (mood) {
        case CharacterMood.signature:
          s.sparkle(const Offset(72, 34), 2.2);
        case CharacterMood.joy:
          s.popTicks(Offset(50, 26 + boing), 8, count: 5);
        case CharacterMood.yum:
          s.heart(const Offset(71, 42), 2.4);
        case CharacterMood.sleepy:
          s.zzz(const Offset(69, 42), s: 2.4);
        case CharacterMood.hype:
          s.speedLines(const Offset(24, 62), 182, len: 9);
          s.sweat(const Offset(68, 40), s: 1.7);
      }
    },
    pose: puddle
        ? const MoodPose(dy: 7, sx: 1.22, sy: 0.72)
        : (mood == CharacterMood.joy ? const MoodPose(dy: -4, sy: 1.05) : null),
  );
}

const nori = FoodCharacter(
  id: 'nori',
  name: 'Nori',
  family: 'Noodle House',
  title: 'The Dependable Scout',
  story:
      'Packed, wrapped, ready since dawn. Nori is the friend who brings snacks '
      'for everyone and, when required, becomes briefly and adorably a ninja.',
  accent: Color(0xFF3A4A3E),
  moodLore: {
    CharacterMood.signature: 'Reporting for lunch duty.',
    CharacterMood.joy: 'Mission complete. Everyone ate.',
    CharacterMood.yum: 'Someone took a bite. It was Nori.',
    CharacterMood.sleepy: 'Off duty. Wrap loosened.',
    CharacterMood.hype: 'Ninja mode. Sesame shuriken deployed.',
  },
  painter: _paintNori,
  motion: MotionProfile(tempo: 1.2, style: PerformanceStyle.dash),
);

void _paintNori(Sketch s, CharacterMood mood) {
  const rice = Color(0xFFF8F2E8);
  const wrap = Color(0xFF3A4A3E);
  s.groundShadow(const Offset(50, 88), 16);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 78), spread: 11, len: 6);
    final body = Path()
      ..moveTo(50, 28)
      ..cubicTo(56, 28, 59, 32, 62, 40)
      ..cubicTo(66, 50, 70, 62, 70, 68)
      ..cubicTo(70, 76, 62, 79, 50, 79)
      ..cubicTo(38, 79, 30, 76, 30, 68)
      ..cubicTo(30, 62, 34, 50, 38, 40)
      ..cubicTo(41, 32, 44, 28, 50, 28)
      ..close();
    s.fillArea(body, rice);
    s.grain(body, dots: 14, color: const Color(0x30C9BCA4));
    s.ink(body, width: 2.8);
    if (mood == CharacterMood.yum) {
      final biteA = Path()
        ..addOval(Rect.fromCircle(center: const Offset(63, 37), radius: 4.6));
      final biteB = Path()
        ..addOval(Rect.fromCircle(center: const Offset(67, 43), radius: 3.8));
      s.fillArea(biteA, Inks.paper, amp: 0.3);
      s.fillArea(biteB, Inks.paper, amp: 0.3);
      s.ink(biteA, width: 2, amp: 0.3);
      s.ink(biteB, width: 2, amp: 0.3);
      s.dot(const Offset(73, 40), 0.8, color: rice);
      s.dot(const Offset(75, 46), 0.7, color: rice);
    }
    final loosen = mood == CharacterMood.sleepy ? 3.0 : 0.0;
    final vest = Path()
      ..moveTo(40, 60 + loosen)
      ..lineTo(60, 60 + loosen)
      ..lineTo(61.5, 78.5)
      ..lineTo(38.5, 78.5)
      ..close();
    s.fillArea(vest, wrap, amp: 0.4);
    s.ink(vest, width: 1.8, amp: 0.4);
    s.gleam(
      Offset(46, 70 + loosen),
      5,
      sweepDeg: 38,
      color: const Color(0x40FFFFFF),
    );
    if (mood == CharacterMood.signature) {
      s.arm(const Offset(35, 62), 152, 8);
      s.arm(const Offset(64, 56), 265, 7, bendDeg: -36);
    } else {
      s.moodArms(mood, const Offset(35, 62), const Offset(65, 62), len: 8);
    }
    if (mood == CharacterMood.hype) {
      final bandana = Path()
        ..moveTo(41, 42)
        ..quadraticBezierTo(50, 39.5, 59, 42)
        ..lineTo(58.5, 45.4)
        ..quadraticBezierTo(50, 43, 41.5, 45.4)
        ..close();
      s.fillArea(bandana, Inks.rose, amp: 0.3);
      s.ink(bandana, width: 1.4, amp: 0.3);
      s.strokeLine(const Offset(59, 43), const Offset(64.5, 41), width: 1.5);
      s.strokeLine(const Offset(59, 44), const Offset(65, 45), width: 1.5);
      s.eyeDot(const Offset(45, 51), 2.3);
      s.eyeDot(const Offset(55, 51), 2.3);
      s.mouthCat(const Offset(50, 58), 6);
      s.blushTicks(const Offset(39, 54), s: 0.85);
      s.blushTicks(const Offset(61, 54), s: 0.85);
    } else {
      s.moodFace(
        const Offset(50, 51),
        mood,
        spread: 10,
        mouthDrop: 7,
        scale: 0.92,
      );
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(73, 30), 2.2);
      case CharacterMood.joy:
        s.popTicks(const Offset(50, 24), 9, count: 5);
        s.sparkleAround(
          const Offset(50, 50),
          27,
          count: 3,
          color: const Color(0xFFD9CDB4),
        );
      case CharacterMood.yum:
        s.heart(const Offset(28, 36), 2.3);
      case CharacterMood.sleepy:
        s.zzz(const Offset(70, 32));
      case CharacterMood.hype:
        for (final star in const [
          Offset(26, 34),
          Offset(31, 24),
          Offset(72, 22),
        ]) {
          s.dot(star, 1.1);
          s.speedLines(
            star + const Offset(4, 1),
            0,
            count: 1,
            len: 3.4,
            width: 1.2,
          );
        }
        s.speedLines(const Offset(24, 60), 183, len: 9);
    }
  });
}

const pearl = FoodCharacter(
  id: 'pearl',
  name: 'Pearl',
  family: 'Noodle House',
  title: 'The Bubbly Insider',
  story:
      'Hears every order and remembers every birthday. Pearl sips its own '
      'straw when thinking, which everyone agrees should not work, and does.',
  accent: Color(0xFFE3B98C),
  moodLore: {
    CharacterMood.signature: 'Thinking. Sipping. Same thing.',
    CharacterMood.joy: 'The pearls are doing a little dance.',
    CharacterMood.yum: 'Bottom-of-the-cup pearls. The good ones.',
    CharacterMood.sleepy: 'Pearls settled. Lid half shut.',
    CharacterMood.hype: 'DO NOT SHAKE THE— too late.',
  },
  painter: _paintPearl,
  motion: MotionProfile(style: PerformanceStyle.shake),
);

void _paintPearl(Sketch s, CharacterMood mood) {
  const tea = Color(0xFFE3B98C);
  const foam = Color(0xFFF3DFC4);
  const tapioca = Color(0xFF4A3428);
  const strawPink = Color(0xFFE8798F);
  final shaken = mood == CharacterMood.hype || s.performing;
  s.groundShadow(const Offset(50, 88), 16);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 80), spread: 11, len: 5.5);
    final cup = Path()
      ..moveTo(37, 36)
      ..lineTo(63, 36)
      ..lineTo(61, 78)
      ..quadraticBezierTo(50, 81, 39, 78)
      ..close();
    s.fillArea(cup, tea);
    s.ink(cup, width: 2.7);
    final foamBand = Path()
      ..moveTo(37.4, 36.5)
      ..lineTo(62.6, 36.5)
      ..lineTo(62.2, 45)
      ..quadraticBezierTo(50, 47.5, 37.8, 45)
      ..close();
    s.fillArea(foamBand, foam, amp: 0.5);
    final pearlsAt = shaken
        ? const [
            Offset(43, 42),
            Offset(56, 40),
            Offset(48, 52),
            Offset(59, 57),
            Offset(42, 62),
            Offset(52, 68),
            Offset(45, 74),
            Offset(57, 72),
          ]
        : mood == CharacterMood.joy
        ? const [
            Offset(43, 58),
            Offset(52, 54),
            Offset(59, 60),
            Offset(42, 68),
            Offset(50, 64),
            Offset(58, 68),
            Offset(45, 74),
            Offset(54, 73),
          ]
        : const [
            Offset(42, 70),
            Offset(48, 67),
            Offset(55, 69),
            Offset(59, 73),
            Offset(44, 75),
            Offset(51, 73),
            Offset(57, 76.5),
            Offset(47, 77.5),
          ];
    for (var i = 0; i < pearlsAt.length; i++) {
      final swirl = s.performing
          ? Offset(0, math.sin(s.perfT * 2 * math.pi + i * 1.1) * 1.9)
          : Offset.zero;
      final p = pearlsAt[i] + swirl;
      s.dot(p, 2.15, color: tapioca);
      s.dot(p + const Offset(-0.6, -0.6), 0.5, color: const Color(0x59FFFFFF));
    }
    s.shade(cup, lift: const Offset(-2, -2.4));
    final tilt = mood == CharacterMood.sleepy ? 1.8 : 0.0;
    final lid = Path()
      ..moveTo(34.5, 36 + tilt)
      ..quadraticBezierTo(50, 26.5 + tilt * 0.4, 65.5, 36)
      ..close();
    s.fillArea(lid, const Color(0xFFF6F1E6), amp: 0.5);
    s.ink(lid, width: 2.4, amp: 0.5);
    s.gleam(const Offset(44, 33), 4, sweepDeg: 40);
    if (mood == CharacterMood.signature) {
      final straw = Path()
        ..moveTo(56, 30)
        ..cubicTo(61, 23.5, 66.5, 30, 61, 38)
        ..quadraticBezierTo(57.5, 43, 54.5, 51);
      s.ink(straw, width: 4.4, amp: 0.2);
      s.ink(straw, width: 2.6, color: strawPink, amp: 0.2);
    } else {
      final straw = Path()
        ..moveTo(56, 31)
        ..lineTo(61.5, 14);
      s.ink(straw, width: 5, amp: 0.2);
      s.ink(straw, width: 3, color: strawPink, amp: 0.2);
      s.strokeLine(
        const Offset(59.4, 20),
        const Offset(63.6, 21.4),
        width: 1.2,
        color: Inks.cream,
        amp: 0.1,
      );
    }
    if (mood == CharacterMood.signature) {
      s.arm(const Offset(38, 58), 152, 8);
      s.arm(const Offset(62, 56), 335, 7, bendDeg: 24);
    } else {
      s.moodArms(mood, const Offset(38, 58), const Offset(62, 58), len: 8);
    }
    if (mood == CharacterMood.signature) {
      s.eyeLid(const Offset(45, 52), 2.3);
      s.eyeLid(const Offset(54, 52), 2.3);
      s.mouthOoo(const Offset(53.5, 54), 1.1);
      s.blushTicks(const Offset(41, 57), s: 0.85);
      s.blushTicks(const Offset(60, 58), s: 0.85);
    } else {
      s.moodFace(
        const Offset(50, 53),
        mood,
        spread: 10,
        mouthDrop: 6.5,
        scale: 0.88,
      );
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(28, 34), 2.2);
      case CharacterMood.joy:
        s.popTicks(const Offset(50, 24), 9, count: 5);
      case CharacterMood.yum:
        s.heart(const Offset(30, 40), 2.4);
      case CharacterMood.sleepy:
        s.zzz(const Offset(70, 26));
      case CharacterMood.hype:
        s.speedLines(const Offset(26, 56), 182, len: 8);
        for (final fizz in const [
          Offset(68, 26),
          Offset(73, 34),
          Offset(66, 18),
        ]) {
          s.dot(fizz, 1.1, color: const Color(0x8CE3B98C));
          s.ring(fizz, 2, width: 0.9, color: Inks.inkFaint);
        }
        s.sweat(const Offset(31, 30), s: 1.7);
    }
  });
}
