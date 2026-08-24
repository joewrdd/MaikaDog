import 'dart:ui';

import '../core/food_character.dart';
import '../core/sketch.dart';

const pantryPals = CharacterFamily(
  name: 'Pantry Pals',
  tagline: 'Steadfast staples with stories to tell.',
  slug: 'pantry_pals',
  members: [fizz, brie, amber, melone, malt],
);

const fizz = FoodCharacter(
  id: 'fizz',
  name: 'Fizz',
  family: 'Pantry Pals',
  title: 'The Carbonated Chaos',
  story:
      'Ninety-nine percent enthusiasm under pressure. The pull-tab antenna '
      'picks up excitement from three aisles away, and Fizz answers every call.',
  accent: Color(0xFFD8452E),
  moodLore: {
    CharacterMood.signature: 'Bubbling within acceptable limits.',
    CharacterMood.joy: 'The bubbles heard the good news.',
    CharacterMood.yum: 'Cold. Crisp. Correct.',
    CharacterMood.sleepy: 'Gone flat. Antenna included.',
    CharacterMood.hype: 'SOMEONE SHOOK THE CAN. IT WAS FIZZ.',
  },
  painter: _paintFizz,
  motion: MotionProfile(
    tempo: 1.5,
    bounce: 1.15,
    style: PerformanceStyle.shake,
  ),
);

void _paintFizz(Sketch s, CharacterMood mood) {
  const canRed = Color(0xFFD8452E);
  const silver = Color(0xFFC9CFD9);
  final flat = mood == CharacterMood.sleepy;
  final burst = mood == CharacterMood.hype || s.performing;
  final blast = s.performing ? bell(s.perfT) : 1.0;
  s.groundShadow(const Offset(50, 88), 15);
  s.posed(
    mood,
    () {
      s.legs(mood, const Offset(50, 80), spread: 11, len: 5.5);
      final body = Path()
        ..moveTo(37, 36)
        ..lineTo(63, 36)
        ..quadraticBezierTo(64.5, 37, 64, 40)
        ..lineTo(63.5, 74)
        ..quadraticBezierTo(63, 79.5, 50, 79.5)
        ..quadraticBezierTo(37, 79.5, 36.5, 74)
        ..lineTo(36, 40)
        ..quadraticBezierTo(35.5, 37, 37, 36)
        ..close();
      s.fillArea(body, canRed);
      s.shade(body, lift: const Offset(-2, -2.4));
      s.ink(body, width: 2.8);
      final wave = Path()
        ..moveTo(36.5, 64)
        ..cubicTo(43, 60, 57, 68, 63.5, 63);
      s.ink(wave, width: 2.6, color: Inks.cream, amp: 0.4);
      s.gleam(
        const Offset(42, 52),
        9,
        sweepDeg: 34,
        color: const Color(0x66FFFFFF),
      );
      final lid = Path()
        ..addOval(
          Rect.fromCenter(
            center: const Offset(50, 35.5),
            width: 27,
            height: 6.4,
          ),
        );
      s.fillArea(lid, silver);
      s.ink(lid, width: 2.2);
      if (flat) {
        s.strokeLine(const Offset(52, 33.5), const Offset(58, 30), width: 1.9);
        s.ring(const Offset(60, 29), 2, width: 1.6);
      } else {
        s.strokeLine(const Offset(52, 33.5), const Offset(54, 25), width: 1.9);
        s.ring(const Offset(54.5, 23), 2.2, width: 1.6);
      }
      s.moodArms(mood, const Offset(37, 58), const Offset(63, 58), len: 8.5);
      s.moodFace(
        const Offset(50, 51),
        mood,
        spread: 10,
        mouthDrop: 6.5,
        scale: 0.9,
      );
      if (burst && blast > 0.08) {
        for (final spray in const [
          [Offset(44, 22), Offset(36, 12)],
          [Offset(50, 21), Offset(50, 9)],
          [Offset(56, 22), Offset(64, 12)],
        ]) {
          final tipAt = Offset.lerp(spray[0], spray[1], blast)!;
          s.strokeLine(
            spray[0],
            tipAt,
            width: 2,
            color: const Color(0x8C7FB5D8),
            amp: 0.6,
          );
          s.dot(tipAt + const Offset(0, -2), 1.3, color: Inks.sky);
        }
        s.sweat(const Offset(31, 40), s: 1.7);
        s.speedLines(const Offset(26, 60), 182, len: 8);
      } else if (!flat) {
        final rising = mood == CharacterMood.joy
            ? const [
                Offset(28, 46),
                Offset(24, 34),
                Offset(30, 24),
                Offset(70, 42),
                Offset(75, 30),
                Offset(70, 20),
              ]
            : const [Offset(28, 44), Offset(25, 32), Offset(72, 38)];
        for (var i = 0; i < rising.length; i++) {
          s.ring(
            rising[i],
            1.4 + (i % 3) * 0.5,
            width: 1.1,
            color: Inks.inkSoft,
          );
        }
      }
      switch (mood) {
        case CharacterMood.signature:
          s.sparkle(const Offset(73, 28), 2.2);
        case CharacterMood.joy:
          s.popTicks(const Offset(50, 20), 9, count: 5);
        case CharacterMood.yum:
          s.heart(const Offset(71, 40), 2.4);
        case CharacterMood.sleepy:
          s.zzz(const Offset(70, 30));
        case CharacterMood.hype:
          break;
      }
    },
    pose: flat ? const MoodPose(dy: 2.4, rot: -0.05, sy: 0.92, sx: 1.04) : null,
  );
}

