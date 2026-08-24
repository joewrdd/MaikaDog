import 'progression.dart';
import 'usage_tracker.dart';

class FieldNote {
  const FieldNote({
    required this.headline,
    required this.subtitle,
    required this.lines,
    required this.closer,
  });

  final String headline;
  final String subtitle;
  final List<String> lines;
  final String closer;
}

String _plural(int n, String one, String many) => n == 1 ? one : many;

String _joinLangs(List<String> langs) {
  final top = langs.take(3).toList();
  if (top.isEmpty) return '';
  if (top.length == 1) return top.first;
  if (top.length == 2) return '${top[0]} and ${top[1]}';
  return '${top[0]}, ${top[1]} and ${top[2]}';
}

FieldNote buildFieldNote(
  UsageStats stats, {
  required bool weekly,
  String name = 'Maika',
}) {
  final ev = weekly ? stats.weekEvents : stats.todayEvents;
  final commits = ev['commit'] ?? 0;
  final tests = ev['test'] ?? 0;
  final edits = ev['edit'] ?? 0;
  final tokens = weekly
      ? stats.dailyRecent.reversed.take(7).fold<int>(0, (a, b) => a + b)
      : stats.todayTokens;
  final late = weekly ? stats.lateThisWeek : stats.lateToday;
  final streak = stats.streakDays;
  final langs = weekly ? stats.weekLangs : const <String>[];

  final lines = <String>[];

  if (tokens <= 0) {
    lines.add(
      weekly
          ? 'A quiet stretch. We rested, and that counts too.'
          : 'A quiet one so far. Resting is allowed.',
    );
  } else {
    lines.add('We moved ${formatTokens(tokens)} tokens of thinking together.');
  }

  if (commits > 0) {
    lines.add(
      '$commits ${_plural(commits, 'commit', 'commits')} shipped'
      '${commits >= 5 ? '. What a run.' : '.'}',
    );
  }

  if (edits > 0) {
    final where = langs.isNotEmpty ? ' across ${_joinLangs(langs)}' : '';
    lines.add('$edits ${_plural(edits, 'file', 'files')} shaped$where.');
  }

  if (tests > 0) {
    final tail = tests >= 3 ? 'Careful hands.' : 'Good instinct.';
    lines.add('Tests ran $tests ${_plural(tests, 'time', 'times')}. $tail');
  }

  if (late) {
    lines.add('We pushed past a late-night wall. I stayed up too.');
  }

  if (streak > 1) {
    lines.add('$streak days in a row now. Look at us.');
  } else if (streak == 1 && !weekly) {
    lines.add('Day one of a fresh streak.');
  }

  final closer = tokens <= 0
      ? 'Come find me when you are ready.'
      : commits > 0 || edits > 0
      ? 'Proud of you. Same time tomorrow?'
      : 'Whatever it was, we did it side by side.';

  return FieldNote(
    headline: weekly ? 'This week with you' : 'Today with you',
    subtitle: weekly ? 'the last seven days' : 'so far today',
    lines: lines,
    closer: closer,
  );
}
