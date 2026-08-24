import 'dart:math' as math;
import 'dart:ui';

import 'core/food_character.dart';
import 'core/sketch.dart';

enum EarStyle { floppy, pointy, tallUp, bigUp, longDroop, pom }

enum TailStyle { wag, curl, stub, plume, pom }

enum FaceMark { none, blaze, mask, muzzle, cheeks, topknot }

class DogCoat {
  const DogCoat({
    required this.id,
    required this.name,
    required this.level,
    required this.coat,
    required this.coatDeep,
    required this.cream,
  });

  final String id;
  final String name;
  final int level;
  final Color coat;
  final Color coatDeep;
  final Color cream;
}

class DogBreed {
  const DogBreed({
    required this.id,
    required this.name,
    required this.title,
    required this.story,
    required this.level,
    required this.ear,
    required this.tail,
    required this.mark,
    required this.coats,
    this.wide = 1,
    this.low = 0,
    this.tempo = 1.1,
    this.bounce = 1.25,
  });

  final String id;
  final String name;
  final String title;
  final String story;
  final int level;
  final EarStyle ear;
  final TailStyle tail;
  final FaceMark mark;
  final List<DogCoat> coats;
  final double wide;
  final double low;
  final double tempo;
  final double bounce;

  DogCoat coatById(String id) =>
      coats.firstWhere((c) => c.id == id, orElse: () => coats.first);
}

const dogBreeds = <DogBreed>[
  DogBreed(
    id: 'golden',
    name: 'Golden Retriever',
    title: 'Chief Morale Officer',
    story:
        'A golden retriever with one job: being near you while you work, '
        'which Maika considers the best job ever invented. Brings the ball '
        'just in case. There is always a case.',
    level: 1,
    ear: EarStyle.floppy,
    tail: TailStyle.wag,
    mark: FaceMark.none,
    coats: [
      DogCoat(
        id: 'golden',
        name: 'Golden',
        level: 1,
        coat: Color(0xFFE5B266),
        coatDeep: Color(0xFFC98F47),
        cream: Color(0xFFF7E9CD),
      ),
      DogCoat(
        id: 'cream',
        name: 'Cream',
        level: 2,
        coat: Color(0xFFEFDFC0),
        coatDeep: Color(0xFFD4BC92),
        cream: Color(0xFFFDF8EC),
      ),
      DogCoat(
        id: 'chocolate',
        name: 'Chocolate',
        level: 4,
        coat: Color(0xFF9A6A48),
        coatDeep: Color(0xFF7A4E33),
        cream: Color(0xFFEBD7BE),
      ),
      DogCoat(
        id: 'copper',
        name: 'Copper',
        level: 6,
        coat: Color(0xFFCE7B41),
        coatDeep: Color(0xFFA95C2B),
        cream: Color(0xFFF5E2C6),
      ),
      DogCoat(
        id: 'midnight',
        name: 'Midnight',
        level: 9,
        coat: Color(0xFF57504B),
        coatDeep: Color(0xFF3E3833),
        cream: Color(0xFFD9CFC2),
      ),
      DogCoat(
        id: 'silver',
        name: 'Silver',
        level: 12,
        coat: Color(0xFFC9C4BD),
        coatDeep: Color(0xFFA8A29A),
        cream: Color(0xFFF3EFE8),
      ),
      DogCoat(
        id: 'champagne',
        name: 'Champagne',
        level: 16,
        coat: Color(0xFFEBD5A4),
        coatDeep: Color(0xFFCFB37B),
        cream: Color(0xFFFBF3DF),
      ),
      DogCoat(
        id: 'rose',
        name: 'Rose',
        level: 21,
        coat: Color(0xFFE8A8B0),
        coatDeep: Color(0xFFC97F8B),
        cream: Color(0xFFFAE9EA),
      ),
      DogCoat(
        id: 'mint',
        name: 'Mint',
        level: 26,
        coat: Color(0xFFA9D6BE),
        coatDeep: Color(0xFF7FB69C),
        cream: Color(0xFFEAF6EE),
      ),
      DogCoat(
        id: 'sky',
        name: 'Sky',
        level: 32,
        coat: Color(0xFFA9C6E5),
        coatDeep: Color(0xFF7FA3C9),
        cream: Color(0xFFEAF1F9),
      ),
      DogCoat(
        id: 'lavender',
        name: 'Lavender',
        level: 41,
        coat: Color(0xFFC4B1DE),
        coatDeep: Color(0xFF9F87C2),
        cream: Color(0xFFF2ECF9),
      ),
      DogCoat(
        id: 'galaxy',
        name: 'Galaxy',
        level: 50,
        coat: Color(0xFF6B639A),
        coatDeep: Color(0xFF4D4675),
        cream: Color(0xFFD9D4EE),
      ),
    ],
  ),
  DogBreed(
    id: 'shiba',
    name: 'Shiba',
    title: 'The Dignified Loaf',
    story:
        'Arrived at level 8 and immediately acted like the desk was always '
        'theirs. Tolerates the ball. Secretly loves the ball.',
    level: 8,
    ear: EarStyle.pointy,
    tail: TailStyle.curl,
    mark: FaceMark.cheeks,
    tempo: 1.0,
    bounce: 1.1,
    coats: [
      DogCoat(
        id: 'red',
        name: 'Red',
        level: 8,
        coat: Color(0xFFE09A55),
        coatDeep: Color(0xFFBE7737),
        cream: Color(0xFFF7EBD4),
      ),
      DogCoat(
        id: 'blacktan',
        name: 'Black & Tan',
        level: 10,
        coat: Color(0xFF4E463F),
        coatDeep: Color(0xFF35302B),
        cream: Color(0xFFE9CFA3),
      ),
      DogCoat(
        id: 'sesame',
        name: 'Sesame',
        level: 18,
        coat: Color(0xFFB99368),
        coatDeep: Color(0xFF8F6C45),
        cream: Color(0xFFF2E6CE),
      ),
      DogCoat(
        id: 'snow',
        name: 'Snow',
        level: 30,
        coat: Color(0xFFF2EBDD),
        coatDeep: Color(0xFFD3C7B0),
        cream: Color(0xFFFFFDF6),
      ),
    ],
  ),
  DogBreed(
    id: 'corgi',
    name: 'Corgi',
    title: 'The Low-Rider',
    story:
        'Ninety percent loaf, ten percent lightning. The stub tail moves '
        'faster than any tail has a right to.',
    level: 14,
    ear: EarStyle.bigUp,
    tail: TailStyle.stub,
    mark: FaceMark.blaze,
    wide: 1.12,
    low: 3,
    tempo: 1.2,
    bounce: 1.35,
    coats: [
      DogCoat(
        id: 'redwhite',
        name: 'Red & White',
        level: 14,
        coat: Color(0xFFDE8E4E),
        coatDeep: Color(0xFFB96D33),
        cream: Color(0xFFFAF2E2),
      ),
      DogCoat(
        id: 'tricolor',
        name: 'Tricolor',
        level: 17,
        coat: Color(0xFF534A42),
        coatDeep: Color(0xFF38322C),
        cream: Color(0xFFF0E3CB),
      ),
      DogCoat(
        id: 'fawn',
        name: 'Fawn',
        level: 24,
        coat: Color(0xFFD9B285),
        coatDeep: Color(0xFFB48F60),
        cream: Color(0xFFF9F0DF),
      ),
      DogCoat(
        id: 'smoke',
        name: 'Smoke',
        level: 33,
        coat: Color(0xFF9C948C),
        coatDeep: Color(0xFF77706A),
        cream: Color(0xFFEFEAE2),
      ),
    ],
  ),
  DogBreed(
    id: 'husky',
    name: 'Husky',
    title: 'The Dramatic Professional',
    story:
        'Has opinions and shares them, at length, melodically. The mask is '
        'permanent. The drama is optional but rarely declined.',
    level: 20,
    ear: EarStyle.pointy,
    tail: TailStyle.plume,
    mark: FaceMark.mask,
    tempo: 1.15,
    bounce: 1.2,
    coats: [
      DogCoat(
        id: 'graymask',
        name: 'Gray',
        level: 20,
        coat: Color(0xFFE8E4DC),
        coatDeep: Color(0xFF8A8E96),
        cream: Color(0xFFFBF9F4),
      ),
      DogCoat(
        id: 'charcoal',
        name: 'Charcoal',
        level: 23,
        coat: Color(0xFFDDD9D2),
        coatDeep: Color(0xFF4E4C4E),
        cream: Color(0xFFF9F7F2),
      ),
      DogCoat(
        id: 'redmask',
        name: 'Copper',
        level: 29,
        coat: Color(0xFFEFE3D2),
        coatDeep: Color(0xFFBE7A4A),
        cream: Color(0xFFFCF8F0),
      ),
      DogCoat(
        id: 'snowstorm',
        name: 'Snowstorm',
        level: 39,
        coat: Color(0xFFF5F2EA),
        coatDeep: Color(0xFFCBC4B4),
        cream: Color(0xFFFFFEFA),
      ),
    ],
  ),
  DogBreed(
    id: 'dachshund',
    name: 'Dachshund',
    title: 'The Long Boi',
    story:
        'Twice the dog lengthwise, half the dog heightwise, all the dog '
        'heart-wise. Believes hallways were invented as a personal runway.',
    level: 27,
    ear: EarStyle.longDroop,
    tail: TailStyle.wag,
    mark: FaceMark.none,
    wide: 1.15,
    low: 4,
    tempo: 1.05,
    bounce: 1.15,
    coats: [
      DogCoat(
        id: 'red',
        name: 'Red',
        level: 27,
        coat: Color(0xFFC97B45),
        coatDeep: Color(0xFFA25C2E),
        cream: Color(0xFFF3E3CC),
      ),
      DogCoat(
        id: 'blacktan',
        name: 'Black & Tan',
        level: 31,
        coat: Color(0xFF443E39),
        coatDeep: Color(0xFF2E2A26),
        cream: Color(0xFFDDAE72),
      ),
      DogCoat(
        id: 'chocolate',
        name: 'Chocolate',
        level: 37,
        coat: Color(0xFF8A5F41),
        coatDeep: Color(0xFF69462D),
        cream: Color(0xFFE9D2B4),
      ),
      DogCoat(
        id: 'creamy',
        name: 'Cream',
        level: 45,
        coat: Color(0xFFEEDFC3),
        coatDeep: Color(0xFFD0BA93),
        cream: Color(0xFFFCF7EB),
      ),
    ],
  ),
  DogBreed(
    id: 'poodle',
    name: 'Poodle',
    title: 'The Cloud Architect',
    story:
        'Immaculate. Cumulus-adjacent. Fetches with the poise of someone '
        'who has never once been rained on.',
    level: 35,
    ear: EarStyle.pom,
    tail: TailStyle.pom,
    mark: FaceMark.topknot,
    tempo: 1.05,
    bounce: 1.3,
    coats: [
      DogCoat(
        id: 'apricot',
        name: 'Apricot',
        level: 35,
        coat: Color(0xFFEDC59A),
        coatDeep: Color(0xFFCFA070),
        cream: Color(0xFFFAF0E1),
      ),
      DogCoat(
        id: 'noir',
        name: 'Noir',
        level: 38,
        coat: Color(0xFF524A46),
        coatDeep: Color(0xFF383230),
        cream: Color(0xFFCFC7C2),
      ),
      DogCoat(
        id: 'blanc',
        name: 'Blanc',
        level: 42,
        coat: Color(0xFFF6F1E6),
        coatDeep: Color(0xFFD8CFBB),
        cream: Color(0xFFFFFEFA),
      ),
      DogCoat(
        id: 'sterling',
        name: 'Sterling',
        level: 47,
        coat: Color(0xFFC5C0BB),
        coatDeep: Color(0xFFA09A94),
        cream: Color(0xFFF1EEE9),
      ),
    ],
  ),
  DogBreed(
    id: 'malinois',
    name: 'Malinois',
    title: 'Head of Security',
    story:
        'A working dog who assigned themselves the job. Perimeter checks '
        'every hour, on the hour, then one extra just in case. Off duty '
        'exists, in theory, somewhere past the ball.',
    level: 44,
    ear: EarStyle.tallUp,
    tail: TailStyle.wag,
    mark: FaceMark.muzzle,
    wide: 0.96,
    tempo: 1.25,
    bounce: 1.3,
    coats: [
      DogCoat(
        id: 'noir',
        name: 'Noir',
        level: 44,
        coat: Color(0xFF35302C),
        coatDeep: Color(0xFF463228),
        cream: Color(0xFF75593F),
      ),
      DogCoat(
        id: 'fawnmask',
        name: 'Fawn Mask',
        level: 46,
        coat: Color(0xFFD9A15E),
        coatDeep: Color(0xFF3B332C),
        cream: Color(0xFFF3E3C8),
      ),
      DogCoat(
        id: 'mahogany',
        name: 'Mahogany',
        level: 48,
        coat: Color(0xFFA5623B),
        coatDeep: Color(0xFF3A2E26),
        cream: Color(0xFFE3C39A),
      ),
      DogCoat(
        id: 'ghostsable',
        name: 'Ghost Sable',
        level: 49,
        coat: Color(0xFFDCCFB6),
        coatDeep: Color(0xFF8C7B66),
        cream: Color(0xFFF7F0E0),
      ),
    ],
  ),
];

DogBreed dogBreedById(String id) =>
    dogBreeds.firstWhere((b) => b.id == id, orElse: () => dogBreeds.first);

const _dogLore = {
  CharacterMood.signature: 'On duty. Ball secured. Tail at cruising speed.',
  CharacterMood.joy: 'You looked over! Best moment of the day so far.',
  CharacterMood.yum: 'A treat has entered the airspace.',
  CharacterMood.sleepy: 'Guarding you quietly. Eyes optional.',
  CharacterMood.hype: 'ZOOMIES. The tail has achieved liftoff.',
};

enum DogAccessoryCategory { headwear, eyewear, neckwear, extras, legends }

extension DogAccessoryCategoryInfo on DogAccessoryCategory {
  String get label => switch (this) {
    DogAccessoryCategory.headwear => 'Headwear',
    DogAccessoryCategory.eyewear => 'Eyewear',
    DogAccessoryCategory.neckwear => 'Neckwear',
    DogAccessoryCategory.extras => 'Extras',
    DogAccessoryCategory.legends => 'Legends',
  };
}

enum DogAccessory {
  none,
  bandana,
  cap,
  bow,
  scarf,
  specs,
  flower,
  beret,
  partyHat,
  crown,
  beanie,
  cowboyHat,
  strawHat,
  halo,
  sunglasses,
  heartShades,
  monocle,
  bowtie,
  collar,
  lei,
  cape,
  backpack,
  beeFriend,
  raggedCloak,
  crimsonScarf,
  ghoulMask,
  asceticBlaze,
  blindfold,
  duelistCoat,
  shadowWisps,
  hornedMask,
  orangeGi,
  pirateCaptain,
}

extension DogAccessoryInfo on DogAccessory {
  String get label => switch (this) {
    DogAccessory.none => 'Nothing',
    DogAccessory.bandana => 'Red bandana',
    DogAccessory.cap => 'Blue cap',
    DogAccessory.bow => 'Rose bow',
    DogAccessory.scarf => 'Golden scarf',
    DogAccessory.specs => 'Round specs',
    DogAccessory.flower => 'Sun flower',
    DogAccessory.beret => 'Rose beret',
    DogAccessory.partyHat => 'Party hat',
    DogAccessory.crown => 'Little crown',
    DogAccessory.beanie => 'Cozy beanie',
    DogAccessory.cowboyHat => 'Cowboy hat',
    DogAccessory.strawHat => 'Straw hat',
    DogAccessory.halo => 'Golden halo',
    DogAccessory.sunglasses => 'Cool shades',
    DogAccessory.heartShades => 'Heart shades',
    DogAccessory.monocle => 'Fancy monocle',
    DogAccessory.bowtie => 'Dapper bowtie',
    DogAccessory.collar => 'Red collar',
    DogAccessory.lei => 'Flower lei',
    DogAccessory.cape => 'Hero cape',
    DogAccessory.backpack => 'Tiny backpack',
    DogAccessory.beeFriend => 'Bee friend',
    DogAccessory.raggedCloak => 'Ragged cloak',
    DogAccessory.crimsonScarf => 'Crimson scarf',
    DogAccessory.ghoulMask => 'Ghoul mask',
    DogAccessory.asceticBlaze => 'Ascetic blaze',
    DogAccessory.blindfold => 'Blindfold',
    DogAccessory.duelistCoat => 'Duelist coat',
    DogAccessory.shadowWisps => 'Shadow wisps',
    DogAccessory.hornedMask => 'Horned mask',
    DogAccessory.orangeGi => 'Orange gi',
    DogAccessory.pirateCaptain => 'Pirate captain',
  };

  int get level => switch (this) {
    DogAccessory.none => 1,
    DogAccessory.bandana => 1,
    DogAccessory.collar => 1,
    DogAccessory.cap => 2,
    DogAccessory.scarf => 3,
    DogAccessory.bow => 4,
    DogAccessory.specs => 5,
    DogAccessory.beret => 6,
    DogAccessory.bowtie => 7,
    DogAccessory.sunglasses => 8,
    DogAccessory.beanie => 9,
    DogAccessory.flower => 10,
    DogAccessory.partyHat => 12,
    DogAccessory.lei => 13,
    DogAccessory.heartShades => 14,
    DogAccessory.cowboyHat => 16,
    DogAccessory.cape => 18,
    DogAccessory.strawHat => 21,
    DogAccessory.backpack => 22,
    DogAccessory.raggedCloak => 24,
    DogAccessory.monocle => 26,
    DogAccessory.crimsonScarf => 27,
    DogAccessory.ghoulMask => 29,
    DogAccessory.crown => 30,
    DogAccessory.asceticBlaze => 32,
    DogAccessory.beeFriend => 33,
    DogAccessory.blindfold => 35,
    DogAccessory.duelistCoat => 38,
    DogAccessory.shadowWisps => 41,
    DogAccessory.halo => 43,
    DogAccessory.hornedMask => 44,
    DogAccessory.orangeGi => 46,
    DogAccessory.pirateCaptain => 49,
  };

  DogAccessoryCategory get category => switch (this) {
    DogAccessory.cap ||
    DogAccessory.bow ||
    DogAccessory.flower ||
    DogAccessory.beret ||
    DogAccessory.partyHat ||
    DogAccessory.crown ||
    DogAccessory.beanie ||
    DogAccessory.cowboyHat ||
    DogAccessory.strawHat ||
    DogAccessory.halo => DogAccessoryCategory.headwear,
    DogAccessory.specs ||
    DogAccessory.sunglasses ||
    DogAccessory.heartShades ||
    DogAccessory.monocle => DogAccessoryCategory.eyewear,
    DogAccessory.bandana ||
    DogAccessory.scarf ||
    DogAccessory.bowtie ||
    DogAccessory.collar ||
    DogAccessory.lei => DogAccessoryCategory.neckwear,
    DogAccessory.none ||
    DogAccessory.cape ||
    DogAccessory.backpack ||
    DogAccessory.beeFriend => DogAccessoryCategory.extras,
    DogAccessory.raggedCloak ||
    DogAccessory.crimsonScarf ||
    DogAccessory.ghoulMask ||
    DogAccessory.asceticBlaze ||
    DogAccessory.blindfold ||
    DogAccessory.duelistCoat ||
    DogAccessory.shadowWisps ||
    DogAccessory.hornedMask ||
    DogAccessory.orangeGi ||
    DogAccessory.pirateCaptain => DogAccessoryCategory.legends,
  };
}

FoodCharacter dogCharacter(
  DogBreed breed,
  DogCoat coat, {
  DogAccessory accessory = DogAccessory.none,
}) => FoodCharacter(
  id: 'dog_${breed.id}_${coat.id}_${accessory.name}',
  name: breed.id == 'golden' ? 'Maika' : breed.name,
  family: 'Desk Companions',
  title: breed.title,
  story: breed.story,
  accent: coat.coat,
  moodLore: _dogLore,
  painter: (s, mood) => _paintDog(s, mood, breed, coat, accessory),
  motion: MotionProfile(
    tempo: breed.tempo,
    bounce: breed.bounce,
    style: PerformanceStyle.hop,
  ),
);

final maika = dogCharacter(dogBreeds.first, dogBreeds.first.coats.first);

