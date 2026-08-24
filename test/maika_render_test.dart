import 'dart:io';
import 'dart:ui';

import 'package:buddy/cast.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _write(String path, Picture picture, int w, int h) async {
  final image = await picture.toImage(w, h);
  final bytes = await image.toByteData(format: ImageByteFormat.png);
  File(path).writeAsBytesSync(bytes!.buffer.asUint8List());
}

void main() {
  test('maika renders all moods and performance frames', () async {
    final outDir = Directory('build/maika_previews')
      ..createSync(recursive: true);
    for (final mood in CharacterMood.values) {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, 300, 300),
        Paint()..color = const Color(0xFFFFF6E9),
      );
      FoodCharacterPainter(
        character: maika,
        mood: mood,
      ).paint(canvas, const Size(300, 300));
      await _write(
        '${outDir.path}/maika_${mood.name}.png',
        recorder.endRecording(),
        300,
        300,
      );
    }
    for (var f = 0; f < 12; f++) {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, 300, 300),
        Paint()..color = const Color(0xFFFFF6E9),
      );
      FoodCharacterPainter(
        character: maika,
        mood: CharacterMood.signature,
        time: f / 10,
        perf: f / 12,
      ).paint(canvas, const Size(300, 300));
      await _write(
        '${outDir.path}/perf_$f.png',
        recorder.endRecording(),
        300,
        300,
      );
    }
    expect(
      Directory(outDir.path).listSync().whereType<File>().length,
      greaterThanOrEqualTo(17),
    );
  });

  test('every breed renders in its base coat', () async {
    final outDir = Directory('build/maika_previews')
      ..createSync(recursive: true);
    for (final breed in dogBreeds) {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, 300, 300),
        Paint()..color = const Color(0xFFFFF6E9),
      );
      FoodCharacterPainter(
        character: dogCharacter(breed, breed.coats.first),
        mood: CharacterMood.signature,
      ).paint(canvas, const Size(300, 300));
      await _write(
        '${outDir.path}/breed_${breed.id}.png',
        recorder.endRecording(),
        300,
        300,
      );
    }
    for (final breed in dogBreeds) {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, 300, 300),
        Paint()..color = const Color(0xFFFFF6E9),
      );
      FoodCharacterPainter(
        character: dogCharacter(breed, breed.coats.first),
        mood: CharacterMood.signature,
        turn: 0.5,
      ).paint(canvas, const Size(300, 300));
      await _write(
        '${outDir.path}/breedq_${breed.id}.png',
        recorder.endRecording(),
        300,
        300,
      );
    }
    for (final breed in dogBreeds) {
      for (final coat in breed.coats) {
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        canvas.drawRect(
          const Rect.fromLTWH(0, 0, 200, 200),
          Paint()..color = const Color(0xFFFFF6E9),
        );
        FoodCharacterPainter(
          character: dogCharacter(breed, coat),
          mood: CharacterMood.signature,
        ).paint(canvas, const Size(200, 200));
        await _write(
          '${outDir.path}/coat_${breed.id}_${coat.id}.png',
          recorder.endRecording(),
          200,
          200,
        );
      }
    }
    expect(dogBreeds.length, 7);
  });

  test('walk cycle frames render for key breeds', () async {
    final outDir = Directory('build/maika_previews')
      ..createSync(recursive: true);
    for (final breedId in ['golden', 'corgi', 'husky', 'malinois']) {
      final breed = dogBreedById(breedId);
      final character = dogCharacter(breed, breed.coats.first);
      for (var f = 0; f < 16; f++) {
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        canvas.drawRect(
          const Rect.fromLTWH(0, 0, 300, 300),
          Paint()..color = const Color(0xFFFFF6E9),
        );
        double? walkPhase;
        var stretchAmount = 0.0;
        if (f < 4) {
          stretchAmount = (f + 1) / 4;
        } else {
          walkPhase = (f - 4) / 12 * 1.5 % 1.0;
          stretchAmount = f == 4 ? 0.4 : 0.0;
        }
        FoodCharacterPainter(
          character: character,
          mood: CharacterMood.signature,
          time: f / 10,
          walk: walkPhase,
          stretch: stretchAmount,
        ).paint(canvas, const Size(300, 300));
        await _write(
          '${outDir.path}/walk_${breedId}_$f.png',
          recorder.endRecording(),
          300,
          300,
        );
      }
    }
    expect(File('build/maika_previews/walk_golden_8.png').existsSync(), isTrue);
  });

  test('wardrobe accessories render', () async {
    final outDir = Directory('build/maika_previews')
      ..createSync(recursive: true);
    final breed = dogBreeds.first;
    const views = <(String, double, double)>[
      ('acc', 0.0, 0.0),
      ('accq', 0.5, 0.0),
      ('accp', 0.0, 0.02),
    ];
    for (final acc in DogAccessory.values) {
      if (acc == DogAccessory.none) continue;
      for (final (prefix, turn, stretch) in views) {
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        canvas.drawRect(
          const Rect.fromLTWH(0, 0, 240, 240),
          Paint()..color = const Color(0xFFFFF6E9),
        );
        FoodCharacterPainter(
          character: dogCharacter(breed, breed.coats.first, accessory: acc),
          mood: CharacterMood.signature,
          turn: turn,
          stretch: stretch,
        ).paint(canvas, const Size(240, 240));
        await _write(
          '${outDir.path}/${prefix}_${acc.name}.png',
          recorder.endRecording(),
          240,
          240,
        );
      }
    }
    expect(File('build/maika_previews/acc_bandana.png').existsSync(), isTrue);
    expect(File('build/maika_previews/accq_halo.png').existsSync(), isTrue);
    expect(File('build/maika_previews/accp_cape.png').existsSync(), isTrue);
  });

  test('bark frames render in all views', () async {
    final outDir = Directory('build/maika_previews')
      ..createSync(recursive: true);
    const specs = <(String, double, double)>[
      ('bark_front_open', 0.0, 0.17),
      ('bark_front_closed', 0.0, 0.34),
      ('bark_quarter', 0.5, 0.17),
      ('bark_profile', 1.0, 0.17),
    ];
    for (final (name, turn, bark) in specs) {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, 300, 300),
        Paint()..color = const Color(0xFFFFF6E9),
      );
      FoodCharacterPainter(
        character: maika,
        mood: CharacterMood.signature,
        time: bark,
        turn: turn,
        bark: bark,
      ).paint(canvas, const Size(300, 300));
      await _write(
        '${outDir.path}/$name.png',
        recorder.endRecording(),
        300,
        300,
      );
    }
    expect(
      File('build/maika_previews/bark_front_open.png').existsSync(),
      isTrue,
    );
  });

  test('turn transition frames render', () async {
    final outDir = Directory('build/maika_previews')
      ..createSync(recursive: true);
    const specs = <(double, double, double?, double)>[
      (1.0, 0, null, 0),
      (0.93, 0.1, null, 0),
      (0.88, 0.45, null, 0),
      (0.9, 0.6, null, 0),
      (0.95, 0.8, null, 0.05),
      (1.0, 1, null, 0.4),
      (1.0, 1, null, 0.8),
      (1.0, 1, null, 1.0),
      (1.0, 1, 0.08, 0.4),
      (1.0, 1, 0.25, 0),
      (1.0, 1, 0.45, 0),
      (1.0, 1, 0.65, 0),
      (1.0, 1, 0.85, 0),
      (1.0, 1, 0.05, 0),
    ];
    for (var f = 0; f < specs.length; f++) {
      final (sx, turn, wp, st) = specs[f];
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, 300, 300),
        Paint()..color = const Color(0xFFFFF6E9),
      );
      canvas.save();
      canvas.translate(150, 264);
      canvas.scale(sx, 1);
      canvas.translate(-150, -264);
      FoodCharacterPainter(
        character: maika,
        mood: CharacterMood.signature,
        time: f / 10,
        walk: wp,
        stretch: st,
        turn: turn,
      ).paint(canvas, const Size(300, 300));
      canvas.restore();
      await _write(
        '${outDir.path}/turn_$f.png',
        recorder.endRecording(),
        300,
        300,
      );
    }
    expect(File('build/maika_previews/turn_7.png').existsSync(), isTrue);
  });

  test('app icon and tray icon render', () async {
    final outDir = Directory('build/icon')..createSync(recursive: true);
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 1024.0;
    final plate = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(64, 64, size - 128, size - 128),
          const Radius.circular(228),
        ),
      );
    canvas.drawPath(plate, Paint()..color = const Color(0xFFF0E2C8));
    canvas.drawPath(
      plate,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..color = const Color(0x2E33251D),
    );
    canvas.save();
    canvas.translate(size * 0.5 - 400, size * 0.5 - 388);
    canvas.scale(8);
    FoodCharacterPainter(
      character: maika,
      mood: CharacterMood.signature,
    ).paint(canvas, const Size(100, 100));
    canvas.restore();
    await _write(
      '${outDir.path}/app_icon_1024.png',
      recorder.endRecording(),
      1024,
      1024,
    );

    final trayRecorder = PictureRecorder();
    final trayCanvas = Canvas(trayRecorder);
    trayCanvas.scale(0.44);
    FoodCharacterPainter(
      character: maika,
      mood: CharacterMood.signature,
    ).paint(trayCanvas, const Size(100, 100));
    await _write(
      '${outDir.path}/tray_icon.png',
      trayRecorder.endRecording(),
      44,
      44,
    );
    expect(
      File('${outDir.path}/app_icon_1024.png').lengthSync(),
      greaterThan(0),
    );
  });
}
