import 'dart:ui';

import '../core/food_character.dart';
import '../core/sketch.dart';

const sunriseClub = CharacterFamily(
  name: 'Sunrise Club',
  tagline: 'The ones who get you out of bed.',
  slug: 'sunrise_club',
  members: [sunny, stax, pop, crisp, brew],
);

const sunny = FoodCharacter(
  id: 'sunny',
  name: 'Sunny',
  family: 'Sunrise Club',
  title: 'The Actual Morning Person',
  story:
      'Rises first, shines always, takes the phrase personally. When Sunny '
      'finally dims, the whole kitchen calls it a sunset and applauds.',
  accent: Color(0xFFF5B942),
  moodLore: {
    CharacterMood.signature: 'Beaming. It is 6 a.m. somewhere.',
    CharacterMood.joy: 'Full sunrise. Rays at maximum.',
    CharacterMood.yum: 'Runny in the best way.',
    CharacterMood.sleepy: 'Yolk setting low. Golden hour.',
    CharacterMood.hype: 'RISE AND SHINE, EVERYBODY.',
  },
  painter: _paintSunny,
  motion: MotionProfile(style: PerformanceStyle.pop),
);

void _paintSunny(Sketch s, CharacterMood mood) {
  const white = Color(0xFFFBF6EC);
  const yolk = Color(0xFFF5B942);
  final setting = mood == CharacterMood.sleepy;
  s.groundShadow(const Offset(50, 88), 19);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 82), spread: 13, len: 4.5);
    final body = Path()
      ..moveTo(38, 44)
      ..cubicTo(46, 38, 58, 39, 64, 44)
      ..cubicTo(72, 50, 74, 58, 70, 66)
      ..cubicTo(74, 74, 68, 82, 58, 83)
      ..cubicTo(50, 86, 38, 84, 33, 78)
      ..cubicTo(26, 72, 27, 62, 31, 57)
      ..cubicTo(27, 50, 31, 46, 38, 44)
      ..close();
    s.fillArea(body, white);
    s.shade(body, lift: const Offset(-2, -2.6), color: const Color(0x1CC9A24C));
    s.ink(body, width: 2.8);
    final yolkAt = setting ? const Offset(50, 66) : const Offset(50, 60);
    final yolkPath = Path()
      ..addOval(Rect.fromCircle(center: yolkAt, radius: 12));
    s.fillArea(yolkPath, yolk);
    s.shade(yolkPath, lift: const Offset(-1.8, -2.2));
    s.ink(yolkPath, width: 2.5);
    s.gleam(yolkAt + const Offset(-4, -4.6), 4.4, sweepDeg: 46);
    s.moodArms(mood, const Offset(31, 62), const Offset(69, 62), len: 8);
    s.moodFace(
      yolkAt + const Offset(0, -1.4),
      mood,
      spread: 8.5,
      mouthDrop: 5.4,
      scale: 0.8,
    );
    switch (mood) {
      case CharacterMood.signature:
        s.popTicks(
          yolkAt,
          15,
          count: 4,
          len: 3,
          color: Inks.sun,
          startDeg: -140,
          endDeg: -40,
        );
        s.sparkle(const Offset(73, 36), 2.2);
      case CharacterMood.joy:
        s.popTicks(
          yolkAt,
          16,
          count: 8,
          len: 3.8,
          color: Inks.sun,
          startDeg: -180,
          endDeg: -12,
        );
      case CharacterMood.yum:
        s.heart(const Offset(72, 40), 2.4);
      case CharacterMood.sleepy:
        s.strokeLine(
          const Offset(24, 40),
          const Offset(38, 40),
          width: 2,
          color: Inks.inkFaint,
          amp: 0.4,
        );
        s.strokeLine(
          const Offset(60, 34),
          const Offset(76, 34),
          width: 2,
          color: Inks.inkFaint,
          amp: 0.4,
        );
        s.zzz(const Offset(70, 26));
      case CharacterMood.hype:
        s.popTicks(
          yolkAt,
          16,
          count: 7,
          len: 4.4,
          color: Inks.sun,
          startDeg: -170,
          endDeg: -10,
        );
        s.speedLines(const Offset(24, 64), 182, len: 8);
    }
  });
}

