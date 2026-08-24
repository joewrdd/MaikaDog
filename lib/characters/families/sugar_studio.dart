import 'dart:ui';

import '../core/food_character.dart';
import '../core/sketch.dart';

const sugarStudio = CharacterFamily(
  name: 'Sugar Studio',
  tagline: 'Little celebrations, plated daily.',
  slug: 'sugar_studio',
  members: [poppy, swirl, coco, maca, flan],
);

const poppy = FoodCharacter(
  id: 'poppy',
  name: 'Poppy',
  family: 'Sugar Studio',
  title: 'The Walking Birthday',
  story:
      'Believes every day is somebody\'s birthday somewhere, and refuses to '
      'waste it. The cherry pin is ceremonial. The frosting is load-bearing.',
  accent: Color(0xFFE86A8A),
  moodLore: {
    CharacterMood.signature: 'Scanning the room for birthdays.',
    CharacterMood.joy: 'FOUND ONE. Candle lit, song incoming.',
    CharacterMood.yum: 'Frosting inspection passed.',
    CharacterMood.sleepy: 'After the party. Frosting at half mast.',
    CharacterMood.hype: 'Surprise party mode. Places, everyone!',
  },
  painter: _paintPoppy,
  motion: MotionProfile(style: PerformanceStyle.pop),
);

void _paintPoppy(Sketch s, CharacterMood mood) {
  const wrapper = Color(0xFFE86A8A);
  const frosting = Color(0xFFF5C7D6);
  s.groundShadow(const Offset(50, 88), 15);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 79), spread: 11, len: 5.5);
    final skirt = Path()
      ..moveTo(36, 58)
      ..lineTo(64, 58)
      ..lineTo(60.5, 80)
      ..quadraticBezierTo(50, 82, 39.5, 80)
      ..close();
    s.fillArea(skirt, wrapper);
    s.shade(skirt, lift: const Offset(-1.8, -2.2));
    s.ink(skirt, width: 2.7);
    for (var i = 1; i < 5; i++) {
      final xTop = 36 + i * 5.6;
      final xBot = 39.5 + i * 4.2;
      s.strokeLine(
        Offset(xTop, 58.5),
        Offset(xBot, 79.5),
        width: 1.3,
        color: const Color(0x66B34561),
        amp: 0.2,
      );
    }
    var mound = Path()
      ..addOval(
        Rect.fromCenter(center: const Offset(50, 53), width: 30, height: 13),
      );
    mound = Path.combine(
      PathOperation.union,
      mound,
      Path()..addOval(
        Rect.fromCenter(center: const Offset(50, 44), width: 24, height: 12),
      ),
    );
    mound = Path.combine(
      PathOperation.union,
      mound,
      Path()..addOval(
        Rect.fromCenter(center: const Offset(50, 35), width: 17, height: 11),
      ),
    );
    mound = Path.combine(
      PathOperation.union,
      mound,
      Path()
        ..addOval(Rect.fromCircle(center: const Offset(52.5, 27), radius: 4.4)),
    );
    s.fillArea(mound, frosting);
    s.shade(mound, lift: const Offset(-1.8, -2.4));
    s.ink(mound, width: 2.7);
    s.curve(
      const Offset(41, 49),
      const Offset(50, 52),
      const Offset(59, 49),
      width: 1.4,
      color: const Color(0x59CE8FA5),
      amp: 0.3,
    );
    s.curve(
      const Offset(43, 40),
      const Offset(50, 43),
      const Offset(57, 40),
      width: 1.4,
      color: const Color(0x59CE8FA5),
      amp: 0.3,
    );
    s.dot(const Offset(58.5, 30), 2.6, color: const Color(0xFFD8452E));
    s.gleam(const Offset(57.7, 29.2), 1.3, sweepDeg: 70, width: 1);
    s.curve(
      const Offset(58.5, 27.4),
      const Offset(59.5, 24.4),
      const Offset(61.5, 23),
      width: 1.4,
      color: Inks.leafDeep,
    );
    s.moodArms(mood, const Offset(37, 61), const Offset(63, 61), len: 8.5);
    s.moodFace(
      const Offset(50, 44),
      mood,
      spread: 9.5,
      mouthDrop: 6,
      scale: 0.88,
    );
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(29, 30), 2.2);
        s.sparkle(const Offset(72, 40), 1.9);
      case CharacterMood.joy:
        s.strokeLine(
          const Offset(45, 24),
          const Offset(45, 17.5),
          width: 2.2,
          color: Inks.cream,
        );
        s.strokeLine(
          const Offset(45, 22),
          const Offset(45, 20.5),
          width: 2.2,
          color: wrapper,
        );
        final flame = Path()
          ..moveTo(45, 16.5)
          ..quadraticBezierTo(47.4, 13.6, 45, 10.5)
          ..quadraticBezierTo(42.6, 13.6, 45, 16.5)
          ..close();
        s.fillArea(flame, Inks.sun, amp: 0.2);
        s.ink(flame, width: 1.2, amp: 0.2);
        s.confetti(const Rect.fromLTWH(24, 12, 52, 14), count: 12);
      case CharacterMood.yum:
        for (final sp in const [
          [Offset(44, 36), Inks.sky],
          [Offset(54, 33), Inks.sun],
          [Offset(47, 46), Inks.leaf],
          [Offset(57, 44), Inks.sky],
        ]) {
          s.strokeLine(
            sp[0] as Offset,
            (sp[0] as Offset) + const Offset(1.8, 1),
            width: 1.5,
            color: sp[1] as Color,
            amp: 0.1,
          );
        }
        s.heart(const Offset(71, 36), 2.4);
      case CharacterMood.sleepy:
        s.zzz(const Offset(70, 28));
      case CharacterMood.hype:
        s.popTicks(const Offset(50, 22), 11, count: 6);
        s.confetti(const Rect.fromLTWH(20, 26, 14, 22), count: 6);
        s.confetti(const Rect.fromLTWH(66, 26, 14, 22), count: 6);
    }
  });
}