const brie = FoodCharacter(
  id: 'brie',
  name: 'Brie',
  family: 'Pantry Pals',
  title: 'The Distinguished Wedge',
  story:
      'Aged eighteen months, acts eighty. Brie pairs everything with grapes, '
      'grades every board out of ten, and loses the monocle only to joy.',
  accent: Color(0xFFF5C64C),
  moodLore: {
    CharacterMood.signature: 'Presenting today\'s pairing. A humble grape.',
    CharacterMood.joy: 'The monocle has LEFT. It is that good.',
    CharacterMood.yum: 'Inhaling the bouquet. Magnifique.',
    CharacterMood.sleepy: 'Cellar hours. Aging, technically working.',
    CharacterMood.hype: 'The good crackers are OUT.',
  },
  painter: _paintBrie,
  motion: MotionProfile(tempo: 0.9, style: PerformanceStyle.pop),
);

void _paintBrie(Sketch s, CharacterMood mood) {
  const cheese = Color(0xFFF5C64C);
  const holeTone = Color(0xFFD9A32E);
  s.groundShadow(const Offset(50, 88), 17);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 78), spread: 12, len: 6);
    final body = Path()
      ..moveTo(50, 30)
      ..cubicTo(55, 30, 58, 34, 61, 42)
      ..cubicTo(65, 52, 70, 66, 70, 72)
      ..quadraticBezierTo(70, 78.5, 50, 78.5)
      ..quadraticBezierTo(30, 78.5, 30, 72)
      ..cubicTo(30, 66, 35, 52, 39, 42)
      ..cubicTo(42, 34, 45, 30, 50, 30)
      ..close();
    s.fillArea(body, cheese);
    s.shade(body, lift: const Offset(-2.2, -2.8));
    s.grain(body, dots: 7);
    s.ink(body, width: 2.8);
    for (final hole in const [
      [Offset(41, 64), 3.2],
      [Offset(57, 68), 2.7],
      [Offset(49, 73), 2.1],
    ]) {
      final pocket = Path()
        ..addOval(
          Rect.fromCircle(center: hole[0] as Offset, radius: hole[1] as double),
        );
      s.fillArea(pocket, holeTone, amp: 0.25);
      s.ink(pocket, width: 1.5, amp: 0.25, color: const Color(0x8C8F5E12));
    }
    if (mood == CharacterMood.signature) {
      s.arm(const Offset(36, 56), 152, 8);
      s.arm(const Offset(64, 54), 330, 9, bendDeg: 16);
      final hand = s.polar(const Offset(64, 54), 330, 9);
      for (final grape in [
        hand + const Offset(1.4, -3.4),
        hand + const Offset(3.6, -1),
        hand + const Offset(0.4, -0.4),
      ]) {
        s.dot(grape, 1.9, color: const Color(0xFF7C5AA0));
        s.dot(
          grape + const Offset(-0.5, -0.5),
          0.5,
          color: const Color(0x8CFFFFFF),
        );
      }
    } else {
      s.moodArms(mood, const Offset(36, 58), const Offset(64, 58), len: 8.5);
    }
    if (mood == CharacterMood.yum) {
      s.eyeArc(const Offset(45, 52), 2.4);
      s.eyeArc(const Offset(55, 52), 2.4);
      s.mouthOoo(const Offset(50, 59), 1.4);
      s.blushTicks(const Offset(38.5, 55), s: 0.85);
      s.blushTicks(const Offset(61.5, 55), s: 0.85);
      s.steam(const Offset(62, 46), h: 9, sway: 2.2);
      s.steam(const Offset(67, 50), h: 7, sway: 1.8);
    } else {
      s.moodFace(
        const Offset(50, 52),
        mood,
        spread: 10,
        mouthDrop: 7,
        scale: 0.92,
      );
    }
    final popped =
        mood == CharacterMood.joy ||
        (s.performing && s.perfT > 0.25 && s.perfT < 0.8);
    final slide = mood == CharacterMood.sleepy ? 2.2 : 0.0;
    final monocleAt = popped ? const Offset(68, 38) : Offset(55, 52.6 + slide);
    s.ring(monocleAt, 3.6, width: 1.8);
    if (popped) {
      s.curve(
        const Offset(60, 56),
        const Offset(66, 50),
        monocleAt + const Offset(-1, 3.4),
        width: 1.2,
        amp: 0.8,
      );
      s.popTicks(monocleAt, 5.4, count: 4, len: 2, width: 1.2);
    } else {
      s.curve(
        monocleAt + const Offset(3.4, 1),
        monocleAt + const Offset(6.4, 6),
        monocleAt + const Offset(6, 10),
        width: 1.2,
        amp: 0.4,
      );
    }
    final bow = Path()
      ..moveTo(50, 74.5)
      ..lineTo(45.4, 72.2)
      ..lineTo(45.4, 77)
      ..close()
      ..moveTo(50, 74.5)
      ..lineTo(54.6, 72.2)
      ..lineTo(54.6, 77)
      ..close();
    s.fillArea(bow, Inks.rose, amp: 0.2);
    s.ink(bow, width: 1.3, amp: 0.2);
    s.dot(const Offset(50, 74.5), 1.2);
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(28, 36), 2.2);
      case CharacterMood.joy:
        s.popTicks(const Offset(50, 26), 10, count: 5);
      case CharacterMood.yum:
        s.sparkleAround(const Offset(50, 40), 22, count: 3);
      case CharacterMood.sleepy:
        s.zzz(const Offset(70, 30));
      case CharacterMood.hype:
        s.speedLines(const Offset(25, 58), 183, len: 8);
        s.sparkle(const Offset(73, 26), 2.5);
    }
  });
}