void _paintDog(
  Sketch s,
  CharacterMood mood,
  DogBreed breed,
  DogCoat look,
  DogAccessory accessory,
) {
  if (s.walking || s.stretch > 0.01 || s.turn >= 0.75) {
    _paintDogProfile(s, breed, look, accessory);
    return;
  }
  if (s.turn > 0.2) {
    _paintDogThreeQuarter(s, mood, breed, look, accessory);
    return;
  }
  final coat = look.coat;
  final coatDeep = look.coatDeep;
  final creamFur = look.cream;
  const ballGreen = Color(0xFFB9D45B);
  final perked = mood == CharacterMood.joy;
  final swept = mood == CharacterMood.hype;
  final resting = mood == CharacterMood.sleepy;
  final low = breed.low;
  final wide = breed.wide;
  s.groundShadow(const Offset(50, 88), 18 * wide);
  s.posed(mood, () {
    final wag = s.live
        ? math.sin(
                s.t * (swept ? 11.0 : (resting ? 2.2 : 4.8)) * s.motion.tempo,
              ) *
              (swept ? 0.62 : (resting ? 0.12 : 0.4))
        : 0.22;
    final stubTail = breed.tail == TailStyle.stub && !resting;
    if (!stubTail) {
      _tail(
        s,
        breed,
        coat,
        coatDeep,
        creamFur,
        wag,
        resting: resting,
        swept: swept,
        wide: wide,
      );
    }
    for (final side in const [-1.0, 1.0]) {
      final haunch = Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset(50 + side * 14.5 * wide, 71),
            width: 16 * wide,
            height: 21,
          ),
        );
      s.fillArea(haunch, coat);
      s.ink(haunch, width: 2.5);
    }
    if (stubTail) {
      _tail(
        s,
        breed,
        coat,
        coatDeep,
        creamFur,
        wag,
        resting: resting,
        swept: swept,
        wide: wide,
      );
    }
    final chest = Path()
      ..moveTo(50 - 9 * wide, 50 + low)
      ..quadraticBezierTo(50, 47 + low, 50 + 9 * wide, 50 + low)
      ..cubicTo(50 + 12 * wide, 58, 50 + 13 * wide, 70, 50 + 11.5 * wide, 80)
      ..quadraticBezierTo(50, 83.5, 50 - 11.5 * wide, 80)
      ..cubicTo(50 - 13 * wide, 70, 50 - 12 * wide, 58, 50 - 9 * wide, 50 + low)
      ..close();
    s.fillArea(chest, coat);
    s.ink(chest, width: 2.6);
    final bib = Path()
      ..moveTo(44.5, 54 + low)
      ..quadraticBezierTo(50, 52 + low, 55.5, 54 + low)
      ..quadraticBezierTo(58, 66, 56.5, 79)
      ..quadraticBezierTo(50, 81.5, 43.5, 79)
      ..quadraticBezierTo(42, 66, 44.5, 54 + low)
      ..close();
    s.fillArea(bib, creamFur);
    for (final side in const [-1.0, 1.0]) {
      final paw = Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset(50 + side * 5.5, 80),
            width: 7.5,
            height: 5,
          ),
        );
      s.fillArea(paw, creamFur, amp: 0.25);
      s.ink(paw, width: 1.8, amp: 0.25);
      s.strokeLine(
        Offset(50 + side * 5.5 - 1, 78.6),
        Offset(50 + side * 5.5 - 1, 80.6),
        width: 1,
        amp: 0.1,
      );
      s.strokeLine(
        Offset(50 + side * 5.5 + 1, 78.6),
        Offset(50 + side * 5.5 + 1, 80.6),
        width: 1,
        amp: 0.1,
      );
    }
    final earLift =
        (perked ? -4.5 : 0.0) +
        (resting ? 3.5 : 0.0) -
        s.perfPose.lift * 5 +
        s.breath * 0.9;
    final upright =
        breed.ear == EarStyle.pointy ||
        breed.ear == EarStyle.tallUp ||
        breed.ear == EarStyle.bigUp;
    if (upright) {
      _ears(
        s,
        breed,
        coat,
        coatDeep,
        creamFur,
        earLift,
        low,
        swept: swept,
        resting: resting,
      );
    }
    final head = Path()
      ..moveTo(50, 14.5 + low)
      ..cubicTo(63, 14.5 + low, 71, 22 + low, 71, 34 + low)
      ..cubicTo(71, 45 + low, 62, 52.5 + low, 50, 52.5 + low)
      ..cubicTo(38, 52.5 + low, 29, 45 + low, 29, 34 + low)
      ..cubicTo(29, 22 + low, 37, 14.5 + low, 50, 14.5 + low)
      ..close();
    s.fillArea(head, coat);
    s.shade(head, lift: const Offset(-2.2, -2.8));
    s.grain(head, dots: 6, color: const Color(0x1F84603A));
    s.ink(head, width: 2.8);
    switch (breed.mark) {
      case FaceMark.blaze:
        final blaze = Path()
          ..moveTo(47.4, 15.6 + low)
          ..quadraticBezierTo(50, 15 + low, 52.6, 15.6 + low)
          ..quadraticBezierTo(52.2, 30 + low, 51.4, 37.5 + low)
          ..quadraticBezierTo(50, 39 + low, 48.6, 37.5 + low)
          ..quadraticBezierTo(47.8, 30 + low, 47.4, 15.6 + low)
          ..close();
        s.fillArea(blaze, creamFur, amp: 0.4);
      case FaceMark.mask:
        final cap = Path()
          ..moveTo(30.5, 31 + low)
          ..cubicTo(31, 20 + low, 38, 14.8 + low, 50, 14.8 + low)
          ..cubicTo(62, 14.8 + low, 69, 20 + low, 69.5, 31 + low)
          ..quadraticBezierTo(60, 25.5 + low, 50, 25.5 + low)
          ..quadraticBezierTo(40, 25.5 + low, 30.5, 31 + low)
          ..close();
        s.fillArea(cap, coatDeep, amp: 0.5);
        s.ink(cap, width: 1.6, amp: 0.5, color: const Color(0x40332A22));
      case FaceMark.muzzle:
        final snout = Path()
          ..moveTo(41, 36.5 + low)
          ..quadraticBezierTo(50, 33.5 + low, 59, 36.5 + low)
          ..quadraticBezierTo(61.5, 44 + low, 55.5, 49.5 + low)
          ..quadraticBezierTo(50, 51.5 + low, 44.5, 49.5 + low)
          ..quadraticBezierTo(38.5, 44 + low, 41, 36.5 + low)
          ..close();
        s.fillArea(snout, Color.lerp(coat, coatDeep, 0.75)!, amp: 0.4);
        s.ink(snout, width: 1.4, amp: 0.4, color: const Color(0x40332A22));
      case FaceMark.cheeks:
        for (final side in const [-1.0, 1.0]) {
          final cheek = Path()
            ..addOval(
              Rect.fromCenter(
                center: Offset(50 + side * 15, 41 + low),
                width: 14,
                height: 12,
              ),
            );
          s.fillArea(cheek, creamFur, amp: 0.5);
        }
      case FaceMark.topknot:
        var tuft = Path()
          ..addOval(Rect.fromCircle(center: Offset(50, 13 + low), radius: 6));
        tuft = Path.combine(
          PathOperation.union,
          tuft,
          Path()..addOval(
            Rect.fromCircle(center: Offset(43.5, 15 + low), radius: 4.6),
          ),
        );
        tuft = Path.combine(
          PathOperation.union,
          tuft,
          Path()..addOval(
            Rect.fromCircle(center: Offset(56.5, 15 + low), radius: 4.6),
          ),
        );
        s.fillArea(tuft, coat);
        s.ink(tuft, width: 2.2);
      case FaceMark.none:
        break;
    }
    if (!upright) {
      _ears(
        s,
        breed,
        coat,
        coatDeep,
        creamFur,
        earLift,
        low,
        swept: swept,
        resting: resting,
      );
    }
    final muzzle = Path()
      ..addOval(
        Rect.fromCenter(center: Offset(50, 42.5 + low), width: 21, height: 16),
      );
    s.fillArea(muzzle, creamFur);
    s.ink(muzzle, width: 1.8, amp: 0.6, color: const Color(0x5084603A));
    final nose = Path()
      ..moveTo(46.8, 38 + low)
      ..quadraticBezierTo(50, 36.8 + low, 53.2, 38 + low)
      ..quadraticBezierTo(52.8, 41.4 + low, 50, 42.2 + low)
      ..quadraticBezierTo(47.2, 41.4 + low, 46.8, 38 + low)
      ..close();
    s.fillArea(nose, Inks.ink, amp: 0.15);
    s.dot(Offset(48.6, 38.4 + low), 0.7, color: const Color(0x66FFFFFF));
    s.strokeLine(Offset(50, 42.2 + low), Offset(50, 44.6 + low), width: 1.6);
    s.curve(
      Offset(50, 44.6 + low),
      Offset(47.5, 46.8 + low),
      Offset(44.8, 45.4 + low),
      width: 1.8,
      amp: 0.2,
    );
    s.curve(
      Offset(50, 44.6 + low),
      Offset(52.5, 46.8 + low),
      Offset(55.2, 45.4 + low),
      width: 1.8,
      amp: 0.2,
    );
    final browTilt = switch (mood) {
      CharacterMood.sleepy => 4.0,
      CharacterMood.hype => -3.0,
      _ => 0.0,
    };
    final browColor = breed.mark == FaceMark.mask ? creamFur : coatDeep;
    s.dot(Offset(41.5, 26.5 + low + browTilt * 0.4), 1.5, color: browColor);
    s.dot(Offset(58.5, 26.5 + low + browTilt * 0.4), 1.5, color: browColor);
    final eyeL = Offset(41.5, 32.5 + low);
    final eyeR = Offset(58.5, 32.5 + low);
    switch (mood) {
      case CharacterMood.signature:
        s.eyeDot(eyeL, 2.7);
        s.eyeDot(eyeR, 2.7);
      case CharacterMood.joy:
        s.eyeArc(eyeL, 2.9);
        s.eyeArc(eyeR, 2.9);
      case CharacterMood.yum:
        s.eyeHeart(eyeL, 2.8);
        s.eyeHeart(eyeR, 2.8);
      case CharacterMood.sleepy:
        s.eyeLid(eyeL, 2.7);
        s.eyeLid(eyeR, 2.7);
      case CharacterMood.hype:
        s.eyeStar(eyeL, 2.7);
        s.eyeStar(eyeR, 2.7);
    }
    s.blushTicks(Offset(35, 39.5 + low), s: 0.95);
    s.blushTicks(Offset(65, 39.5 + low), s: 0.95);
    final tongueOut =
        !s.barking &&
        (mood == CharacterMood.signature ||
            mood == CharacterMood.joy ||
            mood == CharacterMood.hype ||
            (s.performing && s.perfT > 0.3 && s.perfT < 0.8));
    if (tongueOut) {
      final wig = s.live ? math.sin(s.t * 3.4 * s.motion.tempo) * 0.9 : 0.0;
      final len = swept ? 8.0 : 5.6;
      final tongue = Path()
        ..moveTo(51.4, 45.8 + low)
        ..quadraticBezierTo(
          55 + wig,
          47.5 + low + len * 0.55,
          53.6 + wig,
          45.8 + low + len,
        )
        ..quadraticBezierTo(
          51.4 + wig * 0.5,
          46.5 + low + len,
          49.6,
          45.6 + low,
        )
        ..close();
      s.fillArea(tongue, Inks.tongue, amp: 0.25);
      s.ink(tongue, width: 1.4, amp: 0.25);
    } else if (mood == CharacterMood.yum) {
      final lick = Path()
        ..moveTo(52, 45.6 + low)
        ..quadraticBezierTo(58.5, 45 + low, 57.5, 40.5 + low)
        ..quadraticBezierTo(54.5, 42 + low, 51, 44.4 + low)
        ..close();
      s.fillArea(lick, Inks.tongue, amp: 0.25);
      s.ink(lick, width: 1.3, amp: 0.25);
    }
    if (s.barking) {
      final open = math.sin(s.barkT * 3 * math.pi).abs();
      final jaw = Path()
        ..moveTo(44.8, 44.4)
        ..quadraticBezierTo(50, 45 + 5.2 * open, 55.2, 44.4)
        ..quadraticBezierTo(50, 43.3, 44.8, 44.4)
        ..close();
      s.fillArea(jaw, Inks.mouthFill, amp: 0.2);
      s.ink(jaw, width: 1.5, amp: 0.2);
      if (open > 0.45) {
        final tip = Path()
          ..moveTo(47.6, 45.6)
          ..quadraticBezierTo(50, 46.4 + 3.4 * open, 52.4, 45.6)
          ..quadraticBezierTo(50, 45.9, 47.6, 45.6)
          ..close();
        s.fillArea(tip, Inks.tongue, amp: 0.2);
      }
      final loud = (0.35 + open * 0.65).clamp(0.0, 1.0);
      final arcPaint = Color.fromRGBO(51, 37, 29, loud * 0.75);
      s.canvas.drawArc(
        Rect.fromCircle(center: const Offset(73.5, 42), radius: 4),
        -0.7,
        1.4,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round
          ..color = arcPaint,
      );
      s.canvas.drawArc(
        Rect.fromCircle(center: const Offset(73.5, 42), radius: 7.5),
        -0.6,
        1.2,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round
          ..color = arcPaint,
      );
    }
    _accessoryFront(s, accessory);
    switch (mood) {
      case CharacterMood.signature:
        s.sparkle(const Offset(74, 22), 2.3);
      case CharacterMood.joy:
        s.sparkleAround(Offset(50, 26 + low), 30, count: 4);
        s.popTicks(Offset(50, 12 + low), 9, count: 5);
      case CharacterMood.yum:
        final boneAt = const Offset(72, 27);
        final bone = Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: boneAt, width: 9, height: 3),
              const Radius.circular(1.5),
            ),
          );
        s.fillArea(bone, creamFur, amp: 0.2);
        s.ink(bone, width: 1.4, amp: 0.2);
        for (final end in const [-4.5, 4.5]) {
          s.dot(boneAt + Offset(end, -1.6), 1.7, color: creamFur);
          s.dot(boneAt + Offset(end, 1.6), 1.7, color: creamFur);
          s.ring(boneAt + Offset(end, -1.6), 1.7, width: 1.1);
          s.ring(boneAt + Offset(end, 1.6), 1.7, width: 1.1);
        }
        s.heart(const Offset(28, 26), 2.4);
      case CharacterMood.sleepy:
        s.zzz(const Offset(71, 20));
      case CharacterMood.hype:
        s.speedLines(const Offset(21, 56), 182, len: 10, count: 4);
        s.popTicks(Offset(50, 10 + low), 8, count: 4, color: Inks.sun);
    }
  });
  if (mood == CharacterMood.signature || s.performing) {
    final toss = s.performing ? bell(s.perfT) : 0.0;
    final ballAt = Offset(28.5 + toss * 15, 79.5 - toss * 49);
    s.dot(ballAt, 6, color: ballGreen);
    s.ring(ballAt, 6, width: 1.7, amp: 0.3);
    s.curve(
      ballAt + const Offset(-5.2, -2),
      ballAt + const Offset(-0.6, 0.7),
      ballAt + const Offset(4.3, -3.5),
      width: 1.4,
      color: Inks.cream,
      amp: 0.2,
    );
    s.curve(
      ballAt + const Offset(-4.3, 3.5),
      ballAt + const Offset(0.6, 1.2),
      ballAt + const Offset(5.2, 2),
      width: 1.4,
      color: Inks.cream,
      amp: 0.2,
    );
    if (s.performing && toss > 0.2) {
      s.speedLines(
        ballAt + const Offset(-1, 7.5),
        90,
        count: 2,
        len: 4,
        width: 1.2,
      );
    }
  }
}

void _ears(
  Sketch s,
  DogBreed breed,
  Color coat,
  Color coatDeep,
  Color creamFur,
  double earLift,
  double low, {
  required bool swept,
  required bool resting,
}) {
  switch (breed.ear) {
    case EarStyle.floppy:
      for (final side in const [-1.0, 1.0]) {
        final rootX = 50 + side * 13.5;
        final ear = Path()
          ..moveTo(rootX, 16.5 + low)
          ..quadraticBezierTo(
            50 + side * 25,
            17.5 + low + earLift * 0.3,
            50 + side * (swept ? 27.0 : 24.5),
            30 + low + earLift * 0.8,
          )
          ..quadraticBezierTo(
            50 + side * 24,
            42.5 + low + earLift,
            50 + side * 17.5,
            44 + low + earLift,
          )
          ..quadraticBezierTo(50 + side * 14, 34 + low, rootX, 16.5 + low)
          ..close();
        s.fillArea(ear, coatDeep, amp: 0.6);
        s.ink(ear, width: 2.4, amp: 0.6);
      }
    case EarStyle.longDroop:
      for (final side in const [-1.0, 1.0]) {
        final rootX = 50 + side * 13;
        final ear = Path()
          ..moveTo(rootX, 17 + low)
          ..quadraticBezierTo(
            50 + side * 24.5,
            19 + low + earLift * 0.3,
            50 + side * 23.5,
            36 + low + earLift * 0.8,
          )
          ..quadraticBezierTo(
            50 + side * 22.5,
            51 + low + earLift,
            50 + side * 16,
            50 + low + earLift,
          )
          ..quadraticBezierTo(50 + side * 13.5, 34 + low, rootX, 17 + low)
          ..close();
        s.fillArea(ear, coatDeep, amp: 0.6);
        s.ink(ear, width: 2.4, amp: 0.6);
      }
    case EarStyle.pointy:
      for (final side in const [-1.0, 1.0]) {
        final tip = Offset(50 + side * 17.5, 4 + low + earLift * 0.7);
        final ear = Path()
          ..moveTo(50 + side * 7.5, 18 + low)
          ..quadraticBezierTo(50 + side * 12, 9 + low, tip.dx, tip.dy)
          ..quadraticBezierTo(
            50 + side * 20.5,
            15 + low,
            50 + side * 19.5,
            24 + low,
          )
          ..close();
        s.fillArea(ear, coatDeep, amp: 0.4);
        s.ink(ear, width: 2.4, amp: 0.4);
        final inner = Path()
          ..moveTo(50 + side * 11, 16.5 + low)
          ..quadraticBezierTo(
            50 + side * 13.5,
            11 + low,
            tip.dx - side * 1.6,
            tip.dy + 3.4,
          )
          ..quadraticBezierTo(
            50 + side * 16.5,
            14.5 + low,
            50 + side * 16,
            19 + low,
          )
          ..close();
        s.fillArea(inner, creamFur, amp: 0.25);
      }
    case EarStyle.tallUp:
      for (final side in const [-1.0, 1.0]) {
        final tip = Offset(50 + side * 11.5, 0.8 + low + earLift * 0.8);
        final ear = Path()
          ..moveTo(50 + side * 4.5, 17 + low)
          ..quadraticBezierTo(50 + side * 6.5, 5.5 + low, tip.dx, tip.dy)
          ..quadraticBezierTo(
            50 + side * 15.5,
            8 + low,
            50 + side * 15.8,
            20.5 + low,
          )
          ..close();
        s.fillArea(ear, coatDeep, amp: 0.35);
        s.ink(ear, width: 2.4, amp: 0.35);
        final inner = Path()
          ..moveTo(50 + side * 7.8, 13.5 + low)
          ..quadraticBezierTo(
            50 + side * 8.8,
            6.5 + low,
            tip.dx - side * 1.2,
            tip.dy + 3.6,
          )
          ..quadraticBezierTo(
            50 + side * 12.6,
            9.5 + low,
            50 + side * 12.8,
            15.5 + low,
          )
          ..close();
        s.fillArea(inner, const Color(0x59241C16), amp: 0.25);
      }
    case EarStyle.bigUp:
      for (final side in const [-1.0, 1.0]) {
        s.canvas.save();
        s.canvas.translate(50 + side * 15.5, 13 + low + earLift * 0.5);
        s.canvas.rotate(side * 0.3);
        final ear = Path()
          ..addOval(
            Rect.fromCenter(center: Offset.zero, width: 15, height: 23),
          );
        s.fillArea(ear, coat, amp: 0.5);
        s.ink(ear, width: 2.5, amp: 0.5);
        final inner = Path()
          ..addOval(
            Rect.fromCenter(
              center: const Offset(0, 1.4),
              width: 8.5,
              height: 14,
            ),
          );
        s.fillArea(inner, creamFur, amp: 0.3);
        s.canvas.restore();
      }
    case EarStyle.pom:
      for (final side in const [-1.0, 1.0]) {
        var puff = Path()
          ..addOval(
            Rect.fromCircle(
              center: Offset(50 + side * 20, 24 + low + earLift * 0.6),
              radius: 7,
            ),
          );
        puff = Path.combine(
          PathOperation.union,
          puff,
          Path()..addOval(
            Rect.fromCircle(
              center: Offset(50 + side * 21, 33 + low + earLift),
              radius: 5.6,
            ),
          ),
        );
        s.fillArea(puff, coatDeep, amp: 0.5);
        s.ink(puff, width: 2.3, amp: 0.5);
      }
  }
}

void _tail(
  Sketch s,
  DogBreed breed,
  Color coat,
  Color coatDeep,
  Color creamFur,
  double wag, {
  required bool resting,
  required bool swept,
  required double wide,
}) {
  final baseX = 50 + 13.5 * wide;
  if (resting && breed.tail != TailStyle.curl) {
    final curled = Path()
      ..moveTo(baseX - 3, 78)
      ..quadraticBezierTo(baseX + 7, 78, baseX + 8, 82)
      ..quadraticBezierTo(baseX + 3, 85.5, baseX - 11, 84.5)
      ..quadraticBezierTo(baseX - 7, 81, baseX - 3, 78)
      ..close();
    s.fillArea(curled, coat, amp: 0.5);
    s.ink(curled, width: 2.1, amp: 0.5);
    s.dot(Offset(baseX - 9.5, 84), 2.1, color: creamFur);
    return;
  }
  switch (breed.tail) {
    case TailStyle.wag:
    case TailStyle.plume:
      final plume = breed.tail == TailStyle.plume;
      void tailAt(double angleDeg, {double alpha = 1}) {
        final base = Offset(baseX, 70);
        final len = plume ? 19.5 : 17.0;
        final tip = s.polar(base, angleDeg, len);
        final mid = s.polar(base, angleDeg - 14, len * 0.56);
        final girth = plume ? 4.0 : 3.0;
        final tail = Path()
          ..moveTo(baseX - 2.5, 73.5)
          ..quadraticBezierTo(
            mid.dx - girth * 0.7,
            mid.dy + girth,
            tip.dx,
            tip.dy,
          )
          ..quadraticBezierTo(mid.dx + girth, mid.dy - girth, baseX + 2, 67.5)
          ..close();
        final color = coat.withValues(alpha: alpha);
        s.fillArea(tail, color, amp: 0.5);
        if (alpha > 0.6) {
          s.ink(tail, width: 2.2, amp: 0.5);
          s.dot(
            tip,
            plume ? 2.7 : 2.3,
            color: creamFur.withValues(alpha: alpha),
          );
        }
      }

      if (swept) {
        tailAt(-96 + wag * 40, alpha: 0.25);
        tailAt(-18 + wag * 40, alpha: 0.25);
        tailAt(-57 + wag * 46);
        s.curve(
          Offset(baseX + 6, 56),
          Offset(baseX + 14, 62),
          Offset(baseX + 9, 72),
          width: 1.5,
          color: Inks.inkFaint,
        );
      } else {
        tailAt(-52 + wag * 34);
      }
    case TailStyle.curl:
      s.canvas.save();
      s.canvas.translate(baseX + 1, 61);
      s.canvas.rotate(wag * 0.3);
      final curl = Path()
        ..addOval(Rect.fromCircle(center: Offset.zero, radius: 6.6));
      s.fillArea(curl, coat, amp: 0.4);
      s.ink(curl, width: 2.3, amp: 0.4);
      final swirl = Path()
        ..moveTo(-3.4, 2.6)
        ..quadraticBezierTo(-4.2, -2.8, 0.2, -3.2)
        ..quadraticBezierTo(3.4, -3.4, 3, 0.4);
      s.ink(swirl, width: 1.7, amp: 0.3, color: creamFur);
      s.canvas.restore();
    case TailStyle.stub:
      final jump = wag.abs() * 3.2;
      final at = Offset(baseX + 3.5, 62.5 - jump);
      s.dot(at, 4, color: coat);
      s.ring(at, 4, width: 2, amp: 0.3);
      s.dot(at + const Offset(0.9, -1.1), 1.4, color: creamFur);
    case TailStyle.pom:
      final base = Offset(baseX, 71);
      final tip = s.polar(base, -50 + wag * 30, 13);
      s.strokeLine(base, tip, width: 2, amp: 0.3);
      s.dot(tip, 4.4, color: coat);
      s.ring(tip, 4.4, width: 1.9, amp: 0.3);
  }
}

