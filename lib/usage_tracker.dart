import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart' show visibleForTesting;

import 'code_events.dart';

class UsageStats {
  const UsageStats({
    required this.totalTokens,
    required this.todayTokens,
    required this.streakDays,
    this.dailyRecent = const [],
    this.bestStreak = 0,
    this.todayEvents = const {},
    this.weekEvents = const {},
    this.lifetimeEvents = const {},
    this.weekLangs = const [],
    this.lateToday = false,
    this.lateThisWeek = false,
  });

  final int totalTokens;
  final int todayTokens;
  final int streakDays;
  final List<int> dailyRecent;
  final int bestStreak;
  final Map<String, int> todayEvents;
  final Map<String, int> weekEvents;
  final Map<String, int> lifetimeEvents;
  final List<String> weekLangs;
  final bool lateToday;
  final bool lateThisWeek;
}

const _eventKinds = ['commit', 'test', 'edit', 'delete', 'error'];

class UsageTracker {
  static Future<UsageStats> scan() {
    final home = Platform.environment['HOME'] ?? '';
    return Isolate.run(() => _scanSync(home));
  }

  @visibleForTesting
  static UsageStats scanSync(String home) => _scanSync(home);

  static UsageStats _scanSync(String home) {
    final projectsDir = Directory('$home/.claude/projects');
    final stateFile = File(
      '$home/Library/Application Support/Maika/usage_state.json',
    );
    Map<String, dynamic> state = {};
    try {
      if (stateFile.existsSync()) {
        state =
            jsonDecode(stateFile.readAsStringSync()) as Map<String, dynamic>;
      }
    } catch (_) {}
    var files = (state['files'] as Map<String, dynamic>?) ?? {};
    var days = (state['days'] as Map<String, dynamic>?) ?? {};
    var ids = (state['ids'] as Map<String, dynamic>?) ?? {};
    var events = (state['events'] as Map<String, dynamic>?) ?? {};
    var etotal = (state['etotal'] as Map<String, dynamic>?) ?? {};
    var seen = (state['seen'] as Map<String, dynamic>?) ?? {};
    var total = (state['total'] as num?)?.toInt() ?? 0;

    String keyFor(DateTime d) =>
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    final fresh = state['v'] == null;
    if (fresh) {
      files = {};
      days = {};
      ids = {};
      events = {};
      etotal = {};
      seen = {};
      total = 0;
      if (projectsDir.existsSync()) {
        for (final entity in projectsDir.listSync(recursive: true)) {
          if (entity is! File || !entity.path.endsWith('.jsonl')) continue;
          try {
            files[entity.path] = entity.lengthSync();
          } catch (_) {}
        }
      }
    } else if (projectsDir.existsSync()) {
      for (final entity in projectsDir.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.jsonl')) continue;
        final path = entity.path;
        final size = entity.lengthSync();
        final prior = (files[path] as num?)?.toInt() ?? 0;
        if (size == prior) continue;
        if (size < prior) {
          files[path] = size;
          continue;
        }
        try {
          final raf = entity.openSync();
          raf.setPositionSync(prior);
          final bytes = raf.readSync(size - prior);
          raf.closeSync();
          for (final line in const LineSplitter().convert(
            utf8.decode(bytes, allowMalformed: true),
          )) {
            if (line.isEmpty) continue;
            final hasUsage = line.contains('"usage"');
            final hasTool =
                line.contains('"tool_use"') || line.contains('"tool_result"');
            if (!hasUsage && !hasTool) continue;
            try {
              final obj = jsonDecode(line) as Map<String, dynamic>;
              final ts = obj['timestamp'] as String?;
              final when = ts != null
                  ? (DateTime.tryParse(ts)?.toLocal() ?? DateTime.now())
                  : DateTime.now();
              final dayKey = keyFor(when);
              if (obj['type'] == 'assistant') {
                final message = obj['message'] as Map<String, dynamic>?;
                final usage = message?['usage'] as Map<String, dynamic>?;
                if (usage != null) {
                  final id =
                      (message?['id'] as String?) ?? (obj['uuid'] as String?);
                  final tokens =
                      ((usage['input_tokens'] as num?)?.toInt() ?? 0) +
                      ((usage['output_tokens'] as num?)?.toInt() ?? 0) +
                      ((usage['cache_creation_input_tokens'] as num?)
                              ?.toInt() ??
                          0);
                  if (id != null && !ids.containsKey(id) && tokens > 0) {
                    days[dayKey] =
                        ((days[dayKey] as num?)?.toInt() ?? 0) + tokens;
                    total += tokens;
                    ids[id] = when.millisecondsSinceEpoch ~/ 86400000;
                  }
                }
              }
              for (final ev in classifyEntry(obj)) {
                if (ev.kind == 'result') continue;
                final tid = ev.toolUseId;
                final seenKey = tid == null ? null : '$tid:${ev.kind}';
                if (seenKey != null && seen.containsKey(seenKey)) continue;
                final bucket =
                    (events[dayKey] as Map<String, dynamic>?) ??
                    <String, dynamic>{};
                bucket[ev.kind] = ((bucket[ev.kind] as num?)?.toInt() ?? 0) + 1;
                if (when.hour < 5) bucket['late'] = 1;
                final lang = ev.language;
                if (lang != null) {
                  final langs =
                      (bucket['lang'] as Map<String, dynamic>?) ??
                      <String, dynamic>{};
                  langs[lang] = ((langs[lang] as num?)?.toInt() ?? 0) + 1;
                  bucket['lang'] = langs;
                }
                events[dayKey] = bucket;
                etotal[ev.kind] = ((etotal[ev.kind] as num?)?.toInt() ?? 0) + 1;
                if (seenKey != null) {
                  seen[seenKey] = when.millisecondsSinceEpoch ~/ 86400000;
                }
              }
            } catch (_) {}
          }
          files[path] = size;
        } catch (_) {}
      }
    }

    final todayEpochDay = DateTime.now().millisecondsSinceEpoch ~/ 86400000;
    ids.removeWhere(
      (_, day) => todayEpochDay - ((day as num?)?.toInt() ?? 0) > 120,
    );
    seen.removeWhere(
      (_, day) => todayEpochDay - ((day as num?)?.toInt() ?? 0) > 120,
    );
    files.removeWhere((path, _) => !File(path).existsSync());
    final cutoff = DateTime.now().subtract(const Duration(days: 120));
    final cutoffKey =
        '${cutoff.year}-${cutoff.month.toString().padLeft(2, '0')}-${cutoff.day.toString().padLeft(2, '0')}';
    days.removeWhere((key, _) => key.compareTo(cutoffKey) < 0);
    events.removeWhere((key, _) => key.compareTo(cutoffKey) < 0);

    try {
      stateFile.parent.createSync(recursive: true);
      stateFile.writeAsStringSync(
        jsonEncode({
          'v': 3,
          'total': total,
          'files': files,
          'days': days,
          'ids': ids,
          'events': events,
          'etotal': etotal,
          'seen': seen,
        }),
      );
    } catch (_) {}

    final now = DateTime.now();
    DateTime dayShift(DateTime d, int delta) =>
        DateTime(d.year, d.month, d.day + delta);
    final today = (days[keyFor(now)] as num?)?.toInt() ?? 0;
    var streak = 0;
    var cursor = DateTime(now.year, now.month, now.day);
    if (today == 0) cursor = dayShift(cursor, -1);
    while (((days[keyFor(cursor)] as num?)?.toInt() ?? 0) > 0) {
      streak++;
      cursor = dayShift(cursor, -1);
    }
    final recent = <int>[
      for (var i = 13; i >= 0; i--)
        (days[keyFor(dayShift(now, -i))] as num?)?.toInt() ?? 0,
    ];

    Map<String, int> scalarsOn(String key) {
      final b = events[key];
      if (b is! Map) return const {};
      final out = <String, int>{};
      for (final kind in _eventKinds) {
        final v = b[kind];
        if (v is num && v.toInt() != 0) out[kind] = v.toInt();
      }
      return out;
    }

    final todayKey = keyFor(now);
    final weekEvents = <String, int>{};
    final weekLangCount = <String, int>{};
    var lateWeek = false;
    for (var i = 0; i < 7; i++) {
      final b = events[keyFor(dayShift(now, -i))];
      if (b is! Map) continue;
      for (final kind in _eventKinds) {
        final v = b[kind];
        if (v is num) weekEvents[kind] = (weekEvents[kind] ?? 0) + v.toInt();
      }
      if (b['late'] == 1) lateWeek = true;
      final langs = b['lang'];
      if (langs is Map) {
        langs.forEach((lang, cnt) {
          if (cnt is num) {
            weekLangCount[lang as String] =
                (weekLangCount[lang] ?? 0) + cnt.toInt();
          }
        });
      }
    }
    final weekLangs = weekLangCount.keys.toList()
      ..sort((a, b) => weekLangCount[b]!.compareTo(weekLangCount[a]!));
    final lifetimeEvents = <String, int>{
      for (final e in etotal.entries)
        if (e.value is num) e.key: (e.value as num).toInt(),
    };
    final todayBucket = events[todayKey];
    final lateToday = todayBucket is Map && todayBucket['late'] == 1;

    final activeDays = <String>{
      for (final e in days.entries)
        if ((e.value as num?) != null && (e.value as num) > 0) e.key,
    };
    var bestStreak = 0;
    for (final key in activeDays) {
      final parts = key.split('-');
      if (parts.length != 3) continue;
      final d = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      if (activeDays.contains(keyFor(dayShift(d, -1)))) {
        continue;
      }
      var run = 0;
      var walk = d;
      while (activeDays.contains(keyFor(walk))) {
        run++;
        walk = dayShift(walk, 1);
      }
      if (run > bestStreak) bestStreak = run;
    }

    return UsageStats(
      totalTokens: total,
      todayTokens: today,
      streakDays: streak,
      dailyRecent: recent,
      bestStreak: bestStreak,
      todayEvents: scalarsOn(todayKey),
      weekEvents: weekEvents,
      lifetimeEvents: lifetimeEvents,
      weekLangs: weekLangs,
      lateToday: lateToday,
      lateThisWeek: lateWeek,
    );
  }
}
