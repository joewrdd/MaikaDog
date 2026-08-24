import 'package:buddy/code_events.dart';
import 'package:buddy/field_notes.dart';
import 'package:buddy/usage_tracker.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _assistant(List<Map<String, dynamic>> blocks) => {
  'type': 'assistant',
  'message': {'content': blocks},
};

Map<String, dynamic> _user(List<Map<String, dynamic>> blocks) => {
  'type': 'user',
  'message': {'content': blocks},
};

void main() {
  test('classifyEntry reads tool_use and tool_result blocks', () {
    final commit = classifyEntry(
      _assistant([
        {
          'type': 'tool_use',
          'name': 'Bash',
          'id': 'a',
          'input': {'command': 'git commit -m "ship it"'},
        },
      ]),
    );
    expect(commit.length, 1);
    expect(commit.first.kind, 'commit');
    expect(commit.first.toolUseId, 'a');

    final test = classifyEntry(
      _assistant([
        {
          'type': 'tool_use',
          'name': 'Bash',
          'id': 'b',
          'input': {'command': 'flutter test'},
        },
      ]),
    );
    expect(test.single.kind, 'test');

    final edit = classifyEntry(
      _assistant([
        {
          'type': 'tool_use',
          'name': 'Edit',
          'id': 'c',
          'input': {'file_path': '/x/lib/buddy_brain.dart'},
        },
      ]),
    );
    expect(edit.single.kind, 'edit');
    expect(edit.single.language, 'Dart');

    final err = classifyEntry(
      _user([
        {'type': 'tool_result', 'tool_use_id': 'b', 'is_error': true},
      ]),
    );
    expect(err.single.kind, 'error');
    expect(err.single.toolUseId, 'b');
  });

  test('classifyEntry ignores plain text and non-code bash', () {
    expect(
      classifyEntry(
        _assistant([
          {'type': 'text', 'text': 'thinking about git commit history'},
        ]),
      ),
      isEmpty,
    );
    expect(
      classifyEntry(
        _assistant([
          {
            'type': 'tool_use',
            'name': 'Bash',
            'id': 'z',
            'input': {'command': 'ls -la && npm run build'},
          },
        ]),
      ),
      isEmpty,
    );
  });

  List<String> kinds(String cmd) => classifyEntry(
    _assistant([
      {
        'type': 'tool_use',
        'name': 'Bash',
        'id': 'x',
        'input': {'command': cmd},
      },
    ]),
  ).map((e) => e.kind).toList();

  test('classifier resists filename false positives', () {
    expect(kinds('rm jest.config.js'), ['delete']);
    expect(kinds('cat pytest.ini'), isEmpty);
    expect(kinds('git commit-graph write'), isEmpty);
    expect(kinds('python test.py'), isEmpty);
  });

  test('classifier catches real invocations and compounds', () {
    expect(kinds('python -m pytest tests/'), ['test']);
    expect(kinds('python manage.py test'), ['test']);
    expect(kinds('git rm old.txt && pytest'), ['test', 'delete']);
    expect(kinds('git commit -m ok'), ['commit']);
  });

  test('tool_result without error is a completion marker, not an error', () {
    final evs = classifyEntry(
      _user([
        {'type': 'tool_result', 'tool_use_id': 'q', 'is_error': false},
      ]),
    );
    expect(evs.single.kind, 'result');
  });

  test('classifyEntry counts every tool_use in one assistant turn', () {
    final evs = classifyEntry(
      _assistant([
        {
          'type': 'tool_use',
          'name': 'Write',
          'id': '1',
          'input': {'file_path': 'a.py'},
        },
        {
          'type': 'tool_use',
          'name': 'Bash',
          'id': '2',
          'input': {'command': 'git commit -am wip'},
        },
      ]),
    );
    expect(evs.map((e) => e.kind).toList(), ['edit', 'commit']);
    expect(evs.first.language, 'Python');
  });

  test('field notes voice is affectionate and count-driven', () {
    const stats = UsageStats(
      totalTokens: 5000000,
      todayTokens: 900000,
      streakDays: 4,
      todayEvents: {'commit': 3, 'test': 2, 'edit': 11},
      lateToday: true,
    );
    final note = buildFieldNote(stats, weekly: false, name: 'Maika');
    expect(note.headline, 'Today with you');
    expect(note.lines.any((l) => l.contains('3 commits shipped')), isTrue);
    expect(note.lines.any((l) => l.contains('late-night')), isTrue);
    expect(note.lines.any((l) => l.contains('4 days in a row')), isTrue);
    expect(note.closer.isNotEmpty, isTrue);

    const quiet = UsageStats(totalTokens: 0, todayTokens: 0, streakDays: 0);
    final rest = buildFieldNote(quiet, weekly: false);
    expect(rest.lines.first.toLowerCase().contains('quiet'), isTrue);
  });
}