void _paintDogProfile(
  Sketch s,
  DogBreed breed,
  DogCoat look,
  DogAccessory accessory,
) {
  final coat = look.coat;
  final coatDeep = look.coatDeep;
  final creamFur = look.cream;
  final st = s.stretch.clamp(0.0, 1.0);
  final long = breed.low > 0 ? 1.22 : 1.0;
  final legLen = breed.low > 0 ? 13.0 : 19.0;
  final (chestDeep, tuck, neckUp, legThick, rumpBoost) = switch (breed.id) {
    'golden' => (4.5, 3.0, 0.0, 1.0, 0.0),
    'shiba' => (3.5, 2.0, 0.0, 1.0, 1.0),
    'corgi' => (3.5, 0.5, 0.0, 1.05, 3.0),
    'husky' => (5.5, 4.5, 1.5, 1.0, 0.0),
    'dachshund' => (5.0, 0.0, 0.0, 0.85, 0.0),
    'poodle' => (3.5, 5.0, 4.0, 0.8, 0.0),
    'malinois' => (5.5, 7.0, 3.0, 0.88, 0.0),
    _ => (4.5, 2.5, 0.0, 1.0, 0.0),
  };
  final top = (breed.low > 0 ? 53.0 : 45.0) - neckUp * 0.4 + st * -3;
  final belly = top + 17.5 + chestDeep * 0.4;
  const ground = 84.0;
  final backX = 46 - 18 * long;
  final frontX = 46 + 17 * long;
  final hindHipY = belly - 4;
  final frontHipY = belly - 4 + st * (ground - legLen * 0.35 - belly);
  final p = s.walking ? s.gait : 0.0;
  final pitch = s.walking ? math.sin(4 * math.pi * p) * 0.022 : 0.0;
  final headBob = s.walking ? -math.sin(4 * math.pi * p + 0.9) * 1.3 : 0.0;
  final lag = s.walking ? math.sin(4 * math.pi * p - 0.7) : 0.0;
  s.groundShadow(const Offset(48, 87), 25 * long);
  s.posed(CharacterMood.signature, () {
    s.canvas.save();
    s.canvas.translate(46, belly);
    s.canvas.rotate(pitch);
    s.canvas.translate(-46, -belly);

    void limb({
      required Offset hip,
      required double phase,
      required bool hind,
      required bool near,
    }) {
      final swing = s.walking ? math.sin(2 * math.pi * p + phase) : 0.0;
      final lift = s.walking
          ? math.max(0.0, math.sin(2 * math.pi * p + phase + 1.1))
          : 0.0;
      var upperDeg = 90 + swing * 21;
      var lowerDeg = hind
          ? upperDeg - swing * 12 - lift * 30
          : upperDeg + swing * 8 + lift * 34;
      var len = (ground - hip.dy).clamp(6.0, 32.0);
      if (st > 0.15) {
        if (!hind) {
          upperDeg = 90 - 58 * st;
          lowerDeg = 90 - 66 * st;
          len = legLen * (1 + st * 0.3);
        } else {
          upperDeg = 90 + 5 * st;
          lowerDeg = 90 - 4 * st;
        }
      }
      final l1 = len * 0.54;
      final l2 = len * 0.56;
      final knee = s.polar(hip, upperDeg, l1);
      final paw = s.polar(knee, lowerDeg, l2 * (1 - lift * 0.16));
      final w1 = 3.6 * legThick;
      final w2 = 2.5 * legThick;
      final w3 = 1.9 * legThick;
      Offset norm(Offset a, Offset b) {
        final v = b - a;
        final d = v.distance == 0 ? 1.0 : v.distance;
        return Offset(-v.dy / d, v.dx / d);
      }

      final n1 = norm(hip, knee);
      final n2 = norm(knee, paw);
      final nk = (n1 + n2) / 2;
      final shape = Path()
        ..moveTo(hip.dx + n1.dx * w1, hip.dy + n1.dy * w1)
        ..quadraticBezierTo(
          knee.dx + nk.dx * w2 * 1.15,
          knee.dy + nk.dy * w2 * 1.15,
          paw.dx + n2.dx * w3,
          paw.dy + n2.dy * w3,
        )
        ..quadraticBezierTo(
          paw.dx + (paw - knee).dx / (paw - knee).distance * w3 * 1.4,
          paw.dy + (paw - knee).dy / (paw - knee).distance * w3 * 1.4,
          paw.dx - n2.dx * w3,
          paw.dy - n2.dy * w3,
        )
        ..quadraticBezierTo(
          knee.dx - nk.dx * w2,
          knee.dy - nk.dy * w2,
          hip.dx - n1.dx * w1,
          hip.dy - n1.dy * w1,
        )
        ..close();
      s.fillArea(shape, near ? coat : coatDeep, amp: 0.35);
      s.ink(shape, width: near ? 1.8 : 1.3, amp: 0.35);
      final pawOval = Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset(paw.dx + 1.4, paw.dy - 0.4),
            width: 6.2 * legThick,
            height: 3.8,
          ),
        );
      s.fillArea(pawOval, near ? creamFur : coatDeep, amp: 0.2);
      s.ink(pawOval, width: near ? 1.6 : 1.2, amp: 0.2);
      if (breed.id == 'poodle') {
        final pom = Path()
          ..addOval(
            Rect.fromCircle(
              center: Offset(paw.dx + 0.4, paw.dy - 3.4),
              radius: 3.1,
            ),
          );
        s.fillArea(pom, near ? coat : coatDeep, amp: 0.4);
        s.ink(pom, width: near ? 1.5 : 1.1, amp: 0.4);
      }
    }

    final tailBase = Offset(backX - 1, top + 3 - st * 4 + lag * 0.9);
    final wag = s.live ? math.sin(s.t * 6 * s.motion.tempo) * 0.35 : 0.2;
    switch (breed.tail) {
      case TailStyle.wag:
      case TailStyle.plume:
        final plume = breed.tail == TailStyle.plume;
        final tip = s.polar(
          tailBase,
          -122 + wag * 38 + lag * 8,
          plume ? 17.0 : 14.5,
        );
        final mid = s.polar(tailBase, -112 + wag * 28 + lag * 6, 8);
        final tail = Path()
          ..moveTo(tailBase.dx + 1, tailBase.dy + 4)
          ..quadraticBezierTo(mid.dx - 3.5, mid.dy, tip.dx, tip.dy)
          ..quadraticBezierTo(
            mid.dx + (plume ? 4.5 : 3.5),
            mid.dy + 2,
            tailBase.dx + 4,
            tailBase.dy,
          )
          ..close();
        s.fillArea(tail, coat, amp: 0.5);
        s.ink(tail, width: 2.1, amp: 0.5);
        s.dot(tip, plume ? 2.6 : 2.2, color: creamFur);
      case TailStyle.curl:
        s.canvas.save();
        s.canvas.translate(tailBase.dx + 2.5, tailBase.dy - 2.5);
        s.canvas.rotate(wag * 0.4);
        final curl = Path()
          ..addOval(Rect.fromCircle(center: Offset.zero, radius: 5.4));
        s.fillArea(curl, coat, amp: 0.4);
        s.ink(curl, width: 2.1, amp: 0.4);
        final swirl = Path()
          ..moveTo(-2.6, 2.2)
          ..quadraticBezierTo(-3.4, -2.2, 0.3, -2.6);
        s.ink(swirl, width: 1.5, amp: 0.3, color: creamFur);
        s.canvas.restore();
      case TailStyle.stub:
        final at = Offset(tailBase.dx + 1.5, tailBase.dy - 2 - wag.abs() * 3);
        s.dot(at, 3.2, color: coat);
        s.ring(at, 3.2, width: 1.8, amp: 0.3);
      case TailStyle.pom:
        final tip = s.polar(tailBase, -112 + wag * 34, 10);
        s.strokeLine(tailBase, tip, width: 2, amp: 0.3);
        s.dot(tip, 3.9, color: coat);
        s.ring(tip, 3.9, width: 1.8, amp: 0.3);
    }

    limb(
      hip: Offset(backX + 6, hindHipY),
      phase: math.pi + 0.2,
      hind: true,
      near: false,
    );
    limb(
      hip: Offset(frontX - 5, frontHipY),
      phase: 0.2,
      hind: false,
      near: false,
    );

    final rearBellyY = belly - tuck;
    final body = Path()
      ..moveTo(backX, top + 2 - st * 4)
      ..quadraticBezierTo(
        backX - 8 - rumpBoost,
        top + 9 - st * 2,
        backX - 6 - rumpBoost * 0.7,
        top + 18,
      )
      ..quadraticBezierTo(backX - 4, rearBellyY + 2, backX + 6, rearBellyY + 1)
      ..quadraticBezierTo(
        46,
        belly + 2.5 + st * 3,
        frontX - 8,
        belly + 1.5 + st * 6,
      )
      ..quadraticBezierTo(
        frontX + 3,
        belly + 2 + st * 8,
        frontX + 6,
        top + 10 + st * 10,
      )
      ..quadraticBezierTo(
        frontX + 7.5,
        top + 2 + st * 8 - neckUp,
        frontX - 1,
        top - 1 + st * 6 - neckUp,
      )
      ..quadraticBezierTo(46, top - 3.5 + st * 2, backX, top + 2 - st * 4)
      ..close();
    s.fillArea(body, coat);
    s.shade(body, lift: const Offset(-2, -2.6));
    s.grain(body, dots: 6, color: const Color(0x1F84603A));
    s.ink(body, width: 2.7);

    final chestFluff = Path()
      ..moveTo(frontX + 4.5, belly - 1 + st * 7)
      ..quadraticBezierTo(
        frontX + 7.5,
        top + 12 + st * 8 - neckUp * 0.5,
        frontX + 3,
        top + 6 + st * 6 - neckUp * 0.5,
      )
      ..quadraticBezierTo(
        frontX - 2.5,
        top + 10 + st * 6,
        frontX - 3.5,
        belly - 2 + st * 5,
      )
      ..close();
    s.fillArea(chestFluff, creamFur, amp: 0.5);

    final thighAt = Offset(backX + 6.5, hindHipY - 4 + st * -2);
    final thigh = Path()
      ..addOval(
        Rect.fromCenter(center: thighAt, width: 13, height: 15 + rumpBoost),
      );
    s.fillArea(thigh, coat, amp: 0.4);
    s.curve(
      Offset(thighAt.dx + 5.5, thighAt.dy - 5),
      Offset(thighAt.dx + 7.5, thighAt.dy + 2),
      Offset(thighAt.dx + 3, thighAt.dy + (7.5 + rumpBoost * 0.5)),
      width: 1.7,
      color: const Color(0x7333251D),
      amp: 0.4,
    );

    limb(hip: Offset(backX + 7, hindHipY), phase: 0.0, hind: true, near: true);
    limb(
      hip: Offset(frontX - 3, frontHipY),
      phase: math.pi,
      hind: false,
      near: true,
    );

    final headC = Offset(
      frontX + 8 - st * 2,
      top - 10 - neckUp + st * 14 + headBob,
    );
    final tilt = st * -0.25;
    s.canvas.save();
    s.canvas.translate(headC.dx, headC.dy);
    s.canvas.rotate(tilt);
    s.canvas.translate(-headC.dx, -headC.dy);
    final head = Path()..addOval(Rect.fromCircle(center: headC, radius: 11));
    s.fillArea(head, coat);
    s.ink(head, width: 2.6);
    if (breed.mark == FaceMark.mask) {
      final cap = Path()
        ..moveTo(headC.dx - 10.5, headC.dy - 2)
        ..quadraticBezierTo(
          headC.dx - 8,
          headC.dy - 12.5,
          headC.dx + 3,
          headC.dy - 10.5,
        )
        ..quadraticBezierTo(
          headC.dx + 9,
          headC.dy - 9,
          headC.dx + 9.5,
          headC.dy - 4,
        )
        ..quadraticBezierTo(
          headC.dx,
          headC.dy - 6,
          headC.dx - 10.5,
          headC.dy - 2,
        )
        ..close();
      s.fillArea(cap, coatDeep, amp: 0.4);
    }
    if (breed.mark == FaceMark.muzzle) {
      final snoutP = Path()
        ..moveTo(headC.dx + 6.5, headC.dy - 4.5)
        ..quadraticBezierTo(
          headC.dx + 13,
          headC.dy - 6,
          headC.dx + 17.5,
          headC.dy - 2.5,
        )
        ..quadraticBezierTo(
          headC.dx + 18.5,
          headC.dy + 2.5,
          headC.dx + 14,
          headC.dy + 5.5,
        )
        ..quadraticBezierTo(
          headC.dx + 9.5,
          headC.dy + 6.5,
          headC.dx + 6.5,
          headC.dy + 2,
        )
        ..close();
      s.fillArea(snoutP, Color.lerp(coat, coatDeep, 0.75)!, amp: 0.35);
      s.ink(snoutP, width: 1.3, amp: 0.35, color: const Color(0x40332A22));
    }
    if (breed.mark == FaceMark.topknot) {
      var tuftPath = Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(headC.dx - 1, headC.dy - 11.5),
            radius: 4.8,
          ),
        );
      tuftPath = Path.combine(
        PathOperation.union,
        tuftPath,
        Path()..addOval(
          Rect.fromCircle(
            center: Offset(headC.dx - 6, headC.dy - 10),
            radius: 3.6,
          ),
        ),
      );
      s.fillArea(tuftPath, coat);
      s.ink(tuftPath, width: 2, amp: 0.4);
    }
    final muzzle = Path()
      ..moveTo(headC.dx + 5.5, headC.dy - 3.5)
      ..quadraticBezierTo(
        headC.dx + 15.5,
        headC.dy - 4,
        headC.dx + 16,
        headC.dy + 1,
      )
      ..quadraticBezierTo(
        headC.dx + 16,
        headC.dy + 4.8,
        headC.dx + 9.5,
        headC.dy + 5.2,
      )
      ..quadraticBezierTo(
        headC.dx + 6,
        headC.dy + 5.2,
        headC.dx + 5.5,
        headC.dy + 1.8,
      )
      ..close();
    s.fillArea(muzzle, creamFur, amp: 0.3);
    s.ink(muzzle, width: 1.7, amp: 0.4, color: const Color(0x5084603A));
    final nose = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(headC.dx + 14.8, headC.dy - 2.4),
          width: 4.2,
          height: 3.2,
        ),
      );
    s.fillArea(nose, Inks.ink, amp: 0.15);
    s.curve(
      Offset(headC.dx + 12.5, headC.dy + 2.8),
      Offset(headC.dx + 10.5, headC.dy + 4.4),
      Offset(headC.dx + 8, headC.dy + 3.4),
      width: 1.6,
      amp: 0.2,
    );
    if (s.walking) {
      final wig = s.live ? math.sin(s.t * 3.4) * 0.7 : 0.0;
      final tongue = Path()
        ..moveTo(headC.dx + 10, headC.dy + 4.2)
        ..quadraticBezierTo(
          headC.dx + 11.5 + wig,
          headC.dy + 9,
          headC.dx + 9 + wig,
          headC.dy + 8.6,
        )
        ..quadraticBezierTo(
          headC.dx + 8,
          headC.dy + 6.2,
          headC.dx + 8.8,
          headC.dy + 4,
        )
        ..close();
      s.fillArea(tongue, Inks.tongue, amp: 0.2);
      s.ink(tongue, width: 1.3, amp: 0.2);
    }
    s.eyeDot(Offset(headC.dx + 3.5, headC.dy - 3.2), 2.1);
    s.dot(
      Offset(headC.dx + 2.5, headC.dy - 8.2),
      1.3,
      color: breed.mark == FaceMark.mask ? creamFur : coatDeep,
    );
    s.blushTicks(Offset(headC.dx - 1, headC.dy + 3), s: 0.75);
    if (breed.mark == FaceMark.cheeks) {
      final cheek = Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset(headC.dx + 0.5, headC.dy + 3.5),
            width: 8.5,
            height: 7.5,
          ),
        );
      s.fillArea(cheek, creamFur, amp: 0.4);
      s.eyeDot(Offset(headC.dx + 3.5, headC.dy - 3.2), 2.1);
    }
    final earLag = lag * 1.6;
    switch (breed.ear) {
      case EarStyle.floppy:
      case EarStyle.longDroop:
        final droopLen = breed.ear == EarStyle.longDroop ? 15.0 : 11.5;
        final ear = Path()
          ..moveTo(headC.dx - 1.5, headC.dy - 9.5)
          ..quadraticBezierTo(
            headC.dx - 11.5,
            headC.dy - 7.5 + earLag * 0.4,
            headC.dx - 10.5,
            headC.dy - 10 + droopLen + earLag,
          )
          ..quadraticBezierTo(
            headC.dx - 10,
            headC.dy - 7 + droopLen + earLag,
            headC.dx - 5,
            headC.dy - 10.5 + droopLen + earLag * 0.7,
          )
          ..quadraticBezierTo(
            headC.dx - 3,
            headC.dy - 4,
            headC.dx - 1.5,
            headC.dy - 9.5,
          )
          ..close();
        s.fillArea(ear, coatDeep, amp: 0.5);
        s.ink(ear, width: 2.2, amp: 0.5);
      case EarStyle.pointy:
        final ear = Path()
          ..moveTo(headC.dx - 4.5, headC.dy - 8.5)
          ..quadraticBezierTo(
            headC.dx - 5 - earLag * 0.5,
            headC.dy - 18,
            headC.dx - 1.5 - earLag * 0.6,
            headC.dy - 19.5,
          )
          ..quadraticBezierTo(
            headC.dx + 3.5,
            headC.dy - 15,
            headC.dx + 3,
            headC.dy - 9,
          )
          ..close();
        s.fillArea(ear, coatDeep, amp: 0.4);
        s.ink(ear, width: 2.2, amp: 0.4);
        final inner = Path()
          ..moveTo(headC.dx - 2.4, headC.dy - 10.5)
          ..quadraticBezierTo(
            headC.dx - 2.4,
            headC.dy - 15.5,
            headC.dx - 1,
            headC.dy - 17,
          )
          ..quadraticBezierTo(
            headC.dx + 1,
            headC.dy - 13.5,
            headC.dx + 0.8,
            headC.dy - 10.5,
          )
          ..close();
        s.fillArea(inner, creamFur, amp: 0.25);
      case EarStyle.tallUp:
        final earTall = Path()
          ..moveTo(headC.dx - 3.5, headC.dy - 8.5)
          ..quadraticBezierTo(
            headC.dx - 4.5 - earLag * 0.5,
            headC.dy - 19,
            headC.dx - 1 - earLag * 0.7,
            headC.dy - 23,
          )
          ..quadraticBezierTo(
            headC.dx + 3.5,
            headC.dy - 16,
            headC.dx + 2.8,
            headC.dy - 9,
          )
          ..close();
        s.fillArea(earTall, coatDeep, amp: 0.35);
        s.ink(earTall, width: 2.2, amp: 0.35);
        final innerTall = Path()
          ..moveTo(headC.dx - 1.6, headC.dy - 11)
          ..quadraticBezierTo(
            headC.dx - 2,
            headC.dy - 17.5,
            headC.dx - 0.8,
            headC.dy - 20.5,
          )
          ..quadraticBezierTo(
            headC.dx + 1.4,
            headC.dy - 15,
            headC.dx + 1.2,
            headC.dy - 10.5,
          )
          ..close();
        s.fillArea(innerTall, const Color(0x59241C16), amp: 0.25);
      case EarStyle.bigUp:
        s.canvas.save();
        s.canvas.translate(headC.dx - 1, headC.dy - 14 + earLag * 0.5);
        s.canvas.rotate(-0.18 - earLag * 0.03);
        final ear = Path()
          ..addOval(
            Rect.fromCenter(center: Offset.zero, width: 10.5, height: 16),
          );
        s.fillArea(ear, coat, amp: 0.4);
        s.ink(ear, width: 2.2, amp: 0.4);
        final inner = Path()
          ..addOval(
            Rect.fromCenter(
              center: const Offset(0, 1),
              width: 5.6,
              height: 9.5,
            ),
          );
        s.fillArea(inner, creamFur, amp: 0.25);
        s.canvas.restore();
      case EarStyle.pom:
        var puff = Path()
          ..addOval(
            Rect.fromCircle(
              center: Offset(headC.dx - 6, headC.dy - 4 + earLag * 0.6),
              radius: 5.6,
            ),
          );
        puff = Path.combine(
          PathOperation.union,
          puff,
          Path()..addOval(
            Rect.fromCircle(
              center: Offset(headC.dx - 7, headC.dy + 2.5 + earLag),
              radius: 4.4,
            ),
          ),
        );
        s.fillArea(puff, coatDeep, amp: 0.5);
        s.ink(puff, width: 2.1, amp: 0.5);
    }
    if (s.barking) {
      final open = math.sin(s.barkT * 3 * math.pi).abs();
      final jaw = Path()
        ..moveTo(headC.dx + 7, headC.dy + 4.6)
        ..quadraticBezierTo(
          headC.dx + 12,
          headC.dy + 5.4 + 5.5 * open,
          headC.dx + 15.5,
          headC.dy + 3.4,
        )
        ..quadraticBezierTo(
          headC.dx + 11,
          headC.dy + 4.2,
          headC.dx + 7,
          headC.dy + 4.6,
        )
        ..close();
      s.fillArea(jaw, Inks.mouthFill, amp: 0.2);
      s.ink(jaw, width: 1.4, amp: 0.2);
      final loud = (0.35 + open * 0.65).clamp(0.0, 1.0);
      final arcPaint = Color.fromRGBO(51, 37, 29, loud * 0.75);
      s.canvas.drawArc(
        Rect.fromCircle(center: Offset(headC.dx + 20, headC.dy - 1), radius: 4),
        -0.7,
        1.4,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round
          ..color = arcPaint,
      );
      s.canvas.drawArc(
        Rect.fromCircle(
          center: Offset(headC.dx + 20, headC.dy - 1),
          radius: 7.5,
        ),
        -0.6,
        1.2,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round
          ..color = arcPaint,
      );
    }
    _accessoryProfile(s, accessory, headC);
    s.canvas.restore();
    s.canvas.restore();
  });
}

