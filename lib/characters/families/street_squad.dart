import 'dart:ui';

import '../core/food_character.dart';
import '../core/sketch.dart';

const streetSquad = CharacterFamily(
  name: 'Street Squad',
  tagline: 'Loud, fast, and best enjoyed with both hands.',
  slug: 'street_squad',
  members: [patty, fritz, peppo, tico, frank],
);

const patty = FoodCharacter(
  id: 'patty',
  name: 'Patty',
  family: 'Street Squad',
  title: 'The Stacked Captain',
  story:
      'Keeps the squad together the way only a burger can: layer by layer. '
      'Patty tips the top bun to newcomers because manners scale.',
  accent: Color(0xFFE3A25C),
  moodLore: {
    CharacterMood.signature: 'Pointing at the horizon. Lunch is that way.',
    CharacterMood.joy: 'Tipping the bun. At ease, everyone.',
    CharacterMood.yum: 'The cheese is doing its thing.',
    CharacterMood.sleepy: 'Stacked down for the night.',
    CharacterMood.hype: 'SQUAD, ROLL OUT.',
  },
  painter: _paintPatty,
  motion: MotionProfile(style: PerformanceStyle.pop),
);

void _paintPatty(Sketch s, CharacterMood mood) {
  const bun = Color(0xFFE3A25C);
  const meat = Color(0xFF7A4A32);
  const cheese = Color(0xFFF5CE58);
  const lettuce = Color(0xFF7CB65C);
  s.groundShadow(const Offset(50, 88), 18);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 79), spread: 13, len: 5.5);
    final bottomBun = Path()
      ..moveTo(36, 68)
      ..lineTo(64, 68)
      ..quadraticBezierTo(66, 68, 66, 71)
      ..quadraticBezierTo(66, 79, 50, 79)
      ..quadraticBezierTo(34, 79, 34, 71)
      ..quadraticBezierTo(34, 68, 36, 68)
      ..close();
    s.fillArea(bottomBun, bun);
    s.ink(bottomBun, width: 2.6);
    final pattyLayer = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: const Offset(50, 66.5),
            width: 34,
            height: 6.4,
          ),
          const Radius.circular(3.2),
        ),
      );
    s.fillArea(pattyLayer, meat);
    s.ink(pattyLayer, width: 2.2);
    final drip = mood == CharacterMood.yum ? 3.2 : 0.0;
    final cheeseLayer = Path()
      ..moveTo(33, 60)
      ..lineTo(67, 60)
      ..lineTo(67, 62.5)
      ..quadraticBezierTo(64, 64 + drip, 61, 62.8)
      ..quadraticBezierTo(56, 65 + drip * 1.4, 52, 62.6)
      ..quadraticBezierTo(45, 65 + drip, 40, 62.6)
      ..quadraticBezierTo(36, 64, 33, 62.5)
      ..close();
    s.fillArea(cheeseLayer, cheese);
    s.ink(cheeseLayer, width: 2);
    final ruffle = Path()
      ..moveTo(32, 58)
      ..quadraticBezierTo(36, 54.5, 40, 58)
      ..quadraticBezierTo(44, 54.5, 48, 58)
      ..quadraticBezierTo(52, 54.5, 56, 58)
      ..quadraticBezierTo(60, 54.5, 64, 58)
      ..quadraticBezierTo(66, 56, 68, 58)
      ..lineTo(67, 60.5)
      ..lineTo(33, 60.5)
      ..close();
    s.fillArea(ruffle, lettuce);
    s.ink(ruffle, width: 1.8);
    final tip = s.performing
        ? 0.17 * bell(s.perfT)
        : (mood == CharacterMood.joy ? 0.14 : 0.0);
    s.canvas.save();
    if (tip > 0) {
      s.canvas.translate(50, 46);
      s.canvas.rotate(-tip);
      s.canvas.translate(-53, -52 - (s.performing ? 3.2 * bell(s.perfT) : 0));
    }
    final topBun = Path()
      ..moveTo(34, 57)
      ..cubicTo(34, 42, 40, 34, 50, 34)
      ..cubicTo(60, 34, 66, 42, 66, 57)
      ..quadraticBezierTo(50, 60, 34, 57)
      ..close();
    s.fillArea(topBun, bun);
    s.shade(topBun, lift: const Offset(-2.2, -2.8));
    s.ink(topBun, width: 2.8);
    for (final seed in const [
      Offset(42, 41),
      Offset(51, 38),
      Offset(59, 43),
      Offset(45, 48),
      Offset(56, 50),
    ]) {
      final grain = Path()
        ..addOval(Rect.fromCenter(center: seed, width: 2.6, height: 1.5));
      s.fillArea(grain, Inks.cream, amp: 0.15);
    }
    s.moodFace(
      const Offset(50, 47),
      mood,
      spread: 10,
      mouthDrop: 6.5,
      scale: 0.9,
    );
    s.canvas.restore();
    if (mood == CharacterMood.signature) {
      s.arm(const Offset(33, 62), 152, 8.5);
      s.arm(const Offset(67, 60), 348, 10, bendDeg: -8);
    } else {
      s.moodArms(mood, const Offset(33, 62), const Offset(67, 62), len: 8.5);
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(76, 44), 2.2);
      case CharacterMood.joy:
        s.popTicks(const Offset(48, 30), 12, count: 5);
      case CharacterMood.yum:
        s.heart(const Offset(73, 50), 2.4);
      case CharacterMood.sleepy:
        s.zzz(const Offset(71, 34));
      case CharacterMood.hype:
        s.speedLines(const Offset(23, 60), 182, len: 10, count: 4);
    }
  });
}