const amber = FoodCharacter(
  id: 'amber',
  name: 'Amber',
  family: 'Pantry Pals',
  title: 'The Slow Golden Healer',
  story:
      'Everything Amber says takes a while to arrive and is worth the wait. '
      'The bee is named Bumble, works part-time, and sleeps on the lid.',
  accent: Color(0xFFEFB33C),
  moodLore: {
    CharacterMood.signature: 'Dipper up. A spoonful for whoever needs it.',
    CharacterMood.joy: 'Bumble is doing celebration laps.',
    CharacterMood.yum: 'The honey came out heart-shaped. Again.',
    CharacterMood.sleepy: 'Both of them are out. Bumble on the lid.',
    CharacterMood.hype: 'Fresh batch! Bumble, sound the alarm!',
  },
  painter: _paintAmber,
);

void _paintAmber(Sketch s, CharacterMood mood) {
  const honey = Color(0xFFEFB33C);
  const lidCloth = Color(0xFFF6EBDD);
  s.groundShadow(const Offset(50, 88), 15);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 80), spread: 11, len: 5.5);
    final jar = Path()
      ..moveTo(38, 42)
      ..quadraticBezierTo(36, 46, 36.5, 54)
      ..lineTo(37, 72)
      ..quadraticBezierTo(37.5, 79.5, 50, 79.5)
      ..quadraticBezierTo(62.5, 79.5, 63, 72)
      ..lineTo(63.5, 54)
      ..quadraticBezierTo(64, 46, 62, 42)
      ..close();
    s.fillArea(jar, honey);
    s.shade(jar, lift: const Offset(-2, -2.4));
    s.ink(jar, width: 2.8);
    s.strokeLine(
      const Offset(40.5, 47),
      const Offset(40.5, 70),
      width: 1.8,
      color: const Color(0x59FFF1CC),
      amp: 0.4,
    );
    s.strokeLine(
      const Offset(59, 47),
      const Offset(59, 66),
      width: 1.4,
      color: const Color(0x40FFF1CC),
      amp: 0.4,
    );
    final cap = Path()
      ..moveTo(35, 42.5)
      ..quadraticBezierTo(35, 34, 41, 33)
      ..quadraticBezierTo(50, 31.5, 59, 33)
      ..quadraticBezierTo(65, 34, 65, 42.5)
      ..close();
    s.fillArea(cap, lidCloth);
    s.hatch(
      cap,
      angleDeg: 0,
      gap: 4.2,
      width: 1.1,
      color: const Color(0x66D06A55),
    );
    s.hatch(
      cap,
      angleDeg: 90,
      gap: 4.2,
      width: 1.1,
      color: const Color(0x66D06A55),
    );
    s.ink(cap, width: 2.4);
    if (mood == CharacterMood.signature || mood == CharacterMood.yum) {
      s.arm(const Offset(37, 58), 152, 8);
      s.arm(const Offset(63, 56), 315, 8.5, bendDeg: 18);
      final hand = s.polar(const Offset(63, 56), 315, 8.5);
      s.strokeLine(hand, hand + const Offset(2, -6.4), width: 1.7);
      for (var i = 0; i < 3; i++) {
        s.strokeLine(
          hand + Offset(0.2 + i * 0.7, -6.4 - i * 1.7),
          hand + Offset(4 + i * 0.7, -6.4 - i * 1.7),
          width: 1.7,
          amp: 0.15,
        );
      }
      if (mood == CharacterMood.yum) {
        s.heart(hand + const Offset(2.6, -1.4), 2, color: honey);
      } else {
        final bead = Path()
          ..moveTo(hand.dx + 2.2, hand.dy - 4)
          ..quadraticBezierTo(
            hand.dx + 3.4,
            hand.dy - 1,
            hand.dx + 2.2,
            hand.dy + 0.4,
          )
          ..quadraticBezierTo(
            hand.dx + 1,
            hand.dy - 1,
            hand.dx + 2.2,
            hand.dy - 4,
          )
          ..close();
        s.fillArea(bead, honey, amp: 0.15);
        s.ink(bead, width: 1.1, amp: 0.15, color: const Color(0x8CB8830F));
      }
    } else {
      s.moodArms(mood, const Offset(37, 58), const Offset(63, 58), len: 8.5);
    }
    s.moodFace(
      const Offset(50, 56),
      mood,
      spread: 10,
      mouthDrop: 7,
      scale: 0.92,
    );
    final beeAt = switch (mood) {
      CharacterMood.sleepy => const Offset(55, 29),
      CharacterMood.joy => const Offset(27, 26),
      CharacterMood.hype => const Offset(70, 22),
      _ => const Offset(29, 34),
    };
    final beeBody = Path()
      ..addOval(Rect.fromCenter(center: beeAt, width: 6, height: 4.4));
    s.fillArea(beeBody, Inks.sun, amp: 0.15);
    s.ink(beeBody, width: 1.2, amp: 0.15);
    s.strokeLine(
      beeAt + const Offset(-0.9, -2),
      beeAt + const Offset(-0.9, 2),
      width: 1.1,
    );
    s.strokeLine(
      beeAt + const Offset(0.9, -2),
      beeAt + const Offset(0.9, 2),
      width: 1.1,
    );
    if (mood != CharacterMood.sleepy) {
      s.dot(
        beeAt + const Offset(-1, -3.2),
        1.4,
        color: const Color(0xB8FFFFFF),
      );
      s.dot(
        beeAt + const Offset(1.2, -3.2),
        1.4,
        color: const Color(0xB8FFFFFF),
      );
    }
    switch (mood) {
      case CharacterMood.signature:
        s.curve(
          beeAt + const Offset(4, 3),
          beeAt + const Offset(9, 6),
          beeAt + const Offset(11, 11),
          width: 1,
          color: Inks.inkFaint,
          amp: 0.6,
        );
      case CharacterMood.joy:
        s.ring(
          beeAt + const Offset(6, 2),
          4.6,
          width: 1,
          color: Inks.inkFaint,
          amp: 1,
        );
        s.popTicks(const Offset(50, 26), 9, count: 5);
      case CharacterMood.yum:
        s.heart(const Offset(29, 42), 2.2);
      case CharacterMood.sleepy:
        s.zzz(const Offset(66, 22), s: 1.7);
        s.zzz(const Offset(74, 40));
      case CharacterMood.hype:
        s.speedLines(
          beeAt + const Offset(6, 0),
          0,
          count: 2,
          len: 4,
          width: 1.2,
        );
        s.speedLines(const Offset(26, 58), 182, len: 8);
        s.sparkle(const Offset(30, 26), 2.2);
    }
  });
}