void _paintDogThreeQuarter(
  Sketch s,
  CharacterMood mood,
  DogBreed breed,
  DogCoat look,
  DogAccessory accessory,
) {
  final coat = look.coat;
  final coatDeep = look.coatDeep;
  final creamFur = look.cream;
  final wide = breed.wide;
  s.groundShadow(const Offset(51, 88), 17 * wide);
  s.posed(mood, () {
    final wag = s.live ? math.sin(s.t * 4.8 * s.motion.tempo) * 0.38 : 0.22;
    final tailBase = Offset(35, 69);
    switch (breed.tail) {
      case TailStyle.wag:
      case TailStyle.plume:
        final plume = breed.tail == TailStyle.plume;
        final tip = s.polar(tailBase, -117 + wag * 32, plume ? 16.0 : 14.0);
        final mid = s.polar(tailBase, -107 + wag * 24, 8);
        final tail = Path()
          ..moveTo(tailBase.dx + 2, tailBase.dy + 3.5)
          ..quadraticBezierTo(mid.dx - 3, mid.dy + 2, tip.dx, tip.dy)
          ..quadraticBezierTo(
            mid.dx + 3.5,
            mid.dy - 2,
            tailBase.dx + 4.5,
            tailBase.dy - 2,
          )
          ..close();
        s.fillArea(tail, coat, amp: 0.5);
        s.ink(tail, width: 2.2, amp: 0.5);
        s.dot(tip, plume ? 2.5 : 2.2, color: creamFur);
      case TailStyle.curl:
        s.canvas.save();
        s.canvas.translate(tailBase.dx + 1, tailBase.dy - 5);
        s.canvas.rotate(wag * 0.35);
        final curl = Path()
          ..addOval(Rect.fromCircle(center: Offset.zero, radius: 5.8));
        s.fillArea(curl, coat, amp: 0.4);
        s.ink(curl, width: 2.2, amp: 0.4);
        final swirl = Path()
          ..moveTo(-2.8, 2.3)
          ..quadraticBezierTo(-3.6, -2.4, 0.2, -2.8);
        s.ink(swirl, width: 1.6, amp: 0.3, color: creamFur);
        s.canvas.restore();
      case TailStyle.stub:
        final at = Offset(tailBase.dx + 1, tailBase.dy - 3 - wag.abs() * 2.6);
        s.dot(at, 3.6, color: coat);
        s.ring(at, 3.6, width: 1.9, amp: 0.3);
      case TailStyle.pom:
        final tip = s.polar(tailBase, -110 + wag * 28, 11.5);
        s.strokeLine(tailBase, tip, width: 2, amp: 0.3);
        s.dot(tip, 4, color: coat);
        s.ring(tip, 4, width: 1.9, amp: 0.3);
    }
    final farHaunch = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(51 - 13.5 * wide, 71.5),
          width: 13 * wide,
          height: 20,
        ),
      );
    s.fillArea(farHaunch, coatDeep);
    s.ink(farHaunch, width: 2.2);
    final nearHaunch = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(51 + 12.5 * wide, 71),
          width: 17 * wide,
          height: 21,
        ),
      );
    s.fillArea(nearHaunch, coat);
    s.ink(nearHaunch, width: 2.5);
    final chest = Path()
      ..moveTo(51 - 7.5 * wide, 50)
      ..quadraticBezierTo(52, 47.5, 51 + 9 * wide, 50.5)
      ..cubicTo(51 + 11.5 * wide, 58, 51 + 12 * wide, 70, 51 + 10.5 * wide, 80)
      ..quadraticBezierTo(52.5, 83, 51 - 9.5 * wide, 79.5)
      ..cubicTo(51 - 11 * wide, 70, 51 - 10 * wide, 58, 51 - 7.5 * wide, 50)
      ..close();
    s.fillArea(chest, coat);
    s.ink(chest, width: 2.6);
    final bib = Path()
      ..moveTo(48.5, 54.5)
      ..quadraticBezierTo(54, 52.5, 58.5, 55)
      ..quadraticBezierTo(60.5, 66, 59, 78.5)
      ..quadraticBezierTo(53, 81, 47.5, 78.5)
      ..quadraticBezierTo(46.5, 66, 48.5, 54.5)
      ..close();
    s.fillArea(bib, creamFur);
    final farPaw = Path()
      ..addOval(
        Rect.fromCenter(
          center: const Offset(45.5, 79.2),
          width: 6.6,
          height: 4.4,
        ),
      );
    s.fillArea(farPaw, creamFur, amp: 0.25);
    s.ink(farPaw, width: 1.6, amp: 0.25);
    final nearPaw = Path()
      ..addOval(
        Rect.fromCenter(center: const Offset(56.5, 80), width: 7.8, height: 5),
      );
    s.fillArea(nearPaw, creamFur, amp: 0.25);
    s.ink(nearPaw, width: 1.8, amp: 0.25);
    s.strokeLine(
      const Offset(55.5, 78.6),
      const Offset(55.5, 80.6),
      width: 1,
      amp: 0.1,
    );
    s.strokeLine(
      const Offset(57.5, 78.6),
      const Offset(57.5, 80.6),
      width: 1,
      amp: 0.1,
    );
    final earLift =
        (mood == CharacterMood.joy ? -4.0 : 0.0) +
        (mood == CharacterMood.sleepy ? 3.0 : 0.0) +
        s.breath * 0.9;
    final upright =
        breed.ear == EarStyle.pointy ||
        breed.ear == EarStyle.tallUp ||
        breed.ear == EarStyle.bigUp;
    if (upright) {
      _quarterEars(s, breed, coat, coatDeep, creamFur, earLift);
    }
    final head = Path()
      ..moveTo(54, 14.5)
      ..cubicTo(66, 15, 73, 22.5, 73, 34)
      ..cubicTo(73, 45, 64.5, 52.5, 53.5, 52.5)
      ..cubicTo(42, 52.5, 33.5, 45, 33.5, 34.5)
      ..cubicTo(33.5, 23, 42.5, 14, 54, 14.5)
      ..close();
    s.fillArea(head, coat);
    s.shade(head, lift: const Offset(-2.2, -2.8));
    s.grain(head, dots: 6, color: const Color(0x1F84603A));
    s.ink(head, width: 2.8);
    switch (breed.mark) {
      case FaceMark.blaze:
        final blaze = Path()
          ..moveTo(53.6, 15.4)
          ..quadraticBezierTo(56.2, 15, 58.6, 15.8)
          ..quadraticBezierTo(58, 30, 57, 37.5)
          ..quadraticBezierTo(55.5, 39, 54.2, 37.4)
          ..quadraticBezierTo(53.6, 30, 53.6, 15.4)
          ..close();
        s.fillArea(blaze, creamFur, amp: 0.4);
      case FaceMark.mask:
        final cap = Path()
          ..moveTo(35, 31)
          ..cubicTo(36, 20.5, 43, 15.2, 54, 15.2)
          ..cubicTo(65, 15.2, 71.5, 20.5, 72, 30.5)
          ..quadraticBezierTo(63, 25.5, 53.5, 25.8)
          ..quadraticBezierTo(43.5, 26, 35, 31)
          ..close();
        s.fillArea(cap, coatDeep, amp: 0.5);
        s.ink(cap, width: 1.6, amp: 0.5, color: const Color(0x40332A22));
      case FaceMark.muzzle:
        final snoutQ = Path()
          ..moveTo(53.5, 37)
          ..quadraticBezierTo(61, 34.5, 67.5, 38)
          ..quadraticBezierTo(69.5, 44.5, 63.5, 49.5)
          ..quadraticBezierTo(56.5, 51, 52.5, 46.5)
          ..quadraticBezierTo(51, 40.5, 53.5, 37)
          ..close();
        s.fillArea(snoutQ, Color.lerp(coat, coatDeep, 0.75)!, amp: 0.4);
        s.ink(snoutQ, width: 1.4, amp: 0.4, color: const Color(0x40332A22));
      case FaceMark.cheeks:
        final farCheek = Path()
          ..addOval(
            Rect.fromCenter(
              center: const Offset(41, 40.5),
              width: 12,
              height: 11,
            ),
          );
        s.fillArea(farCheek, creamFur, amp: 0.5);
        final nearCheek = Path()
          ..addOval(
            Rect.fromCenter(
              center: const Offset(66, 40),
              width: 14,
              height: 12,
            ),
          );
        s.fillArea(nearCheek, creamFur, amp: 0.5);
      case FaceMark.topknot:
        var tuft = Path()
          ..addOval(Rect.fromCircle(center: const Offset(54, 13), radius: 5.8));
        tuft = Path.combine(
          PathOperation.union,
          tuft,
          Path()..addOval(
            Rect.fromCircle(center: const Offset(48, 15), radius: 4.4),
          ),
        );
        tuft = Path.combine(
          PathOperation.union,
          tuft,
          Path()..addOval(
            Rect.fromCircle(center: const Offset(60, 15.5), radius: 4.4),
          ),
        );
        s.fillArea(tuft, coat);
        s.ink(tuft, width: 2.2);
      case FaceMark.none:
        break;
    }
    if (!upright) {
      _quarterEars(s, breed, coat, coatDeep, creamFur, earLift);
    }
    final muzzle = Path()
      ..addOval(
        Rect.fromCenter(
          center: const Offset(58.5, 42.5),
          width: 20,
          height: 15.5,
        ),
      );
    s.fillArea(muzzle, creamFur);
    s.ink(muzzle, width: 1.8, amp: 0.6, color: const Color(0x5084603A));
    final nose = Path()
      ..moveTo(57.4, 38)
      ..quadraticBezierTo(60.4, 36.9, 63.2, 38.2)
      ..quadraticBezierTo(62.6, 41.4, 60.1, 42.1)
      ..quadraticBezierTo(57.6, 41.3, 57.4, 38)
      ..close();
    s.fillArea(nose, Inks.ink, amp: 0.15);
    s.dot(const Offset(59, 38.4), 0.65, color: const Color(0x66FFFFFF));
    s.strokeLine(
      const Offset(60.2, 42.1),
      const Offset(60.2, 44.5),
      width: 1.6,
    );
    s.curve(
      const Offset(60.2, 44.5),
      const Offset(57.8, 46.6),
      const Offset(55.2, 45.2),
      width: 1.8,
      amp: 0.2,
    );
    s.curve(
      const Offset(60.2, 44.5),
      const Offset(62.6, 46.4),
      const Offset(64.8, 45),
      width: 1.8,
      amp: 0.2,
    );
    final browColor = breed.mark == FaceMark.mask ? creamFur : coatDeep;
    s.dot(const Offset(45, 26.8), 1.4, color: browColor);
    s.dot(const Offset(63.5, 26), 1.5, color: browColor);
    final eyeFar = const Offset(45.5, 32.8);
    final eyeNear = const Offset(62.5, 32);
    switch (mood) {
      case CharacterMood.signature:
        s.eyeDot(eyeFar, 2.4);
        s.eyeDot(eyeNear, 2.7);
      case CharacterMood.joy:
        s.eyeArc(eyeFar, 2.6);
        s.eyeArc(eyeNear, 2.9);
      case CharacterMood.yum:
        s.eyeHeart(eyeFar, 2.5);
        s.eyeHeart(eyeNear, 2.8);
      case CharacterMood.sleepy:
        s.eyeLid(eyeFar, 2.4);
        s.eyeLid(eyeNear, 2.7);
      case CharacterMood.hype:
        s.eyeStar(eyeFar, 2.4);
        s.eyeStar(eyeNear, 2.7);
    }
    s.blushTicks(const Offset(38.5, 38.5), s: 0.8);
    s.blushTicks(const Offset(70.8, 36), s: 0.85);
    final tongueOut =
        !s.barking &&
        (mood == CharacterMood.signature ||
            mood == CharacterMood.joy ||
            mood == CharacterMood.hype);
    if (tongueOut) {
      final wig = s.live ? math.sin(s.t * 3.4 * s.motion.tempo) * 0.8 : 0.0;
      final tongue = Path()
        ..moveTo(61.4, 45.6)
        ..quadraticBezierTo(64.6 + wig, 47.5 + 3, 63.2 + wig, 51.2)
        ..quadraticBezierTo(61.2 + wig * 0.5, 51.6, 59.8, 45.5)
        ..close();
      s.fillArea(tongue, Inks.tongue, amp: 0.25);
      s.ink(tongue, width: 1.4, amp: 0.25);
    }
    if (s.barking) {
      final open = math.sin(s.barkT * 3 * math.pi).abs();
      final jaw = Path()
        ..moveTo(55.8, 44.8)
        ..quadraticBezierTo(60.5, 45.4 + 5 * open, 65.2, 44.2)
        ..quadraticBezierTo(60.5, 43.4, 55.8, 44.8)
        ..close();
      s.fillArea(jaw, Inks.mouthFill, amp: 0.2);
      s.ink(jaw, width: 1.5, amp: 0.2);
      if (open > 0.45) {
        final tip = Path()
          ..moveTo(58.4, 45.8)
          ..quadraticBezierTo(60.6, 46.6 + 3.2 * open, 62.8, 45.4)
          ..quadraticBezierTo(60.6, 45.9, 58.4, 45.8)
          ..close();
        s.fillArea(tip, Inks.tongue, amp: 0.2);
      }
      final loud = (0.35 + open * 0.65).clamp(0.0, 1.0);
      final arcPaint = Color.fromRGBO(51, 37, 29, loud * 0.75);
      s.canvas.drawArc(
        Rect.fromCircle(center: const Offset(70, 43), radius: 4),
        -0.7,
        1.4,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round
          ..color = arcPaint,
      );
      s.canvas.drawArc(
        Rect.fromCircle(center: const Offset(70, 43), radius: 7.5),
        -0.6,
        1.2,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round
          ..color = arcPaint,
      );
    }
    _accessoryQuarter(s, accessory);
  });
}

void _quarterEars(
  Sketch s,
  DogBreed breed,
  Color coat,
  Color coatDeep,
  Color creamFur,
  double earLift,
) {
  switch (breed.ear) {
    case EarStyle.floppy:
    case EarStyle.longDroop:
      final droop = breed.ear == EarStyle.longDroop ? 7.0 : 0.0;
      final farEar = Path()
        ..moveTo(41.5, 17)
        ..quadraticBezierTo(
          33,
          18.5 + earLift * 0.3,
          33.5,
          30 + droop * 0.6 + earLift * 0.8,
        )
        ..quadraticBezierTo(
          34,
          40 + droop + earLift,
          39.5,
          41 + droop + earLift,
        )
        ..quadraticBezierTo(41.5, 32, 41.5, 17)
        ..close();
      s.fillArea(farEar, coatDeep, amp: 0.6);
      s.ink(farEar, width: 2.2, amp: 0.6);
      final nearEar = Path()
        ..moveTo(65.5, 16.5)
        ..quadraticBezierTo(
          75.5,
          18 + earLift * 0.3,
          75,
          31 + droop * 0.7 + earLift * 0.8,
        )
        ..quadraticBezierTo(
          74.5,
          43 + droop + earLift,
          67.5,
          44.5 + droop + earLift,
        )
        ..quadraticBezierTo(64.5, 33, 65.5, 16.5)
        ..close();
      s.fillArea(nearEar, coatDeep, amp: 0.6);
      s.ink(nearEar, width: 2.4, amp: 0.6);
    case EarStyle.pointy:
      final farEar = Path()
        ..moveTo(40, 19)
        ..quadraticBezierTo(38.5, 9 + earLift * 0.5, 42.5, 6.5 + earLift * 0.7)
        ..quadraticBezierTo(47, 11, 47.5, 18)
        ..close();
      s.fillArea(farEar, coatDeep, amp: 0.4);
      s.ink(farEar, width: 2.2, amp: 0.4);
      final nearEar = Path()
        ..moveTo(59.5, 17.5)
        ..quadraticBezierTo(61, 6.5 + earLift * 0.7, 66, 5 + earLift * 0.8)
        ..quadraticBezierTo(70.5, 10.5, 69, 19.5)
        ..close();
      s.fillArea(nearEar, coatDeep, amp: 0.4);
      s.ink(nearEar, width: 2.4, amp: 0.4);
      final inner = Path()
        ..moveTo(62, 15.5)
        ..quadraticBezierTo(63.2, 9, 65.7, 8)
        ..quadraticBezierTo(67.8, 11.5, 66.8, 17)
        ..close();
      s.fillArea(inner, creamFur, amp: 0.25);
    case EarStyle.tallUp:
      final farTall = Path()
        ..moveTo(43.2, 18.5)
        ..lineTo(45.8, 1.2 + earLift * 0.7)
        ..lineTo(50.8, 17)
        ..close();
      s.fillArea(farTall, coatDeep, amp: 0.25);
      s.ink(farTall, width: 2.2, amp: 0.25);
      final nearTall = Path()
        ..moveTo(58.8, 17)
        ..lineTo(63.2, 0.4 + earLift * 0.8)
        ..lineTo(67.8, 17.8)
        ..close();
      s.fillArea(nearTall, coatDeep, amp: 0.25);
      s.ink(nearTall, width: 2.4, amp: 0.25);
      final innerTall = Path()
        ..moveTo(61.4, 14)
        ..lineTo(63.3, 4.2)
        ..lineTo(65.4, 14.8)
        ..close();
      s.fillArea(innerTall, const Color(0x59241C16), amp: 0.2);
    case EarStyle.bigUp:
      s.canvas.save();
      s.canvas.translate(41.5, 12 + earLift * 0.5);
      s.canvas.rotate(-0.34);
      final farEar = Path()
        ..addOval(
          Rect.fromCenter(center: Offset.zero, width: 12.5, height: 20),
        );
      s.fillArea(farEar, coat, amp: 0.5);
      s.ink(farEar, width: 2.3, amp: 0.5);
      final farInner = Path()
        ..addOval(
          Rect.fromCenter(center: const Offset(0, 1.2), width: 7, height: 12),
        );
      s.fillArea(farInner, creamFur, amp: 0.3);
      s.canvas.restore();
      s.canvas.save();
      s.canvas.translate(66.5, 12 + earLift * 0.5);
      s.canvas.rotate(0.26);
      final nearEar = Path()
        ..addOval(
          Rect.fromCenter(center: Offset.zero, width: 15.5, height: 23.5),
        );
      s.fillArea(nearEar, coat, amp: 0.5);
      s.ink(nearEar, width: 2.5, amp: 0.5);
      final nearInner = Path()
        ..addOval(
          Rect.fromCenter(center: const Offset(0, 1.4), width: 9, height: 14.5),
        );
      s.fillArea(nearInner, creamFur, amp: 0.3);
      s.canvas.restore();
    case EarStyle.pom:
      var farPuff = Path()
        ..addOval(
          Rect.fromCircle(center: Offset(38.5, 24 + earLift * 0.6), radius: 6),
        );
      farPuff = Path.combine(
        PathOperation.union,
        farPuff,
        Path()..addOval(
          Rect.fromCircle(center: Offset(37.5, 32 + earLift), radius: 4.8),
        ),
      );
      s.fillArea(farPuff, coatDeep, amp: 0.5);
      s.ink(farPuff, width: 2.1, amp: 0.5);
      var nearPuff = Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(70, 23.5 + earLift * 0.6),
            radius: 7.2,
          ),
        );
      nearPuff = Path.combine(
        PathOperation.union,
        nearPuff,
        Path()..addOval(
          Rect.fromCircle(center: Offset(71.5, 32.5 + earLift), radius: 5.6),
        ),
      );
      s.fillArea(nearPuff, coatDeep, amp: 0.5);
      s.ink(nearPuff, width: 2.3, amp: 0.5);
  }
}

const _accRed = Color(0xFFD8452E);
const _accSky = Color(0xFF7FB5D8);
const _accTan = Color(0xFFC08A52);
const _accTanDeep = Color(0xFF96683A);
const _accKnotInk = Color(0xFF574438);
const _accCloth = Color(0xFF453A32);
const _accNavy = Color(0xFF2E3A55);
const _accSteel = Color(0xFF5E6B7E);
const _accBlade = Color(0xFF9A9184);
const _accTeal = Color(0xFF4FA3A0);
const _accShadow = Color(0xFF7A5BB5);
const _accShadowDeep = Color(0xFF4A3573);
const _accGi = Color(0xFFE87A2E);
const _accGiBlue = Color(0xFF3E5C8C);
const _accBlood = Color(0xFFA83226);
const _leiColors = [Inks.rose, Inks.cream, Inks.sun];

