import 'dart:ui';

import '../core/food_character.dart';
import '../core/sketch.dart';

const gardenGang = CharacterFamily(
  name: 'Garden Gang',
  tagline: 'Root-deep grit and green energy.',
  slug: 'garden_gang',
  members: [brock, carro, ember, shroomi, cobb],
);

const brock = FoodCharacter(
  id: 'brock',
  name: 'Brock',
  family: 'Garden Gang',
  title: 'The Garden Coach',
  story:
      'Runs sunrise drills for the whole plot and calls everyone champ. '
      'Brock believes any day can be leg day if you believe in your stalk.',
  accent: Color(0xFF4E7D46),
  moodLore: {
    CharacterMood.signature: 'Towel on, whistle ready, warm-ups at six.',
    CharacterMood.joy: 'Somebody hit a personal best today.',
    CharacterMood.yum: 'Post-workout smoothie. Greens on greens.',
    CharacterMood.sleepy: 'Rest day. Even the florets are off duty.',
    CharacterMood.hype: 'One more rep! The dumbbell agrees.',
  },
  painter: _paintBrock,
  motion: MotionProfile(style: PerformanceStyle.pop),
);

void _paintBrock(Sketch s, CharacterMood mood) {
  const canopy = Color(0xFF4E7D46);
  const stalk = Color(0xFFC3DB92);
  s.groundShadow(const Offset(50, 88), 16);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 79), spread: 12, len: 6.5);
    final body = Path()
      ..moveTo(42, 44)
      ..quadraticBezierTo(50, 41, 58, 44)
      ..cubicTo(61, 55, 63, 66, 63, 74)
      ..quadraticBezierTo(63, 81, 50, 81)
      ..quadraticBezierTo(37, 81, 37, 74)
      ..cubicTo(37, 66, 39, 55, 42, 44)
      ..close();
    s.fillArea(body, stalk);
    s.shade(body, lift: const Offset(-2, -2.6));
    s.ink(body, width: 2.7);
    var head = Path()
      ..addOval(Rect.fromCircle(center: const Offset(38, 33), radius: 9));
    for (final puff in const [
      [Offset(50, 26), 10.5],
      [Offset(62, 33), 9.0],
      [Offset(44, 39), 8.5],
      [Offset(57, 39), 8.5],
    ]) {
      head = Path.combine(
        PathOperation.union,
        head,
        Path()..addOval(
          Rect.fromCircle(center: puff[0] as Offset, radius: puff[1] as double),
        ),
      );
    }
    final droop = mood == CharacterMood.sleepy ? 2.5 : 0.0;
    if (droop > 0) head = head.shift(Offset(0, droop));
    s.fillArea(head, canopy);
    s.grain(head, dots: 26, color: const Color(0x4D2E4F29), r: 0.8);
    s.ink(head, width: 2.8);
    final band = Path()
      ..moveTo(41.5, 45.5 + droop)
      ..quadraticBezierTo(50, 43 + droop, 58.5, 45.5 + droop)
      ..lineTo(58, 49 + droop)
      ..quadraticBezierTo(50, 46.5 + droop, 42, 49 + droop)
      ..close();
    s.fillArea(band, Inks.rose, amp: 0.3);
    s.ink(band, width: 1.5, amp: 0.3);
    if (mood == CharacterMood.hype) {
      s.arm(const Offset(39, 58), 205, 8.5, bendDeg: -24);
      s.arm(const Offset(61, 58), 335, 10, bendDeg: 20);
      final hand = s.polar(const Offset(61, 58), 335, 11);
      final barA = s.polar(hand, 115, 6.6);
      final barB = s.polar(hand, 295, 6.6);
      s.strokeLine(barA, barB, width: 2.2);
      s.dot(barA, 3.1);
      s.dot(barB, 3.1);
      s.dot(s.polar(hand, 115, 8.8), 2.2);
      s.dot(s.polar(hand, 295, 8.8), 2.2);
    } else {
      s.moodArms(mood, const Offset(39, 58), const Offset(61, 58), len: 9);
    }
    if (mood == CharacterMood.signature) {
      final towel = Path()
        ..moveTo(41, 51)
        ..lineTo(46, 50)
        ..lineTo(47.5, 62)
        ..lineTo(42.5, 63)
        ..close();
      s.fillArea(towel, Inks.cream, amp: 0.3);
      s.ink(towel, width: 1.4, amp: 0.3);
    }
    s.moodFace(
      const Offset(50, 58),
      mood,
      spread: 10,
      mouthDrop: 7,
      scale: 0.95,
    );
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(74, 24), 2.2);
      case CharacterMood.joy:
        s.popTicks(const Offset(50, 24), 15, count: 6, color: Inks.sun);
      case CharacterMood.yum:
        s.heart(const Offset(71, 40), 2.6);
      case CharacterMood.sleepy:
        s.zzz(const Offset(70, 34));
      case CharacterMood.hype:
        s.sweat(const Offset(31, 44), s: 1.8);
        s.popTicks(const Offset(50, 24), 13, count: 4);
    }
  });
}