const fritz = FoodCharacter(
  id: 'fritz',
  name: 'Fritz',
  family: 'Street Squad',
  title: 'The Whole Squad In A Box',
  story:
      'Technically one character, spiritually seven. Fritz never goes anywhere '
      'alone; the smallest fry, Pip, rides up front and sees everything first.',
  accent: Color(0xFFE0503E),
  moodLore: {
    CharacterMood.signature: 'Pip has spotted something good.',
    CharacterMood.joy: 'Everybody lean out, group photo!',
    CharacterMood.yum: 'Passing the ketchup around the box.',
    CharacterMood.sleepy: 'The whole box is flopped over.',
    CharacterMood.hype: 'FRIES UP. Somebody said road trip.',
  },
  painter: _paintFritz,
  motion: MotionProfile(style: PerformanceStyle.shake),
);

void _paintFritz(Sketch s, CharacterMood mood) {
  const carton = Color(0xFFE0503E);
  const fry = Color(0xFFF2C34B);
  s.groundShadow(const Offset(50, 88), 16);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 79), spread: 12, len: 6);
    final lean = mood == CharacterMood.joy ? 1.0 : 0.0;
    final droop = mood == CharacterMood.sleepy;
    final scatter = mood == CharacterMood.hype;
    final xs = const [40.0, 45.5, 51.0, 56.5, 61.0];
    final tops = const [30.0, 24.0, 27.0, 23.0, 31.0];
    for (var i = 0; i < xs.length; i++) {
      final x = xs[i] + (i - 2) * lean * 2.2;
      final top = scatter ? tops[i] - 4 : tops[i];
      if (droop) {
        final flop = Path()
          ..moveTo(xs[i] - 2.2, 48)
          ..lineTo(xs[i] - 2.2, 38)
          ..quadraticBezierTo(xs[i] - 2, 32, xs[i] + (i - 2) * 3.4, 33.5)
          ..quadraticBezierTo(xs[i] + 2.4, 36, xs[i] + 2.2, 40)
          ..lineTo(xs[i] + 2.2, 48)
          ..close();
        s.fillArea(flop, fry, amp: 0.4);
        s.ink(flop, width: 1.8, amp: 0.4);
      } else {
        final stick = Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x - 2.2, top, 4.4, 48 - top),
              const Radius.circular(2),
            ),
          );
        s.fillArea(stick, fry, amp: 0.35);
        s.ink(stick, width: 1.8, amp: 0.35);
      }
    }
    final box = Path()
      ..moveTo(36, 46)
      ..lineTo(64, 46)
      ..lineTo(62.5, 78)
      ..quadraticBezierTo(50, 80.5, 37.5, 78)
      ..close();
    s.fillArea(box, carton);
    s.shade(box, lift: const Offset(-2, -2.4));
    s.ink(box, width: 2.8);
    s.strokeLine(const Offset(36, 46), const Offset(64, 46), width: 2.2);
    if (!droop) {
      final pipX = scatter ? 43.0 : 44.0;
      final pipTop = scatter ? 34.0 : 40.0;
      final pip = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(pipX - 2.6, pipTop, 5.2, 46 - pipTop),
            const Radius.circular(2.4),
          ),
        );
      s.fillArea(pip, const Color(0xFFF6D276), amp: 0.3);
      s.ink(pip, width: 1.8, amp: 0.3);
      s.dot(Offset(pipX - 1, pipTop + 3.4), 0.8);
      s.dot(Offset(pipX + 1, pipTop + 3.4), 0.8);
      if (scatter) {
        s.mouthSmile(Offset(pipX, pipTop + 5.6), 2.2, curveDepth: 1.2);
      }
    }
    s.moodArms(mood, const Offset(37, 60), const Offset(63, 60), len: 8.5);
    s.moodFace(
      const Offset(50, 60),
      mood,
      spread: 10,
      mouthDrop: 6.5,
      scale: 0.9,
      blushColor: const Color(0xFFF6B49F),
    );
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(72, 26), 2.4);
      case CharacterMood.joy:
        s.popTicks(const Offset(50, 20), 9, count: 5);
      case CharacterMood.yum:
        s.heart(const Offset(70, 40), 2.5);
      case CharacterMood.sleepy:
        s.zzz(const Offset(70, 34));
      case CharacterMood.hype:
        s.speedLines(const Offset(24, 58), 182, len: 9);
        s.confetti(
          const Rect.fromLTWH(28, 10, 44, 10),
          count: 8,
          colors: const [fry, Inks.sun, Inks.cream, fry],
        );
    }
  });
}

