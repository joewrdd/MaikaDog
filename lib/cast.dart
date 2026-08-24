import 'characters/characters.dart';

export 'characters/characters.dart';
export 'characters/dogs.dart';

final buddyFoodCast = <FoodCharacter>[...allFoodCharacters];

FoodCharacter? foodById(String id) {
  for (final c in buddyFoodCast) {
    if (c.id == id) return c;
  }
  return null;
}