const carro = FoodCharacter(
  id: 'carro',
  name: 'Carro',
  family: 'Garden Gang',
  title: 'The Underground Sprinter',
  story:
      'Fastest root in the plot, raised entirely on soil and ambition. '
      'Sleeps planted, wakes up mid-stride, goggles permanently within reach.',
  accent: Color(0xFFED8A3F),
  moodLore: {
    CharacterMood.signature: 'Goggles up, stretching before the big one.',
    CharacterMood.joy: 'Gold medal! Grown, not given.',
    CharacterMood.yum: 'Carbo-loading, garden style.',
    CharacterMood.sleepy: 'Recharging in the soil, leaves out.',
    CharacterMood.hype: 'Goggles down. Dust everywhere. Gone.',
  },
  painter: _paintCarro,
  motion: MotionProfile(tempo: 1.25, style: PerformanceStyle.dash),
);

void _paintCarro(Sketch s, CharacterMood mood) {
  const root = Color(0xFFED8A3F);
  const ridge = Color(0x59C96D2A);
  const soil = Color(0xFF8A6248);
  final planted = mood == CharacterMood.sleepy;
  s.groundShadow(const Offset(50, 88), planted ? 19 : 14);
  s.posed(mood, () {
    if (!planted) {
      s.legs(mood, const Offset(50, 78), spread: 9, len: 6.5);
    }
    final body = Path()
      ..moveTo(50, 34)
      ..cubicTo(59, 34, 65, 38, 64, 46)
      ..cubicTo(63, 60, 56, 76, 50, 83)
      ..cubicTo(44, 76, 37, 60, 36, 46)
      ..cubicTo(35, 38, 41, 34, 50, 34)
      ..close();
    s.fillArea(body, root);
    s.shade(body, lift: const Offset(-2.2, -2.8));
    s.ink(body, width: 2.8);
    for (final y in const [46.0, 56.0, 66.0]) {
      final w = 13 - (y - 46) * 0.32;
      s.curve(
        Offset(50 - w, y),
        Offset(50, y + 2.2),
        Offset(50 + w, y),
        width: 1.4,
        color: ridge,
        amp: 0.3,
      );
    }
    for (var i = 0; i < 3; i++) {
      final sway = (i - 1) * 9.0;
      final tuft = Path()
        ..moveTo(48 + i * 2.0, 34)
        ..quadraticBezierTo(
          46 + sway,
          26,
          44 + sway * 1.5,
          19 + (i == 1 ? -3 : 0),
        )
        ..quadraticBezierTo(50 + sway * 0.6, 26, 51 + i * 1.4, 34)
        ..close();
      s.fillArea(tuft, i.isEven ? Inks.leaf : Inks.leafDeep, amp: 0.4);
      s.ink(tuft, width: 1.6, amp: 0.4);
    }
    s.moodArms(mood, const Offset(38, 52), const Offset(62, 52), len: 9);
    if (mood == CharacterMood.hype) {
      for (final lens in const [Offset(45, 48), Offset(55.5, 48)]) {
        final glass = Path()
          ..addOval(Rect.fromCircle(center: lens, radius: 3.6));
        s.fillArea(glass, Inks.sky, amp: 0.2);
        s.ink(glass, width: 1.8, amp: 0.2);
        s.gleam(lens, 1.8, sweepDeg: 60, width: 1.2);
      }
      s.strokeLine(const Offset(48.6, 48), const Offset(51.9, 48), width: 1.6);
      s.strokeLine(const Offset(41.4, 47), const Offset(38, 46), width: 1.6);
      s.strokeLine(const Offset(59.1, 47), const Offset(62, 46), width: 1.6);
      s.mouthGrin(const Offset(50, 57), 6.4);
      s.blushTicks(const Offset(40, 54), s: 0.85);
      s.blushTicks(const Offset(60, 54), s: 0.85);
    } else {
      s.moodFace(
        const Offset(50, 50),
        mood,
        spread: 10,
        mouthDrop: 7,
        scale: 0.95,
      );
      s.strokeLine(
        const Offset(41, 38.5),
        const Offset(59, 38.5),
        width: 2,
        color: Inks.rose,
        amp: 0.3,
      );
      s.ring(const Offset(46, 37), 2.6, width: 1.6);
      s.ring(const Offset(54, 37), 2.6, width: 1.6);
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(72, 30), 2.2);
      case CharacterMood.joy:
        s.dot(const Offset(50, 63), 3.4, color: Inks.sun);
        s.ring(const Offset(50, 63), 3.4, width: 1.4);
        s.strokeLine(
          const Offset(47.5, 60),
          const Offset(45, 55.5),
          width: 1.6,
          color: Inks.rose,
        );
        s.strokeLine(
          const Offset(52.5, 60),
          const Offset(55, 55.5),
          width: 1.6,
          color: Inks.rose,
        );
        s.popTicks(const Offset(50, 20), 8, count: 5, color: Inks.sun);
      case CharacterMood.yum:
        s.heart(const Offset(70, 36), 2.6);
      case CharacterMood.sleepy:
        final mound = Path()
          ..moveTo(26, 88)
          ..quadraticBezierTo(34, 78, 50, 77)
          ..quadraticBezierTo(66, 78, 74, 88)
          ..close();
        s.fillArea(mound, soil, amp: 1.2);
        s.ink(mound, width: 2.2, amp: 1.2);
        s.grain(mound, dots: 10, color: const Color(0x59543826));
        s.zzz(const Offset(69, 30));
      case CharacterMood.hype:
        s.speedLines(const Offset(24, 55), 180, len: 10, count: 4);
        s.dot(const Offset(27, 80), 2.2, color: const Color(0x66845F41));
        s.dot(const Offset(21, 84), 1.6, color: const Color(0x66845F41));
    }
  });
}