const melone = FoodCharacter(
  id: 'melone',
  name: 'Melone',
  family: 'Pantry Pals',
  title: 'The Permanent Summer',
  story:
      'Keeps beach energy in stock all year. Melone\'s seeds are strictly '
      'decorative until hype strikes, at which point one becomes a projectile.',
  accent: Color(0xFFE85C4E),
  moodLore: {
    CharacterMood.signature: 'Off-duty lifeguard posture.',
    CharacterMood.joy: 'Juice levels: fountain.',
    CharacterMood.yum: 'Peak ripeness confirmed.',
    CharacterMood.sleepy: 'Shade found. Summer paused.',
    CharacterMood.hype: 'Seed away! PTOO.',
  },
  painter: _paintMelone,
  motion: MotionProfile(style: PerformanceStyle.pop),
);

void _paintMelone(Sketch s, CharacterMood mood) {
  const flesh = Color(0xFFE85C4E);
  const rindGreen = Color(0xFF57A05C);
  const rindPale = Color(0xFFDFF0B8);
  s.groundShadow(const Offset(50, 88), 18);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 79), spread: 12, len: 5.5);
    final slice = Path()
      ..moveTo(29, 48)
      ..lineTo(71, 48)
      ..cubicTo(71, 66, 63, 80, 50, 80)
      ..cubicTo(37, 80, 29, 66, 29, 48)
      ..close();
    s.fillArea(slice, flesh);
    s.shade(slice, lift: const Offset(-2, -2.6));
    s.grain(slice, dots: 8, color: const Color(0x26B03A2E));
    s.ink(slice, width: 2.8);
    final rind = Path()
      ..moveTo(29.5, 57)
      ..cubicTo(31, 70, 39, 79.4, 50, 79.4)
      ..cubicTo(61, 79.4, 69, 70, 70.5, 57)
      ..cubicTo(67, 72, 60, 76.4, 50, 76.4)
      ..cubicTo(40, 76.4, 33, 72, 29.5, 57)
      ..close();
    s.fillArea(rind, rindGreen, amp: 0.5);
    s.ink(rind, width: 2, amp: 0.5);
    s.curve(
      const Offset(31, 58),
      const Offset(40, 74),
      const Offset(50, 75),
      width: 1.6,
      color: rindPale,
      amp: 0.4,
    );
    s.curve(
      const Offset(50, 75),
      const Offset(60, 74),
      const Offset(69, 58),
      width: 1.6,
      color: rindPale,
      amp: 0.4,
    );
    for (final seed in const [
      Offset(39, 55),
      Offset(61, 55),
      Offset(44, 66),
      Offset(56, 66),
    ]) {
      final pip = Path()
        ..moveTo(seed.dx, seed.dy - 1.7)
        ..quadraticBezierTo(seed.dx + 1.5, seed.dy, seed.dx, seed.dy + 1.7)
        ..quadraticBezierTo(seed.dx - 1.5, seed.dy, seed.dx, seed.dy - 1.7)
        ..close();
      s.fillArea(pip, Inks.ink, amp: 0.1);
    }
    s.moodArms(mood, const Offset(32, 60), const Offset(68, 60), len: 8.5);
    if (mood == CharacterMood.signature) {
      s.eyeLid(const Offset(45, 56), 2.3);
      s.eyeLid(const Offset(55, 56), 2.3);
      s.mouthSmile(const Offset(50, 62.5), 5.6, curveDepth: 2.4);
      s.blushTicks(const Offset(38.5, 59), s: 0.85);
      s.blushTicks(const Offset(61.5, 59), s: 0.85);
    } else if (mood == CharacterMood.hype) {
      s.eyeDot(const Offset(45, 56), 2.4);
      s.eyeWink(const Offset(56, 56), 2.5);
      s.mouthOoo(const Offset(51, 62.5), 1.8);
      s.blushTicks(const Offset(38.5, 59), s: 0.85);
      s.blushTicks(const Offset(61.5, 59), s: 0.85);
    } else {
      s.moodFace(
        const Offset(50, 56),
        mood,
        spread: 10,
        mouthDrop: 6.5,
        scale: 0.9,
      );
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(73, 36), 2.3);
        s.popTicks(
          const Offset(76, 24),
          3,
          count: 3,
          len: 2.2,
          color: Inks.sun,
          startDeg: -160,
          endDeg: -60,
          width: 1.3,
        );
        s.dot(const Offset(76, 24), 2.6, color: Inks.sun);
      case CharacterMood.joy:
        for (final drop in const [
          Offset(30, 36),
          Offset(38, 28),
          Offset(66, 30),
        ]) {
          s.sweat(drop, s: 1.4);
        }
        s.popTicks(const Offset(50, 38), 10, count: 5);
      case CharacterMood.yum:
        s.strokeLine(
          const Offset(52.5, 65),
          const Offset(53.5, 69.5),
          width: 1.8,
          color: const Color(0xFFF6A399),
        );
        s.heart(const Offset(72, 40), 2.4);
      case CharacterMood.sleepy:
        s.zzz(const Offset(71, 34));
      case CharacterMood.hype:
        final flying = Path()
          ..moveTo(63, 60)
          ..quadraticBezierTo(64.8, 61.2, 66.4, 60)
          ..quadraticBezierTo(64.8, 58.8, 63, 60)
          ..close();
        s.fillArea(flying.shift(const Offset(6, -4)), Inks.ink, amp: 0.1);
        s.speedLines(const Offset(60, 57), 340, count: 2, len: 5, width: 1.3);
        s.strokeLine(const Offset(74, 52), const Offset(78, 50), width: 1.5);
    }
  });
}