const stax = FoodCharacter(
  id: 'stax',
  name: 'Stax',
  family: 'Sunrise Club',
  title: 'The Cozy Triple-Decker',
  story:
      'Three layers of warm, wearing a butter beret. Stax moves slowly on '
      'purpose; syrup taught it everything worth arriving at arrives gently.',
  accent: Color(0xFFE2A85F),
  moodLore: {
    CharacterMood.signature: 'Fresh off the griddle, beret at an angle.',
    CharacterMood.joy: 'Syrup day! It found every layer.',
    CharacterMood.yum: 'Tasting own syrup. Sunday rules.',
    CharacterMood.sleepy: 'The butter melted into a blanket.',
    CharacterMood.hype: 'Flip practice! One pancake achieved flight.',
  },
  painter: _paintStax,
);

void _paintStax(Sketch s, CharacterMood mood) {
  const cake = Color(0xFFE2A85F);
  const cakeTop = Color(0xFFEDBE7A);
  const syrup = Color(0xFFB0682F);
  const butter = Color(0xFFF7DC6F);
  s.groundShadow(const Offset(50, 88), 18);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 80), spread: 12, len: 4.5);
    for (final layer in const [
      [Offset(50, 70), 40.0],
      [Offset(50, 61), 37.0],
      [Offset(50, 52), 34.0],
    ]) {
      final at = layer[0] as Offset;
      final w = layer[1] as double;
      final cakePath = Path()
        ..addOval(Rect.fromCenter(center: at, width: w, height: 15));
      s.fillArea(cakePath, at.dy == 52 ? cakeTop : cake);
      s.ink(cakePath, width: 2.5);
    }
    final drizzle = mood == CharacterMood.joy ? 3.4 : 0.0;
    for (final drip in const [
      [38.0, 48.0],
      [47.0, 46.5],
      [57.0, 47.5],
      [63.0, 49.0],
    ]) {
      final x = drip[0];
      final y = drip[1];
      final run = Path()
        ..moveTo(x - 1.9, y)
        ..quadraticBezierTo(x - 2.2, y + 6 + drizzle, x, y + 8 + drizzle)
        ..quadraticBezierTo(x + 2.2, y + 6 + drizzle, x + 1.9, y)
        ..close();
      s.fillArea(run, syrup, amp: 0.25);
    }
    s.curve(
      const Offset(35, 47.5),
      const Offset(50, 44),
      const Offset(65, 47.5),
      width: 2.6,
      color: syrup,
      amp: 0.4,
    );
    final melted = mood == CharacterMood.sleepy;
    final pat = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(45, melted ? 45.4 : 43.6),
            width: melted ? 13 : 10,
            height: melted ? 3.4 : 5.4,
          ),
          const Radius.circular(1.4),
        ),
      );
    s.fillArea(pat, butter, amp: 0.3);
    s.ink(pat, width: 1.6, amp: 0.3);
    s.moodArms(mood, const Offset(32, 64), const Offset(68, 64), len: 8.5);
    s.moodFace(
      const Offset(50, 60),
      mood,
      spread: 10.5,
      mouthDrop: 7,
      scale: 0.95,
    );
    switch (mood) {
      case CharacterMood.signature:
        s.steam(const Offset(40, 42), h: 10, sway: 2.4);
        s.steam(const Offset(60, 41), h: 11, sway: 2.6);
      case CharacterMood.joy:
        s.sparkle(const Offset(72, 34), 2.4);
        s.sparkle(const Offset(27, 38), 2);
      case CharacterMood.yum:
        s.strokeLine(
          const Offset(53, 68.5),
          const Offset(54, 72),
          width: 2,
          color: syrup,
        );
        s.heart(const Offset(71, 40), 2.4);
      case CharacterMood.sleepy:
        s.zzz(const Offset(70, 34));
      case CharacterMood.hype:
        final flying = Path()
          ..addOval(
            Rect.fromCenter(
              center: const Offset(66, 20),
              width: 16,
              height: 6.4,
            ),
          );
        s.fillArea(flying, cakeTop, amp: 0.4);
        s.ink(flying, width: 1.8, amp: 0.4);
        s.curve(
          const Offset(60, 26),
          const Offset(64, 30),
          const Offset(62, 34),
          width: 1.4,
          color: Inks.inkSoft,
        );
        s.popTicks(const Offset(66, 20), 10, count: 4, len: 2.6);
    }
  });
}

