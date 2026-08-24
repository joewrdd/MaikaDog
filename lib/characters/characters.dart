import 'core/food_character.dart';
import 'families/bakery_bunch.dart';
import 'families/garden_gang.dart';
import 'families/noodle_house.dart';
import 'families/orchard_folk.dart';
import 'families/pantry_pals.dart';
import 'families/street_squad.dart';
import 'families/sugar_studio.dart';
import 'families/sunrise_club.dart';

export 'core/food_character.dart';
export 'core/sketch.dart';
export 'families/bakery_bunch.dart';
export 'families/garden_gang.dart';
export 'families/noodle_house.dart';
export 'families/orchard_folk.dart';
export 'families/pantry_pals.dart';
export 'families/street_squad.dart';
export 'families/sugar_studio.dart';
export 'families/sunrise_club.dart';

const characterFamilies = <CharacterFamily>[
  orchardFolk,
  gardenGang,
  bakeryBunch,
  streetSquad,
  noodleHouse,
  sugarStudio,
  sunriseClub,
  pantryPals,
];

final allFoodCharacters = <FoodCharacter>[
  for (final family in characterFamilies) ...family.members,
];