const malt = FoodCharacter(
  id: 'malt',
  name: 'Malt',
  family: 'Pantry Pals',
  title: 'The Two-Straw Philosopher',
  story:
      'Came with two straws and treats that as a moral position. Malt has '
      'never finished a shake alone and does not intend to start.',
  accent: Color(0xFFF5C7D6),
  moodLore: {
    CharacterMood.signature: 'Second straw extended. It is for you.',
    CharacterMood.joy: 'Cherry bounce! Somebody said yes.',
    CharacterMood.yum: 'Whipped cream on the nose. Worth it.',
    CharacterMood.sleepy: 'Both straws off duty.',
    CharacterMood.hype: 'Double-straw turbo. Share FASTER.',
  },
  painter: _paintMalt,
);

void _paintMalt(Sketch s, CharacterMood mood) {
  const shake = Color(0xFFF5C7D6);
  const whip = Color(0xFFF8EFE6);
  s.groundShadow(const Offset(50, 88), 14);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 80), spread: 10, len: 5.5);
    final glass = Path()
      ..moveTo(38, 36)
      ..lineTo(62, 36)
      ..lineTo(59.5, 76)
      ..quadraticBezierTo(50, 78.5, 40.5, 76)
      ..close();
    s.fillArea(glass, shake);
    s.shade(
      glass,
      lift: const Offset(-1.8, -2.2),
      color: const Color(0x21C77E96),
    );
    s.ink(glass, width: 2.8);
    s.strokeLine(
      const Offset(42, 41),
      const Offset(43.5, 70),
      width: 1.8,
      color: const Color(0x73FFFFFF),
      amp: 0.4,
    );
    final slump = mood == CharacterMood.sleepy ? 2.6 : 0.0;
    var cloud = Path()
      ..addOval(
        Rect.fromCenter(center: Offset(43, 32 + slump), width: 15, height: 10),
      );
    cloud = Path.combine(
      PathOperation.union,
      cloud,
      Path()..addOval(
        Rect.fromCenter(
          center: Offset(50, 28.5 + slump * 1.4),
          width: 16,
          height: 11,
        ),
      ),
    );
    cloud = Path.combine(
      PathOperation.union,
      cloud,
      Path()..addOval(
        Rect.fromCenter(center: Offset(57, 32 + slump), width: 14, height: 10),
      ),
    );
    s.fillArea(cloud, whip);
    s.shade(
      cloud,
      lift: const Offset(-1.6, -2),
      color: const Color(0x1CC9A24C),
    );
    s.ink(cloud, width: 2.4);
    final bounce = mood == CharacterMood.joy ? -5.0 : 0.0;
    s.dot(
      Offset(50, 21.4 + slump * 2 + bounce),
      2.7,
      color: const Color(0xFFD8452E),
    );
    s.gleam(
      Offset(49.2, 20.6 + slump * 2 + bounce),
      1.3,
      sweepDeg: 70,
      width: 1,
    );
    s.curve(
      Offset(50, 18.8 + slump * 2 + bounce),
      Offset(51.4, 15.8 + slump * 2 + bounce),
      Offset(53.4, 14.6 + slump * 2 + bounce),
      width: 1.4,
      color: Inks.leafDeep,
    );
    final crossed = mood == CharacterMood.sleepy;
    final strawL = Path()
      ..moveTo(44, 29 + slump)
      ..lineTo(crossed ? 52 : 38.5, crossed ? 16 : 13.5);
    final strawR = Path()
      ..moveTo(56, 29 + slump)
      ..lineTo(crossed ? 48 : 62.5, crossed ? 15 : 14);
    for (final side in [
      [strawL, Inks.rose],
      [strawR, Inks.sky],
    ]) {
      s.ink(side[0] as Path, width: 4.2, amp: 0.15);
      s.ink(side[0] as Path, width: 2.4, color: side[1] as Color, amp: 0.15);
    }
    if (mood == CharacterMood.signature) {
      s.arm(const Offset(39, 56), 152, 8);
      s.arm(const Offset(61, 54), 340, 10, bendDeg: -14);
      final hand = s.polar(const Offset(61, 54), 340, 10);
      final offered = Path()
        ..moveTo(hand.dx, hand.dy)
        ..lineTo(hand.dx + 3.4, hand.dy - 8);
      s.ink(offered, width: 3.6, amp: 0.15);
      s.ink(offered, width: 2, color: Inks.sky, amp: 0.15);
    } else {
      s.moodArms(mood, const Offset(39, 56), const Offset(61, 56), len: 8);
    }
    s.moodFace(
      const Offset(50, 52),
      mood,
      spread: 9.5,
      mouthDrop: 6.5,
      scale: 0.88,
    );
    if (mood == CharacterMood.yum) {
      s.dot(const Offset(50, 48), 1.9, color: whip);
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(28, 32), 2.2);
      case CharacterMood.joy:
        s.popTicks(Offset(50, 16 + bounce), 7, count: 5);
      case CharacterMood.yum:
        s.heart(const Offset(70, 38), 2.4);
      case CharacterMood.sleepy:
        s.zzz(const Offset(70, 26));
      case CharacterMood.hype:
        s.speedLines(const Offset(27, 56), 182, len: 8);
        for (final bub in const [
          Offset(46, 62),
          Offset(53, 58),
          Offset(49, 68),
        ]) {
          s.ring(bub, 1.5, width: 1, color: const Color(0x8CFFFFFF));
        }
        s.popTicks(const Offset(50, 14), 8, count: 4);
    }
  });
}
