import 'dart:io';
import 'dart:ui';

import 'package:buddy/cast.dart';
import 'package:buddy/characters/houses/houses.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _write(String path, Picture picture) async {
  final image = await picture.toImage(300, 300);
  final bytes = await image.toByteData(format: ImageByteFormat.png);
  File(path).writeAsBytesSync(bytes!.buffer.asUint8List());
}

void _paintHouse(Canvas canvas, DogHouse house) {
  canvas.drawRect(
    const Rect.fromLTWH(0, 0, 300, 300),
    Paint()..color = const Color(0xFFFFF6E9),
  );
  canvas.save();
  canvas.scale(3);
  house.painter(
    Sketch(canvas, characterSeed(house.id, CharacterMood.signature)),
  );
  canvas.restore();
}

void main() {
  test('houses render', () async {
    final outDir = Directory('build/house_previews')
      ..createSync(recursive: true);
    for (final house in dogHouses) {
      final recorder = PictureRecorder();
      _paintHouse(Canvas(recorder), house);
      await _write(
        '${outDir.path}/house_${house.id}.png',
        recorder.endRecording(),
      );

      final dogRecorder = PictureRecorder();
      final dogCanvas = Canvas(dogRecorder);
      _paintHouse(dogCanvas, house);
      dogCanvas.save();
      dogCanvas.translate(63, 110.9);
      dogCanvas.scale(1.74);
      FoodCharacterPainter(
        character: maika,
        mood: CharacterMood.signature,
      ).paint(dogCanvas, const Size(100, 100));
      dogCanvas.restore();
      await _write(
        '${outDir.path}/house_${house.id}_with_dog.png',
        dogRecorder.endRecording(),
      );
    }
    final pngs = Directory(
      outDir.path,
    ).listSync().whereType<File>().where((f) => f.path.endsWith('.png')).length;
    expect(pngs, greaterThanOrEqualTo(12));
    expect(
      File('${outDir.path}/house_kennel_with_dog.png').existsSync(),
      isTrue,
    );
  });
}