const swirl = FoodCharacter(
  id: 'swirl',
  name: 'Swirl',
  family: 'Sugar Studio',
  title: 'The Melodramatic Peak',
  story:
      'A soft-serve artist in every sense. Swirl insists the melting is not a '
      'flaw but a performance, and demands the audience feel something.',
  accent: Color(0xFFF8EFE6),
  moodLore: {
    CharacterMood.signature: 'Holding the pose. Peak form.',
    CharacterMood.joy: 'A standing ovation somewhere, surely.',
    CharacterMood.yum: 'Self-taste. Purely artistic research.',
    CharacterMood.sleepy: 'Melting. Dramatically. As rehearsed.',
    CharacterMood.hype: 'The spin! The crowd! The swirl!',
  },
  painter: _paintSwirl,
  motion: MotionProfile(style: PerformanceStyle.spin),
);

void _paintSwirl(Sketch s, CharacterMood mood) {
  const cream = Color(0xFFF8EFE6);
  const cone = Color(0xFFE0A85F);
  final melting = mood == CharacterMood.sleepy;
  s.groundShadow(const Offset(50, 88), 14);
  s.posed(
    mood,
    () {
      final coneBody = Path()
        ..moveTo(38, 52)
        ..lineTo(62, 52)
        ..quadraticBezierTo(56, 70, 51, 83)
        ..quadraticBezierTo(50, 85, 49, 83)
        ..quadraticBezierTo(44, 70, 38, 52)
        ..close();
      s.fillArea(coneBody, cone);
      s.hatch(
        coneBody,
        angleDeg: 30,
        gap: 6,
        width: 1.2,
        color: const Color(0x59B27C3C),
      );
      s.hatch(
        coneBody,
        angleDeg: -30,
        gap: 6,
        width: 1.2,
        color: const Color(0x59B27C3C),
      );
      s.ink(coneBody, width: 2.7);
      var head = Path()
        ..addOval(
          Rect.fromCenter(center: const Offset(50, 48), width: 34, height: 11),
        );
      head = Path.combine(
        PathOperation.union,
        head,
        Path()..addOval(
          Rect.fromCenter(center: const Offset(50, 40), width: 28, height: 11),
        ),
      );
      head = Path.combine(
        PathOperation.union,
        head,
        Path()..addOval(
          Rect.fromCenter(center: const Offset(50, 31), width: 20, height: 10),
        ),
      );
      head = Path.combine(
        PathOperation.union,
        head,
        Path()
          ..addOval(Rect.fromCircle(center: const Offset(54, 23), radius: 4.6)),
      );
      s.fillArea(head, cream);
      s.shade(
        head,
        lift: const Offset(-1.8, -2.4),
        color: const Color(0x21C9A24C),
      );
      s.ink(head, width: 2.7);
      s.curve(
        const Offset(38, 45),
        const Offset(50, 48.5),
        const Offset(62, 45),
        width: 1.4,
        color: const Color(0x40C9A24C),
        amp: 0.3,
      );
      s.curve(
        const Offset(40, 36.5),
        const Offset(50, 39.5),
        const Offset(60, 36.5),
        width: 1.4,
        color: const Color(0x40C9A24C),
        amp: 0.3,
      );
      if (melting) {
        final drip = Path()
          ..moveTo(41, 52.5)
          ..quadraticBezierTo(40, 60, 41.5, 64)
          ..quadraticBezierTo(43.4, 60, 43, 53);
        s.fillArea(drip, cream, amp: 0.3);
        s.ink(drip, width: 1.5, amp: 0.3);
        final puddle = Path()
          ..addOval(
            Rect.fromCenter(
              center: const Offset(31, 86),
              width: 12,
              height: 3.6,
            ),
          );
        s.fillArea(puddle, cream, amp: 0.4);
        s.ink(puddle, width: 1.3, amp: 0.4);
      }
      s.moodArms(mood, const Offset(40, 56), const Offset(60, 56), len: 8);
      s.moodFace(
        const Offset(50, 39),
        mood,
        spread: 9.5,
        mouthDrop: 6,
        scale: 0.88,
      );
      switch (mood) {
        case CharacterMood.signature:
          s.gleam(const Offset(43, 30), 4.6, sweepDeg: 44);
          s.sparkle(const Offset(71, 28), 2.3);
          s.dot(const Offset(63, 51), 1.4, color: cream);
        case CharacterMood.joy:
          s.confetti(const Rect.fromLTWH(28, 10, 44, 12), count: 9);
        case CharacterMood.yum:
          s.heart(const Offset(70, 34), 2.4);
          s.strokeLine(
            const Offset(36, 30),
            const Offset(33.6, 36),
            width: 2,
            color: cream,
          );
        case CharacterMood.sleepy:
          s.zzz(const Offset(70, 26));
        case CharacterMood.hype:
          s.curve(
            const Offset(28, 34),
            const Offset(24, 26),
            const Offset(31, 20),
            width: 1.8,
            color: Inks.inkSoft,
          );
          s.curve(
            const Offset(72, 34),
            const Offset(76, 26),
            const Offset(69, 20),
            width: 1.8,
            color: Inks.inkSoft,
          );
          s.popTicks(const Offset(54, 18), 8, count: 4);
      }
    },
    pose: melting ? const MoodPose(dy: 3, rot: -0.06, sy: 0.9, sx: 1.06) : null,
  );
}