void _accessoryFront(Sketch s, DogAccessory acc) {
  switch (acc) {
    case DogAccessory.none:
      break;
    case DogAccessory.bandana:
      final tri = Path()
        ..moveTo(41, 51.5)
        ..lineTo(59, 51.5)
        ..quadraticBezierTo(52, 56, 50, 62)
        ..quadraticBezierTo(48, 56, 41, 51.5)
        ..close();
      s.fillArea(tri, _accRed, amp: 0.35);
      s.ink(tri, width: 1.8, amp: 0.35);
      s.dot(const Offset(47, 55), 0.9, color: Inks.cream);
      s.dot(const Offset(52.5, 54), 0.9, color: Inks.cream);
      s.dot(const Offset(50, 58.5), 0.9, color: Inks.cream);
    case DogAccessory.cap:
      final dome = Path()
        ..moveTo(40.5, 16.5)
        ..quadraticBezierTo(42, 8.5, 50, 8.5)
        ..quadraticBezierTo(58, 8.5, 59.5, 16.5)
        ..close();
      s.fillArea(dome, _accSky, amp: 0.35);
      s.ink(dome, width: 1.9, amp: 0.35);
      final brim = Path()
        ..addOval(
          Rect.fromCenter(center: const Offset(50, 17), width: 25, height: 5),
        );
      s.fillArea(brim, const Color(0xFF5B7FA6), amp: 0.3);
      s.ink(brim, width: 1.7, amp: 0.3);
      s.dot(const Offset(50, 8.5), 1.3);
    case DogAccessory.bow:
      _bow(s, const Offset(37, 18.5), 1.0);
    case DogAccessory.scarf:
      final band = Path()
        ..moveTo(41.5, 50)
        ..quadraticBezierTo(50, 53.5, 58.5, 50)
        ..lineTo(58, 55)
        ..quadraticBezierTo(50, 58, 42, 55)
        ..close();
      s.fillArea(band, Inks.sun, amp: 0.35);
      s.ink(band, width: 1.8, amp: 0.35);
      final flap = Path()
        ..moveTo(53, 55.5)
        ..quadraticBezierTo(57, 60, 55.5, 66)
        ..quadraticBezierTo(51.5, 65, 50.5, 56.5)
        ..close();
      s.fillArea(flap, Inks.sun, amp: 0.35);
      s.ink(flap, width: 1.7, amp: 0.35);
      s.strokeLine(const Offset(52.4, 64), const Offset(52, 66.6), width: 1.2);
      s.strokeLine(
        const Offset(54.6, 64.4),
        const Offset(54.8, 67),
        width: 1.2,
      );
    case DogAccessory.specs:
      s.ring(const Offset(41.5, 32.5), 4.2, width: 1.8);
      s.ring(const Offset(58.5, 32.5), 4.2, width: 1.8);
      s.strokeLine(
        const Offset(45.7, 32.5),
        const Offset(54.3, 32.5),
        width: 1.5,
      );
      s.strokeLine(
        const Offset(37.3, 31.5),
        const Offset(32, 29.5),
        width: 1.4,
      );
      s.strokeLine(
        const Offset(62.7, 31.5),
        const Offset(68, 29.5),
        width: 1.4,
      );
    case DogAccessory.flower:
      _flower(s, const Offset(63.5, 17), 1.0);
    case DogAccessory.beret:
      _beret(s, const Offset(46.5, 13.5), 1.0, -0.16);
    case DogAccessory.partyHat:
      _partyHat(s, const Offset(50, 14.5), 1.0, 0.08);
    case DogAccessory.crown:
      _crown(s, const Offset(50, 14.5), 1.15, 0);
    case DogAccessory.beanie:
      _beanie(s, const Offset(50, 16), 1.05, 0);
    case DogAccessory.cowboyHat:
      _brimHat(
        s,
        const Offset(50, 15.8),
        1.0,
        0,
        top: _accTan,
        band: _accTanDeep,
        brimW: 32,
        cowboy: true,
      );
    case DogAccessory.strawHat:
      _brimHat(
        s,
        const Offset(50, 15.8),
        1.0,
        0,
        top: Inks.sun,
        band: Inks.leaf,
        brimW: 30,
      );
    case DogAccessory.halo:
      _halo(s, const Offset(50, 7.5), 1.0);
    case DogAccessory.sunglasses:
      _shadeLens(s, const Offset(41.5, 32.5), 1.0);
      _shadeLens(s, const Offset(58.5, 32.5), 1.0);
      s.strokeLine(const Offset(45.9, 32), const Offset(54.1, 32), width: 1.6);
      s.strokeLine(
        const Offset(37.2, 31.6),
        const Offset(32, 29.6),
        width: 1.4,
      );
      s.strokeLine(
        const Offset(62.8, 31.6),
        const Offset(68, 29.6),
        width: 1.4,
      );
    case DogAccessory.heartShades:
      _heartLens(s, const Offset(41.5, 32.5), 1.0);
      _heartLens(s, const Offset(58.5, 32.5), 1.0);
      s.strokeLine(
        const Offset(46.8, 31.4),
        const Offset(53.2, 31.4),
        width: 1.5,
      );
      s.strokeLine(
        const Offset(36.2, 31.2),
        const Offset(32, 29.6),
        width: 1.4,
      );
      s.strokeLine(
        const Offset(63.8, 31.2),
        const Offset(68, 29.6),
        width: 1.4,
      );
    case DogAccessory.monocle:
      s.ring(const Offset(58.5, 32.5), 4.4, width: 3.2);
      s.ring(const Offset(58.5, 32.5), 4.4, width: 1.7, color: Inks.sun);
      s.curve(
        const Offset(60.5, 36.4),
        const Offset(64.5, 42),
        const Offset(63, 48.5),
        width: 1.2,
        amp: 0.4,
      );
      s.dot(const Offset(63, 49), 0.9, color: Inks.sun);
    case DogAccessory.bowtie:
      _bow(s, const Offset(50, 53.5), 1.1, fill: Inks.ink, knot: _accKnotInk);
    case DogAccessory.collar:
      final collarBand = Path()
        ..moveTo(41.5, 50.5)
        ..quadraticBezierTo(50, 54, 58.5, 50.5)
        ..lineTo(58, 53.8)
        ..quadraticBezierTo(50, 57, 42, 53.8)
        ..close();
      s.fillArea(collarBand, _accRed, amp: 0.3);
      s.ink(collarBand, width: 1.7, amp: 0.3);
      s.dot(const Offset(50, 57.8), 1.8, color: Inks.sun);
      s.ring(const Offset(50, 57.8), 1.8, width: 1.2, amp: 0.2);
    case DogAccessory.lei:
      const leiSpots = [
        Offset(42, 51.5),
        Offset(44.5, 55),
        Offset(47.5, 57.4),
        Offset(51, 58.2),
        Offset(54.5, 57.2),
        Offset(57, 54.6),
        Offset(59, 51.2),
      ];
      for (var i = 0; i < leiSpots.length; i++) {
        _leiFlower(s, leiSpots[i], 1.0, _leiColors[i % 3]);
      }
    case DogAccessory.cape:
      for (final side in const [-1.0, 1.0]) {
        final wing = Path()
          ..moveTo(50 + side * 8.5, 51)
          ..quadraticBezierTo(50 + side * 16, 55, 50 + side * 18.5, 62)
          ..quadraticBezierTo(50 + side * 20, 69, 50 + side * 17.5, 75)
          ..quadraticBezierTo(50 + side * 14.5, 71, 50 + side * 13.5, 65)
          ..quadraticBezierTo(50 + side * 12, 57, 50 + side * 8.5, 51)
          ..close();
        s.fillArea(wing, _accRed, amp: 0.4);
        s.ink(wing, width: 1.8, amp: 0.4);
      }
      final capeCollar = Path()
        ..moveTo(41, 50.5)
        ..quadraticBezierTo(50, 54.5, 59, 50.5)
        ..lineTo(58.5, 53.5)
        ..quadraticBezierTo(50, 57.2, 41.5, 53.5)
        ..close();
      s.fillArea(capeCollar, _accRed, amp: 0.3);
      s.ink(capeCollar, width: 1.7, amp: 0.3);
      s.dot(const Offset(50, 53.8), 1.6, color: Inks.sun);
      s.ring(const Offset(50, 53.8), 1.6, width: 1.1, amp: 0.2);
    case DogAccessory.backpack:
      for (final side in const [-1.0, 1.0]) {
        final tab = Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(50 + side * 13.5, 58),
                width: 6,
                height: 13,
              ),
              const Radius.circular(2.8),
            ),
          );
        s.fillArea(tab, _accSky, amp: 0.3);
        s.ink(tab, width: 1.6, amp: 0.3);
        final strap = Path()
          ..moveTo(50 + side * 3.6, 50.2)
          ..lineTo(50 + side * 7.0, 50.8)
          ..lineTo(50 + side * 8.2, 61.5)
          ..lineTo(50 + side * 4.8, 61.8)
          ..close();
        s.fillArea(strap, _accSky, amp: 0.25);
        s.ink(strap, width: 1.4, amp: 0.25);
      }
    case DogAccessory.beeFriend:
      _bee(s, const Offset(27.5, 8.5), 1.4);
    case DogAccessory.raggedCloak:
      _sword(
        s,
        const Offset(66.5, 58),
        const Offset(79, 26),
        3.0,
        blade: _accCloth,
      );
      for (final side in const [-1.0, 1.0]) {
        final wing = Path()
          ..moveTo(50 + side * 8.5, 51)
          ..quadraticBezierTo(50 + side * 16, 55, 50 + side * 18.5, 62)
          ..quadraticBezierTo(50 + side * 19.5, 68, 50 + side * 17.5, 74.5)
          ..lineTo(50 + side * 15.8, 70.5)
          ..lineTo(50 + side * 14.6, 75)
          ..lineTo(50 + side * 13.2, 66)
          ..quadraticBezierTo(50 + side * 12, 57, 50 + side * 8.5, 51)
          ..close();
        s.fillArea(wing, _accCloth, amp: 0.4);
        s.ink(wing, width: 1.8, amp: 0.4);
        final hem = Path()
          ..moveTo(50 + side * 17.8, 62.5)
          ..quadraticBezierTo(50 + side * 19, 68, 50 + side * 17.4, 73.5);
        s.ink(hem, width: 1.2, amp: 0.3, color: Inks.sun);
      }
      final cloakCollar = Path()
        ..moveTo(41, 50.5)
        ..quadraticBezierTo(50, 54.5, 59, 50.5)
        ..lineTo(58.5, 53.8)
        ..quadraticBezierTo(50, 57.4, 41.5, 53.8)
        ..close();
      s.fillArea(cloakCollar, _accCloth, amp: 0.3);
      s.ink(cloakCollar, width: 1.7, amp: 0.3);
      final cloakBand = Path()
        ..moveTo(34.5, 23.5)
        ..quadraticBezierTo(50, 19.5, 65.5, 23.5)
        ..lineTo(65, 27)
        ..quadraticBezierTo(50, 23.2, 35, 27)
        ..close();
      s.fillArea(cloakBand, _accCloth, amp: 0.3);
      s.ink(cloakBand, width: 1.6, amp: 0.3);
      s.dot(const Offset(50, 21.9), 0.75, color: Inks.sun);
      s.dot(const Offset(48.7, 23.3), 0.75, color: Inks.sun);
      s.dot(const Offset(51.3, 23.3), 0.75, color: Inks.sun);
      s.dot(const Offset(50, 24.7), 0.75, color: Inks.sun);
    case DogAccessory.crimsonScarf:
      final scarfWrap = Path()
        ..moveTo(40, 49)
        ..quadraticBezierTo(50, 54.5, 60, 49)
        ..lineTo(59.4, 56.5)
        ..quadraticBezierTo(50, 61.5, 40.6, 56.5)
        ..close();
      s.fillArea(scarfWrap, _accRed, amp: 0.4);
      s.ink(scarfWrap, width: 1.8, amp: 0.4);
      final scarfFold = Path()
        ..moveTo(41.8, 52.4)
        ..quadraticBezierTo(50, 56.8, 58.2, 52.4);
      s.ink(scarfFold, width: 1.1, amp: 0.3, color: _accBlood);
      final scarfTail = Path()
        ..moveTo(43.5, 56)
        ..quadraticBezierTo(36.5, 60.5, 33.5, 67.5)
        ..lineTo(36.8, 66.2)
        ..lineTo(37.6, 68.6)
        ..quadraticBezierTo(41.5, 62.5, 44.8, 57.6)
        ..close();
      s.fillArea(scarfTail, _accRed, amp: 0.4);
      s.ink(scarfTail, width: 1.6, amp: 0.4);
      final scarfJacket = Path()
        ..moveTo(44, 59.5)
        ..quadraticBezierTo(50, 62.5, 56, 59.5)
        ..lineTo(55.6, 68.5)
        ..quadraticBezierTo(50, 71, 44.4, 68.5)
        ..close();
      s.fillArea(scarfJacket, _accSteel, amp: 0.3);
      s.ink(scarfJacket, width: 1.6, amp: 0.3);
      s.dot(const Offset(47.6, 63.5), 0.8, color: Inks.cream);
      s.dot(const Offset(52.4, 63.5), 0.8, color: Inks.cream);
    case DogAccessory.ghoulMask:
      _tendril(s, const Offset(24, 64), 1.2, -1);
      _tendril(s, const Offset(31, 71), 0.9, -1);
      _tendril(s, const Offset(76, 64), 1.2, 1);
      _tendril(s, const Offset(69, 71), 0.9, 1);
      final ghoulMask = Path()
        ..moveTo(41.5, 39)
        ..quadraticBezierTo(50, 36, 58.5, 39)
        ..quadraticBezierTo(59.8, 46, 50, 51)
        ..quadraticBezierTo(40.2, 46, 41.5, 39)
        ..close();
      s.fillArea(ghoulMask, _accCloth, amp: 0.3);
      s.ink(ghoulMask, width: 1.7, amp: 0.3);
      final grin = Path()..moveTo(43.2, 43.6);
      for (var i = 1; i <= 6; i++) {
        grin.lineTo(43.2 + i * 2.3, i.isOdd ? 46.2 : 43.4);
      }
      s.ink(grin, width: 1.4, amp: 0.15, color: Inks.cream);
      final patch = Path()
        ..addOval(
          Rect.fromCircle(center: const Offset(41.5, 32.5), radius: 4.6),
        );
      s.fillArea(patch, Inks.ink, amp: 0.2);
      s.ink(patch, width: 1.5, amp: 0.2);
      final strapA = Path()
        ..moveTo(37, 30.9)
        ..lineTo(31.8, 28.4);
      s.ink(strapA, width: 1.3, amp: 0.2);
      final strapB = Path()
        ..moveTo(46, 31.4)
        ..lineTo(55, 27.4);
      s.ink(strapB, width: 1.3, amp: 0.2);
    case DogAccessory.asceticBlaze:
      final hood = Path()
        ..moveTo(37, 44)
        ..quadraticBezierTo(29, 33, 31.5, 20.5)
        ..quadraticBezierTo(37.5, 8, 50, 7.6)
        ..quadraticBezierTo(62.5, 8, 68.5, 20.5)
        ..quadraticBezierTo(71, 33, 63, 44)
        ..quadraticBezierTo(66.5, 31.5, 63, 21.5)
        ..quadraticBezierTo(57.5, 12.8, 50, 12.6)
        ..quadraticBezierTo(42.5, 12.8, 37, 21.5)
        ..quadraticBezierTo(33.5, 31.5, 37, 44)
        ..close();
      s.fillArea(hood, _accCloth, amp: 0.35);
      s.ink(hood, width: 1.8, amp: 0.35);
      final rim = Path()
        ..moveTo(37.6, 42)
        ..quadraticBezierTo(34.4, 31, 37.8, 21.8)
        ..quadraticBezierTo(43, 13.6, 50, 13.4)
        ..quadraticBezierTo(57, 13.6, 62.2, 21.8)
        ..quadraticBezierTo(65.6, 31, 62.4, 42);
      s.ink(rim, width: 1.2, amp: 0.25, color: _accRed);
      _flameTongue(s, const Offset(25.5, 62), 1.05, -0.4);
      _flameTongue(s, const Offset(74.5, 62), 1.05, 0.4);
      _flameTongue(s, const Offset(31, 51), 0.7, -0.25);
      _flameTongue(s, const Offset(69.5, 50.5), 0.75, 0.3);
      _flameTongue(s, const Offset(38.5, 71), 0.65, -0.2);
      _flameTongue(s, const Offset(62, 72), 0.6, 0.2);
      _bloodDrop(s, const Offset(20, 38), 1.0);
      _bloodDrop(s, const Offset(79.5, 42), 0.9);
      _bloodDrop(s, const Offset(70.5, 17), 0.8);
      _bloodDrop(s, const Offset(25.5, 22), 0.85);
    case DogAccessory.blindfold:
      final blind = Path()
        ..moveTo(33.5, 29.5)
        ..quadraticBezierTo(50, 25.8, 66.5, 29.5)
        ..lineTo(66, 36.5)
        ..quadraticBezierTo(50, 40, 34, 36.5)
        ..close();
      s.fillArea(blind, Inks.ink, amp: 0.3);
      s.ink(blind, width: 1.7, amp: 0.3);
      final crease = Path()
        ..moveTo(40, 31)
        ..quadraticBezierTo(50, 33.8, 60, 31);
      s.ink(crease, width: 0.9, amp: 0.2, color: _accKnotInk);
      final blindCollar = Path()
        ..moveTo(41, 50)
        ..lineTo(43, 45.8)
        ..lineTo(45.8, 50.6)
        ..quadraticBezierTo(50, 52.6, 54.2, 50.6)
        ..lineTo(57, 45.8)
        ..lineTo(59, 50)
        ..lineTo(58.6, 55)
        ..quadraticBezierTo(50, 58.6, 41.4, 55)
        ..close();
      s.fillArea(blindCollar, Inks.ink, amp: 0.3);
      s.ink(blindCollar, width: 1.6, amp: 0.3);
      s.dot(const Offset(26.5, 19), 1.6, color: _accRed);
      s.ring(const Offset(26.5, 19), 2.7, width: 1.0, color: _accRed);
      s.dot(const Offset(73.5, 15), 1.6, color: _accSky);
      s.ring(const Offset(73.5, 15), 2.7, width: 1.0, color: _accSky);
    case DogAccessory.duelistCoat:
      _sword(s, const Offset(31, 61), const Offset(22.5, 46.5), 1.9);
      _sword(
        s,
        const Offset(69, 61),
        const Offset(77.5, 46.5),
        1.9,
        blade: _accTeal,
      );
      for (final side in const [-1.0, 1.0]) {
        final coat = Path()
          ..moveTo(50 + side * 8.5, 51)
          ..quadraticBezierTo(50 + side * 16, 55, 50 + side * 18, 62)
          ..quadraticBezierTo(50 + side * 19, 69, 50 + side * 16.5, 75)
          ..quadraticBezierTo(50 + side * 14, 70, 50 + side * 13, 64)
          ..quadraticBezierTo(50 + side * 12, 56.5, 50 + side * 8.5, 51)
          ..close();
        s.fillArea(coat, Inks.ink, amp: 0.4);
        s.ink(coat, width: 1.8, amp: 0.4);
        final trim = Path()
          ..moveTo(50 + side * 17.4, 61)
          ..quadraticBezierTo(50 + side * 18.6, 68, 50 + side * 16.3, 74);
        s.ink(trim, width: 1.0, amp: 0.3, color: _accSteel);
      }
      final kCollar = Path()
        ..moveTo(41, 50.5)
        ..quadraticBezierTo(50, 54.5, 59, 50.5)
        ..lineTo(58.5, 53.6)
        ..quadraticBezierTo(50, 57.2, 41.5, 53.6)
        ..close();
      s.fillArea(kCollar, Inks.ink, amp: 0.3);
      s.ink(kCollar, width: 1.6, amp: 0.3);
    case DogAccessory.shadowWisps:
      _shadowWisp(s, const Offset(24, 64), 1.05, -1.2);
      _shadowWisp(s, const Offset(76, 64), 1.05, 1.2);
      _shadowWisp(s, const Offset(31, 49), 0.7, -0.8);
      final mantle = Path()
        ..moveTo(41.5, 50)
        ..quadraticBezierTo(50, 54, 58.5, 50)
        ..lineTo(58.8, 64)
        ..quadraticBezierTo(50, 67.5, 41.2, 64)
        ..close();
      s.fillArea(mantle, Inks.ink, amp: 0.35);
      s.ink(mantle, width: 1.7, amp: 0.35);
      final vTrim = Path()
        ..moveTo(50, 54.2)
        ..lineTo(50, 66.4);
      s.ink(vTrim, width: 1.2, amp: 0.2, color: _accShadow);
      final mTrim = Path()
        ..moveTo(42, 51.2)
        ..quadraticBezierTo(50, 55, 58, 51.2);
      s.ink(mTrim, width: 1.2, amp: 0.25, color: _accShadow);
      s.dot(const Offset(37, 29.3), 0.95, color: _accShadow);
      s.dot(const Offset(63, 29.3), 0.95, color: _accShadow);
    case DogAccessory.hornedMask:
      _curvedHorn(s, const Offset(37.5, 12), -1, 1.25);
      _curvedHorn(s, const Offset(62.5, 12), 1, 1.25);
      final skull = Path()
        ..moveTo(33.5, 27)
        ..quadraticBezierTo(34.5, 9.5, 50, 8.4)
        ..quadraticBezierTo(65.5, 9.5, 66.5, 27)
        ..quadraticBezierTo(58, 24, 50, 24)
        ..quadraticBezierTo(42, 24, 33.5, 27)
        ..close();
      s.fillArea(skull, Inks.cream, amp: 0.3);
      s.ink(skull, width: 1.8, amp: 0.3);
      for (final side in const [-1.0, 1.0]) {
        final cheek = Path()
          ..moveTo(50 + side * 15.5, 27.5)
          ..quadraticBezierTo(50 + side * 19.5, 32.5, 50 + side * 17.5, 39)
          ..quadraticBezierTo(50 + side * 14.5, 43.5, 50 + side * 10.5, 44.5)
          ..quadraticBezierTo(50 + side * 12.8, 38.5, 50 + side * 12, 32.5)
          ..quadraticBezierTo(50 + side * 13.2, 29, 50 + side * 15.5, 27.5)
          ..close();
        s.fillArea(cheek, Inks.cream, amp: 0.3);
        s.ink(cheek, width: 1.6, amp: 0.3);
      }
      final jaw = Path()
        ..moveTo(41, 43)
        ..quadraticBezierTo(50, 40, 59, 43)
        ..lineTo(58.4, 49)
        ..quadraticBezierTo(50, 52.2, 41.6, 49)
        ..close();
      s.fillArea(jaw, Inks.cream, amp: 0.25);
      s.ink(jaw, width: 1.6, amp: 0.25);
      for (final x in const [44.2, 47.1, 50.0, 52.9, 55.8]) {
        final tooth = Path()
          ..moveTo(x, 42.4)
          ..lineTo(x, 49.4);
        s.ink(tooth, width: 1.1, amp: 0.15);
      }
      final stripeA = Path()
        ..moveTo(43.5, 9.8)
        ..quadraticBezierTo(42.6, 16, 43.2, 23.4);
      s.ink(stripeA, width: 1.7, amp: 0.2, color: _accRed);
      final stripeB = Path()
        ..moveTo(47.2, 9)
        ..quadraticBezierTo(46.4, 16, 46.9, 23.2);
      s.ink(stripeB, width: 1.7, amp: 0.2, color: _accRed);
      final mane = Path()
        ..moveTo(41.5, 50.5)
        ..lineTo(43.8, 56.5)
        ..lineTo(46.2, 51.5)
        ..lineTo(48.6, 57.2)
        ..lineTo(51, 51.6)
        ..lineTo(53.4, 57.2)
        ..lineTo(55.8, 51.5)
        ..lineTo(58.2, 56.5)
        ..lineTo(58.5, 50.5)
        ..quadraticBezierTo(50, 54.4, 41.5, 50.5)
        ..close();
      s.fillArea(mane, _accGi, amp: 0.35);
      s.ink(mane, width: 1.5, amp: 0.35);
    case DogAccessory.orangeGi:
      final hair = Path()
        ..moveTo(33.5, 26)
        ..lineTo(36.5, 14.5)
        ..lineTo(40.2, 20)
        ..lineTo(43, 6.5)
        ..lineTo(47, 16)
        ..lineTo(50.2, 3)
        ..lineTo(53.6, 15.5)
        ..lineTo(57.8, 5.5)
        ..lineTo(60.6, 18.5)
        ..lineTo(64.2, 11.5)
        ..lineTo(66.5, 26)
        ..quadraticBezierTo(58, 20.5, 50, 20.5)
        ..quadraticBezierTo(42, 20.5, 33.5, 26)
        ..close();
      s.fillArea(hair, Inks.sun, amp: 0.3);
      s.ink(hair, width: 1.7, amp: 0.3);
      final strandA = Path()
        ..moveTo(44.5, 20.4)
        ..lineTo(46.8, 12);
      s.ink(strandA, width: 1.0, amp: 0.25, color: _accTanDeep);
      final strandB = Path()
        ..moveTo(55.5, 20.2)
        ..lineTo(57.2, 12.5);
      s.ink(strandB, width: 1.0, amp: 0.25, color: _accTanDeep);
      final gi = Path()
        ..moveTo(41.5, 50)
        ..quadraticBezierTo(50, 54.2, 58.5, 50)
        ..lineTo(58.8, 63)
        ..quadraticBezierTo(50, 66.6, 41.2, 63)
        ..close();
      s.fillArea(gi, _accGi, amp: 0.35);
      s.ink(gi, width: 1.7, amp: 0.35);
      final giTrim = Path()
        ..moveTo(42, 51.2)
        ..quadraticBezierTo(50, 55.4, 58, 51.2);
      s.ink(giTrim, width: 1.5, amp: 0.25, color: _accGiBlue);
      final sash = Path()
        ..moveTo(42.6, 61.4)
        ..quadraticBezierTo(50, 64.6, 57.4, 61.4)
        ..lineTo(57, 65)
        ..quadraticBezierTo(50, 68, 43, 65)
        ..close();
      s.fillArea(sash, _accGiBlue, amp: 0.3);
      s.ink(sash, width: 1.5, amp: 0.3);
      s.dot(const Offset(50, 65.4), 1.1, color: Inks.cream);
      _auraBolt(s, const Offset(24, 68), 1.15, -1);
      _auraBolt(s, const Offset(76, 68), 1.15, 1);
      _auraBolt(s, const Offset(30, 52), 0.8, -1);
      _auraBolt(s, const Offset(70, 52), 0.8, 1);
    case DogAccessory.pirateCaptain:
      _brimHat(
        s,
        const Offset(50, 15.8),
        1.0,
        0,
        top: _accNavy,
        band: Inks.sun,
        brimW: 30,
      );
      for (final side in const [-1.0, 1.0]) {
        final vest = Path()
          ..moveTo(50 + side * 8.5, 50.5)
          ..quadraticBezierTo(50 + side * 13, 53.5, 50 + side * 14, 58.5)
          ..lineTo(50 + side * 13.4, 66)
          ..quadraticBezierTo(50 + side * 9, 64.4, 50 + side * 6, 60.5)
          ..lineTo(50 + side * 5.8, 53.6)
          ..quadraticBezierTo(50 + side * 7, 51.6, 50 + side * 8.5, 50.5)
          ..close();
        s.fillArea(vest, _accNavy, amp: 0.35);
        s.ink(vest, width: 1.6, amp: 0.35);
      }
  }
}

