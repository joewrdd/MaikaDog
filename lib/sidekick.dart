import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show visibleForTesting;

import 'code_events.dart';

enum SidekickEvent {
  workingStarted,
  completed,
  needsInput,
  error,
  contextLow,
  committed,
  testPassed,
  testFailed,
}

enum SessionState { working, waiting, done, error, idle }

class SessionStatus {
  const SessionStatus({
    required this.label,
    required this.state,
    required this.since,
    this.context = 0,
  });

  final String label;
  final SessionState state;
  final DateTime since;
  final double context;
}

class _SessionTrack {
  int size = 0;
  String folder = '';
  String branch = '';
  bool identityDone = false;
  DateTime lastGrowth = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime firstGrowth = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime? tailAt;
  String lastType = '';
  String lastStop = '';
  int contextTokens = 0;
  bool contextWarned = false;
  bool completionFired = false;
  bool errorFired = false;
  String lastCodeSig = '';
  int waitingNags = 0;
  DateTime lastNag = DateTime.fromMillisecondsSinceEpoch(0);
  bool announcedWorking = false;
  DateTime? discoveredAt;
}

class Sidekick {
  Sidekick(
    this.onEvent, {
    String? projectsDirOverride,
    this._frontAppOverride,
    Map<String, int>? Function()? liveProbeOverride,
    this.workingWindow = const Duration(seconds: 15),
    this.announceAfter = const Duration(seconds: 20),
    this.completionQuietMin = const Duration(seconds: 20),
    this.completionQuietMax = const Duration(seconds: 90),
    this.completionMinRun = const Duration(seconds: 90),
    this.nagQuietMin = const Duration(seconds: 45),
    this.nagQuietMax = const Duration(minutes: 10),
    this.nagMinRun = const Duration(seconds: 10),
    this.nagInterval = const Duration(seconds: 90),
    this.contextWarnTokens = 160000,
  }) : _liveOverride = liveProbeOverride,
       _projectsDir =
           projectsDirOverride ??
           '${Platform.environment['HOME'] ?? ''}/.claude/projects';

  final void Function(SidekickEvent event, String label) onEvent;
  final String _projectsDir;
  final String? Function()? _frontAppOverride;
  final Map<String, int>? Function()? _liveOverride;
  final Duration workingWindow;
  final Duration announceAfter;
  final Duration completionQuietMin;
  final Duration completionQuietMax;
  final Duration completionMinRun;
  final Duration nagQuietMin;
  final Duration nagQuietMax;
  final Duration nagMinRun;
  final Duration nagInterval;
  final int contextWarnTokens;

  static const _contentFresh = Duration(minutes: 5);
  static const _identityReadBytes = 65536;
  static const _tailReadBytes = 16384;
  static const _terminalApps = {
    'Terminal',
    'iTerm2',
    'Warp',
    'kitty',
    'Alacritty',
    'Ghostty',
    'Code',
    'Cursor',
    'WezTerm',
  };

  final _tracks = <String, _SessionTrack>{};
  Timer? _timer;
  Timer? _debounce;
  StreamSubscription<FileSystemEvent>? _watch;
  int? _learnedCeiling;
  int _maxUsage = 0;
  bool _anyWorking = false;
  String? _frontApp;
  DateTime _frontAppAt = DateTime.fromMillisecondsSinceEpoch(0);
  Map<String, int>? _liveByProject;
  DateTime _liveAt = DateTime.fromMillisecondsSinceEpoch(0);
  bool _probing = false;

  bool get anyWorking => _anyWorking;

  Map<String, int>? get _live {
    final override = _liveOverride;
    if (override != null) return override();
    final data = _liveByProject;
    if (data == null) return null;
    if (DateTime.now().difference(_liveAt) > const Duration(seconds: 45)) {
      return null;
    }
    return data;
  }