const peppo = FoodCharacter(
  id: 'peppo',
  name: 'Peppo',
  family: 'Street Squad',
  title: 'The Laid-Back Slice',
  story:
      'Balances on the tip like it is nothing, because to Peppo it is nothing. '
      'The board goes where Peppo goes; the cheese follows a second later.',
  accent: Color(0xFFF5CE58),
  moodLore: {
    CharacterMood.signature: 'Chilling with the board. No rush.',
    CharacterMood.joy: 'Landed the trick called lunch.',
    CharacterMood.yum: 'Extra pepperoni dropped. Beautiful.',
    CharacterMood.sleepy: 'Cheese fully relaxed.',
    CharacterMood.hype: 'Dropping in! Cheese trailing behind.',
  },
  painter: _paintPeppo,
  motion: MotionProfile(style: PerformanceStyle.spin),
);

void _paintPeppo(Sketch s, CharacterMood mood) {
  const crust = Color(0xFFE2A45C);
  const cheese = Color(0xFFF5CE58);
  const pepperoni = Color(0xFFC24435);
  final riding = mood == CharacterMood.hype;
  s.groundShadow(const Offset(50, 88), 15);
  s.posed(mood, () {
    if (riding) {
      s.strokeLine(const Offset(38, 84), const Offset(62, 84), width: 3);
      s.dot(const Offset(42, 86.5), 1.9);
      s.dot(const Offset(58, 86.5), 1.9);
      s.strokeLine(const Offset(46, 76), const Offset(44, 82.5), width: 2.4);
      s.strokeLine(const Offset(52, 76), const Offset(56, 82.5), width: 2.4);
    } else {
      s.legs(mood, const Offset(50, 76), spread: 8, len: 6);
    }
    final slice = Path()
      ..moveTo(33, 39)
      ..lineTo(67, 39)
      ..quadraticBezierTo(60, 58, 52, 76)
      ..quadraticBezierTo(50, 79, 48, 76)
      ..quadraticBezierTo(40, 58, 33, 39)
      ..close();
    s.fillArea(slice, cheese);
    s.shade(slice, lift: const Offset(-2, -2.6));
    s.ink(slice, width: 2.7);
    final sag = mood == CharacterMood.sleepy ? 3.0 : 0.0;
    final melt = Path()
      ..moveTo(34, 40)
      ..quadraticBezierTo(37, 45 + sag, 40, 41.5)
      ..quadraticBezierTo(44, 47 + sag * 1.4, 49, 42)
      ..quadraticBezierTo(54, 47.5 + sag, 59, 41.5)
      ..quadraticBezierTo(62.5, 45 + sag, 66, 40)
      ..lineTo(66, 39.5)
      ..lineTo(34, 39.5)
      ..close();
    s.fillArea(melt, const Color(0xFFF8DE8C));
    s.ink(melt, width: 1.6, amp: 0.6);
    final band = Path()
      ..moveTo(31, 39)
      ..quadraticBezierTo(50, 30, 69, 39)
      ..lineTo(68, 33.6)
      ..quadraticBezierTo(50, 25, 32, 33.6)
      ..close();
    s.fillArea(band, crust);
    s.grain(band, dots: 6);
    s.ink(band, width: 2.6);
    for (final dotAt in const [
      Offset(43, 50),
      Offset(57, 52),
      Offset(50, 64),
    ]) {
      final slicePep = Path()
        ..addOval(Rect.fromCircle(center: dotAt, radius: 3.1));
      s.fillArea(slicePep, pepperoni, amp: 0.25);
      s.ink(slicePep, width: 1.4, amp: 0.25);
    }
    s.moodArms(mood, const Offset(39, 47), const Offset(61, 47), len: 8.5);
    if (mood == CharacterMood.signature) {
      s.eyeLid(const Offset(45.5, 45), 2.3);
      s.eyeLid(const Offset(54.5, 45), 2.3);
      s.mouthSmile(const Offset(50, 52), 5.6, curveDepth: 2.4);
      s.blushTicks(const Offset(40, 49), s: 0.85);
      s.blushTicks(const Offset(60, 49), s: 0.85);
      final board = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: const Offset(72, 66),
              width: 5.5,
              height: 22,
            ),
            const Radius.circular(2.6),
          ),
        );
      s.fillArea(board, Inks.sky, amp: 0.4);
      s.ink(board, width: 1.8, amp: 0.4);
      s.dot(const Offset(70.2, 58), 1.4);
      s.dot(const Offset(70.2, 74), 1.4);
    } else {
      s.moodFace(
        const Offset(50, 45),
        mood,
        spread: 9,
        mouthDrop: 7,
        scale: 0.88,
      );
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(28, 28), 2);
      case CharacterMood.joy:
        s.popTicks(const Offset(50, 26), 10, count: 5);
      case CharacterMood.yum:
        s.heart(const Offset(70, 46), 2.4);
      case CharacterMood.sleepy:
        s.zzz(const Offset(70, 30));
      case CharacterMood.hype:
        s.speedLines(const Offset(24, 50), 185, len: 10, count: 4);
        s.strokeLine(
          const Offset(28, 68),
          const Offset(35, 64),
          width: 1.8,
          color: const Color(0xFFF8DE8C),
        );
    }
  });
}