void _accessoryQuarter(Sketch s, DogAccessory acc) {
  switch (acc) {
    case DogAccessory.none:
      break;
    case DogAccessory.bandana:
      final tri = Path()
        ..moveTo(43.5, 52)
        ..lineTo(61.5, 51)
        ..quadraticBezierTo(56, 56, 54, 62)
        ..quadraticBezierTo(50.5, 56, 43.5, 52)
        ..close();
      s.fillArea(tri, _accRed, amp: 0.35);
      s.ink(tri, width: 1.8, amp: 0.35);
      s.dot(const Offset(50.5, 55), 0.9, color: Inks.cream);
      s.dot(const Offset(56, 54.5), 0.9, color: Inks.cream);
    case DogAccessory.cap:
      final dome = Path()
        ..moveTo(44.5, 15.5)
        ..quadraticBezierTo(46.5, 7.5, 54.5, 7.5)
        ..quadraticBezierTo(62, 7.8, 63.5, 15.5)
        ..close();
      s.fillArea(dome, _accSky, amp: 0.35);
      s.ink(dome, width: 1.9, amp: 0.35);
      final brim = Path()
        ..addOval(
          Rect.fromCenter(center: const Offset(56, 16), width: 23, height: 5),
        );
      s.fillArea(brim, const Color(0xFF5B7FA6), amp: 0.3);
      s.ink(brim, width: 1.7, amp: 0.3);
      s.dot(const Offset(54.5, 7.6), 1.3);
    case DogAccessory.bow:
      _bow(s, const Offset(42, 17.5), 1.0);
    case DogAccessory.scarf:
      final band = Path()
        ..moveTo(45, 51)
        ..quadraticBezierTo(53.5, 54, 61.5, 50.5)
        ..lineTo(61, 55.5)
        ..quadraticBezierTo(53.5, 58.5, 45.5, 56)
        ..close();
      s.fillArea(band, Inks.sun, amp: 0.35);
      s.ink(band, width: 1.8, amp: 0.35);
      final flap = Path()
        ..moveTo(57, 56)
        ..quadraticBezierTo(61, 60.5, 59.5, 66)
        ..quadraticBezierTo(55.5, 65, 54.8, 57)
        ..close();
      s.fillArea(flap, Inks.sun, amp: 0.35);
      s.ink(flap, width: 1.7, amp: 0.35);
    case DogAccessory.specs:
      s.ring(const Offset(45.5, 32.8), 3.9, width: 1.8);
      s.ring(const Offset(62.5, 32), 4.2, width: 1.8);
      s.strokeLine(
        const Offset(49.4, 32.6),
        const Offset(58.3, 32.1),
        width: 1.5,
      );
      s.strokeLine(
        const Offset(41.6, 32),
        const Offset(36.5, 30.5),
        width: 1.4,
      );
      s.strokeLine(
        const Offset(66.7, 31),
        const Offset(71.5, 29.5),
        width: 1.4,
      );
    case DogAccessory.flower:
      _flower(s, const Offset(67, 15.5), 1.0);
    case DogAccessory.beret:
      _beret(s, const Offset(52, 14.2), 1.0, 0.14);
    case DogAccessory.partyHat:
      _partyHat(s, const Offset(54.5, 16), 1.0, 0.1);
    case DogAccessory.crown:
      _crown(s, const Offset(54.5, 16.5), 1.15, 0.06);
    case DogAccessory.beanie:
      _beanie(s, const Offset(54, 15.5), 1.05, 0.05);
    case DogAccessory.cowboyHat:
      _brimHat(
        s,
        const Offset(54.5, 15.5),
        1.0,
        0.05,
        top: _accTan,
        band: _accTanDeep,
        brimW: 32,
        cowboy: true,
      );
    case DogAccessory.strawHat:
      _brimHat(
        s,
        const Offset(54.5, 15.5),
        1.0,
        0.05,
        top: Inks.sun,
        band: Inks.leaf,
        brimW: 30,
      );
    case DogAccessory.halo:
      _halo(s, const Offset(55, 7), 1.0);
    case DogAccessory.sunglasses:
      _shadeLens(s, const Offset(45.5, 32.8), 0.92);
      _shadeLens(s, const Offset(62.5, 32), 1.0);
      s.strokeLine(
        const Offset(49.6, 32.4),
        const Offset(58.1, 32),
        width: 1.6,
      );
      s.strokeLine(
        const Offset(41.5, 32.2),
        const Offset(36.5, 30.6),
        width: 1.4,
      );
      s.strokeLine(
        const Offset(66.9, 31.4),
        const Offset(71.5, 29.8),
        width: 1.4,
      );
    case DogAccessory.heartShades:
      _heartLens(s, const Offset(45.5, 32.8), 0.92);
      _heartLens(s, const Offset(60.5, 32), 0.92);
      s.strokeLine(
        const Offset(50.2, 31.8),
        const Offset(57.2, 31.4),
        width: 1.5,
      );
      s.strokeLine(
        const Offset(40.6, 31.8),
        const Offset(36.5, 30.4),
        width: 1.4,
      );
      s.strokeLine(
        const Offset(63.6, 31.1),
        const Offset(71.5, 29.5),
        width: 1.4,
      );
    case DogAccessory.monocle:
      s.ring(const Offset(62.5, 32), 4.4, width: 3.2);
      s.ring(const Offset(62.5, 32), 4.4, width: 1.7, color: Inks.sun);
      s.curve(
        const Offset(64.5, 35.9),
        const Offset(68, 42),
        const Offset(66.5, 48),
        width: 1.2,
        amp: 0.4,
      );
      s.dot(const Offset(66.5, 48.5), 0.9, color: Inks.sun);
    case DogAccessory.bowtie:
      _bow(s, const Offset(53.5, 54), 1.1, fill: Inks.ink, knot: _accKnotInk);
    case DogAccessory.collar:
      final collarBand = Path()
        ..moveTo(45, 51)
        ..quadraticBezierTo(53.5, 54.5, 61.5, 50.5)
        ..lineTo(61, 53.8)
        ..quadraticBezierTo(53.5, 57.5, 45.5, 54.2)
        ..close();
      s.fillArea(collarBand, _accRed, amp: 0.3);
      s.ink(collarBand, width: 1.7, amp: 0.3);
      s.dot(const Offset(54, 58), 1.8, color: Inks.sun);
      s.ring(const Offset(54, 58), 1.8, width: 1.2, amp: 0.2);
    case DogAccessory.lei:
      const leiSpots = [
        Offset(45.5, 51.5),
        Offset(48, 55),
        Offset(51, 57.4),
        Offset(54.5, 58),
        Offset(57.5, 56.4),
        Offset(60, 53.6),
        Offset(62, 50.8),
      ];
      for (var i = 0; i < leiSpots.length; i++) {
        _leiFlower(s, leiSpots[i], 1.0, _leiColors[i % 3]);
      }
    case DogAccessory.cape:
      final capeWing = Path()
        ..moveTo(46, 52)
        ..quadraticBezierTo(37, 56, 34, 64)
        ..quadraticBezierTo(32.5, 71, 35.5, 77.5)
        ..quadraticBezierTo(40.5, 72, 43, 64.5)
        ..quadraticBezierTo(45, 57, 46, 52)
        ..close();
      s.fillArea(capeWing, _accRed, amp: 0.4);
      s.ink(capeWing, width: 1.8, amp: 0.4);
      final capeCollar = Path()
        ..moveTo(44.5, 50.8)
        ..quadraticBezierTo(53.5, 54.8, 62, 50.3)
        ..lineTo(61.5, 53.3)
        ..quadraticBezierTo(53.5, 57.4, 45, 53.8)
        ..close();
      s.fillArea(capeCollar, _accRed, amp: 0.3);
      s.ink(capeCollar, width: 1.7, amp: 0.3);
      s.dot(const Offset(56, 53), 1.6, color: Inks.sun);
      s.ring(const Offset(56, 53), 1.6, width: 1.1, amp: 0.2);
    case DogAccessory.backpack:
      final pack = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: const Offset(39.5, 58),
              width: 9,
              height: 14,
            ),
            const Radius.circular(3.2),
          ),
        );
      s.fillArea(pack, _accSky, amp: 0.3);
      s.ink(pack, width: 1.8, amp: 0.3);
      s.strokeLine(
        const Offset(35.8, 54.5),
        const Offset(43.2, 54.5),
        width: 1.3,
        amp: 0.3,
      );
      final strap = Path()
        ..moveTo(48.5, 50.5)
        ..lineTo(52, 51)
        ..lineTo(53.5, 61.5)
        ..lineTo(50, 62)
        ..close();
      s.fillArea(strap, _accSky, amp: 0.25);
      s.ink(strap, width: 1.4, amp: 0.25);
    case DogAccessory.beeFriend:
      _bee(s, const Offset(33, 8.5), 1.4);
    case DogAccessory.raggedCloak:
      _sword(
        s,
        const Offset(38, 56),
        const Offset(26, 27),
        3.0,
        blade: _accCloth,
      );
      final cloakWing = Path()
        ..moveTo(46, 52)
        ..quadraticBezierTo(37, 56, 34, 64)
        ..quadraticBezierTo(32.5, 71, 35.5, 77.5)
        ..lineTo(37.5, 73)
        ..lineTo(39.4, 76.5)
        ..lineTo(41.5, 67)
        ..quadraticBezierTo(44, 58, 46, 52)
        ..close();
      s.fillArea(cloakWing, _accCloth, amp: 0.4);
      s.ink(cloakWing, width: 1.8, amp: 0.4);
      final cloakHem = Path()
        ..moveTo(34.6, 65)
        ..quadraticBezierTo(33.4, 71, 35.8, 76.4);
      s.ink(cloakHem, width: 1.2, amp: 0.3, color: Inks.sun);
      final cloakCollarQ = Path()
        ..moveTo(44.5, 50.8)
        ..quadraticBezierTo(53.5, 54.8, 62, 50.3)
        ..lineTo(61.5, 53.3)
        ..quadraticBezierTo(53.5, 57.4, 45, 53.8)
        ..close();
      s.fillArea(cloakCollarQ, _accCloth, amp: 0.3);
      s.ink(cloakCollarQ, width: 1.7, amp: 0.3);
      final cloakBandQ = Path()
        ..moveTo(38.5, 24)
        ..quadraticBezierTo(52, 20, 65.5, 22.5)
        ..lineTo(65, 25.8)
        ..quadraticBezierTo(52, 23.4, 39, 27.2)
        ..close();
      s.fillArea(cloakBandQ, _accCloth, amp: 0.3);
      s.ink(cloakBandQ, width: 1.6, amp: 0.3);
      s.dot(const Offset(55, 21.6), 0.72, color: Inks.sun);
      s.dot(const Offset(53.8, 22.9), 0.72, color: Inks.sun);
      s.dot(const Offset(56.2, 22.9), 0.72, color: Inks.sun);
      s.dot(const Offset(55, 24.2), 0.72, color: Inks.sun);
    case DogAccessory.crimsonScarf:
      final scarfWrapQ = Path()
        ..moveTo(43, 49.5)
        ..quadraticBezierTo(53.5, 54.5, 62.5, 49.2)
        ..lineTo(62, 56.5)
        ..quadraticBezierTo(53, 61, 43.6, 56.5)
        ..close();
      s.fillArea(scarfWrapQ, _accRed, amp: 0.4);
      s.ink(scarfWrapQ, width: 1.8, amp: 0.4);
      final scarfFoldQ = Path()
        ..moveTo(44.8, 52.8)
        ..quadraticBezierTo(53, 56.6, 61, 52.4);
      s.ink(scarfFoldQ, width: 1.1, amp: 0.3, color: _accBlood);
      final scarfTailQ = Path()
        ..moveTo(44.5, 55.5)
        ..quadraticBezierTo(37, 59.5, 33.5, 66.5)
        ..lineTo(36.8, 65.3)
        ..lineTo(37.6, 67.8)
        ..quadraticBezierTo(42, 62, 45.8, 57.2)
        ..close();
      s.fillArea(scarfTailQ, _accRed, amp: 0.4);
      s.ink(scarfTailQ, width: 1.6, amp: 0.4);
      final scarfJacketQ = Path()
        ..moveTo(47, 59.8)
        ..quadraticBezierTo(53, 62.6, 58.5, 59.4)
        ..lineTo(58, 68.2)
        ..quadraticBezierTo(52.5, 70.8, 47.4, 68.2)
        ..close();
      s.fillArea(scarfJacketQ, _accSteel, amp: 0.3);
      s.ink(scarfJacketQ, width: 1.6, amp: 0.3);
      s.dot(const Offset(50.8, 63.6), 0.8, color: Inks.cream);
      s.dot(const Offset(55.2, 63.2), 0.8, color: Inks.cream);
    case DogAccessory.ghoulMask:
      _tendril(s, const Offset(27, 63), 1.15, -1);
      _tendril(s, const Offset(33, 70), 0.95, -1);
      _tendril(s, const Offset(40, 73.5), 0.75, -1);
      _tendril(s, const Offset(71, 67), 0.85, 1);
      final ghoulMaskQ = Path()
        ..moveTo(54.5, 41.5)
        ..quadraticBezierTo(60.5, 38.8, 66.5, 41.8)
        ..quadraticBezierTo(67.5, 47, 60.5, 50.6)
        ..quadraticBezierTo(53.5, 47, 54.5, 41.5)
        ..close();
      s.fillArea(ghoulMaskQ, _accCloth, amp: 0.3);
      s.ink(ghoulMaskQ, width: 1.7, amp: 0.3);
      final grinQ = Path()..moveTo(56, 44.6);
      for (var i = 1; i <= 5; i++) {
        grinQ.lineTo(56 + i * 1.9, i.isOdd ? 46.8 : 44.4);
      }
      s.ink(grinQ, width: 1.3, amp: 0.15, color: Inks.cream);
      final patchQ = Path()
        ..addOval(
          Rect.fromCircle(center: const Offset(45.5, 32.8), radius: 4.2),
        );
      s.fillArea(patchQ, Inks.ink, amp: 0.2);
      s.ink(patchQ, width: 1.5, amp: 0.2);
      final strapAQ = Path()
        ..moveTo(41.6, 31.4)
        ..lineTo(37, 29.6);
      s.ink(strapAQ, width: 1.3, amp: 0.2);
      final strapBQ = Path()
        ..moveTo(49.5, 31.6)
        ..lineTo(58, 28.2);
      s.ink(strapBQ, width: 1.3, amp: 0.2);
    case DogAccessory.asceticBlaze:
      final hoodQ = Path()
        ..moveTo(38, 40)
        ..quadraticBezierTo(32, 26, 38, 15)
        ..quadraticBezierTo(45, 6.6, 56, 7.2)
        ..quadraticBezierTo(66, 8.4, 69, 20)
        ..quadraticBezierTo(70.5, 30, 65, 38.5)
        ..quadraticBezierTo(66.8, 28, 64, 19.5)
        ..quadraticBezierTo(58.5, 12, 52, 11.8)
        ..quadraticBezierTo(44.5, 12.4, 41.2, 20)
        ..quadraticBezierTo(38.6, 29, 41, 38)
        ..close();
      s.fillArea(hoodQ, _accCloth, amp: 0.35);
      s.ink(hoodQ, width: 1.8, amp: 0.35);
      final rimQ = Path()
        ..moveTo(41.6, 36.5)
        ..quadraticBezierTo(39.4, 28, 42, 20.5)
        ..quadraticBezierTo(45.2, 13, 52, 12.6)
        ..quadraticBezierTo(58, 12.8, 63.2, 20)
        ..quadraticBezierTo(66, 27.5, 64.4, 36.5);
      s.ink(rimQ, width: 1.2, amp: 0.25, color: _accRed);
      _flameTongue(s, const Offset(29, 60), 1.0, -0.4);
      _flameTongue(s, const Offset(72, 58), 0.9, 0.35);
      _flameTongue(s, const Offset(35, 49), 0.65, -0.25);
      _flameTongue(s, const Offset(74.5, 47), 0.65, 0.3);
      _flameTongue(s, const Offset(41, 72), 0.65, -0.2);
      _flameTongue(s, const Offset(64, 71.5), 0.6, 0.2);
      _bloodDrop(s, const Offset(24, 36), 0.95);
      _bloodDrop(s, const Offset(78.5, 37), 0.9);
      _bloodDrop(s, const Offset(68, 14.5), 0.8);
      _bloodDrop(s, const Offset(30.5, 19), 0.85);
    case DogAccessory.blindfold:
      final blindQ = Path()
        ..moveTo(38, 30.8)
        ..quadraticBezierTo(53, 26.8, 68.5, 29.2)
        ..lineTo(68, 35.6)
        ..quadraticBezierTo(53, 33.2, 38.5, 37.2)
        ..close();
      s.fillArea(blindQ, Inks.ink, amp: 0.3);
      s.ink(blindQ, width: 1.7, amp: 0.3);
      final creaseQ = Path()
        ..moveTo(43, 32.4)
        ..quadraticBezierTo(53, 30.6, 63.5, 31.4);
      s.ink(creaseQ, width: 0.9, amp: 0.2, color: _accKnotInk);
      final blindCollarQ = Path()
        ..moveTo(44.5, 50)
        ..lineTo(46.5, 46)
        ..lineTo(49, 50.6)
        ..quadraticBezierTo(53, 52.4, 57, 50.6)
        ..lineTo(59.5, 46)
        ..lineTo(61.5, 50)
        ..lineTo(61, 55)
        ..quadraticBezierTo(52.5, 58.4, 45, 55)
        ..close();
      s.fillArea(blindCollarQ, Inks.ink, amp: 0.3);
      s.ink(blindCollarQ, width: 1.6, amp: 0.3);
      s.dot(const Offset(31, 17), 1.6, color: _accRed);
      s.ring(const Offset(31, 17), 2.7, width: 1.0, color: _accRed);
      s.dot(const Offset(74, 13), 1.6, color: _accSky);
      s.ring(const Offset(74, 13), 2.7, width: 1.0, color: _accSky);
    case DogAccessory.duelistCoat:
      _sword(s, const Offset(37, 54), const Offset(27, 36), 1.7);
      _sword(
        s,
        const Offset(43.5, 59),
        const Offset(32, 48.5),
        1.7,
        blade: _accTeal,
      );
      final coatQ = Path()
        ..moveTo(46, 52)
        ..quadraticBezierTo(37, 56, 34, 64)
        ..quadraticBezierTo(32.5, 71, 35.5, 77.5)
        ..quadraticBezierTo(40.5, 72, 43, 64.5)
        ..quadraticBezierTo(45, 57, 46, 52)
        ..close();
      s.fillArea(coatQ, Inks.ink, amp: 0.4);
      s.ink(coatQ, width: 1.8, amp: 0.4);
      final trimQ = Path()
        ..moveTo(34.6, 64.5)
        ..quadraticBezierTo(33.2, 70.5, 35.4, 76.4);
      s.ink(trimQ, width: 1.0, amp: 0.3, color: _accSteel);
      final kCollarQ = Path()
        ..moveTo(44.5, 50.8)
        ..quadraticBezierTo(53.5, 54.8, 62, 50.3)
        ..lineTo(61.5, 53.3)
        ..quadraticBezierTo(53.5, 57.4, 45, 53.8)
        ..close();
      s.fillArea(kCollarQ, Inks.ink, amp: 0.3);
      s.ink(kCollarQ, width: 1.6, amp: 0.3);
    case DogAccessory.shadowWisps:
      _shadowWisp(s, const Offset(28, 62), 1.0, -1.0);
      _shadowWisp(s, const Offset(72, 60), 0.9, 1.0);
      _shadowWisp(s, const Offset(35, 48), 0.65, -0.6);
      final mantleQ = Path()
        ..moveTo(46, 50.5)
        ..quadraticBezierTo(53, 54, 60.5, 50)
        ..lineTo(60.8, 63.5)
        ..quadraticBezierTo(53, 67, 45.8, 63.5)
        ..close();
      s.fillArea(mantleQ, Inks.ink, amp: 0.35);
      s.ink(mantleQ, width: 1.7, amp: 0.35);
      final vTrimQ = Path()
        ..moveTo(53.2, 54)
        ..lineTo(53.2, 66);
      s.ink(vTrimQ, width: 1.2, amp: 0.2, color: _accShadow);
      final mTrimQ = Path()
        ..moveTo(46.6, 51.6)
        ..quadraticBezierTo(53, 55, 60, 51);
      s.ink(mTrimQ, width: 1.2, amp: 0.25, color: _accShadow);
      s.dot(const Offset(42, 29.8), 0.95, color: _accShadow);
      s.dot(const Offset(66, 29), 0.95, color: _accShadow);
    case DogAccessory.hornedMask:
      _curvedHorn(s, const Offset(42, 11), -1, 1.15);
      _curvedHorn(s, const Offset(60, 10.5), 1, 1.15);
      final skullQ = Path()
        ..moveTo(38.5, 25.5)
        ..quadraticBezierTo(40, 8.8, 53, 7.8)
        ..quadraticBezierTo(65, 8.6, 66.5, 24)
        ..quadraticBezierTo(59, 21, 52.5, 21.2)
        ..quadraticBezierTo(45, 21.6, 38.5, 25.5)
        ..close();
      s.fillArea(skullQ, Inks.cream, amp: 0.3);
      s.ink(skullQ, width: 1.8, amp: 0.3);
      final cheekFarQ = Path()
        ..moveTo(40.5, 26.5)
        ..quadraticBezierTo(37.5, 31.5, 39, 37.5)
        ..quadraticBezierTo(41.5, 41.5, 45, 42.5)
        ..quadraticBezierTo(43.2, 37, 43.6, 31.5)
        ..quadraticBezierTo(42, 28, 40.5, 26.5)
        ..close();
      s.fillArea(cheekFarQ, Inks.cream, amp: 0.3);
      s.ink(cheekFarQ, width: 1.5, amp: 0.3);
      final cheekNearQ = Path()
        ..moveTo(66, 25.5)
        ..quadraticBezierTo(69.5, 30.5, 68.5, 37)
        ..quadraticBezierTo(66.5, 41, 63, 42.5)
        ..quadraticBezierTo(64.8, 36.5, 64.4, 31)
        ..quadraticBezierTo(64.8, 27.5, 66, 25.5)
        ..close();
      s.fillArea(cheekNearQ, Inks.cream, amp: 0.3);
      s.ink(cheekNearQ, width: 1.5, amp: 0.3);
      final jawQ = Path()
        ..moveTo(54, 41.8)
        ..quadraticBezierTo(60.5, 39, 66.8, 42)
        ..lineTo(66.2, 47.5)
        ..quadraticBezierTo(60, 50.8, 54.4, 47.8)
        ..close();
      s.fillArea(jawQ, Inks.cream, amp: 0.25);
      s.ink(jawQ, width: 1.5, amp: 0.25);
      for (final x in const [56.6, 59.2, 61.8, 64.4]) {
        final toothQ = Path()
          ..moveTo(x, 41.4)
          ..lineTo(x, 48.4);
        s.ink(toothQ, width: 1.0, amp: 0.15);
      }
      final stripeAQ = Path()
        ..moveTo(48.2, 9.4)
        ..quadraticBezierTo(47.4, 14.5, 47.8, 20.6);
      s.ink(stripeAQ, width: 1.7, amp: 0.2, color: _accRed);
      final stripeBQ = Path()
        ..moveTo(51.6, 8.9)
        ..quadraticBezierTo(50.8, 14.5, 51.2, 20.4);
      s.ink(stripeBQ, width: 1.7, amp: 0.2, color: _accRed);
      final maneQ = Path()
        ..moveTo(43.5, 50.8)
        ..lineTo(45.8, 56.5)
        ..lineTo(48.2, 51.8)
        ..lineTo(50.6, 57.2)
        ..lineTo(53, 51.8)
        ..lineTo(55.4, 57)
        ..lineTo(57.8, 51.4)
        ..lineTo(60.2, 56.2)
        ..lineTo(61.5, 50.2)
        ..quadraticBezierTo(52.5, 54.6, 43.5, 50.8)
        ..close();
      s.fillArea(maneQ, _accGi, amp: 0.35);
      s.ink(maneQ, width: 1.5, amp: 0.35);
    case DogAccessory.orangeGi:
      final hairQ = Path()
        ..moveTo(38, 25)
        ..lineTo(40.5, 13.5)
        ..lineTo(44, 19)
        ..lineTo(46.8, 5.5)
        ..lineTo(50.6, 15)
        ..lineTo(54, 2.5)
        ..lineTo(57.2, 14.5)
        ..lineTo(61.2, 5)
        ..lineTo(63.6, 17.5)
        ..lineTo(66.8, 11)
        ..lineTo(68.5, 24)
        ..quadraticBezierTo(60, 19.5, 53, 19.6)
        ..quadraticBezierTo(45, 20, 38, 25)
        ..close();
      s.fillArea(hairQ, Inks.sun, amp: 0.3);
      s.ink(hairQ, width: 1.7, amp: 0.3);
      final strandAQ = Path()
        ..moveTo(48.5, 19.4)
        ..lineTo(50.6, 11);
      s.ink(strandAQ, width: 1.0, amp: 0.25, color: _accTanDeep);
      final strandBQ = Path()
        ..moveTo(59, 19.2)
        ..lineTo(60.4, 11.5);
      s.ink(strandBQ, width: 1.0, amp: 0.25, color: _accTanDeep);
      final giQ = Path()
        ..moveTo(46, 50.5)
        ..quadraticBezierTo(53, 54.2, 60.5, 50)
        ..lineTo(60.8, 62.5)
        ..quadraticBezierTo(53, 66, 45.8, 62.5)
        ..close();
      s.fillArea(giQ, _accGi, amp: 0.35);
      s.ink(giQ, width: 1.7, amp: 0.35);
      final giTrimQ = Path()
        ..moveTo(46.6, 51.8)
        ..quadraticBezierTo(53, 55.4, 60, 51.2);
      s.ink(giTrimQ, width: 1.5, amp: 0.25, color: _accGiBlue);
      final sashQ = Path()
        ..moveTo(47, 61)
        ..quadraticBezierTo(53, 64, 59.5, 60.8)
        ..lineTo(59.1, 64.4)
        ..quadraticBezierTo(53, 67.4, 47.4, 64.6)
        ..close();
      s.fillArea(sashQ, _accGiBlue, amp: 0.3);
      s.ink(sashQ, width: 1.5, amp: 0.3);
      s.dot(const Offset(53.2, 64.8), 1.1, color: Inks.cream);
      _auraBolt(s, const Offset(28, 66), 1.05, -1);
      _auraBolt(s, const Offset(73, 64), 1.0, 1);
      _auraBolt(s, const Offset(34, 50), 0.7, -1);
    case DogAccessory.pirateCaptain:
      _brimHat(
        s,
        const Offset(54.5, 15.5),
        1.0,
        0.05,
        top: _accNavy,
        band: Inks.sun,
        brimW: 30,
      );
      final vestL = Path()
        ..moveTo(46, 51)
        ..quadraticBezierTo(43.5, 54, 43.2, 58.5)
        ..lineTo(44, 65.5)
        ..quadraticBezierTo(47.5, 64, 49.6, 60.8)
        ..lineTo(49.8, 53.8)
        ..close();
      s.fillArea(vestL, _accNavy, amp: 0.35);
      s.ink(vestL, width: 1.6, amp: 0.35);
      final vestR = Path()
        ..moveTo(59.5, 50.6)
        ..quadraticBezierTo(62.5, 53.4, 63.2, 58)
        ..lineTo(62.4, 65.6)
        ..quadraticBezierTo(58.8, 64.2, 56.8, 60.6)
        ..lineTo(56.6, 53.4)
        ..close();
      s.fillArea(vestR, _accNavy, amp: 0.35);
      s.ink(vestR, width: 1.6, amp: 0.35);
  }
}