  Map<String, int>? get _liveForDisplay {
    final override = _liveOverride;
    if (override != null) return override();
    final data = _liveByProject;
    if (data == null) return null;
    if (DateTime.now().difference(_liveAt) > const Duration(minutes: 10)) {
      return null;
    }
    return data;
  }

  static String _projOf(String path) {
    final parts = path.split('/');
    return parts.length < 2 ? '' : parts[parts.length - 2];
  }

  Future<void> _probeLive() async {
    if (_probing) return;
    _probing = true;
    try {
      final ps = await Process.run('ps', [
        '-xo',
        'pid=,comm=',
      ]).timeout(const Duration(seconds: 10));
      if (ps.exitCode != 0) return;
      final pids = <String>[];
      for (final line in const LineSplitter().convert(ps.stdout.toString())) {
        final entry = line.trim();
        final split = entry.indexOf(' ');
        if (split <= 0) continue;
        final comm = entry.substring(split + 1).trim();
        if (comm == 'claude' || comm.endsWith('/claude')) {
          pids.add(entry.substring(0, split));
        }
      }
      if (pids.isEmpty) {
        _liveByProject = {};
        _liveAt = DateTime.now();
        return;
      }
      final lsof = await Process.run('lsof', [
        '-b',
        '-a',
        '-p',
        pids.join(','),
        '-d',
        'cwd',
        '-Fn',
      ]).timeout(const Duration(seconds: 10));
      final counts = <String, int>{};
      for (final line in const LineSplitter().convert(lsof.stdout.toString())) {
        if (!line.startsWith('n')) continue;
        final proj = line.substring(1).replaceAll(RegExp(r'[^a-zA-Z0-9]'), '-');
        counts[proj] = (counts[proj] ?? 0) + 1;
      }
      if (counts.isEmpty) return;
      _liveByProject = counts;
      _liveAt = DateTime.now();
    } catch (_) {
    } finally {
      _probing = false;
    }
  }

  int get _warnTokens {
    final ceiling = _learnedCeiling;
    if (ceiling != null && ceiling > 30000) return ceiling * 88 ~/ 100;
    if (_maxUsage > 200000) return 800000;
    return contextWarnTokens;
  }