const ember = FoodCharacter(
  id: 'ember',
  name: 'Ember',
  family: 'Garden Gang',
  title: 'The Slow-Burn Hothead',
  story:
      'Runs warm, means well. Ember keeps a tiny flame lit above the stem as '
      'a courtesy warning and considers mild salsa a personal insult.',
  accent: Color(0xFFD8452E),
  moodLore: {
    CharacterMood.signature: 'Pilot light on, temper at a polite simmer.',
    CharacterMood.joy: 'Crackling with good news.',
    CharacterMood.yum: 'Ate something spicier than itself. Respect.',
    CharacterMood.sleepy: 'Down to smoke and embers.',
    CharacterMood.hype: 'Full flame-breath. Stand back, lovingly.',
  },
  painter: _paintEmber,
  motion: MotionProfile(style: PerformanceStyle.shake),
);

void _paintEmber(Sketch s, CharacterMood mood) {
  const pod = Color(0xFFD8452E);
  s.groundShadow(const Offset(50, 88), 16);
  s.posed(mood, () {
    s.legs(mood, const Offset(46, 79), spread: 10, len: 6);
    final body = Path()
      ..moveTo(44, 30)
      ..cubicTo(30, 34, 24, 50, 31, 63)
      ..cubicTo(38, 75, 52, 82, 64, 79)
      ..cubicTo(71, 77, 75, 72, 73, 68)
      ..cubicTo(71, 64, 64, 63, 58, 58)
      ..cubicTo(52, 52, 52, 40, 53, 34)
      ..quadraticBezierTo(50, 30, 44, 30)
      ..close();
    s.fillArea(body, pod);
    s.shade(body, lift: const Offset(-2.4, -3));
    s.grain(body, dots: 8, color: const Color(0x26801F12));
    s.ink(body, width: 2.8);
    s.gleam(const Offset(38, 44), 8, sweepDeg: 46);
    s.curve(
      const Offset(46, 30),
      const Offset(44, 25),
      const Offset(47, 21),
      width: 2.4,
      color: Inks.leafDeep,
    );
    final cap = Path()
      ..moveTo(40, 31)
      ..quadraticBezierTo(46, 26.5, 52, 31)
      ..quadraticBezierTo(46, 33.5, 40, 31)
      ..close();
    s.fillArea(cap, Inks.leaf, amp: 0.3);
    s.ink(cap, width: 1.6, amp: 0.3);
    if (mood != CharacterMood.sleepy) {
      final blaze = s.performing ? 1 + 0.85 * bell(s.perfT) : 1.0;
      s.canvas.save();
      s.canvas.translate(48.5, 20);
      s.canvas.scale(blaze);
      s.canvas.translate(-48.5, -20);
      final flame = Path()
        ..moveTo(47, 20)
        ..quadraticBezierTo(43.5, 15, 46, 10.5)
        ..quadraticBezierTo(47, 13, 48.5, 13.5)
        ..quadraticBezierTo(50.5, 11, 49.5, 8)
        ..quadraticBezierTo(53.5, 12, 52, 17)
        ..quadraticBezierTo(50.5, 20.5, 47, 20)
        ..close();
      s.fillArea(flame, Inks.sun, amp: 0.4);
      s.ink(flame, width: 1.5, amp: 0.4);
      s.dot(const Offset(49, 15.5), 1.6 * blaze, color: pod);
      s.canvas.restore();
    } else {
      s.steam(const Offset(47, 19), h: 10, sway: 2.4);
    }
    s.moodArms(mood, const Offset(33, 54), const Offset(56, 52), len: 8.5);
    s.moodFace(
      const Offset(43, 52),
      mood,
      spread: 9.5,
      mouthDrop: 7,
      scale: 0.92,
    );
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(68, 40), 2, color: Inks.sun);
      case CharacterMood.joy:
        s.popTicks(const Offset(48, 14), 8, count: 5, color: Inks.sun);
        s.confetti(
          const Rect.fromLTWH(58, 26, 20, 12),
          count: 6,
          colors: const [Inks.sun, pod, Color(0xFFF6D8B0), Inks.rose],
        );
      case CharacterMood.yum:
        final chili = Path()
          ..moveTo(68, 34)
          ..quadraticBezierTo(74, 35, 74.5, 40)
          ..quadraticBezierTo(72, 39, 69.5, 37.5)
          ..quadraticBezierTo(67.5, 36, 68, 34)
          ..close();
        s.fillArea(chili, pod, amp: 0.2);
        s.ink(chili, width: 1.2, amp: 0.2);
        s.heart(const Offset(74, 27), 2.2);
      case CharacterMood.sleepy:
        s.zzz(const Offset(68, 30));
      case CharacterMood.hype:
        final breath = Path()
          ..moveTo(52, 60)
          ..quadraticBezierTo(60, 56, 67, 60)
          ..quadraticBezierTo(63, 61.5, 60.5, 61)
          ..quadraticBezierTo(63, 63.5, 61, 66)
          ..quadraticBezierTo(56, 64, 52, 61.5)
          ..close();
        s.fillArea(breath, Inks.sun, amp: 0.5);
        s.ink(breath, width: 1.4, amp: 0.5);
        s.popTicks(const Offset(48, 14), 9, count: 5, color: Inks.sun);
    }
  });
}