const coco = FoodCharacter(
  id: 'coco',
  name: 'Coco',
  family: 'Sugar Studio',
  title: 'The Smooth Talker',
  story:
      'Seventy percent charm, thirty percent cocoa. Coco keeps the foil jacket '
      'half on because commitment, like chocolate, is best served slow.',
  accent: Color(0xFF6B4231),
  moodLore: {
    CharacterMood.signature: 'One eyebrow. That is the whole move.',
    CharacterMood.joy: 'Offering you a square. The good corner one.',
    CharacterMood.yum: 'Slightly melted. Extremely composed.',
    CharacterMood.sleepy: 'Foil blanket up. Do not tell anyone.',
    CharacterMood.hype: 'Limited edition energy.',
  },
  painter: _paintCoco,
  motion: MotionProfile(tempo: 0.9, style: PerformanceStyle.bow),
);

void _paintCoco(Sketch s, CharacterMood mood) {
  const cocoa = Color(0xFF6B4231);
  const foil = Color(0xFFC9CFD9);
  final blanket = mood == CharacterMood.sleepy;
  s.groundShadow(const Offset(50, 88), 15);
  s.posed(mood, () {
    s.legs(mood, const Offset(50, 79), spread: 11, len: 6);
    final slab = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(35, 30, 30, 50),
          const Radius.circular(5),
        ),
      );
    s.fillArea(slab, cocoa);
    s.ink(slab, width: 2.8);
    for (final y in const [42.5, 55.0, 67.5]) {
      s.strokeLine(
        Offset(36, y),
        Offset(64, y),
        width: 1.5,
        color: const Color(0x59F2E3C9),
        amp: 0.3,
      );
    }
    s.strokeLine(
      const Offset(50, 31),
      const Offset(50, 79),
      width: 1.5,
      color: const Color(0x59F2E3C9),
      amp: 0.3,
    );
    if (mood == CharacterMood.yum) {
      final melt = Path()
        ..moveTo(36.5, 76)
        ..quadraticBezierTo(35, 82, 37.5, 84)
        ..quadraticBezierTo(40, 82, 39.5, 78);
      s.fillArea(melt, cocoa, amp: 0.3);
      s.ink(melt, width: 1.5, amp: 0.3);
    }
    final foilTop = blanket ? 48.0 : 62.0;
    final wrapPath = Path()..moveTo(34, foilTop + 2);
    for (var i = 0; i < 6; i++) {
      final x = 34 + (i + 0.5) * 32 / 6;
      wrapPath.lineTo(x, foilTop + (i.isEven ? -3.4 : 1.6));
    }
    wrapPath
      ..lineTo(66, foilTop + 2)
      ..lineTo(66, 81)
      ..quadraticBezierTo(50, 83.5, 34, 81)
      ..close();
    s.fillArea(wrapPath, foil);
    s.ink(wrapPath, width: 2.2);
    s.strokeLine(
      Offset(41, foilTop + 5),
      const Offset(44, 78),
      width: 1.2,
      color: const Color(0x66808A99),
      amp: 0.4,
    );
    s.strokeLine(
      Offset(56, foilTop + 4),
      const Offset(58, 78),
      width: 1.2,
      color: const Color(0x66808A99),
      amp: 0.4,
    );
    s.gleam(
      Offset(48, foilTop + 10),
      6,
      sweepDeg: 36,
      color: const Color(0xB8EFF3F8),
    );
    if (mood == CharacterMood.joy) {
      s.moodArms(mood, const Offset(36, 58), const Offset(64, 58), len: 8.5);
      final piece = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: const Offset(74, 42), width: 8, height: 8),
            const Radius.circular(1.8),
          ),
        );
      s.fillArea(piece, cocoa, amp: 0.25);
      s.ink(piece, width: 1.6, amp: 0.25);
      s.popTicks(const Offset(74, 42), 6.4, count: 4, len: 2, width: 1.2);
    } else {
      s.moodArms(mood, const Offset(36, 58), const Offset(64, 58), len: 8.5);
    }
    if (mood == CharacterMood.signature) {
      s.eyeLid(const Offset(45, 43), 2.3);
      s.eyeLid(const Offset(55, 43), 2.3);
      s.brow(const Offset(56, 38), 4, tiltDeg: -22);
      s.mouthSmile(const Offset(52, 50), 5, curveDepth: 2.2);
      s.blushTicks(
        const Offset(40, 47),
        s: 0.8,
        color: const Color(0xFFB9755C),
      );
      s.blushTicks(
        const Offset(60, 47),
        s: 0.8,
        color: const Color(0xFFB9755C),
      );
    } else {
      s.moodFace(
        const Offset(50, 43),
        mood,
        spread: 10,
        mouthDrop: 6.5,
        scale: 0.9,
        blushColor: const Color(0xFFB9755C),
      );
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(72, 30), 2.2);
      case CharacterMood.joy:
        break;
      case CharacterMood.yum:
        s.heart(const Offset(28, 36), 2.3);
        s.steam(const Offset(29, 48), h: 8, sway: 2);
      case CharacterMood.sleepy:
        s.zzz(const Offset(71, 30));
      case CharacterMood.hype:
        s.popTicks(const Offset(50, 26), 10, count: 5);
        s.speedLines(const Offset(26, 60), 183, len: 8);
    }
  });
}

