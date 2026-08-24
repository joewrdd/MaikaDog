import 'dart:convert';
import 'dart:io';

import 'package:buddy/usage_tracker.dart';
import 'package:flutter_test/flutter_test.dart';

String _assistantLine(String id, int tokens, DateTime at) => jsonEncode({
  'type': 'assistant',
  'timestamp': at.toUtc().toIso8601String(),
  'message': {
    'id': id,
    'usage': {
      'input_tokens': tokens,
      'output_tokens': 0,
      'cache_creation_input_tokens': 0,
      'cache_read_input_tokens': 999999,
    },
  },
});

void main() {
  late Directory home;
  late File transcript;

  setUp(() {
    home = Directory.systemTemp.createTempSync('ledger_test');
    final project = Directory('${home.path}/.claude/projects/-Users-t-alpha')
      ..createSync(recursive: true);
    transcript = File('${project.path}/aaaa1111.jsonl');
  });

  tearDown(() {
    home.deleteSync(recursive: true);
  });

  void append(String line) {
    transcript.writeAsStringSync('$line\n', mode: FileMode.append, flush: true);
  }

  test('install day starts at zero even with a rich history', () {
    final old = DateTime.now().subtract(const Duration(days: 40));
    append(_assistantLine('msg_old1', 5000000, old));
    append(_assistantLine('msg_old2', 9000000, old));
    final stats = UsageTracker.scanSync(home.path);
    expect(stats.totalTokens, 0);
    expect(stats.todayTokens, 0);
  });

  test('new tokens after install accumulate and never rescan history', () {
    append(_assistantLine('msg_old', 7000000, DateTime.now()));
    UsageTracker.scanSync(home.path);
    append(_assistantLine('msg_a', 1200, DateTime.now()));
    var stats = UsageTracker.scanSync(home.path);
    expect(stats.totalTokens, 1200);
    expect(stats.todayTokens, 1200);
    append(_assistantLine('msg_b', 800, DateTime.now()));
    stats = UsageTracker.scanSync(home.path);
    expect(stats.totalTokens, 2000);
    expect(stats.streakDays, 1);
  });

  test('duplicate message ids count once', () {
    UsageTracker.scanSync(home.path);
    append(_assistantLine('msg_dup', 500, DateTime.now()));
    UsageTracker.scanSync(home.path);
    append(_assistantLine('msg_dup', 500, DateTime.now()));
    final stats = UsageTracker.scanSync(home.path);
    expect(stats.totalTokens, 500);
  });

  test('files born after install count in full', () {
    UsageTracker.scanSync(home.path);
    final project = Directory('${home.path}/.claude/projects/-Users-t-beta')
      ..createSync(recursive: true);
    File('${project.path}/bbbb2222.jsonl').writeAsStringSync(
      '${_assistantLine('msg_new', 3000, DateTime.now())}\n',
      flush: true,
    );
    final stats = UsageTracker.scanSync(home.path);
    expect(stats.totalTokens, 3000);
  });

  test('deleted transcripts never shrink the ledger', () {
    UsageTracker.scanSync(home.path);
    append(_assistantLine('msg_keep', 4000, DateTime.now()));
    UsageTracker.scanSync(home.path);
    transcript.deleteSync();
    final stats = UsageTracker.scanSync(home.path);
    expect(stats.totalTokens, 4000);
  });

  test('legacy lifetime state resets to a fresh baseline', () {
    append(_assistantLine('msg_old', 6000000, DateTime.now()));
    final stateFile = File(
      '${home.path}/Library/Application Support/Maika/usage_state.json',
    )..createSync(recursive: true);
    stateFile.writeAsStringSync(
      jsonEncode({
        'files': <String, int>{},
        'days': {'2026-07-01': 6000000},
        'ids': <String, int>{},
      }),
    );
    final stats = UsageTracker.scanSync(home.path);
    expect(stats.totalTokens, 0);
  });
}