void _accessoryProfile(Sketch s, DogAccessory acc, Offset headC) {
  switch (acc) {
    case DogAccessory.none:
      break;
    case DogAccessory.bandana:
      final tri = Path()
        ..moveTo(headC.dx - 9, headC.dy + 6.5)
        ..lineTo(headC.dx + 3, headC.dy + 8.5)
        ..quadraticBezierTo(
          headC.dx - 1,
          headC.dy + 12,
          headC.dx - 3.5,
          headC.dy + 16,
        )
        ..quadraticBezierTo(
          headC.dx - 7,
          headC.dy + 11,
          headC.dx - 9,
          headC.dy + 6.5,
        )
        ..close();
      s.fillArea(tri, _accRed, amp: 0.35);
      s.ink(tri, width: 1.7, amp: 0.35);
      s.dot(Offset(headC.dx - 4, headC.dy + 10.5), 0.85, color: Inks.cream);
    case DogAccessory.cap:
      final dome = Path()
        ..moveTo(headC.dx - 8.5, headC.dy - 7.5)
        ..quadraticBezierTo(
          headC.dx - 7,
          headC.dy - 15.5,
          headC.dx + 0.5,
          headC.dy - 15,
        )
        ..quadraticBezierTo(
          headC.dx + 6.5,
          headC.dy - 14,
          headC.dx + 7,
          headC.dy - 8.5,
        )
        ..close();
      s.fillArea(dome, _accSky, amp: 0.35);
      s.ink(dome, width: 1.9, amp: 0.35);
      final brim = Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset(headC.dx + 10.5, headC.dy - 9.5),
            width: 11,
            height: 3.6,
          ),
        );
      s.fillArea(brim, const Color(0xFF5B7FA6), amp: 0.3);
      s.ink(brim, width: 1.6, amp: 0.3);
      s.dot(Offset(headC.dx + 0.5, headC.dy - 15), 1.2);
    case DogAccessory.bow:
      _bow(s, Offset(headC.dx - 4, headC.dy - 11.5), 0.9);
    case DogAccessory.scarf:
      final band = Path()
        ..moveTo(headC.dx - 9.5, headC.dy + 6)
        ..quadraticBezierTo(
          headC.dx - 3,
          headC.dy + 9.5,
          headC.dx + 3,
          headC.dy + 8,
        )
        ..lineTo(headC.dx + 2, headC.dy + 12)
        ..quadraticBezierTo(
          headC.dx - 4,
          headC.dy + 13.5,
          headC.dx - 10,
          headC.dy + 10.5,
        )
        ..close();
      s.fillArea(band, Inks.sun, amp: 0.35);
      s.ink(band, width: 1.7, amp: 0.35);
      final flap = Path()
        ..moveTo(headC.dx - 6, headC.dy + 12.5)
        ..quadraticBezierTo(
          headC.dx - 4,
          headC.dy + 18,
          headC.dx - 6.5,
          headC.dy + 22,
        )
        ..quadraticBezierTo(
          headC.dx - 10,
          headC.dy + 20,
          headC.dx - 9.5,
          headC.dy + 12.5,
        )
        ..close();
      s.fillArea(flap, Inks.sun, amp: 0.35);
      s.ink(flap, width: 1.6, amp: 0.35);
    case DogAccessory.specs:
      s.ring(Offset(headC.dx + 3.5, headC.dy - 3.2), 3.9, width: 1.8);
      s.strokeLine(
        Offset(headC.dx - 0.4, headC.dy - 3.6),
        Offset(headC.dx - 8, headC.dy - 5),
        width: 1.4,
      );
    case DogAccessory.flower:
      _flower(s, Offset(headC.dx - 5.5, headC.dy - 10), 0.9);
    case DogAccessory.beret:
      _beret(s, Offset(headC.dx - 2, headC.dy - 10), 0.85, -0.18);
    case DogAccessory.partyHat:
      _partyHat(s, Offset(headC.dx - 1, headC.dy - 9.8), 0.85, -0.12);
    case DogAccessory.crown:
      _crown(s, Offset(headC.dx - 1, headC.dy - 9.8), 0.9, -0.08);
    case DogAccessory.beanie:
      _beanie(s, Offset(headC.dx - 1, headC.dy - 7.5), 0.85, -0.1);
    case DogAccessory.cowboyHat:
      _brimHat(
        s,
        Offset(headC.dx - 1, headC.dy - 9.5),
        0.85,
        -0.08,
        top: _accTan,
        band: _accTanDeep,
        brimW: 26,
      );
    case DogAccessory.strawHat:
      _brimHat(
        s,
        Offset(headC.dx - 1, headC.dy - 9.5),
        0.85,
        -0.08,
        top: Inks.sun,
        band: Inks.leaf,
        brimW: 30,
      );
    case DogAccessory.halo:
      _halo(s, Offset(headC.dx, headC.dy - 17.5), 0.85);
    case DogAccessory.sunglasses:
      _shadeLens(s, Offset(headC.dx + 3.5, headC.dy - 3.2), 0.9);
      s.strokeLine(
        Offset(headC.dx - 0.5, headC.dy - 3.8),
        Offset(headC.dx - 8, headC.dy - 5.2),
        width: 1.4,
      );
    case DogAccessory.heartShades:
      _heartLens(s, Offset(headC.dx + 3.5, headC.dy - 3.2), 0.9);
      s.strokeLine(
        Offset(headC.dx - 1.4, headC.dy - 3.8),
        Offset(headC.dx - 8, headC.dy - 5.2),
        width: 1.4,
      );
    case DogAccessory.monocle:
      s.ring(Offset(headC.dx + 3.5, headC.dy - 3.2), 3.9, width: 3.0);
      s.ring(
        Offset(headC.dx + 3.5, headC.dy - 3.2),
        3.9,
        width: 1.6,
        color: Inks.sun,
      );
      s.curve(
        Offset(headC.dx + 3.2, headC.dy + 0.6),
        Offset(headC.dx + 6.5, headC.dy + 5),
        Offset(headC.dx + 5, headC.dy + 9.5),
        width: 1.1,
        amp: 0.4,
      );
      s.dot(Offset(headC.dx + 5, headC.dy + 10), 0.8, color: Inks.sun);
    case DogAccessory.bowtie:
      _bow(
        s,
        Offset(headC.dx - 1, headC.dy + 12),
        0.95,
        fill: Inks.ink,
        knot: _accKnotInk,
      );
    case DogAccessory.collar:
      final collarBand = Path()
        ..moveTo(headC.dx - 9.5, headC.dy + 6)
        ..quadraticBezierTo(
          headC.dx - 3,
          headC.dy + 9.5,
          headC.dx + 3,
          headC.dy + 8,
        )
        ..lineTo(headC.dx + 2.6, headC.dy + 10.6)
        ..quadraticBezierTo(
          headC.dx - 3,
          headC.dy + 12,
          headC.dx - 10,
          headC.dy + 8.8,
        )
        ..close();
      s.fillArea(collarBand, _accRed, amp: 0.3);
      s.ink(collarBand, width: 1.6, amp: 0.3);
      s.dot(Offset(headC.dx - 3.2, headC.dy + 13), 1.5, color: Inks.sun);
      s.ring(Offset(headC.dx - 3.2, headC.dy + 13), 1.5, width: 1.1, amp: 0.2);
    case DogAccessory.lei:
      final leiSpots = [
        Offset(headC.dx - 9.5, headC.dy + 6.2),
        Offset(headC.dx - 6.5, headC.dy + 9),
        Offset(headC.dx - 3, headC.dy + 10.6),
        Offset(headC.dx + 0.6, headC.dy + 10.2),
        Offset(headC.dx + 3.4, headC.dy + 8.4),
      ];
      for (var i = 0; i < leiSpots.length; i++) {
        _leiFlower(s, leiSpots[i], 0.85, _leiColors[i % 3]);
      }
    case DogAccessory.cape:
      final cloak = Path()
        ..moveTo(headC.dx - 7.5, headC.dy + 8)
        ..quadraticBezierTo(
          headC.dx - 18,
          headC.dy + 2,
          headC.dx - 30,
          headC.dy + 3.5,
        )
        ..quadraticBezierTo(
          headC.dx - 36.5,
          headC.dy + 12,
          headC.dx - 32,
          headC.dy + 25,
        )
        ..quadraticBezierTo(
          headC.dx - 27.5,
          headC.dy + 26,
          headC.dx - 22,
          headC.dy + 21,
        )
        ..quadraticBezierTo(
          headC.dx - 13.5,
          headC.dy + 20,
          headC.dx - 6.5,
          headC.dy + 13.5,
        )
        ..close();
      s.fillArea(cloak, _accRed, amp: 0.45);
      s.ink(cloak, width: 1.8, amp: 0.45);
      s.dot(Offset(headC.dx - 5, headC.dy + 11), 1.5, color: Inks.sun);
      s.ring(Offset(headC.dx - 5, headC.dy + 11), 1.5, width: 1.1, amp: 0.2);
    case DogAccessory.backpack:
      final pack = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(headC.dx - 17, headC.dy + 10),
              width: 11,
              height: 12.5,
            ),
            const Radius.circular(3.6),
          ),
        );
      s.fillArea(pack, _accSky, amp: 0.3);
      s.ink(pack, width: 1.8, amp: 0.3);
      s.strokeLine(
        Offset(headC.dx - 21.5, headC.dy + 6.5),
        Offset(headC.dx - 12.5, headC.dy + 6.5),
        width: 1.3,
        amp: 0.3,
      );
      s.dot(Offset(headC.dx - 17, headC.dy + 12), 1.3, color: Inks.cream);
      final strap = Path()
        ..moveTo(headC.dx - 13, headC.dy + 5.5)
        ..quadraticBezierTo(
          headC.dx - 3,
          headC.dy + 6,
          headC.dx - 4,
          headC.dy + 14.5,
        );
      s.ink(strap, width: 1.6, amp: 0.3, color: _accSky);
      s.ink(strap, width: 0.7, amp: 0.3, color: Inks.inkSoft);
    case DogAccessory.beeFriend:
      _bee(s, Offset(headC.dx - 16, headC.dy - 15), 1.25);
    case DogAccessory.raggedCloak:
      final cloakCloakP = Path()
        ..moveTo(headC.dx - 7.5, headC.dy + 8)
        ..quadraticBezierTo(
          headC.dx - 18,
          headC.dy + 2,
          headC.dx - 30,
          headC.dy + 3.5,
        )
        ..quadraticBezierTo(
          headC.dx - 36.5,
          headC.dy + 12,
          headC.dx - 32,
          headC.dy + 25,
        )
        ..lineTo(headC.dx - 28.5, headC.dy + 21)
        ..lineTo(headC.dx - 25.5, headC.dy + 25.5)
        ..lineTo(headC.dx - 22, headC.dy + 21)
        ..quadraticBezierTo(
          headC.dx - 13.5,
          headC.dy + 20,
          headC.dx - 6.5,
          headC.dy + 13.5,
        )
        ..close();
      s.fillArea(cloakCloakP, _accCloth, amp: 0.45);
      s.ink(cloakCloakP, width: 1.8, amp: 0.45);
      final cloakHemP = Path()
        ..moveTo(headC.dx - 35, headC.dy + 13)
        ..quadraticBezierTo(
          headC.dx - 36,
          headC.dy + 19,
          headC.dx - 32.5,
          headC.dy + 24,
        );
      s.ink(cloakHemP, width: 1.2, amp: 0.3, color: Inks.sun);
      _sword(
        s,
        Offset(headC.dx - 3, headC.dy + 6),
        Offset(headC.dx - 32, headC.dy - 12),
        2.8,
        blade: _accCloth,
      );
      final cloakBandP = Path()
        ..moveTo(headC.dx - 8.5, headC.dy - 6.8)
        ..quadraticBezierTo(
          headC.dx - 1,
          headC.dy - 9.2,
          headC.dx + 6.5,
          headC.dy - 7,
        )
        ..lineTo(headC.dx + 6.2, headC.dy - 4.4)
        ..quadraticBezierTo(
          headC.dx - 1,
          headC.dy - 6.6,
          headC.dx - 8.2,
          headC.dy - 4.2,
        )
        ..close();
      s.fillArea(cloakBandP, _accCloth, amp: 0.3);
      s.ink(cloakBandP, width: 1.5, amp: 0.3);
      s.dot(Offset(headC.dx - 1, headC.dy - 8.1), 0.65, color: Inks.sun);
      s.dot(Offset(headC.dx - 2, headC.dy - 7), 0.65, color: Inks.sun);
      s.dot(Offset(headC.dx, headC.dy - 7), 0.65, color: Inks.sun);
      s.dot(Offset(headC.dx - 1, headC.dy - 5.9), 0.65, color: Inks.sun);
    case DogAccessory.crimsonScarf:
      final scarfBandP = Path()
        ..moveTo(headC.dx - 9.5, headC.dy + 6)
        ..quadraticBezierTo(
          headC.dx - 1,
          headC.dy + 10.5,
          headC.dx + 7,
          headC.dy + 7,
        )
        ..lineTo(headC.dx + 6.6, headC.dy + 11)
        ..quadraticBezierTo(
          headC.dx - 1,
          headC.dy + 14.5,
          headC.dx - 9,
          headC.dy + 10.5,
        )
        ..close();
      s.fillArea(scarfBandP, _accRed, amp: 0.4);
      s.ink(scarfBandP, width: 1.7, amp: 0.4);
      final scarfTailP = Path()
        ..moveTo(headC.dx - 8.5, headC.dy + 8)
        ..quadraticBezierTo(
          headC.dx - 16,
          headC.dy + 4,
          headC.dx - 22.5,
          headC.dy + 7.5,
        )
        ..lineTo(headC.dx - 20, headC.dy + 9)
        ..lineTo(headC.dx - 22, headC.dy + 11.5)
        ..quadraticBezierTo(
          headC.dx - 15,
          headC.dy + 11.5,
          headC.dx - 8.5,
          headC.dy + 11.5,
        )
        ..close();
      s.fillArea(scarfTailP, _accRed, amp: 0.4);
      s.ink(scarfTailP, width: 1.6, amp: 0.4);
      final scarfJacketP = Path()
        ..moveTo(headC.dx + 1.5, headC.dy + 12)
        ..quadraticBezierTo(
          headC.dx + 7,
          headC.dy + 13,
          headC.dx + 9,
          headC.dy + 15.5,
        )
        ..lineTo(headC.dx + 8.2, headC.dy + 20.5)
        ..quadraticBezierTo(
          headC.dx + 3,
          headC.dy + 21.5,
          headC.dx + 0.5,
          headC.dy + 19,
        )
        ..close();
      s.fillArea(scarfJacketP, _accSteel, amp: 0.3);
      s.ink(scarfJacketP, width: 1.5, amp: 0.3);
      s.dot(Offset(headC.dx + 4.6, headC.dy + 16.6), 0.75, color: Inks.cream);
      s.dot(Offset(headC.dx + 4.4, headC.dy + 19), 0.75, color: Inks.cream);
    case DogAccessory.ghoulMask:
      _tendril(s, Offset(headC.dx - 29, headC.dy + 12), 1.1, -1);
      _tendril(s, Offset(headC.dx - 23, headC.dy + 15), 0.95, -1);
      _tendril(s, Offset(headC.dx - 17, headC.dy + 14), 0.8, -1);
      _tendril(s, Offset(headC.dx - 33, headC.dy + 17), 0.7, -1);
      final maskStrapP = Path()
        ..moveTo(headC.dx + 7, headC.dy + 0.2)
        ..lineTo(headC.dx - 7.5, headC.dy - 5);
      s.ink(maskStrapP, width: 1.3, amp: 0.2);
      final ghoulMaskP = Path()
        ..moveTo(headC.dx + 7.5, headC.dy + 0.5)
        ..quadraticBezierTo(
          headC.dx + 13,
          headC.dy - 1,
          headC.dx + 16.8,
          headC.dy + 1,
        )
        ..quadraticBezierTo(
          headC.dx + 17.5,
          headC.dy + 4.5,
          headC.dx + 12,
          headC.dy + 6.8,
        )
        ..quadraticBezierTo(
          headC.dx + 7,
          headC.dy + 4.5,
          headC.dx + 7.5,
          headC.dy + 0.5,
        )
        ..close();
      s.fillArea(ghoulMaskP, _accCloth, amp: 0.3);
      s.ink(ghoulMaskP, width: 1.6, amp: 0.3);
      final grinP = Path()..moveTo(headC.dx + 9, headC.dy + 3);
      for (var i = 1; i <= 4; i++) {
        grinP.lineTo(headC.dx + 9 + i * 1.9, headC.dy + (i.isOdd ? 4.6 : 2.8));
      }
      s.ink(grinP, width: 1.2, amp: 0.15, color: Inks.cream);
      final patchP = Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(headC.dx + 3.5, headC.dy - 3.2),
            radius: 3.6,
          ),
        );
      s.fillArea(patchP, Inks.ink, amp: 0.2);
      s.ink(patchP, width: 1.4, amp: 0.2);
    case DogAccessory.asceticBlaze:
      final hoodP = Path()
        ..moveTo(headC.dx + 6, headC.dy - 13.5)
        ..quadraticBezierTo(
          headC.dx - 2,
          headC.dy - 17.5,
          headC.dx - 9.5,
          headC.dy - 13,
        )
        ..quadraticBezierTo(
          headC.dx - 14.5,
          headC.dy - 7,
          headC.dx - 12.5,
          headC.dy + 2,
        )
        ..quadraticBezierTo(
          headC.dx - 11,
          headC.dy + 7,
          headC.dx - 6,
          headC.dy + 10,
        )
        ..quadraticBezierTo(
          headC.dx - 9.5,
          headC.dy + 5,
          headC.dx - 10.2,
          headC.dy - 1,
        )
        ..quadraticBezierTo(
          headC.dx - 10.8,
          headC.dy - 8,
          headC.dx - 5.5,
          headC.dy - 12.4,
        )
        ..quadraticBezierTo(
          headC.dx + 1,
          headC.dy - 15,
          headC.dx + 6,
          headC.dy - 11.2,
        )
        ..close();
      s.fillArea(hoodP, _accCloth, amp: 0.35);
      s.ink(hoodP, width: 1.7, amp: 0.35);
      final rimP = Path()
        ..moveTo(headC.dx + 5.4, headC.dy - 12)
        ..quadraticBezierTo(
          headC.dx - 1,
          headC.dy - 14.6,
          headC.dx - 6.2,
          headC.dy - 11.6,
        )
        ..quadraticBezierTo(
          headC.dx - 10,
          headC.dy - 7,
          headC.dx - 9.4,
          headC.dy,
        );
      s.ink(rimP, width: 1.1, amp: 0.25, color: _accRed);
      _flameTongue(s, Offset(headC.dx - 18, headC.dy + 6), 0.95, -0.3);
      _flameTongue(s, Offset(headC.dx - 27, headC.dy + 11), 0.8, -0.35);
      _flameTongue(s, Offset(headC.dx + 7, headC.dy + 14), 0.6, 0.2);
      _flameTongue(s, Offset(headC.dx - 34, headC.dy + 17), 0.7, -0.3);
      _flameTongue(s, Offset(headC.dx - 10, headC.dy + 2), 0.65, -0.2);
      _bloodDrop(s, Offset(headC.dx + 13.5, headC.dy - 11), 0.85);
      _bloodDrop(s, Offset(headC.dx - 19, headC.dy - 7.5), 0.9);
      _bloodDrop(s, Offset(headC.dx - 36, headC.dy + 6), 0.8);
      _bloodDrop(s, Offset(headC.dx + 15, headC.dy + 9), 0.75);
    case DogAccessory.blindfold:
      final blindP = Path()
        ..moveTo(headC.dx + 9.5, headC.dy - 5.6)
        ..quadraticBezierTo(
          headC.dx + 2,
          headC.dy - 8.2,
          headC.dx - 7.5,
          headC.dy - 7.6,
        )
        ..lineTo(headC.dx - 8, headC.dy - 2.8)
        ..quadraticBezierTo(
          headC.dx + 2,
          headC.dy - 3.2,
          headC.dx + 9.2,
          headC.dy - 1.2,
        )
        ..close();
      s.fillArea(blindP, Inks.ink, amp: 0.3);
      s.ink(blindP, width: 1.6, amp: 0.3);
      s.dot(Offset(headC.dx - 8.4, headC.dy - 5), 1.3);
      final tailA = Path()
        ..moveTo(headC.dx - 9, headC.dy - 4.6)
        ..quadraticBezierTo(
          headC.dx - 12.5,
          headC.dy - 2,
          headC.dx - 13.5,
          headC.dy + 1.5,
        );
      s.ink(tailA, width: 1.9, amp: 0.35);
      final tailB = Path()
        ..moveTo(headC.dx - 9, headC.dy - 4.2)
        ..quadraticBezierTo(
          headC.dx - 10.5,
          headC.dy - 0.5,
          headC.dx - 12,
          headC.dy + 3.5,
        );
      s.ink(tailB, width: 1.9, amp: 0.35);
      final blindCollarP = Path()
        ..moveTo(headC.dx - 7, headC.dy + 6.5)
        ..lineTo(headC.dx - 5, headC.dy + 3.5)
        ..lineTo(headC.dx - 2.5, headC.dy + 7.5)
        ..quadraticBezierTo(
          headC.dx + 1,
          headC.dy + 9,
          headC.dx + 4,
          headC.dy + 8,
        )
        ..lineTo(headC.dx + 3.6, headC.dy + 11.5)
        ..quadraticBezierTo(
          headC.dx - 2,
          headC.dy + 12.5,
          headC.dx - 7.2,
          headC.dy + 10.5,
        )
        ..close();
      s.fillArea(blindCollarP, Inks.ink, amp: 0.3);
      s.ink(blindCollarP, width: 1.5, amp: 0.3);
      s.dot(Offset(headC.dx + 13, headC.dy - 13), 1.5, color: _accRed);
      s.ring(
        Offset(headC.dx + 13, headC.dy - 13),
        2.5,
        width: 1.0,
        color: _accRed,
      );
      s.dot(Offset(headC.dx + 17, headC.dy - 7), 1.5, color: _accSky);
      s.ring(
        Offset(headC.dx + 17, headC.dy - 7),
        2.5,
        width: 1.0,
        color: _accSky,
      );
    case DogAccessory.duelistCoat:
      final coatP = Path()
        ..moveTo(headC.dx - 7.5, headC.dy + 8)
        ..quadraticBezierTo(
          headC.dx - 18,
          headC.dy + 2,
          headC.dx - 30,
          headC.dy + 3.5,
        )
        ..quadraticBezierTo(
          headC.dx - 36.5,
          headC.dy + 12,
          headC.dx - 32,
          headC.dy + 25,
        )
        ..quadraticBezierTo(
          headC.dx - 27.5,
          headC.dy + 26,
          headC.dx - 22,
          headC.dy + 21,
        )
        ..quadraticBezierTo(
          headC.dx - 13.5,
          headC.dy + 20,
          headC.dx - 6.5,
          headC.dy + 13.5,
        )
        ..close();
      s.fillArea(coatP, Inks.ink, amp: 0.45);
      s.ink(coatP, width: 1.8, amp: 0.45);
      final trimP = Path()
        ..moveTo(headC.dx - 35, headC.dy + 13)
        ..quadraticBezierTo(
          headC.dx - 36,
          headC.dy + 19,
          headC.dx - 32.5,
          headC.dy + 24,
        );
      s.ink(trimP, width: 1.0, amp: 0.3, color: _accSteel);
      _sword(
        s,
        Offset(headC.dx - 5, headC.dy + 3),
        Offset(headC.dx - 28, headC.dy - 13),
        1.8,
      );
      _sword(
        s,
        Offset(headC.dx - 2, headC.dy + 6),
        Offset(headC.dx - 30, headC.dy - 4),
        1.7,
        blade: _accTeal,
      );
    case DogAccessory.shadowWisps:
      final mantleP = Path()
        ..moveTo(headC.dx - 7.5, headC.dy + 8)
        ..quadraticBezierTo(
          headC.dx - 18,
          headC.dy + 2,
          headC.dx - 30,
          headC.dy + 3.5,
        )
        ..quadraticBezierTo(
          headC.dx - 36.5,
          headC.dy + 12,
          headC.dx - 32,
          headC.dy + 25,
        )
        ..quadraticBezierTo(
          headC.dx - 27.5,
          headC.dy + 26,
          headC.dx - 22,
          headC.dy + 21,
        )
        ..quadraticBezierTo(
          headC.dx - 13.5,
          headC.dy + 20,
          headC.dx - 6.5,
          headC.dy + 13.5,
        )
        ..close();
      s.fillArea(mantleP, Inks.ink, amp: 0.45);
      s.ink(mantleP, width: 1.8, amp: 0.45);
      final hemP = Path()
        ..moveTo(headC.dx - 35, headC.dy + 13)
        ..quadraticBezierTo(
          headC.dx - 36,
          headC.dy + 19,
          headC.dx - 32.5,
          headC.dy + 24,
        );
      s.ink(hemP, width: 1.2, amp: 0.3, color: _accShadow);
      _shadowWisp(s, Offset(headC.dx - 13, headC.dy - 2), 0.85, -0.5);
      _shadowWisp(s, Offset(headC.dx - 23, headC.dy + 2), 1.0, -0.8);
      _shadowWisp(s, Offset(headC.dx - 31, headC.dy + 9), 0.8, -0.5);
      s.dot(Offset(headC.dx + 6.3, headC.dy - 6), 0.9, color: _accShadow);
    case DogAccessory.hornedMask:
      final skullP = Path()
        ..moveTo(headC.dx - 8.8, headC.dy - 7.5)
        ..quadraticBezierTo(
          headC.dx - 7,
          headC.dy - 15,
          headC.dx + 0.5,
          headC.dy - 14.6,
        )
        ..quadraticBezierTo(
          headC.dx + 6.5,
          headC.dy - 13.6,
          headC.dx + 7,
          headC.dy - 8,
        )
        ..quadraticBezierTo(
          headC.dx + 2,
          headC.dy - 10.6,
          headC.dx - 3,
          headC.dy - 10.4,
        )
        ..quadraticBezierTo(
          headC.dx - 6.5,
          headC.dy - 10,
          headC.dx - 8.8,
          headC.dy - 7.5,
        )
        ..close();
      s.fillArea(skullP, Inks.cream, amp: 0.3);
      s.ink(skullP, width: 1.7, amp: 0.3);
      final cheekP = Path()
        ..moveTo(headC.dx - 8.5, headC.dy - 7.8)
        ..quadraticBezierTo(
          headC.dx - 10.5,
          headC.dy - 2,
          headC.dx - 8,
          headC.dy + 3.5,
        )
        ..quadraticBezierTo(
          headC.dx - 4.5,
          headC.dy + 6.5,
          headC.dx - 0.5,
          headC.dy + 6.8,
        )
        ..quadraticBezierTo(
          headC.dx - 4,
          headC.dy + 2,
          headC.dx - 4.4,
          headC.dy - 3.5,
        )
        ..quadraticBezierTo(
          headC.dx - 6,
          headC.dy - 6.5,
          headC.dx - 8.5,
          headC.dy - 7.8,
        )
        ..close();
      s.fillArea(cheekP, Inks.cream, amp: 0.3);
      s.ink(cheekP, width: 1.5, amp: 0.3);
      final jawP = Path()
        ..moveTo(headC.dx + 7, headC.dy + 0.2)
        ..quadraticBezierTo(
          headC.dx + 12.5,
          headC.dy - 1.2,
          headC.dx + 17,
          headC.dy + 1,
        )
        ..lineTo(headC.dx + 16.4, headC.dy + 5)
        ..quadraticBezierTo(
          headC.dx + 12,
          headC.dy + 7.4,
          headC.dx + 7.2,
          headC.dy + 5.2,
        )
        ..close();
      s.fillArea(jawP, Inks.cream, amp: 0.25);
      s.ink(jawP, width: 1.5, amp: 0.25);
      for (final dx in const [9.4, 11.8, 14.2]) {
        final toothP = Path()
          ..moveTo(headC.dx + dx, headC.dy - 0.4)
          ..lineTo(headC.dx + dx, headC.dy + 6);
        s.ink(toothP, width: 1.0, amp: 0.15);
      }
      final stripeAP = Path()
        ..moveTo(headC.dx + 1.2, headC.dy - 14.2)
        ..lineTo(headC.dx + 1.5, headC.dy - 10.8);
      s.ink(stripeAP, width: 1.5, amp: 0.2, color: _accRed);
      final stripeBP = Path()
        ..moveTo(headC.dx + 3.8, headC.dy - 13.6)
        ..lineTo(headC.dx + 4.1, headC.dy - 10.4);
      s.ink(stripeBP, width: 1.5, amp: 0.2, color: _accRed);
      _curvedHorn(s, Offset(headC.dx - 6, headC.dy - 13.5), 1, 1.35);
      _curvedHorn(s, Offset(headC.dx - 9.5, headC.dy - 10.5), 1, 1.05);
      final maneP = Path()
        ..moveTo(headC.dx - 8, headC.dy + 2)
        ..lineTo(headC.dx - 12.5, headC.dy + 3.5)
        ..lineTo(headC.dx - 9, headC.dy + 5.5)
        ..lineTo(headC.dx - 13.5, headC.dy + 8)
        ..lineTo(headC.dx - 9.5, headC.dy + 9.5)
        ..quadraticBezierTo(
          headC.dx - 8,
          headC.dy + 6,
          headC.dx - 8,
          headC.dy + 2,
        )
        ..close();
      s.fillArea(maneP, _accGi, amp: 0.35);
      s.ink(maneP, width: 1.4, amp: 0.35);
    case DogAccessory.orangeGi:
      final hairP = Path()
        ..moveTo(headC.dx + 7, headC.dy - 8)
        ..lineTo(headC.dx + 4, headC.dy - 16.5)
        ..lineTo(headC.dx + 0.5, headC.dy - 12.5)
        ..lineTo(headC.dx - 3.5, headC.dy - 19.5)
        ..lineTo(headC.dx - 6, headC.dy - 12.8)
        ..lineTo(headC.dx - 11.5, headC.dy - 17)
        ..lineTo(headC.dx - 10.5, headC.dy - 10)
        ..lineTo(headC.dx - 16, headC.dy - 11.5)
        ..lineTo(headC.dx - 11.5, headC.dy - 5.5)
        ..quadraticBezierTo(
          headC.dx - 4,
          headC.dy - 11.5,
          headC.dx + 7,
          headC.dy - 8,
        )
        ..close();
      s.fillArea(hairP, Inks.sun, amp: 0.3);
      s.ink(hairP, width: 1.6, amp: 0.3);
      final strandP = Path()
        ..moveTo(headC.dx - 2, headC.dy - 12)
        ..lineTo(headC.dx - 4, headC.dy - 16.5);
      s.ink(strandP, width: 1.0, amp: 0.25, color: _accTanDeep);
      final giP = Path()
        ..moveTo(headC.dx + 0.5, headC.dy + 8)
        ..quadraticBezierTo(
          headC.dx + 7,
          headC.dy + 9,
          headC.dx + 9.5,
          headC.dy + 12,
        )
        ..lineTo(headC.dx + 8.6, headC.dy + 19.5)
        ..quadraticBezierTo(
          headC.dx + 3,
          headC.dy + 20.5,
          headC.dx - 1.5,
          headC.dy + 18,
        )
        ..close();
      s.fillArea(giP, _accGi, amp: 0.35);
      s.ink(giP, width: 1.6, amp: 0.35);
      final sashP = Path()
        ..moveTo(headC.dx - 1.2, headC.dy + 16.6)
        ..quadraticBezierTo(
          headC.dx + 4,
          headC.dy + 18.6,
          headC.dx + 8.8,
          headC.dy + 17.2,
        )
        ..lineTo(headC.dx + 8.4, headC.dy + 19.8)
        ..quadraticBezierTo(
          headC.dx + 3.5,
          headC.dy + 21,
          headC.dx - 1.5,
          headC.dy + 19,
        )
        ..close();
      s.fillArea(sashP, _accGiBlue, amp: 0.3);
      s.ink(sashP, width: 1.4, amp: 0.3);
      s.dot(Offset(headC.dx + 3.8, headC.dy + 19.6), 1.0, color: Inks.cream);
      _auraBolt(s, Offset(headC.dx - 14, headC.dy - 3), 0.9, -1);
      _auraBolt(s, Offset(headC.dx - 26, headC.dy + 2), 1.0, -1);
      _auraBolt(s, Offset(headC.dx - 33, headC.dy + 12), 0.75, -1);
      _auraBolt(s, Offset(headC.dx + 12, headC.dy + 6), 0.7, 1);
    case DogAccessory.pirateCaptain:
      _brimHat(
        s,
        Offset(headC.dx - 1, headC.dy - 9.5),
        0.85,
        -0.08,
        top: _accNavy,
        band: Inks.sun,
        brimW: 30,
      );
      final vestP = Path()
        ..moveTo(headC.dx + 0.5, headC.dy + 7.5)
        ..quadraticBezierTo(
          headC.dx + 6.5,
          headC.dy + 8.5,
          headC.dx + 9,
          headC.dy + 11.5,
        )
        ..lineTo(headC.dx + 8, headC.dy + 19)
        ..quadraticBezierTo(
          headC.dx + 2.5,
          headC.dy + 20,
          headC.dx - 2,
          headC.dy + 17.5,
        )
        ..close();
      s.fillArea(vestP, _accNavy, amp: 0.35);
      s.ink(vestP, width: 1.6, amp: 0.35);
  }
}