const maca = FoodCharacter(
  id: 'maca',
  name: 'Maca',
  family: 'Sugar Studio',
  title: 'The Pastel Perfectionist',
  story:
      'Speaks entirely through the cream line between its shells, which is '
      'also its mouth. Hovers when excited. Prefers this not be discussed.',
  accent: Color(0xFFB7D9C8),
  moodLore: {
    CharacterMood.signature: 'A composed, curated little wave of cream.',
    CharacterMood.joy: 'The filling positively scalloped.',
    CharacterMood.yum: 'Cream overflow. Elegantly handled.',
    CharacterMood.sleepy: 'The filling has gone flat. Retire the display.',
    CharacterMood.hype: 'Hover engaged. Beam, tastefully, down.',
  },
  painter: _paintMaca,
  motion: MotionProfile(style: PerformanceStyle.float),
);

void _paintMaca(Sketch s, CharacterMood mood) {
  const shell = Color(0xFFB7D9C8);
  const shellDeep = Color(0xFF93BFA9);
  const creamFill = Color(0xFFF8EFE6);
  final hover = mood == CharacterMood.hype;
  s.groundShadow(const Offset(50, 88), hover ? 9 : 15);
  s.posed(mood, () {
    if (!hover) {
      s.legs(
        mood,
        const Offset(50, 72),
        spread: 12,
        len: 7,
        width: 2.2,
        foot: 2,
      );
    } else {
      final beam = Path()
        ..moveTo(41, 72)
        ..lineTo(59, 72)
        ..lineTo(65, 87)
        ..lineTo(35, 87)
        ..close();
      s.fillArea(beam, const Color(0x2EF6B84C), amp: 0.6);
      s.sparkleAround(const Offset(50, 82), 8, count: 3, size: 1.7);
    }
    final top = Path()
      ..moveTo(32, 49)
      ..cubicTo(32, 39, 39, 34, 50, 34)
      ..cubicTo(61, 34, 68, 39, 68, 49)
      ..quadraticBezierTo(50, 52.5, 32, 49)
      ..close();
    final bottom = Path()
      ..moveTo(34, 56)
      ..quadraticBezierTo(50, 53.5, 66, 56)
      ..cubicTo(66, 64, 60, 69, 50, 69)
      ..cubicTo(40, 69, 34, 64, 34, 56)
      ..close();
    s.fillArea(bottom, shell);
    s.shade(bottom, lift: const Offset(-1.6, -2));
    s.ink(bottom, width: 2.6);
    s.fillArea(top, shell);
    s.shade(top, lift: const Offset(-1.8, -2.2));
    s.ink(top, width: 2.6);
    s.curve(
      const Offset(35, 51),
      const Offset(34, 53),
      const Offset(35.5, 55),
      width: 1.2,
      color: shellDeep,
      amp: 0.15,
    );
    s.curve(
      const Offset(65, 51),
      const Offset(66, 53),
      const Offset(64.5, 55),
      width: 1.2,
      color: shellDeep,
      amp: 0.15,
    );
    final creamPath = Path()..moveTo(38, 53);
    switch (mood) {
      case CharacterMood.signature:
        creamPath
          ..quadraticBezierTo(44, 51.6, 49, 53.4)
          ..quadraticBezierTo(55, 55.4, 62, 53);
      case CharacterMood.joy:
        creamPath
          ..quadraticBezierTo(44, 58.6, 50, 53.4)
          ..quadraticBezierTo(56, 58.6, 62, 53);
      case CharacterMood.yum:
        creamPath
          ..quadraticBezierTo(44, 51.8, 48, 53.4)
          ..quadraticBezierTo(52, 57.4, 56, 53.6)
          ..quadraticBezierTo(59.5, 51.8, 62, 53);
      case CharacterMood.sleepy:
        creamPath
          ..quadraticBezierTo(46, 54.4, 55, 54.8)
          ..quadraticBezierTo(59.5, 55, 62, 55.2);
      case CharacterMood.hype:
        creamPath
          ..lineTo(43, 50.8)
          ..lineTo(48, 55.4)
          ..lineTo(53, 50.8)
          ..lineTo(58, 55.4)
          ..lineTo(62, 51.4);
    }
    s.ink(creamPath, width: 4.2, color: creamFill, amp: 0.2);
    s.ink(creamPath, width: 1.7, amp: 0.2, color: const Color(0xCC33251D));
    if (mood == CharacterMood.yum) {
      final drip = Path()
        ..moveTo(55, 55)
        ..quadraticBezierTo(55.4, 59, 54.4, 61)
        ..quadraticBezierTo(53, 58, 53.4, 55.4);
      s.fillArea(drip, creamFill, amp: 0.2);
      s.ink(drip, width: 1.2, amp: 0.2);
    }
    s.moodArms(
      mood,
      const Offset(36, 58.5),
      const Offset(64, 58.5),
      len: 7,
      width: 2.2,
    );
    final eyeL = const Offset(44, 44);
    final eyeR = const Offset(56, 44);
    switch (mood) {
      case CharacterMood.signature:
        s.eyeDot(eyeL, 2.2);
        s.eyeDot(eyeR, 2.2);
      case CharacterMood.joy:
        s.eyeArc(eyeL, 2.5);
        s.eyeArc(eyeR, 2.5);
      case CharacterMood.yum:
        s.eyeHeart(eyeL, 2.5);
        s.eyeHeart(eyeR, 2.5);
      case CharacterMood.sleepy:
        s.eyeLid(eyeL, 2.4);
        s.eyeLid(eyeR, 2.4);
      case CharacterMood.hype:
        s.eyeStar(eyeL, 2.4);
        s.eyeStar(eyeR, 2.4);
    }
    s.blushTicks(const Offset(37, 47), s: 0.85);
    s.blushTicks(const Offset(63, 47), s: 0.85);
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(71, 32), 2.2);
      case CharacterMood.joy:
        s.popTicks(const Offset(50, 30), 10, count: 5);
      case CharacterMood.yum:
        s.heart(const Offset(70, 36), 2.3);
      case CharacterMood.sleepy:
        s.zzz(const Offset(70, 34));
      case CharacterMood.hype:
        s.sparkle(const Offset(28, 30), 2.2);
        s.sparkle(const Offset(72, 26), 2.5);
    }
  }, pose: hover ? const MoodPose(dy: -9) : null);
}