const pop = FoodCharacter(
  id: 'pop',
  name: 'Pop',
  family: 'Sunrise Club',
  title: 'The Punctual Launcher',
  story:
      'Has never once been late; the toaster simply will not allow it. '
      'Pop keeps a jam heart on standby for days that need extra.',
  accent: Color(0xFFE8C07A),
  moodLore: {
    CharacterMood.signature: 'On the mark, crumbs combed.',
    CharacterMood.joy: 'Jam heart day. Spread the good stuff.',
    CharacterMood.yum: 'Butter landed. Everything is butter now.',
    CharacterMood.sleepy: 'Still in the slot. Five more degrees.',
    CharacterMood.hype: 'LAUNCH! Right on schedule.',
  },
  painter: _paintPop,
);

void _paintPop(Sketch s, CharacterMood mood) {
  const bread = Color(0xFFE8C07A);
  const crustEdge = Color(0xFFB57B42);
  const metal = Color(0xFFC9CFD9);
  final tucked = mood == CharacterMood.sleepy;
  final launched = mood == CharacterMood.hype;
  final rise = launched ? -20.0 : (tucked ? 16.0 : 0.0);
  s.groundShadow(const Offset(50, 89), launched || tucked ? 20 : 15);
  void toaster() {
    final shell = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(30, 58, 40, 28),
          const Radius.circular(8),
        ),
      );
    s.fillArea(shell, metal);
    s.shade(
      shell,
      lift: const Offset(-2, -2.4),
      color: const Color(0x21596273),
    );
    s.ink(shell, width: 2.8);
    final slot = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(37, 60, 26, 3.6),
          const Radius.circular(1.8),
        ),
      );
    s.fillArea(slot, const Color(0xFF6E7887), amp: 0.2);
    s.ink(slot, width: 1.4, amp: 0.2);
    s.strokeLine(const Offset(71, 66), const Offset(75, 66), width: 2.4);
    s.dot(const Offset(76, 66), 2, color: Inks.rose);
    s.dot(const Offset(38, 78), 1.6, color: Inks.rose);
    s.gleam(
      const Offset(42, 70),
      6,
      sweepDeg: 40,
      color: const Color(0xB8EFF3F8),
    );
  }

  if (tucked || launched) {
    toaster();
  }
  s.posed(mood, () {
    if (!tucked && !launched) {
      s.legs(mood, const Offset(50, 76), spread: 10, len: 6);
    } else if (launched) {
      s.legs(mood, const Offset(50, 55), spread: 10, len: 6);
    }
    final slice = Path()
      ..moveTo(36, 44 + rise)
      ..cubicTo(34, 34 + rise, 42, 30 + rise, 50, 32 + rise)
      ..cubicTo(58, 30 + rise, 66, 34 + rise, 64, 44 + rise)
      ..lineTo(64.5, 70 + rise)
      ..quadraticBezierTo(50, 73 + rise, 35.5, 70 + rise)
      ..close();
    s.fillArea(slice, bread);
    s.ink(slice, width: 2.8);
    final crumb = Path()
      ..moveTo(39.5, 45 + rise)
      ..cubicTo(38, 37.5 + rise, 44, 34.5 + rise, 50, 36 + rise)
      ..cubicTo(56, 34.5 + rise, 62, 37.5 + rise, 60.5, 45 + rise)
      ..lineTo(61, 66.5 + rise)
      ..quadraticBezierTo(50, 69 + rise, 39, 66.5 + rise)
      ..close();
    s.ink(crumb, width: 2.6, color: crustEdge, amp: 0.7);
    for (final freckle in [
      Offset(43, 41 + rise),
      Offset(58, 43 + rise),
      Offset(46, 63 + rise),
    ]) {
      s.dot(freckle, 0.8, color: const Color(0x66B57B42));
    }
    if (!tucked) {
      s.moodArms(mood, Offset(37, 54 + rise), Offset(63, 54 + rise), len: 8);
      s.moodFace(
        Offset(50, 50 + rise),
        mood,
        spread: 9.5,
        mouthDrop: 6.5,
        scale: 0.9,
      );
    } else {
      s.eyeLid(const Offset(45, 52), 2.3);
      s.eyeLid(const Offset(55, 52), 2.3);
    }
    if (mood == CharacterMood.joy) {
      s.heart(Offset(50, 63 + rise), 3.2, color: const Color(0xFFC0392B));
    }
    if (mood == CharacterMood.yum) {
      final patSquare = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(52, 33 + rise),
              width: 8,
              height: 4.6,
            ),
            const Radius.circular(1),
          ),
        );
      s.fillArea(patSquare, const Color(0xFFF7DC6F), amp: 0.25);
      s.ink(patSquare, width: 1.3, amp: 0.25);
    }
  }, pose: launched ? const MoodPose(rot: 0.12) : null);
  if (s.performing && !tucked && !launched) {
    final coil = bell(s.perfT);
    if (coil > 0.15) {
      final springL = Path()
        ..moveTo(45, 84)
        ..lineTo(47, 81 - coil * 2)
        ..lineTo(44, 78 - coil * 3)
        ..lineTo(46.5, 75 - coil * 4);
      final springR = Path()
        ..moveTo(55, 84)
        ..lineTo(53, 81 - coil * 2)
        ..lineTo(56, 78 - coil * 3)
        ..lineTo(53.5, 75 - coil * 4);
      s.ink(springL, width: 1.6, color: Inks.inkSoft, amp: 0.2);
      s.ink(springR, width: 1.6, color: Inks.inkSoft, amp: 0.2);
    }
    if (s.perfT > 0.25 && s.perfT < 0.6) {
      s.popTicks(const Offset(50, 20), 9, count: 5);
    }
  }
  switch (mood) {
    case CharacterMood.signature:
      s.sparkle(const Offset(72, 32), 2.2);
    case CharacterMood.joy:
      s.popTicks(const Offset(50, 26), 12, count: 5);
    case CharacterMood.yum:
      s.heart(const Offset(71, 38), 2.3);
    case CharacterMood.sleepy:
      s.zzz(const Offset(70, 44));
    case CharacterMood.hype:
      final springL = Path()
        ..moveTo(44, 57.5)
        ..lineTo(46.5, 55)
        ..lineTo(43.5, 52.5)
        ..lineTo(46.5, 50);
      final springR = Path()
        ..moveTo(56, 57.5)
        ..lineTo(53.5, 55)
        ..lineTo(56.5, 52.5)
        ..lineTo(53.5, 50);
      s.ink(springL, width: 1.7, color: Inks.inkSoft, amp: 0.2);
      s.ink(springR, width: 1.7, color: Inks.inkSoft, amp: 0.2);
      s.popTicks(const Offset(50, 12), 10, count: 5);
  }
}