const tico = FoodCharacter(
  id: 'tico',
  name: 'Tico',
  family: 'Street Squad',
  title: 'The Crunchy Bandleader',
  story:
      'Fills every silence with rhythm and every shell with confetti of '
      'lettuce and tomato. Tico\'s lime maracas have never once been on beat.',
  accent: Color(0xFFEFC15B),
  moodLore: {
    CharacterMood.signature: 'Soundcheck. One lime, two lime.',
    CharacterMood.joy: 'The chorus hit and so did dinner.',
    CharacterMood.yum: 'Salsa verde encore.',
    CharacterMood.sleepy: 'The band bus, after the show.',
    CharacterMood.hype: 'DOUBLE MARACA FINALE.',
  },
  painter: _paintTico,
  motion: MotionProfile(tempo: 1.15, style: PerformanceStyle.shake),
);

void _paintTico(Sketch s, CharacterMood mood) {
  const shell = Color(0xFFEFC15B);
  const lettuce = Color(0xFF7CB65C);
  const tomato = Color(0xFFD8452E);
  s.groundShadow(const Offset(50, 88), 17);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 76), spread: 11, len: 6.5);
    final filling = Path()
      ..moveTo(28, 52)
      ..quadraticBezierTo(33, 45.5, 39, 51)
      ..quadraticBezierTo(44, 45, 50, 50.5)
      ..quadraticBezierTo(56, 45, 61, 51)
      ..quadraticBezierTo(67, 45.5, 72, 52)
      ..close();
    s.fillArea(filling, lettuce, amp: 0.6);
    s.ink(filling, width: 1.8, amp: 0.6);
    for (final t in const [
      Offset(38, 48.5),
      Offset(52, 47.5),
      Offset(64, 49),
    ]) {
      s.dot(t, 1.9, color: tomato);
    }
    for (final c in const [
      Offset(33, 47),
      Offset(46, 45.5),
      Offset(59, 45.5),
    ]) {
      s.strokeLine(
        c,
        c + const Offset(1.2, -3),
        width: 1.6,
        color: const Color(0xFFF8DE8C),
        amp: 0.2,
      );
    }
    final body = Path()
      ..moveTo(26, 52)
      ..lineTo(74, 52)
      ..cubicTo(74, 68, 64, 78, 50, 78)
      ..cubicTo(36, 78, 26, 68, 26, 52)
      ..close();
    s.fillArea(body, shell);
    s.shade(body, lift: const Offset(-2.2, -2.8));
    s.grain(body, dots: 9);
    s.ink(body, width: 2.8);
    void maraca(Offset hand, double angleDeg, {bool shaking = true}) {
      final head = s.polar(hand, angleDeg, 5.4);
      s.strokeLine(hand, head, width: 1.8);
      final limeHalf = Path()
        ..addOval(Rect.fromCircle(center: head, radius: 3.2));
      s.fillArea(limeHalf, Inks.leaf, amp: 0.25);
      s.ink(limeHalf, width: 1.5, amp: 0.25);
      s.dot(head, 1.1, color: const Color(0xFFDFF0B8));
      if (shaking) {
        s.popTicks(
          head,
          4.4,
          count: 3,
          len: 1.8,
          startDeg: angleDeg - 50,
          endDeg: angleDeg + 50,
          width: 1.2,
        );
      }
    }

    if (mood == CharacterMood.signature) {
      s.arm(const Offset(30, 58), 152, 8);
      s.arm(const Offset(70, 58), 335, 9, bendDeg: 16);
      maraca(s.polar(const Offset(70, 58), 335, 9), -60);
    } else if (mood == CharacterMood.joy || mood == CharacterMood.hype) {
      s.moodArms(mood, const Offset(30, 58), const Offset(70, 58), len: 9);
      final la = mood == CharacterMood.joy ? 227.0 : 205.0;
      final ra = mood == CharacterMood.joy ? 313.0 : 335.0;
      maraca(
        s.polar(
          const Offset(30, 58),
          la,
          mood == CharacterMood.joy ? 9.7 : 8.6,
        ),
        la,
      );
      maraca(
        s.polar(
          const Offset(70, 58),
          ra,
          mood == CharacterMood.joy ? 9.7 : 9.9,
        ),
        ra,
      );
    } else {
      s.moodArms(mood, const Offset(30, 58), const Offset(70, 58), len: 8.5);
    }
    s.moodFace(
      const Offset(50, 61),
      mood,
      spread: 10,
      mouthDrop: 6.5,
      scale: 0.9,
    );
    switch (mood) {
      case CharacterMood.signature:
        s.musicNote(const Offset(76, 40), s: 2.6);
      case CharacterMood.joy:
        s.musicNote(const Offset(24, 34), s: 2.6);
        s.musicNote(const Offset(74, 30), s: 3);
      case CharacterMood.yum:
        s.heart(const Offset(72, 40), 2.4);
      case CharacterMood.sleepy:
        s.zzz(const Offset(71, 36));
      case CharacterMood.hype:
        s.musicNote(const Offset(22, 30), s: 2.6);
        s.musicNote(const Offset(76, 26), s: 3);
        s.confetti(const Rect.fromLTWH(32, 14, 36, 12), count: 10);
    }
  });
}

