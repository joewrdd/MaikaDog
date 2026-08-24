import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _networkApis = RegExp(
  r'HttpClient|WebSocket|package:http|package:dio|InternetAddress|'
  r'RawDatagramSocket|SecureSocket|Socket\.connect|HttpServer|'
  r'URLSession|NSURLConnection|CFStream',
);

const _allowedPackages = {
  'battery_plus',
  'flutter',
  'hotkey_manager',
  'launch_at_startup',
  'screen_retriever',
  'shared_preferences',
  'tray_manager',
  'window_manager',
};

void main() {
  test('no networking APIs anywhere in the app', () {
    final offenders = <String>[];
    for (final dir in ['lib', 'macos/Runner']) {
      final root = Directory(dir);
      if (!root.existsSync()) continue;
      for (final entity in root.listSync(recursive: true)) {
        if (entity is! File) continue;
        if (!entity.path.endsWith('.dart') && !entity.path.endsWith('.swift')) {
          continue;
        }
        final lines = entity.readAsLinesSync();
        for (var i = 0; i < lines.length; i++) {
          if (_networkApis.hasMatch(lines[i])) {
            offenders.add('${entity.path}:${i + 1}  ${lines[i].trim()}');
          }
        }
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'Maika promises that nothing leaves your Mac. Something here opens '
          'a network connection:\n${offenders.join('\n')}',
    );
  });

  test('no dependency can smuggle networking in', () {
    final pubspec = File('pubspec.yaml').readAsLinesSync();
    final deps = <String>[];
    var inDeps = false;
    for (final raw in pubspec) {
      if (raw.startsWith('dependencies:')) {
        inDeps = true;
        continue;
      }
      if (inDeps && raw.isNotEmpty && !raw.startsWith(' ')) break;
      if (!inDeps) continue;
      final match = RegExp(r'^  ([a-z0-9_]+):').firstMatch(raw);
      if (match != null) deps.add(match.group(1)!);
    }
    expect(deps, isNotEmpty);
    expect(
      deps.toSet().difference(_allowedPackages),
      isEmpty,
      reason:
          'A new dependency appeared. Confirm it cannot reach the network, '
          'then add it to _allowedPackages in this test.',
    );
  });
}
