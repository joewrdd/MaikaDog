import 'characters/dogs.dart';
import 'characters/houses/houses.dart';

const levelThresholds = <int>[
  0,
  250000,
  970000,
  2100000,
  3700000,
  5800000,
  8300000,
  11000000,
  14500000,
  18500000,
  22500000,
  27000000,
  32000000,
  37500000,
  43500000,
  49500000,
  56000000,
  63500000,
  70500000,
  78500000,
  87000000,
  95500000,
  105000000,
  114000000,
  124000000,
  134000000,
  145000000,
  156000000,
  168000000,
  180000000,
  192000000,
  204000000,
  218000000,
  231000000,
  245000000,
  259000000,
  274000000,
  289000000,
  304000000,
  320000000,
  336000000,
  353000000,
  370000000,
  387000000,
  405000000,
  423000000,
  442000000,
  461000000,
  480000000,
  500000000,
];

const levelStep = 25000000;

int levelFor(int tokens) {
  var level = 1;
  for (var i = 0; i < levelThresholds.length; i++) {
    if (tokens >= levelThresholds[i]) level = i + 1;
  }
  if (tokens > levelThresholds.last) {
    level += (tokens - levelThresholds.last) ~/ levelStep;
  }
  return level;
}

int? nextThresholdFor(int level) => level < levelThresholds.length
    ? levelThresholds[level]
    : levelThresholds.last + (level - levelThresholds.length + 1) * levelStep;

List<String> unlocksAt(int level) => [
  for (final breed in dogBreeds)
    if (breed.level == level && breed.id != 'golden') '${breed.name} breed',
  for (final breed in dogBreeds)
    for (final coat in breed.coats)
      if (coat.level == level && coat.level != breed.level)
        '${breed.name} \u{00B7} ${coat.name} coat',
  for (final acc in DogAccessory.values)
    if (acc != DogAccessory.none && acc.level == level) '${acc.label} fit',
  for (final house in dogHouses)
    if (house.level == level) '${house.name} den',
];

List<(int, String)> nextUnlocks(int level, {int count = 3}) {
  final upcoming = <(int, String)>[];
  for (var l = level + 1; l <= level + 60 && upcoming.length < count; l++) {
    for (final label in unlocksAt(l)) {
      if (upcoming.length < count) upcoming.add((l, label));
    }
  }
  return upcoming;
}

String formatTokens(int tokens) {
  if (tokens >= 1000000000) {
    return '${(tokens / 1000000000).toStringAsFixed(1)}B';
  }
  if (tokens >= 1000000) return '${(tokens / 1000000).toStringAsFixed(1)}M';
  if (tokens >= 1000) return '${(tokens / 1000).toStringAsFixed(0)}k';
  return '$tokens';
}