const frank = FoodCharacter(
  id: 'frank',
  name: 'Frank',
  family: 'Street Squad',
  title: 'The Corner-Cart Hustler',
  story:
      'Knows everyone on the block by order. Frank\'s bun doubles as a '
      'sleeping bag, which is either genius or the whole business plan.',
  accent: Color(0xFFC05B45),
  moodLore: {
    CharacterMood.signature: 'Cap tipped. What can I get you?',
    CharacterMood.joy: 'Sold out before noon. Cap goes up.',
    CharacterMood.yum: 'Sampling the merchandise, strictly professional.',
    CharacterMood.sleepy: 'Zipped into the bun till opening time.',
    CharacterMood.hype: 'Rush hour! Mustard lightning!',
  },
  painter: _paintFrank,
  motion: MotionProfile(style: PerformanceStyle.pop),
);

void _paintFrank(Sketch s, CharacterMood mood) {
  const bunColor = Color(0xFFE2A25C);
  const sausage = Color(0xFFC05B45);
  const capBlue = Color(0xFF5B7FA6);
  final sunk = mood == CharacterMood.sleepy;
  final sink = sunk ? 9.0 : 0.0;
  s.groundShadow(const Offset(50, 88), 17);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 80), spread: 12, len: 5.5);
    final dog = Path()
      ..moveTo(41, 70)
      ..lineTo(41, 40 + sink)
      ..cubicTo(41, 30 + sink, 45, 26 + sink, 50, 26 + sink)
      ..cubicTo(55, 26 + sink, 59, 30 + sink, 59, 40 + sink)
      ..lineTo(59, 70)
      ..close();
    s.fillArea(dog, sausage);
    s.shade(dog, lift: const Offset(-1.8, -2.2));
    s.ink(dog, width: 2.6);
    if (!sunk) {
      final zig = Path()
        ..moveTo(45, 49)
        ..lineTo(55, 45.5)
        ..lineTo(45, 42.5)
        ..lineTo(55, 39)
        ..lineTo(45, 36);
      s.ink(zig, width: 2.3, color: Inks.sun, amp: 0.3);
    }
    s.moodFace(
      Offset(50, 36 + sink),
      mood,
      spread: 8,
      mouthDrop: 5.6,
      scale: 0.8,
    );
    final rest = Offset(50, 25 + sink + (sunk ? 1.4 : 0));
    final toss = s.performing
        ? bell(s.perfT)
        : (mood == CharacterMood.joy ? 1.0 : 0.0);
    final capAt = Offset.lerp(rest, const Offset(62, 13), toss)!;
    final capTilt = toss > 0 ? 0.4 * toss : (sunk ? -0.18 : 0.0);
    s.canvas.save();
    s.canvas.translate(capAt.dx, capAt.dy);
    s.canvas.rotate(capTilt);
    final dome = Path()
      ..moveTo(-6.5, 0.6)
      ..quadraticBezierTo(-6, -4.4, 0, -4.4)
      ..quadraticBezierTo(6, -4.4, 6.5, 0.6)
      ..close();
    s.fillArea(dome, capBlue, amp: 0.3);
    s.ink(dome, width: 1.7, amp: 0.3);
    s.strokeLine(const Offset(-7.6, 1), const Offset(9.4, 1), width: 1.9);
    s.canvas.restore();
    final bunShell = Path()
      ..moveTo(35, 52)
      ..cubicTo(33, 52, 32, 55, 32, 60)
      ..cubicTo(32, 72, 38, 79, 50, 79)
      ..cubicTo(62, 79, 68, 72, 68, 60)
      ..cubicTo(68, 55, 67, 52, 65, 52)
      ..quadraticBezierTo(50, 57, 35, 52)
      ..close();
    s.fillArea(bunShell, bunColor);
    s.shade(bunShell, lift: const Offset(-2, -2.4));
    s.grain(bunShell, dots: 6);
    s.ink(bunShell, width: 2.8);
    if (mood == CharacterMood.signature) {
      s.arm(const Offset(34, 62), 152, 8);
      s.arm(const Offset(66, 58), 285, 9, bendDeg: -30);
    } else {
      s.moodArms(mood, const Offset(34, 62), const Offset(66, 62), len: 8.5);
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(74, 34), 2.2);
      case CharacterMood.joy:
        s.popTicks(const Offset(64, 14), 8, count: 4);
      case CharacterMood.yum:
        s.heart(const Offset(70, 36), 2.2, color: Inks.sun);
        s.heart(const Offset(75, 42), 2.2);
      case CharacterMood.sleepy:
        s.zzz(const Offset(69, 30));
      case CharacterMood.hype:
        final bolt = Path()
          ..moveTo(72, 26)
          ..lineTo(67, 34)
          ..lineTo(71, 34.5)
          ..lineTo(66, 43)
          ..lineTo(74, 32.5)
          ..lineTo(70.5, 32)
          ..close();
        s.fillArea(bolt, Inks.sun, amp: 0.2);
        s.ink(bolt, width: 1.3, amp: 0.2);
        s.speedLines(const Offset(24, 60), 182, len: 9);
    }
  });
}