  double get _windowTokens {
    final ceiling = _learnedCeiling;
    if (ceiling != null && ceiling > 30000) return ceiling.toDouble();
    return _maxUsage > 200000 ? 1000000.0 : 200000.0;
  }

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      unawaited(_probeLive());
      _scan();
    });
    unawaited(_probeLive());
    try {
      _watch = Directory(_projectsDir).watch(recursive: true).listen((event) {
        if (!event.path.endsWith('.jsonl')) return;
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 300), _scan);
      });
    } catch (_) {}
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _debounce?.cancel();
    _debounce = null;
    _watch?.cancel();
    _watch = null;
  }

  @visibleForTesting
  void scanOnce() => _scan();

  void _scan() {
    final projects = Directory(_projectsDir);
    List<FileSystemEntity> projectDirs;
    try {
      projectDirs = projects.listSync();
    } catch (_) {
      return;
    }
    final now = DateTime.now();
    final live = _live;
    var working = false;
    for (final projectDir in projectDirs) {
      if (projectDir is! Directory) continue;
      List<FileSystemEntity> entries;
      try {
        entries = projectDir.listSync();
      } catch (_) {
        continue;
      }
      for (final entity in entries) {
        if (entity is! File || !entity.path.endsWith('.jsonl')) continue;
        working = _checkSession(entity, now, live) || working;
      }
    }
    _tracks.removeWhere((path, t) {
      final quiet = now.difference(t.lastGrowth);
      final count = live == null ? null : (live[_projOf(path)] ?? 0);
      if (count != null && count > 0) return quiet > const Duration(hours: 24);
      if (count == 0) return quiet > const Duration(minutes: 2);
      return quiet >
          ((t.completionFired || t.errorFired)
              ? const Duration(hours: 6)
              : const Duration(minutes: 30));
    });
    if (live != null) _discoverIdle(projectDirs, live, now);
    _anyWorking = working;
  }

  void _discoverIdle(
    List<FileSystemEntity> projectDirs,
    Map<String, int> live,
    DateTime now,
  ) {
    for (final projectDir in projectDirs) {
      if (projectDir is! Directory) continue;
      final name = projectDir.path.split('/').last;
      final want = live[name] ?? 0;
      if (want == 0) continue;
      final have = _tracks.keys.where((k) => _projOf(k) == name).length;
      if (have >= want) continue;
      final candidates = <(File, DateTime)>[];
      try {
        for (final entity in projectDir.listSync()) {
          if (entity is! File || !entity.path.endsWith('.jsonl')) continue;
          if (_tracks.containsKey(entity.path)) continue;
          final modified = entity.statSync().modified;
          if (now.difference(modified) > const Duration(hours: 24)) continue;
          candidates.add((entity, modified));
        }
      } catch (_) {
        continue;
      }
      candidates.sort((a, b) => b.$2.compareTo(a.$2));
      for (final (file, modified) in candidates.take(want - have)) {
        try {
          final size = file.lengthSync();
          final track = _tracks.putIfAbsent(file.path, () => _SessionTrack());
          track.discoveredAt = now;
          _loadIdentity(file, track);
          track.size = size;
          track.firstGrowth = modified;
          track.lastGrowth = modified;
          track.lastType = _tailType(file, size, track, now);
        } catch (_) {}
      }
    }
  }

  List<SessionStatus> snapshot() {
    final now = DateTime.now();
    final live = _liveForDisplay;
    final rankByPath = <String, int>{};
    if (live != null) {
      final byProject = <String, List<MapEntry<String, _SessionTrack>>>{};
      for (final entry in _tracks.entries) {
        byProject.putIfAbsent(_projOf(entry.key), () => []).add(entry);
      }
      for (final group in byProject.values) {
        group.sort((a, b) => b.value.lastGrowth.compareTo(a.value.lastGrowth));
        for (var i = 0; i < group.length; i++) {
          rankByPath[group[i].key] = i;
        }
      }
    }
    final rows = <SessionStatus>[];
    for (final entry in _tracks.entries) {
      final track = entry.value;
      if (track.folder.isEmpty) continue;
      final sinceGrowth = now.difference(track.lastGrowth);
      final growing = sinceGrowth < workingWindow;
      final liveCount = live == null ? null : (live[_projOf(entry.key)] ?? 0);
      if (liveCount != null && !growing) {
        if (liveCount == 0) continue;
        if ((rankByPath[entry.key] ?? 0) >= liveCount) continue;
      }
      final inFlight =
          track.lastType == 'user' ||
          (track.lastType == 'assistant' && track.lastStop != 'end_turn');
      SessionState? state;
      if (track.errorFired) {
        state = SessionState.error;
      } else if (growing || (inFlight && sinceGrowth < nagQuietMax)) {
        state = SessionState.working;
      } else if (track.completionFired) {
        state = SessionState.done;
      } else if (track.lastType == 'assistant' &&
          sinceGrowth >= nagQuietMin &&
          sinceGrowth < nagQuietMax) {
        state = SessionState.waiting;
      } else if (liveCount != null && liveCount > 0) {
        state = SessionState.idle;
      }
      if (state == null) continue;
      final discovered = track.discoveredAt;
      final since =
          state == SessionState.idle &&
              discovered != null &&
              discovered.isAfter(track.lastGrowth)
          ? discovered
          : track.lastGrowth;
      rows.add(
        SessionStatus(
          label: _labelFor(track),
          state: state,
          since: since,
          context: (track.contextTokens / _windowTokens).clamp(0.0, 1.0),
        ),
      );
    }
    rows.sort((a, b) {
      final order = a.state.index.compareTo(b.state.index);
      if (order != 0) return order;
      return b.since.compareTo(a.since);
    });
    return rows;
  }

  bool _checkSession(File entity, DateTime now, Map<String, int>? live) {
    FileStat stat;
    try {
      stat = entity.statSync();
    } catch (_) {
      return false;
    }
    final projDead = live != null && (live[_projOf(entity.path)] ?? 0) == 0;
    if (now.difference(stat.modified) > const Duration(minutes: 5)) {
      return false;
    }
    final track = _tracks.putIfAbsent(entity.path, () => _SessionTrack());
    if (!track.identityDone) _loadIdentity(entity, track);
    if (stat.size != track.size) {
      if (track.firstGrowth.millisecondsSinceEpoch == 0 ||
          now.difference(track.lastGrowth) > const Duration(seconds: 120)) {
        track.firstGrowth = now;
        track.completionFired = false;
        track.errorFired = false;
        track.announcedWorking = false;
      }
      track.size = stat.size;
      track.waitingNags = 0;
      track.lastType = _tailType(entity, stat.size, track, now);
      final tailAt = track.tailAt;
      final fresh = tailAt == null || now.difference(tailAt) <= _contentFresh;
      track.lastGrowth = fresh ? now : tailAt;
      if (fresh) {
        if (track.lastType == 'user') track.completionFired = false;
        final warnAt = _warnTokens;
        if (track.contextTokens < warnAt ~/ 2) {
          track.contextWarned = false;
        }
        if (!track.contextWarned &&
            track.contextTokens >= warnAt &&
            !_terminalIsFront()) {
          track.contextWarned = true;
          onEvent(SidekickEvent.contextLow, _labelFor(track));
        }
      }
    }
    final sinceGrowth = now.difference(track.lastGrowth);
    final ranFor = track.lastGrowth.difference(track.firstGrowth);
    var working = false;
    if (sinceGrowth < workingWindow) {
      working = true;
      if (!track.announcedWorking && ranFor > announceAfter) {
        track.announcedWorking = true;
        onEvent(SidekickEvent.workingStarted, _labelFor(track));
      }
    }
    if (!track.completionFired &&
        sinceGrowth < completionQuietMax &&
        (projDead || sinceGrowth >= completionQuietMin) &&
        ranFor >= completionMinRun &&
        track.lastType == 'assistant' &&
        track.lastStop == 'end_turn') {
      track.completionFired = true;
      onEvent(SidekickEvent.completed, _labelFor(track));
    }
    if (!projDead &&
        sinceGrowth >= nagQuietMin &&
        sinceGrowth < nagQuietMax &&
        track.lastType == 'assistant' &&
        track.lastStop == 'end_turn' &&
        ranFor >= nagMinRun &&
        track.waitingNags < 3 &&
        now.difference(track.lastNag) >= nagInterval &&
        !_terminalIsFront()) {
      track.waitingNags++;
      track.lastNag = now;
      onEvent(SidekickEvent.needsInput, _labelFor(track));
    }
    return working;
  }

  bool _terminalIsFront() {
    final override = _frontAppOverride;
    final name = override != null ? override() : _lsappinfoFrontName();
    return name != null && _terminalApps.contains(name);
  }

  String? _lsappinfoFrontName() {
    final now = DateTime.now();
    if (now.difference(_frontAppAt) < const Duration(seconds: 5)) {
      return _frontApp;
    }
    _frontAppAt = now;
    _frontApp = null;
    try {
      final front = Process.runSync('lsappinfo', ['front']);
      final asn = front.stdout.toString().trim();
      if (front.exitCode != 0 || asn.isEmpty) return null;
      final info = Process.runSync('lsappinfo', ['info', '-only', 'name', asn]);
      if (info.exitCode != 0) return null;
      _frontApp = RegExp(
        r'"LSDisplayName"\s*=\s*"([^"]*)"',
      ).firstMatch(info.stdout.toString())?.group(1);
    } catch (_) {
      _frontApp = null;
    }
    return _frontApp;
  }

  void _loadIdentity(File file, _SessionTrack track) {
    try {
      final len = file.lengthSync();
      final raf = file.openSync();
      final bytes = raf.readSync(
        len > _identityReadBytes ? _identityReadBytes : len,
      );
      raf.closeSync();
      final lines = const LineSplitter().convert(
        utf8.decode(bytes, allowMalformed: true),
      );
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        Map<String, dynamic> obj;
        try {
          obj = jsonDecode(line) as Map<String, dynamic>;
        } catch (_) {
          continue;
        }
        final cwd = obj['cwd'];
        if (cwd is String && cwd.isNotEmpty && track.folder.isEmpty) {
          track.folder = cwd.split('/').last;
        }
        final branch = obj['gitBranch'];
        if (branch is String &&
            branch.isNotEmpty &&
            branch != 'HEAD' &&
            track.branch.isEmpty) {
          track.branch = branch;
        }
        if (track.folder.isNotEmpty && track.branch.isNotEmpty) {
          break;
        }
      }
      track.identityDone = track.folder.isNotEmpty || len >= _identityReadBytes;
    } catch (_) {}
  }

  String _pathOf(_SessionTrack track) {
    for (final entry in _tracks.entries) {
      if (identical(entry.value, track)) return entry.key;
    }
    return '';
  }

  String _labelFor(_SessionTrack track) {
    if (track.folder.isEmpty) return 'a session';
    final now = DateTime.now();
    final siblings = _tracks.values.where(
      (t) =>
          t != track &&
          t.folder == track.folder &&
          now.difference(t.lastGrowth).inMinutes < 10,
    );
    if (siblings.isEmpty) return track.folder;
    final branchClash = siblings.any((t) => t.branch == track.branch);
    if (!branchClash && track.branch.isNotEmpty) {
      return '${track.folder} (${track.branch})';
    }
    final peers = <_SessionTrack>[
      for (final t in _tracks.values)
        if (t.folder == track.folder && t.branch == track.branch) t,
    ];
    peers.sort((a, b) {
      final byAge = a.firstGrowth.compareTo(b.firstGrowth);
      return byAge != 0 ? byAge : _pathOf(a).compareTo(_pathOf(b));
    });
    final seat = peers.indexOf(track) + 1;
    return seat > 1 ? '${track.folder} ($seat)' : track.folder;
  }

  String _tailType(File file, int size, _SessionTrack track, DateTime now) {
    try {
      final raf = file.openSync();
      final from = size > _tailReadBytes ? size - _tailReadBytes : 0;
      raf.setPositionSync(from);
      final bytes = raf.readSync(size - from);
      raf.closeSync();
      final lines = const LineSplitter()
          .convert(utf8.decode(bytes, allowMalformed: true))
          .where((l) => l.trim().isNotEmpty)
          .toList();
      String? newestType;
      var usageSettled = false;
      var sawError = false;
      var branchSeen = false;
      var folderSeen = false;
      final failedIds = <String>{};
      final resultIds = <String>{};
      CodeEvent? headline;
      track.tailAt = null;
      for (final line in lines.reversed) {
        Map<String, dynamic> obj;
        try {
          obj = jsonDecode(line) as Map<String, dynamic>;
        } catch (_) {
          continue;
        }
        if (track.tailAt == null) {
          final ts = obj['timestamp'];
          if (ts is String) track.tailAt = DateTime.tryParse(ts);
        }
        for (final ev in classifyEntry(obj)) {
          if (ev.kind == 'error') {
            final id = ev.toolUseId;
            if (id != null) {
              failedIds.add(id);
              resultIds.add(id);
            }
          } else if (ev.kind == 'result') {
            final id = ev.toolUseId;
            if (id != null) resultIds.add(id);
          } else if (headline == null &&
              (ev.kind == 'commit' || ev.kind == 'test')) {
            headline = ev;
          }
        }
        if (!branchSeen) {
          final branch = obj['gitBranch'];
          if (branch is String && branch.isNotEmpty && branch != 'HEAD') {
            track.branch = branch;
            branchSeen = true;
          }
        }
        if (!folderSeen) {
          final cwd = obj['cwd'];
          if (cwd is String && cwd.isNotEmpty) {
            track.folder = cwd.split('/').last;
            folderSeen = true;
          }
        }
        final type = obj['type'];
        if (type == 'system') {
          final subtype = obj['subtype'];
          if (subtype == 'api_error' && newestType == null) {
            sawError = true;
          }
          if (subtype == 'compact_boundary') {
            if (!usageSettled) {
              track.contextTokens = 0;
              track.contextWarned = false;
            }
            final meta = obj['compactMetadata'];
            if (meta is Map<String, dynamic> && meta['preTokens'] is int) {
              final pre = meta['preTokens'] as int;
              if (pre > _maxUsage) _maxUsage = pre;
              if (meta['trigger'] == 'auto') _learnedCeiling = pre;
            }
            break;
          }
          continue;
        }
        if (type == 'assistant') {
          if (newestType == null) {
            newestType = 'assistant';
            final message = obj['message'];
            track.lastStop = message is Map<String, dynamic>
                ? (message['stop_reason'] as String? ?? '')
                : '';
            if (_assistantApiError(obj)) sawError = true;
          }
          if (!usageSettled && obj['isSidechain'] != true) {
            final tokens = _usageTokens(obj);
            if (tokens != null) {
              track.contextTokens = tokens;
              if (tokens > _maxUsage) _maxUsage = tokens;
              usageSettled = true;
            }
          }
        } else if (type == 'user') {
          newestType ??= 'user';
        }
      }
      if (sawError) {
        final at = track.tailAt;
        if (at == null || now.difference(at) <= _contentFresh) {
          _fireError(track);
        }
      }
      final h = headline;
      if (h != null) {
        final resultReady =
            h.kind == 'commit' || resultIds.contains(h.toolUseId);
        final at = track.tailAt;
        final fresh = at == null || now.difference(at) <= _contentFresh;
        final sig = '${h.kind}:${h.toolUseId}';
        if (resultReady &&
            fresh &&
            sig != track.lastCodeSig &&
            !_terminalIsFront()) {
          track.lastCodeSig = sig;
          final evt = h.kind == 'commit'
              ? SidekickEvent.committed
              : failedIds.contains(h.toolUseId)
              ? SidekickEvent.testFailed
              : SidekickEvent.testPassed;
          onEvent(evt, _labelFor(track));
        }
      }
      if (newestType != null) return newestType;
    } catch (_) {}
    return track.lastType;
  }

  int? _usageTokens(Map<String, dynamic> obj) {
    final message = obj['message'];
    if (message is! Map<String, dynamic>) return null;
    final usage = message['usage'];
    if (usage is! Map<String, dynamic>) return null;
    var total = 0;
    for (final key in const [
      'input_tokens',
      'cache_creation_input_tokens',
      'cache_read_input_tokens',
      'output_tokens',
    ]) {
      final value = usage[key];
      if (value is int) total += value;
    }
    return total == 0 ? null : total;
  }

  bool _assistantApiError(Map<String, dynamic> obj) {
    final message = obj['message'];
    if (message is! Map<String, dynamic>) return false;
    final content = message['content'];
    if (content is! List) return false;
    for (final block in content) {
      if (block is Map && block['type'] == 'text') {
        final text = block['text'];
        if (text is String && text.startsWith('API Error')) return true;
      }
    }
    return false;
  }

  void _fireError(_SessionTrack track) {
    if (track.errorFired) return;
    track.errorFired = true;
    onEvent(SidekickEvent.error, _labelFor(track));
  }
}