const shroomi = FoodCharacter(
  id: 'shroomi',
  name: 'Shroomi',
  family: 'Garden Gang',
  title: 'The Night-Shift Sage',
  story:
      'Keeper of the forest floor and its softest opinions. Shroomi walks the '
      'plot after dark with a little lantern, checking that everyone is fed.',
  accent: Color(0xFFD96C4F),
  moodLore: {
    CharacterMood.signature: 'Evening rounds, lantern lit.',
    CharacterMood.joy: 'The spores are dancing tonight.',
    CharacterMood.yum: 'Forest snacks are criminally underrated.',
    CharacterMood.sleepy: 'Cap down. Do not disturb.',
    CharacterMood.hype: 'Found a new glade! Fireflies agree it is great.',
  },
  painter: _paintShroomi,
  motion: MotionProfile(tempo: 0.8, style: PerformanceStyle.bow),
);

void _paintShroomi(Sketch s, CharacterMood mood) {
  const cap = Color(0xFFD96C4F);
  const stem = Color(0xFFF3E3C8);
  final capDrop = mood == CharacterMood.sleepy ? 7.0 : 0.0;
  s.groundShadow(const Offset(50, 88), 15);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 80), spread: 11, len: 5.5);
    final body = Path()
      ..moveTo(41, 46)
      ..quadraticBezierTo(50, 44, 59, 46)
      ..cubicTo(61, 58, 61, 70, 59, 78)
      ..quadraticBezierTo(50, 83, 41, 78)
      ..cubicTo(39, 70, 39, 58, 41, 46)
      ..close();
    s.fillArea(body, stem);
    s.shade(body, lift: const Offset(-2, -2.4));
    s.ink(body, width: 2.7);
    final dome = Path()
      ..moveTo(27, 46 + capDrop)
      ..cubicTo(26, 30 + capDrop, 36, 21 + capDrop, 50, 21 + capDrop)
      ..cubicTo(64, 21 + capDrop, 74, 30 + capDrop, 73, 46 + capDrop)
      ..quadraticBezierTo(62, 50 + capDrop, 50, 50 + capDrop)
      ..quadraticBezierTo(38, 50 + capDrop, 27, 46 + capDrop)
      ..close();
    s.fillArea(dome, cap);
    s.shade(dome, lift: const Offset(-2.4, -3));
    s.ink(dome, width: 2.8);
    for (final fleck in const [
      Offset(38, 30),
      Offset(52, 26),
      Offset(64, 33),
      Offset(44, 40),
      Offset(59, 42),
    ]) {
      final spot = Path()
        ..addOval(
          Rect.fromCircle(center: fleck + Offset(0, capDrop), radius: 2.6),
        );
      s.fillArea(spot, Inks.cream, amp: 0.25);
      s.ink(spot, width: 1.1, amp: 0.25, color: const Color(0x66A34833));
    }
    for (var x = 33.0; x <= 67; x += 6.8) {
      s.strokeLine(
        Offset(x, 47.5 + capDrop),
        Offset(x - 0.5, 50.5 + capDrop),
        width: 1.2,
        color: const Color(0x59A9846B),
      );
    }
    s.moodArms(mood, const Offset(41, 60), const Offset(59, 60), len: 8.5);
    if (mood == CharacterMood.sleepy) {
      s.mouthOoo(const Offset(50, 66), 1.6);
      s.blushTicks(const Offset(42, 63), s: 0.85);
      s.blushTicks(const Offset(58, 63), s: 0.85);
      s.zzz(const Offset(72, 40));
    } else {
      s.moodFace(
        const Offset(50, 58),
        mood,
        spread: 9.5,
        mouthDrop: 6.5,
        scale: 0.92,
      );
    }
    final lanternHand = mood == CharacterMood.hype
        ? s.polar(const Offset(59, 60), 335, 9.9)
        : s.polar(const Offset(59, 60), 28, 8.5);
    if (mood == CharacterMood.signature || mood == CharacterMood.hype) {
      final swing = lanternHand + const Offset(0, 5.4);
      s.strokeLine(lanternHand, swing + const Offset(0, -3), width: 1.3);
      final glassBox = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: swing + const Offset(0, 2),
              width: 6,
              height: 7,
            ),
            const Radius.circular(1.6),
          ),
        );
      s.fillArea(glassBox, const Color(0xFFFBE7A9), amp: 0.25);
      s.ink(glassBox, width: 1.5, amp: 0.25);
      s.dot(swing + const Offset(0, 2), 1.5, color: Inks.sun);
      s.sparkle(
        swing + const Offset(0, 2),
        3.4,
        color: const Color(0x8CF6B84C),
      );
    }
    switch (mood) {
      case CharacterMood.signature:
        s.dot(const Offset(26, 60), 0.9, color: Inks.sun);
        s.dot(const Offset(31, 66), 0.7, color: Inks.sun);
      case CharacterMood.joy:
        s.sparkleAround(
          const Offset(50, 30),
          26,
          count: 5,
          color: const Color(0xFFEDD9A9),
        );
      case CharacterMood.yum:
        s.heart(const Offset(72, 52), 2.4);
      case CharacterMood.sleepy:
        break;
      case CharacterMood.hype:
        for (final fly in const [
          Offset(26, 40),
          Offset(31, 30),
          Offset(72, 26),
        ]) {
          s.dot(fly, 1.2, color: Inks.sun);
          s.ring(fly, 2.6, width: 0.9, color: const Color(0x59F6B84C));
        }
        s.speedLines(const Offset(24, 62), 185, len: 7);
    }
  });
}

