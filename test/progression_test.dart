import 'package:buddy/characters/dogs.dart';
import 'package:buddy/characters/houses/houses.dart';
import 'package:buddy/progression.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the curve runs 1 to 50 and keeps climbing after', () {
    expect(levelThresholds.length, 50);
    expect(levelThresholds.first, 0);
    expect(levelThresholds.last, 500000000);
    expect(levelFor(0), 1);
    expect(levelFor(levelThresholds[1] - 1), 1);
    expect(levelFor(levelThresholds[1]), 2);
    expect(levelFor(500000000), 50);
    expect(levelFor(500000000 + levelStep), 51);
    expect(levelFor(500000000 + levelStep * 4), 54);
    var prev = -1;
    for (final t in levelThresholds) {
      expect(t > prev, isTrue, reason: 'thresholds must strictly increase');
      prev = t;
    }
  });

  test('day one gives a starter set, not an empty dog', () {
    final free = unlocksAt(1);
    expect(free, contains('Cozy Kennel den'));
    expect(
      free.where((u) => u.endsWith(' fit')).length,
      greaterThanOrEqualTo(2),
    );
    expect(
      DogAccessory.values.where((a) => a.level == 1).length,
      greaterThanOrEqualTo(3),
    );
    expect(dogHouses.where((h) => h.level == 1).length, 1);
  });

  test('every single unlockable is reachable by level 50', () {
    for (final breed in dogBreeds) {
      expect(breed.level, lessThanOrEqualTo(50), reason: breed.name);
      for (final coat in breed.coats) {
        expect(coat.level, lessThanOrEqualTo(50), reason: coat.name);
        expect(
          coat.level,
          greaterThanOrEqualTo(breed.level),
          reason: '${breed.name} ${coat.name} unlocks before its breed',
        );
      }
    }
    for (final acc in DogAccessory.values) {
      expect(acc.level, inInclusiveRange(1, 50), reason: acc.label);
    }
    for (final house in dogHouses) {
      expect(house.level, inInclusiveRange(1, 50), reason: house.name);
    }
  });

  test('unlocks are spread, not clumped, and name every kind', () {
    final all = <String>[];
    for (var l = 1; l <= 50; l++) {
      all.addAll(unlocksAt(l));
    }
    expect(all.where((u) => u.endsWith(' breed')).length, 6);
    expect(all.where((u) => u.endsWith(' fit')).length, 32);
    expect(all.where((u) => u.endsWith(' den')).length, 16);
    expect(all.where((u) => u.endsWith(' coat')).length, 29);
    expect(all.length, 83);
    final barren = [
      for (var l = 2; l <= 50; l++)
        if (unlocksAt(l).isEmpty) l,
    ];
    expect(barren.length, lessThan(12), reason: 'empty levels: $barren');
  });

  test('milestones land where they were designed to', () {
    expect(unlocksAt(8), contains('Shiba breed'));
    expect(unlocksAt(14), contains('Corgi breed'));
    expect(unlocksAt(44), contains('Malinois breed'));
    expect(unlocksAt(50).join(), contains('Galaxy'));
    expect(nextUnlocks(1, count: 3).length, 3);
    expect(formatTokens(3200000), '3.2M');
  });
}