void _sword(
  Sketch s,
  Offset hilt,
  Offset tip,
  double w, {
  Color blade = _accBlade,
}) {
  final vx = tip.dx - hilt.dx;
  final vy = tip.dy - hilt.dy;
  final len = math.sqrt(vx * vx + vy * vy);
  final nx = -vy / len * w;
  final ny = vx / len * w;
  final bx = hilt.dx + vx * 0.22;
  final by = hilt.dy + vy * 0.22;
  final body = Path()
    ..moveTo(bx + nx, by + ny)
    ..lineTo(tip.dx + nx * 0.3 - vx / len * 2, tip.dy + ny * 0.3 - vy / len * 2)
    ..lineTo(tip.dx, tip.dy)
    ..lineTo(tip.dx - nx * 0.3 - vx / len * 2, tip.dy - ny * 0.3 - vy / len * 2)
    ..lineTo(bx - nx, by - ny)
    ..close();
  s.fillArea(body, blade, amp: 0.25);
  s.ink(body, width: 1.5, amp: 0.25);
  final guard = Path()
    ..moveTo(bx + nx * 1.8, by + ny * 1.8)
    ..lineTo(bx - nx * 1.8, by - ny * 1.8);
  s.ink(guard, width: 2.0, amp: 0.2);
  final grip = Path()
    ..moveTo(hilt.dx, hilt.dy)
    ..lineTo(bx, by);
  s.ink(grip, width: 2.2, amp: 0.2, color: _accKnotInk);
  s.dot(hilt, 1.2, color: Inks.sun);
}

void _flameTongue(Sketch s, Offset base, double k, double lean) {
  final flame = Path()
    ..moveTo(base.dx - 2.6 * k, base.dy)
    ..quadraticBezierTo(
      base.dx - 3.2 * k + lean * 2,
      base.dy - 4.5 * k,
      base.dx + lean * 5,
      base.dy - 8.5 * k,
    )
    ..quadraticBezierTo(
      base.dx + 3.2 * k + lean * 2,
      base.dy - 4.5 * k,
      base.dx + 2.6 * k,
      base.dy,
    )
    ..close();
  s.fillArea(flame, Inks.sun, amp: 0.4);
  s.ink(flame, width: 1.4, amp: 0.4);
  final core = Path()
    ..moveTo(base.dx - 1.2 * k, base.dy)
    ..quadraticBezierTo(
      base.dx - 1.4 * k + lean * 2,
      base.dy - 2.6 * k,
      base.dx + lean * 2.4,
      base.dy - 4.6 * k,
    )
    ..quadraticBezierTo(
      base.dx + 1.5 * k + lean,
      base.dy - 2.4 * k,
      base.dx + 1.2 * k,
      base.dy,
    )
    ..close();
  s.fillArea(core, _accRed, amp: 0.3);
}

void _bloodDrop(Sketch s, Offset at, double k) {
  final drop = Path()
    ..moveTo(at.dx, at.dy - 2.6 * k)
    ..quadraticBezierTo(
      at.dx + 1.9 * k,
      at.dy - 0.4 * k,
      at.dx + 1.5 * k,
      at.dy + 0.9 * k,
    )
    ..quadraticBezierTo(
      at.dx + 0.9 * k,
      at.dy + 2.2 * k,
      at.dx,
      at.dy + 2.2 * k,
    )
    ..quadraticBezierTo(
      at.dx - 1.7 * k,
      at.dy + 2.2 * k,
      at.dx - 1.5 * k,
      at.dy + 0.9 * k,
    )
    ..quadraticBezierTo(
      at.dx - 1.9 * k,
      at.dy - 0.4 * k,
      at.dx,
      at.dy - 2.6 * k,
    )
    ..close();
  s.fillArea(drop, _accBlood, amp: 0.25);
  s.ink(drop, width: 1.2, amp: 0.25);
}

void _shadowWisp(Sketch s, Offset base, double k, double sway) {
  final wisp = Path()
    ..moveTo(base.dx, base.dy)
    ..quadraticBezierTo(
      base.dx - 3 * k + sway,
      base.dy - 5 * k,
      base.dx + 1.2 * k + sway,
      base.dy - 10 * k,
    );
  s.ink(wisp, width: 2.4, amp: 0.5, color: _accShadow);
  s.ink(wisp, width: 1.1, amp: 0.5, color: _accShadowDeep);
  s.dot(
    Offset(base.dx + 1.6 * k + sway, base.dy - 12 * k),
    0.9,
    color: _accShadow,
  );
}

void _tendril(Sketch s, Offset base, double k, double dir) {
  final tendril = Path()
    ..moveTo(base.dx, base.dy)
    ..quadraticBezierTo(
      base.dx + dir * 6 * k,
      base.dy - 2 * k,
      base.dx + dir * 8 * k,
      base.dy - 8 * k,
    )
    ..quadraticBezierTo(
      base.dx + dir * 8.5 * k,
      base.dy - 12 * k,
      base.dx + dir * 5.5 * k,
      base.dy - 14 * k,
    );
  s.ink(tendril, width: 3.2, amp: 0.4, color: _accRed);
  s.ink(tendril, width: 1.4, amp: 0.4, color: _accBlood);
  s.dot(Offset(base.dx + dir * 5.5 * k, base.dy - 14 * k), 1.5, color: _accRed);
}

void _curvedHorn(Sketch s, Offset base, double dir, double k) {
  final horn = Path()
    ..moveTo(base.dx - dir * 1.5 * k, base.dy + 1.5 * k)
    ..quadraticBezierTo(
      base.dx + dir * 5 * k,
      base.dy - 3.5 * k,
      base.dx + dir * 11.5 * k,
      base.dy - 7 * k,
    )
    ..quadraticBezierTo(
      base.dx + dir * 7 * k,
      base.dy - 1.5 * k,
      base.dx + dir * 3.5 * k,
      base.dy + 3 * k,
    )
    ..close();
  s.fillArea(horn, Inks.cream, amp: 0.25);
  s.ink(horn, width: 1.7, amp: 0.25);
}

void _auraBolt(Sketch s, Offset base, double k, double dir) {
  final bolt = Path()
    ..moveTo(base.dx, base.dy)
    ..lineTo(base.dx + dir * 2.2 * k, base.dy - 4.5 * k)
    ..lineTo(base.dx - dir * 0.6 * k, base.dy - 7.5 * k)
    ..lineTo(base.dx + dir * 1.8 * k, base.dy - 12 * k);
  s.ink(bolt, width: 1.9, amp: 0.4, color: Inks.sun);
  s.dot(
    Offset(base.dx + dir * 1.8 * k, base.dy - 13 * k),
    0.8,
    color: Inks.sun,
  );
}

void _bow(
  Sketch s,
  Offset at,
  double k, {
  Color fill = Inks.rose,
  Color knot = const Color(0xFFC24463),
}) {
  final left = Path()
    ..moveTo(at.dx, at.dy)
    ..quadraticBezierTo(
      at.dx - 6 * k,
      at.dy - 4.5 * k,
      at.dx - 5.5 * k,
      at.dy + 1 * k,
    )
    ..quadraticBezierTo(at.dx - 5 * k, at.dy + 4 * k, at.dx, at.dy)
    ..close();
  final right = Path()
    ..moveTo(at.dx, at.dy)
    ..quadraticBezierTo(
      at.dx + 6 * k,
      at.dy - 4.5 * k,
      at.dx + 5.5 * k,
      at.dy + 1 * k,
    )
    ..quadraticBezierTo(at.dx + 5 * k, at.dy + 4 * k, at.dx, at.dy)
    ..close();
  s.fillArea(left, fill, amp: 0.3);
  s.fillArea(right, fill, amp: 0.3);
  s.ink(left, width: 1.6, amp: 0.3);
  s.ink(right, width: 1.6, amp: 0.3);
  s.dot(at, 1.7 * k, color: knot);
}

void _flower(Sketch s, Offset at, double k) {
  for (var i = 0; i < 5; i++) {
    s.dot(s.polar(at, i * 72.0 - 90, 3 * k), 1.7 * k, color: Inks.cream);
  }
  s.dot(at, 1.9 * k, color: Inks.sun);
  s.ring(at, 1.9 * k, width: 1.1, amp: 0.15);
}

void _hatFrame(Sketch s, Offset at, double rot, void Function() draw) {
  s.canvas.save();
  s.canvas.translate(at.dx, at.dy);
  s.canvas.rotate(rot);
  draw();
  s.canvas.restore();
}

void _beret(Sketch s, Offset at, double k, double rot) {
  _hatFrame(s, at, rot, () {
    final puff = Path()
      ..moveTo(-8 * k, 0.5 * k)
      ..quadraticBezierTo(-9 * k, -5 * k, 0, -5.2 * k)
      ..quadraticBezierTo(9 * k, -5 * k, 8 * k, 0.5 * k)
      ..quadraticBezierTo(0, 2.2 * k, -8 * k, 0.5 * k)
      ..close();
    s.fillArea(puff, Inks.rose, amp: 0.4);
    s.ink(puff, width: 1.8, amp: 0.4);
    s.strokeLine(
      Offset(0.4 * k, -5 * k),
      Offset(1.4 * k, -7.2 * k),
      width: 1.6,
      amp: 0.2,
    );
    s.dot(Offset(1.6 * k, -7.5 * k), 1.1 * k);
  });
}

void _partyHat(Sketch s, Offset at, double k, double rot) {
  _hatFrame(s, at, rot, () {
    final cone = Path()
      ..moveTo(-5.5 * k, 0)
      ..lineTo(0, -11 * k)
      ..lineTo(5.5 * k, 0)
      ..quadraticBezierTo(0, 1.6 * k, -5.5 * k, 0)
      ..close();
    s.fillArea(cone, Inks.sun, amp: 0.35);
    s.ink(cone, width: 1.8, amp: 0.35);
    s.strokeLine(
      Offset(-3.8 * k, -2.8 * k),
      Offset(2.4 * k, -5.4 * k),
      width: 1.9,
      color: Inks.rose,
      amp: 0.3,
    );
    s.strokeLine(
      Offset(-2 * k, -6.6 * k),
      Offset(1.2 * k, -8.2 * k),
      width: 1.7,
      color: Inks.rose,
      amp: 0.3,
    );
    s.dot(Offset(0, -11.7 * k), 1.7 * k, color: Inks.rose);
    s.ring(Offset(0, -11.7 * k), 1.7 * k, width: 1.2, amp: 0.25);
  });
}

void _crown(Sketch s, Offset at, double k, double rot) {
  _hatFrame(s, at, rot, () {
    final band = Path()
      ..moveTo(-6.5 * k, 0)
      ..lineTo(-6.5 * k, -5 * k)
      ..lineTo(-3.2 * k, -2.4 * k)
      ..lineTo(0, -6.6 * k)
      ..lineTo(3.2 * k, -2.4 * k)
      ..lineTo(6.5 * k, -5 * k)
      ..lineTo(6.5 * k, 0)
      ..quadraticBezierTo(0, 1.4 * k, -6.5 * k, 0)
      ..close();
    s.fillArea(band, Inks.sun, amp: 0.3);
    s.ink(band, width: 1.7, amp: 0.3);
    s.dot(Offset(-3.4 * k, -1 * k), 0.9 * k, color: Inks.rose);
    s.dot(Offset(0, -0.6 * k), 1.0 * k, color: Inks.sky);
    s.dot(Offset(3.4 * k, -1 * k), 0.9 * k, color: Inks.rose);
  });
}

void _beanie(Sketch s, Offset at, double k, double rot) {
  _hatFrame(s, at, rot, () {
    final dome = Path()
      ..moveTo(-8.5 * k, 0)
      ..quadraticBezierTo(-8.5 * k, -8.5 * k, 0, -9 * k)
      ..quadraticBezierTo(8.5 * k, -8.5 * k, 8.5 * k, 0)
      ..close();
    s.fillArea(dome, _accSky, amp: 0.35);
    s.ink(dome, width: 1.9, amp: 0.35);
    final fold = Path()
      ..moveTo(-9 * k, 0.8 * k)
      ..quadraticBezierTo(0, 2.4 * k, 9 * k, 0.8 * k)
      ..lineTo(8.6 * k, -2.2 * k)
      ..quadraticBezierTo(0, -0.6 * k, -8.6 * k, -2.2 * k)
      ..close();
    s.fillArea(fold, const Color(0xFF5B7FA6), amp: 0.3);
    s.ink(fold, width: 1.6, amp: 0.3);
    s.dot(Offset(0, -10 * k), 2.1 * k, color: Inks.cream);
    s.ring(Offset(0, -10 * k), 2.1 * k, width: 1.4, amp: 0.3);
  });
}

void _brimHat(
  Sketch s,
  Offset at,
  double k,
  double rot, {
  required Color top,
  required Color band,
  required double brimW,
  bool cowboy = false,
}) {
  _hatFrame(s, at, rot, () {
    final w = brimW * k / 2;
    final brim = Path();
    if (cowboy) {
      brim
        ..moveTo(-w, -1.2 * k)
        ..quadraticBezierTo(-w * 0.48, 3.1 * k, 0, 3.1 * k)
        ..quadraticBezierTo(w * 0.48, 3.1 * k, w, -1.2 * k)
        ..quadraticBezierTo(w * 0.52, 0.6 * k, 0, 0.8 * k)
        ..quadraticBezierTo(-w * 0.52, 0.6 * k, -w, -1.2 * k)
        ..close();
    } else {
      brim.addOval(
        Rect.fromCenter(center: Offset.zero, width: brimW * k, height: 6 * k),
      );
    }
    s.fillArea(brim, top, amp: 0.35);
    s.ink(brim, width: 1.8, amp: 0.35);
    final dome = Path()..moveTo(-7.5 * k, -0.8 * k);
    if (cowboy) {
      dome
        ..quadraticBezierTo(-8.2 * k, -7.4 * k, -3.5 * k, -8.4 * k)
        ..quadraticBezierTo(-1.4 * k, -8.4 * k, 0, -6.8 * k)
        ..quadraticBezierTo(1.4 * k, -8.4 * k, 3.5 * k, -8.4 * k)
        ..quadraticBezierTo(8.2 * k, -7.4 * k, 7.5 * k, -0.8 * k);
    } else {
      dome
        ..quadraticBezierTo(-8 * k, -8.6 * k, 0, -8.8 * k)
        ..quadraticBezierTo(8 * k, -8.6 * k, 7.5 * k, -0.8 * k);
    }
    dome
      ..quadraticBezierTo(0, 1 * k, -7.5 * k, -0.8 * k)
      ..close();
    s.fillArea(dome, top, amp: 0.35);
    s.ink(dome, width: 1.8, amp: 0.35);
    final bandPath = Path()
      ..moveTo(-7.6 * k, -1.2 * k)
      ..quadraticBezierTo(0, 0.6 * k, 7.6 * k, -1.2 * k)
      ..lineTo(7.2 * k, -3.4 * k)
      ..quadraticBezierTo(0, -1.8 * k, -7.2 * k, -3.4 * k)
      ..close();
    s.fillArea(bandPath, band, amp: 0.3);
    s.ink(bandPath, width: 1.4, amp: 0.3);
  });
}

void _halo(Sketch s, Offset at, double k) {
  final ringPath = Path.combine(
    PathOperation.difference,
    Path()..addOval(Rect.fromCenter(center: at, width: 18 * k, height: 6 * k)),
    Path()
      ..addOval(Rect.fromCenter(center: at, width: 12 * k, height: 2.6 * k)),
  );
  s.fillArea(ringPath, Inks.sun, amp: 0.3);
  s.ink(ringPath, width: 1.4, amp: 0.3);
}

void _shadeLens(Sketch s, Offset at, double k) {
  final lens = Path()
    ..addOval(Rect.fromCenter(center: at, width: 9 * k, height: 7 * k));
  s.fillArea(lens, Inks.ink, amp: 0.25);
  s.ink(lens, width: 1.5, amp: 0.25);
  s.dot(
    Offset(at.dx - 1.6 * k, at.dy - 1.4 * k),
    0.8 * k,
    color: const Color(0x66FFFFFF),
  );
}

void _heartLens(Sketch s, Offset at, double k) {
  final lens = s.heartShape(Offset(at.dx, at.dy + 0.6 * k), 3.6 * k);
  s.fillArea(lens, Inks.rose, amp: 0.25);
  s.ink(lens, width: 1.5, amp: 0.25);
  s.dot(Offset(at.dx - 1.4 * k, at.dy - 1.2 * k), 0.7 * k, color: Inks.cream);
}

void _leiFlower(Sketch s, Offset at, double k, Color c) {
  s.dot(at, 2.1 * k, color: c);
  s.ring(at, 2.1 * k, width: 1.1, amp: 0.2);
  s.dot(at, 0.8 * k, color: c == Inks.sun ? Inks.rose : Inks.sun);
}

void _bee(Sketch s, Offset at, double k) {
  for (final (d, r) in const [
    (Offset(5.5, 3.5), 0.7),
    (Offset(8.5, 6), 0.6),
    (Offset(11, 9), 0.5),
  ]) {
    s.dot(at + d * k, r * k, color: Inks.inkSoft);
  }
  for (final w in const [Offset(-1.4, -2.6), Offset(1.2, -2.7)]) {
    final wing = Path()
      ..addOval(
        Rect.fromCenter(center: at + w * k, width: 3 * k, height: 2.2 * k),
      );
    s.fillArea(wing, Inks.cream, amp: 0.2);
    s.ink(wing, width: 1.0, amp: 0.2, color: Inks.inkSoft);
  }
  final body = Path()
    ..addOval(Rect.fromCenter(center: at, width: 5.2 * k, height: 3.6 * k));
  s.fillArea(body, Inks.sun, amp: 0.2);
  s.ink(body, width: 1.1, amp: 0.2);
  s.strokeLine(
    at + Offset(-0.6 * k, -1.7 * k),
    at + Offset(-0.6 * k, 1.7 * k),
    width: 1.2,
    amp: 0.15,
  );
  s.strokeLine(
    at + Offset(1.0 * k, -1.5 * k),
    at + Offset(1.0 * k, 1.5 * k),
    width: 1.2,
    amp: 0.15,
  );
  s.dot(at + Offset(-1.8 * k, -0.6 * k), 0.5 * k);
}