const crisp = FoodCharacter(
  id: 'crisp',
  name: 'Crisp',
  family: 'Sunrise Club',
  title: 'The Wavy Comedian',
  story:
      'Physically incapable of standing straight and emotionally committed to '
      'the bit. Crisp sizzles when laughing, which is most of the time.',
  accent: Color(0xFFC05B45),
  moodLore: {
    CharacterMood.signature: 'Leaning on air. Nailing it.',
    CharacterMood.joy: 'Laughed so hard it curled further.',
    CharacterMood.yum: 'Maple found the streaks.',
    CharacterMood.sleepy: 'Fully draped. Flat is a lifestyle.',
    CharacterMood.hype: 'PAN IS HOT. Sizzle mode engaged.',
  },
  painter: _paintCrisp,
  motion: MotionProfile(tempo: 1.2, style: PerformanceStyle.wobble),
);

void _paintCrisp(Sketch s, CharacterMood mood) {
  const meat = Color(0xFFC05B45);
  const fat = Color(0xFFF2D9C0);
  s.groundShadow(const Offset(50, 88), 14);
  s.posed(
    mood,
    () {
      s.legs(mood, const Offset(50, 78), spread: 9, len: 6);
      final body = Path()
        ..moveTo(44, 26)
        ..cubicTo(36, 36, 52, 46, 42, 56)
        ..cubicTo(36, 63, 46, 70, 44, 78)
        ..lineTo(58, 78)
        ..cubicTo(60, 70, 50, 64, 56, 57)
        ..cubicTo(66, 46, 50, 38, 58, 26)
        ..close();
      s.fillArea(body, meat);
      s.ink(body, width: 2.7, rough: mood == CharacterMood.hype);
      final streakA = Path()
        ..moveTo(48, 27)
        ..cubicTo(42, 37, 56, 46, 46, 56)
        ..cubicTo(41, 62, 50, 69, 48, 76);
      final streakB = Path()
        ..moveTo(53, 27)
        ..cubicTo(47, 37, 61, 45, 51, 55)
        ..cubicTo(46, 62, 55, 69, 53, 76);
      s.ink(streakA, width: 2.6, color: fat, amp: 0.5);
      s.ink(streakB, width: 2.6, color: fat, amp: 0.5);
      if (mood == CharacterMood.signature) {
        s.arm(const Offset(41, 48), 152, 8);
        s.arm(const Offset(59, 46), 350, 9, bendDeg: -10);
      } else {
        s.moodArms(mood, const Offset(41, 48), const Offset(59, 48), len: 8);
      }
      s.moodFace(
        const Offset(50, 37),
        mood,
        spread: 8.5,
        mouthDrop: 6,
        scale: 0.82,
      );
      switch (mood) {
        case CharacterMood.signature:
          s.sparkle(const Offset(70, 30), 2.2);
        case CharacterMood.joy:
          s.popTicks(const Offset(50, 22), 9, count: 5);
        case CharacterMood.yum:
          s.heart(const Offset(69, 34), 2.3);
        case CharacterMood.sleepy:
          s.zzz(const Offset(68, 28));
        case CharacterMood.hype:
          for (final spark in const [
            Offset(33, 32),
            Offset(28, 48),
            Offset(70, 44),
            Offset(67, 62),
          ]) {
            s.sparkle(spark, 2, color: Inks.sun, width: 1.4);
          }
          s.speedLines(const Offset(27, 66), 185, len: 7);
      }
    },
    pose: mood == CharacterMood.sleepy
        ? const MoodPose(dy: 4, rot: -0.14, sy: 0.84, sx: 1.1)
        : (mood == CharacterMood.signature ? const MoodPose(rot: -0.07) : null),
  );
}

