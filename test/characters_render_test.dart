import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:buddy/characters/characters.dart';

void main() {
  test('every character paints all five moods and renders a preview', () async {
    final outDir = Directory('build/character_previews')
      ..createSync(recursive: true);
    expect(allFoodCharacters.length, 40);
    for (final character in allFoodCharacters) {
      for (final mood in CharacterMood.values) {
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        canvas.drawRect(
          const Rect.fromLTWH(0, 0, 256, 256),
          Paint()..color = const Color(0xFFFFF6E9),
        );
        FoodCharacterPainter(
          character: character,
          mood: mood,
        ).paint(canvas, const Size(256, 256));
        final image = await recorder.endRecording().toImage(256, 256);
        final bytes = await image.toByteData(format: ImageByteFormat.png);
        expect(
          bytes,
          isNotNull,
          reason: '${character.id}/${mood.name} produced no bytes',
        );
        final file = File('${outDir.path}/${character.id}_${mood.name}.png');
        file.writeAsBytesSync(bytes!.buffer.asUint8List());
        expect(file.lengthSync(), greaterThan(0));
      }
    }
  });

  test('live time parameter animates the drawing', () async {
    final outDir = Directory('build/character_previews')
      ..createSync(recursive: true);
    for (final character in [miso, flan]) {
      final frames = <Uint8List>[];
      const cell = 256.0;
      final recorder = PictureRecorder();
      final strip = Canvas(recorder);
      for (var f = 0; f < 6; f++) {
        final time = f * 0.35;
        final frameRecorder = PictureRecorder();
        final canvas = Canvas(frameRecorder);
        canvas.drawRect(
          const Rect.fromLTWH(0, 0, cell, cell),
          Paint()..color = const Color(0xFFFFF6E9),
        );
        FoodCharacterPainter(
          character: character,
          mood: CharacterMood.signature,
          time: time,
        ).paint(canvas, const Size(cell, cell));
        final image = await frameRecorder.endRecording().toImage(256, 256);
        final bytes = await image.toByteData(format: ImageByteFormat.png);
        frames.add(bytes!.buffer.asUint8List());
        strip.save();
        strip.translate(f * cell, 0);
        strip.drawImage(image, Offset.zero, Paint());
        strip.restore();
      }
      final stripImage = await recorder.endRecording().toImage(1536, 256);
      final stripBytes = await stripImage.toByteData(
        format: ImageByteFormat.png,
      );
      File(
        '${outDir.path}/_live_strip_${character.id}.png',
      ).writeAsBytesSync(stripBytes!.buffer.asUint8List());
      final allSame = frames.every(
        (f) =>
            f.length == frames.first.length &&
            List.generate(
              f.length,
              (i) => f[i] == frames.first[i],
            ).every((same) => same),
      );
      expect(
        allSame,
        isFalse,
        reason: '${character.id} should move across live frames',
      );
    }
  });

  test('performance frames render for every character', () async {
    final outDir = Directory('build/character_performances')
      ..createSync(recursive: true);
    for (final character in allFoodCharacters) {
      final samples = <Uint8List>[];
      for (var f = 0; f < 12; f++) {
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        canvas.drawRect(
          const Rect.fromLTWH(0, 0, 224, 224),
          Paint()..color = const Color(0xFFFFF6E9),
        );
        FoodCharacterPainter(
          character: character,
          mood: CharacterMood.signature,
          time: f / 10,
          perf: f / 12,
        ).paint(canvas, const Size(224, 224));
        final image = await recorder.endRecording().toImage(224, 224);
        final bytes = await image.toByteData(format: ImageByteFormat.png);
        final data = bytes!.buffer.asUint8List();
        File('${outDir.path}/${character.id}_$f.png').writeAsBytesSync(data);
        if (f == 0 || f == 6) samples.add(data);
      }
      final identical =
          samples[0].length == samples[1].length &&
          List.generate(
            samples[0].length,
            (i) => samples[0][i] == samples[1][i],
          ).every((same) => same);
      expect(
        identical,
        isFalse,
        reason: '${character.id} performance should move',
      );
    }
  });

  test('registry metadata exports for external previews', () {
    final outDir = Directory('build/character_previews')
      ..createSync(recursive: true);
    final meta = {
      'families': [
        for (final family in characterFamilies)
          {
            'name': family.name,
            'tagline': family.tagline,
            'slug': family.slug,
            'members': [for (final c in family.members) c.id],
          },
      ],
      'characters': {
        for (final c in allFoodCharacters)
          c.id: {
            'name': c.name,
            'title': c.title,
            'family': c.family,
            'story': c.story,
            'accent':
                '#${c.accent.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
            'moodLore': {
              for (final entry in c.moodLore.entries)
                entry.key.name: entry.value,
            },
          },
      },
    };
    final file = File('${outDir.path}/character_meta.json')
      ..writeAsStringSync(const JsonEncoder.withIndent('  ').convert(meta));
    expect(file.lengthSync(), greaterThan(0));
  });
}
