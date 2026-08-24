import '../core/sketch.dart';
import 'bakery.dart';
import 'barrack.dart';
import 'beach.dart';
import 'skullbanner.dart';
import 'cabin.dart';
import 'cafe.dart';
import 'cursed.dart';
import 'galley.dart';
import 'gate.dart';
import 'homestead.dart';
import 'dune.dart';
import 'kennel.dart';
import 'nook.dart';
import 'observatory.dart';
import 'shinobi.dart';
import 'teahouse.dart';

class DogHouse {
  const DogHouse({
    required this.id,
    required this.name,
    required this.lore,
    required this.level,
    required this.painter,
  });

  final String id;
  final String name;
  final String lore;
  final int level;
  final void Function(Sketch s) painter;
}

final dogHouses = <DogHouse>[
  const DogHouse(
    id: 'kennel',
    name: 'Cozy Kennel',
    lore: 'A snug plank kennel with a blanket that always smells of sunshine.',
    level: 1,
    painter: paintKennelHouse,
  ),
  const DogHouse(
    id: 'teahouse',
    name: 'Paper Teahouse',
    lore: 'A quiet paper-walled room where the kettle hums and time slows.',
    level: 15,
    painter: paintTeahouseHouse,
  ),
  const DogHouse(
    id: 'observatory',
    name: 'Star Cabin',
    lore:
        'A little cabin under a wide night sky, made for counting stars '
        'until sleep wins.',
    level: 25,
    painter: paintObservatoryHouse,
  ),
  const DogHouse(
    id: 'beach',
    name: 'Beach Hut',
    lore: 'A driftwood hut where warm sand meets the sound of easy waves.',
    level: 11,
    painter: paintBeachHouse,
  ),
  const DogHouse(
    id: 'nook',
    name: 'Reading Nook',
    lore:
        'A pillow-stacked corner between bookshelves, perfect for long '
        'naps mid-chapter.',
    level: 5,
    painter: paintNookHouse,
  ),
  const DogHouse(
    id: 'bakery',
    name: 'Bakery Corner',
    lore:
        'A flour-dusted corner by the oven where everything smells like '
        'fresh bread.',
    level: 19,
    painter: paintBakeryHouse,
  ),
  const DogHouse(
    id: 'skullbanner',
    name: 'Skull Banner Hideout',
    lore:
        'A rowdy stone den where the fire never dies and every seat is '
        'somebody\'s favorite.',
    level: 45,
    painter: paintSkullbannerHouse,
  ),
  const DogHouse(
    id: 'barrack',
    name: 'Spearhead Barrack',
    lore:
        'A timber bunkroom where polished spears line the wall and '
        'lights-out always comes too soon.',
    level: 31,
    painter: paintBarrackHouse,
  ),
  const DogHouse(
    id: 'cafe',
    name: 'Antique Cafe',
    lore:
        'A dusty-sweet cafe corner where old clocks tick softly over '
        'cocoa gone lukewarm.',
    level: 23,
    painter: paintCafeHouse,
  ),
  const DogHouse(
    id: 'shinobi',
    name: 'Shinobi Hollow',
    lore:
        'A lantern-lit hollow behind the leaves where even the wind '
        'walks on tiptoe.',
    level: 34,
    painter: paintShinobiHouse,
  ),
  const DogHouse(
    id: 'cursed',
    name: 'Cursed Classroom',
    lore:
        'An after-hours classroom where the chalk glows faintly and the '
        'desks keep friendly secrets.',
    level: 37,
    painter: paintCursedHouse,
  ),
  const DogHouse(
    id: 'cabin',
    name: 'Forest Cabin',
    lore:
        'A mossy log cabin deep in the pines where rain on the roof is '
        'the whole evening plan.',
    level: 28,
    painter: paintCabinHouse,
  ),
  const DogHouse(
    id: 'gate',
    name: 'Shadow Gate',
    lore:
        'A violet gate humming quietly in the dark, warm on the near '
        'side and patient on the far.',
    level: 40,
    painter: paintGateHouse,
  ),
  const DogHouse(
    id: 'dune',
    name: 'Moonlit Dune',
    lore:
        'A moonlit dune under an endless night where the sand still '
        'holds the day\'s warmth.',
    level: 42,
    painter: paintDuneHouse,
  ),
  const DogHouse(
    id: 'homestead',
    name: 'Round Homestead',
    lore:
        'A round little country house where training ends the moment '
        'dinner hits the table.',
    level: 47,
    painter: paintHomesteadHouse,
  ),
  const DogHouse(
    id: 'galley',
    name: 'Pirate Galley',
    lore:
        'A creaking ship galley where the stew pot never empties and '
        'the sea rocks you to sleep.',
    level: 50,
    painter: paintGalleyHouse,
  ),
];

DogHouse dogHouseById(String id) =>
    dogHouses.firstWhere((h) => h.id == id, orElse: () => dogHouses.first);