const brew = FoodCharacter(
  id: 'brew',
  name: 'Brew',
  family: 'Sunrise Club',
  title: 'The Overclocked Optimist',
  story:
      'Technically a morning beverage, spiritually a to-do list. Brew\'s '
      'right arm is a handle, which saves time, which Brew spends worrying.',
  accent: Color(0xFF6B4231),
  moodLore: {
    CharacterMood.signature: 'Third refill, first draft, full plan.',
    CharacterMood.joy: 'Someone drew a heart in the foam.',
    CharacterMood.yum: 'The good beans. The GOOD beans.',
    CharacterMood.sleepy: 'Decaf incident. Steam barely trying.',
    CharacterMood.hype: 'Espresso protocol. Vibrating politely.',
  },
  painter: _paintBrew,
  motion: MotionProfile(tempo: 1.45, style: PerformanceStyle.shake),
);

void _paintBrew(Sketch s, CharacterMood mood) {
  const cup = Color(0xFFF6F1E6);
  const coffee = Color(0xFF6B4231);
  final wired = mood == CharacterMood.hype;
  s.groundShadow(const Offset(50, 89), 21);
  s.posed(
    mood,
    () {
      final saucer = Path()
        ..addOval(
          Rect.fromCenter(center: const Offset(50, 82), width: 48, height: 9),
        );
      s.fillArea(saucer, cup);
      s.ink(saucer, width: 2.3);
      final body = Path()
        ..moveTo(36, 42)
        ..lineTo(64, 42)
        ..lineTo(62, 76)
        ..quadraticBezierTo(50, 79, 38, 76)
        ..close();
      if (wired) {
        s.ink(
          body.shift(const Offset(2.2, 0)),
          width: 1.2,
          color: Inks.inkFaint,
          amp: 1.3,
        );
        s.ink(
          body.shift(const Offset(-2.2, 0)),
          width: 1.2,
          color: Inks.inkFaint,
          amp: 1.3,
        );
      }
      s.fillArea(body, cup);
      s.shade(
        body,
        lift: const Offset(-2, -2.4),
        color: const Color(0x1FA98B62),
      );
      s.ink(body, width: 2.8);
      s.strokeLine(
        const Offset(37.5, 66),
        const Offset(62.5, 66),
        width: 2.6,
        color: Inks.rose,
        amp: 0.4,
      );
      final rim = Path()
        ..addOval(
          Rect.fromCenter(center: const Offset(50, 42), width: 28, height: 7),
        );
      s.fillArea(rim, coffee);
      s.ink(rim, width: 2.2);
      final handle = Path()
        ..moveTo(63.5, 50)
        ..cubicTo(72, 47, 74, 58, 64.5, 61);
      s.ink(handle, width: 3.4);
      s.ink(handle, width: 1.6, color: cup, amp: 0.2);
      final leftArmAngle = switch (mood) {
        CharacterMood.signature => 152.0,
        CharacterMood.joy => 227.0,
        CharacterMood.yum => 60.0,
        CharacterMood.sleepy => 115.0,
        CharacterMood.hype => 205.0,
      };
      s.arm(
        const Offset(37, 58),
        leftArmAngle,
        8.5,
        bendDeg: mood == CharacterMood.joy ? -12 : 14,
      );
      if (wired) {
        s.eyeSwirl(const Offset(45, 54), 2.6);
        s.eyeSwirl(const Offset(55, 54), 2.6);
        s.mouthGrin(const Offset(50, 61), 6.4);
        s.blushTicks(const Offset(39.5, 57), s: 0.85);
        s.blushTicks(const Offset(60.5, 57), s: 0.85);
      } else {
        s.moodFace(
          const Offset(50, 55),
          mood,
          spread: 10,
          mouthDrop: 6.5,
          scale: 0.9,
        );
      }
      if (mood == CharacterMood.sleepy) {
        final droopSteam = Path()
          ..moveTo(50, 36)
          ..cubicTo(52, 31, 58, 32, 60, 36);
        s.ink(droopSteam, width: 1.7, color: const Color(0x4633251D), amp: 0.4);
      } else {
        s.steam(const Offset(43, 37), h: wired ? 15 : 11, sway: 2.6);
        s.steam(const Offset(50, 34), h: wired ? 17 : 13, sway: 3);
        s.steam(const Offset(57, 37), h: wired ? 14 : 10, sway: 2.4);
      }
      switch (mood) {
        case CharacterMood.signature:
          s.sparkle(const Offset(27, 36), 2.2);
        case CharacterMood.joy:
          s.heart(const Offset(50, 41.4), 2, color: cup);
          s.popTicks(const Offset(50, 30), 11, count: 5);
        case CharacterMood.yum:
          s.heart(const Offset(29, 40), 2.4);
        case CharacterMood.sleepy:
          s.zzz(const Offset(69, 30));
        case CharacterMood.hype:
          s.sweat(const Offset(30, 44), s: 1.7);
          s.popTicks(const Offset(50, 26), 12, count: 6);
      }
    },
    pose: mood == CharacterMood.sleepy
        ? const MoodPose(dy: 2, rot: -0.05, sy: 0.95)
        : null,
  );
}