const cobb = FoodCharacter(
  id: 'cobb',
  name: 'Cobb',
  family: 'Garden Gang',
  title: 'The Kernel Comedian',
  story:
      'Every kernel is a joke Cobb has not told yet. When one really lands, '
      'it pops. The husk hoodie stays on for mysterious showbiz reasons.',
  accent: Color(0xFFF2C94C),
  moodLore: {
    CharacterMood.signature: 'Mid-set, working the garden crowd.',
    CharacterMood.joy: 'Three jokes popped in a row. Career night.',
    CharacterMood.yum: 'Butter. The oldest bit in the book still works.',
    CharacterMood.sleepy: 'After the late show, hood up.',
    CharacterMood.hype: 'Popping off. Literally.',
  },
  painter: _paintCobb,
  motion: MotionProfile(style: PerformanceStyle.pop),
);

void _paintCobb(Sketch s, CharacterMood mood) {
  const kernel = Color(0xFFF2C94C);
  const kernelLine = Color(0x59C99A2E);
  s.groundShadow(const Offset(50, 88), 15);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 79), spread: 10, len: 6);
    final body = Path()
      ..moveTo(50, 24)
      ..cubicTo(59, 24, 63, 32, 63, 44)
      ..cubicTo(63, 62, 60, 76, 50, 80)
      ..cubicTo(40, 76, 37, 62, 37, 44)
      ..cubicTo(37, 32, 41, 24, 50, 24)
      ..close();
    s.fillArea(body, kernel);
    s.hatch(body, angleDeg: 0, gap: 6, width: 1.2, color: kernelLine);
    s.hatch(body, angleDeg: 90, gap: 5.4, width: 1.2, color: kernelLine);
    s.shade(body, lift: const Offset(-2.2, -2.6));
    s.ink(body, width: 2.8);
    for (final side in const [-1, 1]) {
      final husk = Path()
        ..moveTo(50 + side * 6.0, 79)
        ..quadraticBezierTo(50 + side * 16.0, 74, 50 + side * 15.0, 52)
        ..quadraticBezierTo(50 + side * 21.0, 66, 50 + side * 13.0, 80.5)
        ..close();
      s.fillArea(husk, Inks.leaf, amp: 0.5);
      s.ink(husk, width: 1.8, amp: 0.5);
    }
    s.moodArms(mood, const Offset(38, 56), const Offset(62, 56), len: 9);
    s.moodFace(
      const Offset(50, 46),
      mood,
      spread: 10,
      mouthDrop: 7.5,
      scale: 0.95,
    );
    void puff(Offset at, double r) {
      var cloud = Path()..addOval(Rect.fromCircle(center: at, radius: r));
      cloud = Path.combine(
        PathOperation.union,
        cloud,
        Path()..addOval(
          Rect.fromCircle(
            center: at + Offset(r * 0.9, r * 0.35),
            radius: r * 0.8,
          ),
        ),
      );
      cloud = Path.combine(
        PathOperation.union,
        cloud,
        Path()..addOval(
          Rect.fromCircle(
            center: at + Offset(-r * 0.85, r * 0.4),
            radius: r * 0.75,
          ),
        ),
      );
      s.fillArea(cloud, Inks.cream, amp: 0.3);
      s.ink(cloud, width: 1.4, amp: 0.3);
    }

    if (s.performing) {
      if (s.perfT > 0.2) puff(const Offset(37, 16), 2.1);
      if (s.perfT > 0.42) puff(const Offset(53, 11), 2.5);
      if (s.perfT > 0.64) puff(const Offset(67, 17), 2.2);
      if (s.perfT > 0.42 && s.perfT < 0.9) {
        s.popTicks(const Offset(53, 11), 6, count: 4, len: 2.4, width: 1.3);
      }
    }

    switch (mood) {
      case CharacterMood.signature:
        puff(const Offset(71, 30), 2.4);
        s.popTicks(
          const Offset(71, 30),
          5,
          count: 3,
          len: 2,
          startDeg: -120,
          endDeg: -20,
          width: 1.2,
        );
      case CharacterMood.joy:
        puff(const Offset(36, 17), 2.2);
        puff(const Offset(53, 12), 2.6);
        puff(const Offset(68, 18), 2.2);
        s.popTicks(const Offset(53, 12), 6, count: 5, len: 2.4, width: 1.3);
      case CharacterMood.yum:
        final butter = Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: const Offset(50, 22),
                width: 9,
                height: 5.4,
              ),
              const Radius.circular(1.2),
            ),
          );
        s.fillArea(butter, const Color(0xFFFBE28B), amp: 0.25);
        s.ink(butter, width: 1.4, amp: 0.25);
        s.heart(const Offset(70, 30), 2.2);
      case CharacterMood.sleepy:
        s.zzz(const Offset(70, 30));
      case CharacterMood.hype:
        puff(const Offset(30, 22), 2.1);
        puff(const Offset(46, 12), 2.5);
        puff(const Offset(64, 15), 2.2);
        puff(const Offset(74, 28), 1.9);
        s.speedLines(const Offset(24, 58), 182, len: 8);
    }
  });
}