const flan = FoodCharacter(
  id: 'flan',
  name: 'Flan',
  family: 'Sugar Studio',
  title: 'The Bravest Wobble',
  story:
      'Scared of loud noises, sudden moves, and spoons, yet shows up anyway. '
      'The plate is home. The wobble is not fear. Mostly.',
  accent: Color(0xFFEFC15B),
  moodLore: {
    CharacterMood.signature: 'Holding steady. More or less.',
    CharacterMood.joy: 'A good wobble, for once.',
    CharacterMood.yum: 'Caramel appreciation moment.',
    CharacterMood.sleepy: 'The wobble finally rests.',
    CharacterMood.hype: 'Terrified. Thrilled. Both. Fully both.',
  },
  painter: _paintFlan,
  motion: MotionProfile(bounce: 1.7, style: PerformanceStyle.wobble),
);

void _paintFlan(Sketch s, CharacterMood mood) {
  const custard = Color(0xFFEFC15B);
  const caramel = Color(0xFFA25B2E);
  s.groundShadow(const Offset(50, 89), 20);
  s.posed(mood, () {
    final plate = Path()
      ..addOval(
        Rect.fromCenter(center: const Offset(50, 81), width: 46, height: 8),
      );
    s.fillArea(plate, const Color(0xFFF6F1E6));
    s.ink(plate, width: 2.2);
    final body = Path()
      ..moveTo(40, 46)
      ..lineTo(60, 46)
      ..cubicTo(64, 46, 66, 56, 66, 66)
      ..quadraticBezierTo(66, 79, 50, 79)
      ..quadraticBezierTo(34, 79, 34, 66)
      ..cubicTo(34, 56, 36, 46, 40, 46)
      ..close();
    final ghosts = switch (mood) {
      CharacterMood.sleepy => 0,
      CharacterMood.hype => 2,
      _ => 1,
    };
    for (var i = 1; i <= ghosts; i++) {
      s.ink(
        body.shift(Offset(i * 1.6, 0)),
        width: 1.2,
        color: const Color(0x2E33251D),
        amp: 0.7,
      );
      s.ink(
        body.shift(Offset(-i * 1.6, 0)),
        width: 1.2,
        color: const Color(0x2E33251D),
        amp: 0.7,
      );
    }
    s.fillArea(body, custard);
    s.shade(body, lift: const Offset(-2, -2.4));
    s.ink(body, width: 2.8);
    final cap = Path()
      ..moveTo(39.5, 47)
      ..quadraticBezierTo(50, 43.5, 60.5, 47)
      ..quadraticBezierTo(61.5, 50, 60, 52.5)
      ..quadraticBezierTo(58.5, 55.5, 57, 52)
      ..quadraticBezierTo(55, 56.5, 52, 53)
      ..quadraticBezierTo(48, 57, 45, 52.6)
      ..quadraticBezierTo(43, 55, 41.5, 52)
      ..quadraticBezierTo(39, 50, 39.5, 47)
      ..close();
    s.fillArea(cap, caramel);
    s.ink(cap, width: 1.9, amp: 0.7);
    s.moodArms(
      mood,
      const Offset(36, 62),
      const Offset(64, 62),
      len: 7.5,
      width: 2.3,
    );
    if (mood == CharacterMood.signature) {
      s.eyeDot(const Offset(45, 60), 2.5);
      s.eyeDot(const Offset(55, 60), 2.5);
      s.mouthWavy(const Offset(50, 67), 5.4);
      s.blushTicks(const Offset(38.5, 63.5), s: 0.85);
      s.blushTicks(const Offset(61.5, 63.5), s: 0.85);
    } else {
      s.moodFace(
        const Offset(50, 60),
        mood,
        spread: 10,
        mouthDrop: 7,
        scale: 0.92,
      );
    }
    switch (mood) {
      case CharacterMood.signature:
        s.sweat(const Offset(66, 50), s: 1.6);
      case CharacterMood.joy:
        s.popTicks(const Offset(50, 40), 10, count: 5);
      case CharacterMood.yum:
        s.heart(const Offset(71, 42), 2.4);
      case CharacterMood.sleepy:
        s.zzz(const Offset(70, 38));
      case CharacterMood.hype:
        s.sweat(const Offset(67, 48), s: 1.8);
        s.sweat(const Offset(33, 46), s: 1.5);
        s.popTicks(const Offset(50, 40), 12, count: 6);
    }
  });
}
