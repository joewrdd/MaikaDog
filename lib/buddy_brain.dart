import 'dart:async';
import 'dart:math' as math;

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import 'cast.dart';
import 'characters/houses/houses.dart';
import 'progression.dart';
import 'sidekick.dart';
import 'usage_tracker.dart';
import 'yard.dart';

const appVersion = '1.0.0';
const windowSize = Size(210, 250);
const dashboardSize = Size(330, 600);
const denSize = Size(270, 300);
const yardSize = Size(420, 300);

enum BuddyMode { idle, walking, tossed, fetching }

class BuddyBrain extends ChangeNotifier with TrayListener {
  BuddyBrain(this._prefs);

  final SharedPreferences _prefs;
  final _battery = Battery();

  BuddyMode mode = BuddyMode.idle;
  CharacterMood? pinnedMood;
  CharacterMood ambientMood = CharacterMood.signature;
  CharacterMood? _reactMood;
  bool holdingYum = false;
  double lean = 0;
  int performNonce = 0;
  int walkDir = 1;
  String? bubbleText;

  bool ghostMode = false;
  bool wanderEnabled = true;
  bool stretchEnabled = true;
  bool hourlyEnabled = true;
  bool launchAtLogin = false;
  bool hidden = false;

  DateTime? pomodoroEnd;

  String petName = 'Maika';
  bool naming = false;
  bool dashboardOpen = false;
  bool statusOpen = false;
  bool denOpen = false;
  bool fieldNotesOpen = false;
  bool dogTagOpen = false;
  bool fieldNotesWeekly = false;
  DogAccessory accessory = DogAccessory.none;
  String houseId = 'kennel';
  bool sidekickEnabled = true;
  bool carryingBall = false;
  int fetchNonce = 0;
  int barkNonce = 0;
  Sidekick? _sidekick;
  final List<({SidekickEvent event, String label, DateTime at})> recentEvents =
      [];
  DateTime? walkStartedAt;

  List<SessionStatus> sessionStatuses() =>
      _sidekick?.snapshot() ?? const <SessionStatus>[];
  int _lastMilestone = 0;

  bool get anyPanelOpen =>
      dashboardOpen || statusOpen || denOpen || fieldNotesOpen || dogTagOpen;

  bool unlockedAt(int req) => level >= req;

  YardService? _yard;

  YardService get yard => _yard!;

  bool get roomLive => _yard?.roomLive ?? false;

  Size get winSize =>
      dashboardOpen || statusOpen || fieldNotesOpen || dogTagOpen
      ? dashboardSize
      : denOpen
      ? roomLive
            ? yardSize
            : denSize
      : windowSize;

  Size _appliedWin = windowSize;

  Future<void> _syncWindow() async {
    final target = winSize;
    if (_appliedWin == target) return;
    final old = _appliedWin;
    _appliedWin = target;
    await windowManager.setSize(target);
    await _refreshWorkArea();
    await _moveTo(
      Offset(
        _pos.dx - (target.width - old.width) / 2,
        _pos.dy - (target.height - old.height),
      ),
    );
  }

  void _onYard() {
    unawaited(_syncWindow());
    notifyListeners();
  }

  Future<void> toggleDashboard() => _togglePanel(0);

  Future<void> toggleStatusBoard() => _togglePanel(1);

  Future<void> toggleDen() async {
    if (denOpen) await _yard?.closeAll(silent: true);
    await _togglePanel(2);
  }

  Future<void> toggleFieldNotes() => _togglePanel(3);

  Future<void> toggleDogTag() => _togglePanel(4);

  void setFieldNotesWeekly(bool weekly) {
    if (fieldNotesWeekly == weekly) return;
    fieldNotesWeekly = weekly;
    notifyListeners();
  }

  Future<void> _togglePanel(int kind) async {
    final next = switch (kind) {
      0 => !dashboardOpen,
      1 => !statusOpen,
      2 => !denOpen,
      3 => !fieldNotesOpen,
      4 => !dogTagOpen,
      _ => false,
    };
    if (next && mode != BuddyMode.idle) {
      _physicsTimer?.cancel();
      mode = BuddyMode.idle;
      lean = 0;
      carryingBall = false;
      _savePos();
    }
    dashboardOpen = kind == 0 && next;
    statusOpen = kind == 1 && next;
    denOpen = kind == 2 && next;
    fieldNotesOpen = kind == 3 && next;
    dogTagOpen = kind == 4 && next;
    await _syncWindow();
    await _rebuildTrayMenu();
    notifyListeners();
  }

  Future<void> selectAccessory(DogAccessory acc) async {
    if (!unlockedAt(acc.level)) return;
    accessory = acc;
    _prefs.setString('accessory', acc.name);
    character = _buildCharacter();
    perform();
    await _rebuildTrayMenu();
    notifyListeners();
  }

  Future<void> selectHouse(String id) async {
    if (!unlockedAt(dogHouseById(id).level)) return;
    houseId = id;
    _prefs.setString('house', id);
    _yard?.announceHouse();
    perform();
    await _rebuildTrayMenu();
    notifyListeners();
  }

  Future<void> throwBall(Offset velocity) async {
    if (mode != BuddyMode.idle || _foodSkin != null || anyPanelOpen) {
      return;
    }
    await _refreshWorkArea();
    mode = BuddyMode.fetching;
    carryingBall = false;
    fetchNonce++;
    final reach = (velocity.dx.abs() * 0.5).clamp(180.0, 900.0);
    final dir = velocity.dx >= 0 ? 1 : -1;
    _walkTargetX = (_pos.dx + dir * reach).clamp(
      _work.left,
      _work.right - winSize.width,
    );
    walkDir = dir;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 650), () {
      if (mode != BuddyMode.fetching) return;
      walkStartedAt = DateTime.now();
      _physicsTimer?.cancel();
      _physicsTimer = Timer.periodic(const Duration(milliseconds: 50), (
        timer,
      ) async {
        final warmup = DateTime.now().difference(walkStartedAt!).inMilliseconds;
        if (warmup < 1250) {
          notifyListeners();
          return;
        }
        final step = 6.4 * walkDir;
        lean = 0.14 * walkDir;
        await _moveTo(Offset(_pos.dx + step, _pos.dy));
        final arrived =
            (walkDir > 0 && _pos.dx >= _walkTargetX) ||
            (walkDir < 0 && _pos.dx <= _walkTargetX);
        if (arrived) {
          timer.cancel();
          carryingBall = true;
          notifyListeners();
          final cursor = await screenRetriever.getCursorScreenPoint();
          _walkTargetX = (cursor.dx - winSize.width / 2).clamp(
            _work.left,
            _work.right - winSize.width,
          );
          walkDir = _walkTargetX > _pos.dx ? 1 : -1;
          await Future.delayed(const Duration(milliseconds: 550));
          if (mode != BuddyMode.fetching) return;
          _physicsTimer = Timer.periodic(const Duration(milliseconds: 50), (
            back,
          ) async {
            final s2 = 6.4 * walkDir;
            lean = 0.14 * walkDir;
            await _moveTo(Offset(_pos.dx + s2, _pos.dy));
            final home =
                (walkDir > 0 && _pos.dx >= _walkTargetX) ||
                (walkDir < 0 && _pos.dx <= _walkTargetX);
            if (home) {
              back.cancel();
              mode = BuddyMode.idle;
              lean = 0;
              carryingBall = false;
              _savePos();
              showBubble('again? again!');
              perform();
            }
            notifyListeners();
          });
        }
        notifyListeners();
      });
    });
  }

  static const _boardEvents = {
    SidekickEvent.completed,
    SidekickEvent.needsInput,
    SidekickEvent.error,
    SidekickEvent.contextLow,
  };

  void _onSidekickEvent(SidekickEvent event, String label) {
    if (!sidekickEnabled) return;
    if (_boardEvents.contains(event)) {
      recentEvents.insert(0, (event: event, label: label, at: DateTime.now()));
      if (recentEvents.length > 10) recentEvents.removeLast();
    }
    if (naming || roomLive) return;
    switch (event) {
      case SidekickEvent.workingStarted:
        showBubble('watching $label…');
      case SidekickEvent.completed:
        showBubble('$label is done!', duration: const Duration(seconds: 7));
        perform();
      case SidekickEvent.needsInput:
        showBubble(
          'woof! $label needs you',
          duration: const Duration(seconds: 8),
        );
        barkNow();
      case SidekickEvent.error:
        showBubble('$label hit an error');
      case SidekickEvent.contextLow:
        showBubble(
          'woof! $label needs a compact soon',
          duration: const Duration(seconds: 8),
        );
        barkNow();
      case SidekickEvent.committed:
        if (showBubble('$label — committed! proud of you', throttle: true)) {
          _flashMood(CharacterMood.joy);
          perform();
        }
      case SidekickEvent.testPassed:
        if (showBubble('$label — tests green! zoomies', throttle: true)) {
          _flashMood(CharacterMood.hype);
          perform();
        }
      case SidekickEvent.testFailed:
        if (showBubble('$label — red tests, we got this', throttle: true)) {
          barkNow();
        }
    }
  }

  UsageStats stats = const UsageStats(
    totalTokens: 0,
    todayTokens: 0,
    streakDays: 0,
  );
  int level = 1;
  String _breedId = 'golden';
  String _coatId = 'golden';
  String? _foodSkin;
  late FoodCharacter character = _buildCharacter();

  Offset _pos = Offset.zero;

  Offset get pos => _pos;
  Rect _work = const Rect.fromLTWH(0, 0, 1440, 900);
  Timer? _physicsTimer;
  Timer? _minuteTimer;
  Timer? _stretchTimer;
  Timer? _pomodoroTimer;
  Timer? _bubbleTimer;
  Timer? _usageTimer;
  Timer? _reactTimer;
  DateTime _lastSpoke = DateTime.fromMillisecondsSinceEpoch(0);
  Offset _velocity = Offset.zero;
  double _walkTargetX = 0;

  FoodCharacter _buildCharacter() {
    final skin = _foodSkin;
    if (skin != null) {
      final food = foodById(skin);
      if (food != null) return food;
    }
    final breed = dogBreedById(_breedId);
    return dogCharacter(breed, breed.coatById(_coatId), accessory: accessory);
  }

  CharacterMood get mood => naming
      ? CharacterMood.joy
      : holdingYum
      ? CharacterMood.yum
      : (pinnedMood ?? _reactMood ?? ambientMood);

  void _flashMood(
    CharacterMood m, {
    Duration hold = const Duration(seconds: 3),
  }) {
    _reactMood = m;
    _reactTimer?.cancel();
    _reactTimer = Timer(hold, () {
      _reactMood = null;
      notifyListeners();
    });
    notifyListeners();
  }

  String get displayName => _foodSkin == null ? petName : character.name;

  String get breedLabel {
    if (_foodSkin != null) return character.name;
    return _breedId == 'golden' ? 'Golden' : dogBreedById(_breedId).name;
  }

  String get coatLabel =>
      _foodSkin != null ? '—' : dogBreedById(_breedId).coatById(_coatId).name;

  String get fitLabel => (_foodSkin != null || accessory == DogAccessory.none)
      ? '—'
      : accessory.label;

  Future<void> startNaming() async {
    if (ghostMode) await _setGhost(false);
    naming = true;
    hidden = false;
    await windowManager.show();
    await windowManager.focus();
    notifyListeners();
  }

  Future<void> finishNaming(String rawName) async {
    final name = rawName.trim();
    if (name.isNotEmpty) {
      petName = name.length > 14 ? name.substring(0, 14) : name;
      _prefs.setString('pet_name', petName);
    } else if (_prefs.getString('pet_name') == null) {
      _prefs.setString('pet_name', petName);
    }
    naming = false;
    showBubble('$petName! i love it');
    perform();
    await _rebuildTrayMenu();
    notifyListeners();
  }

  Future<void> initWindow() async {
    const options = WindowOptions(
      size: windowSize,
      backgroundColor: Colors.transparent,
      skipTaskbar: true,
      alwaysOnTop: true,
    );
    await _refreshWorkArea();
    final savedX = _prefs.getDouble('pos_x');
    final savedY = _prefs.getDouble('pos_y');
    _pos = Offset(
      savedX ?? (_work.right - winSize.width - 60),
      savedY ?? (_work.bottom - winSize.height - 4),
    );
    _pos = _clampToWork(_pos);
    await windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.setAsFrameless();
      await windowManager.setHasShadow(false);
      await windowManager.setVisibleOnAllWorkspaces(
        true,
        visibleOnFullScreen: true,
      );
      await windowManager.setAlwaysOnTop(true);
      await windowManager.setPosition(_pos);
      await windowManager.show();
      await windowManager.setSkipTaskbar(true);
    });
    _startClock();
    _startStretch();
    _maybeGreet();
    _watchBattery();
  }

  Future<void> initTray() async {
    trayManager.addListener(this);
    await trayManager.setIcon('assets/tray_icon.png');
    await _rebuildTrayMenu();
  }

  Future<void> initHotkey() async {
    await hotKeyManager.unregisterAll();
    final key = HotKey(
      key: PhysicalKeyboardKey.keyM,
      modifiers: [HotKeyModifier.alt, HotKeyModifier.meta],
      scope: HotKeyScope.system,
    );
    await hotKeyManager.register(key, keyDownHandler: (_) => summon());
    launchAtLogin = _prefs.getBool('launch_login') ?? false;
    wanderEnabled = _prefs.getBool('wander') ?? true;
    stretchEnabled = _prefs.getBool('stretch') ?? true;
    hourlyEnabled = _prefs.getBool('hourly') ?? true;
    _breedId = _prefs.getString('dog_breed') ?? 'golden';
    _coatId = _prefs.getString('dog_coat') ?? 'golden';
    houseId = _prefs.getString('house') ?? 'kennel';
    _foodSkin = _prefs.getString('food_skin');
    level = _prefs.getInt('level') ?? 1;
    petName = _prefs.getString('pet_name') ?? 'Maika';
    sidekickEnabled = _prefs.getBool('sidekick') ?? true;
    _lastMilestone = _prefs.getInt('milestone') ?? 0;
    accessory = DogAccessory.values.firstWhere(
      (a) => a.name == (_prefs.getString('accessory') ?? 'none'),
      orElse: () => DogAccessory.none,
    );
    if (!unlockedAt(accessory.level)) accessory = DogAccessory.none;
    if (!unlockedAt(dogHouseById(houseId).level)) houseId = 'kennel';
    character = _buildCharacter();
    _sidekick = Sidekick(_onSidekickEvent)..start();
    _yard = YardService(
      selfState: () => YardSelfState(
        name: petName,
        breedId: _breedId,
        coatId: _coatId,
        accessory: accessory.name,
        mood: mood,
      ),
      localHouseId: () => houseId,
    )..addListener(_onYard);
    if (_prefs.getString('pet_name') == null) {
      await startNaming();
    }
    notifyListeners();
    _scanUsage(initial: _prefs.getInt('level') == null);
    _usageTimer = Timer.periodic(
      const Duration(minutes: 3),
      (_) => _scanUsage(),
    );
  }

  Future<void> _scanUsage({bool initial = false}) async {
    UsageStats next;
    try {
      next = await UsageTracker.scan();
    } catch (_) {
      return;
    }
    stats = next;
    const milestones = [
      1000000,
      2000000,
      5000000,
      10000000,
      20000000,
      50000000,
    ];
    for (final m in milestones) {
      if (stats.todayTokens >= m && _lastMilestone < m) {
        _lastMilestone = m;
        _prefs.setInt('milestone', m);
        if (!initial) {
          showBubble('${formatTokens(m)} today!! zoomies earned');
          perform();
        }
      }
    }
    if (stats.todayTokens < 500000 && _lastMilestone != 0) {
      _lastMilestone = 0;
      _prefs.setInt('milestone', 0);
    }
    final newLevel = levelFor(stats.totalTokens);
    if (!initial && newLevel > level) {
      final unlocked = <String>[
        for (var l = level + 1; l <= newLevel; l++) ...unlocksAt(l),
      ];
      level = newLevel;
      _prefs.setInt('level', level);
      showBubble(
        unlocked.isEmpty
            ? 'LEVEL UP! Lv $level'
            : 'Lv $level! Unlocked: ${unlocked.join(', ')}',
        duration: const Duration(seconds: 7),
      );
      perform();
    } else if (newLevel != level || initial) {
      level = newLevel;
      _prefs.setInt('level', level);
    }
    await _rebuildTrayMenu();
    notifyListeners();
  }

  Future<void> _refreshWorkArea() async {
    final display = await screenRetriever.getPrimaryDisplay();
    final origin = display.visiblePosition ?? Offset.zero;
    final size = display.visibleSize ?? display.size;
    _work = Rect.fromLTWH(origin.dx, origin.dy, size.width, size.height);
  }

  Offset _clampToWork(Offset p) => Offset(
    p.dx.clamp(_work.left, _work.right - winSize.width),
    p.dy.clamp(_work.top, _work.bottom - winSize.height),
  );

  bool _moveBusy = false;
  Offset? _movePending;

  Future<void> _moveTo(Offset p) async {
    _pos = _clampToWork(p);
    if (_moveBusy) {
      _movePending = _pos;
      return;
    }
    _moveBusy = true;
    try {
      var target = _pos;
      while (true) {
        await windowManager.setPosition(target);
        final pending = _movePending;
        _movePending = null;
        if (pending == null) break;
        target = pending;
      }
    } finally {
      _moveBusy = false;
    }
  }

  void _savePos() {
    _prefs.setDouble('pos_x', _pos.dx);
    _prefs.setDouble('pos_y', _pos.dy);
  }

  void perform() {
    performNonce++;
    _yard?.performOut();
    notifyListeners();
  }

  void barkNow() {
    barkNonce++;
    _yard?.barkOut();
    notifyListeners();
  }

  void setHoldYum(bool holding) {
    holdingYum = holding;
    notifyListeners();
  }

  Future<void> dragBy(Offset delta) async {
    mode = BuddyMode.idle;
    _physicsTimer?.cancel();
    lean = (lean + delta.dx * 0.003).clamp(-0.3, 0.3);
    await _moveTo(_pos + delta);
    notifyListeners();
  }

  Future<void> dragEnd(Offset velocity) async {
    if (velocity.distance > 750 && !anyPanelOpen && !naming) {
      _velocity = velocity;
      mode = BuddyMode.tossed;
      _startPhysics();
    } else {
      lean = 0;
      _savePos();
    }
    notifyListeners();
  }

  void _startPhysics() {
    _physicsTimer?.cancel();
    _physicsTimer = Timer.periodic(const Duration(milliseconds: 33), (
      timer,
    ) async {
      const dt = 0.033;
      _velocity = Offset(_velocity.dx * 0.995, _velocity.dy + 2600 * dt);
      var next = _pos + _velocity * dt;
      final floor = _work.bottom - winSize.height;
      var grounded = false;
      if (next.dy >= floor) {
        next = Offset(next.dx, floor);
        _velocity = Offset(_velocity.dx * 0.72, -_velocity.dy.abs() * 0.38);
        performNonce++;
        grounded = _velocity.dy.abs() < 140;
      }
      if (next.dx <= _work.left || next.dx >= _work.right - winSize.width) {
        _velocity = Offset(-_velocity.dx * 0.7, _velocity.dy);
      }
      if (next.dy <= _work.top) {
        next = Offset(next.dx, _work.top);
        _velocity = Offset(_velocity.dx, _velocity.dy.abs() * 0.4);
      }
      lean = (_velocity.dx / 1600).clamp(-0.35, 0.35);
      await _moveTo(next);
      if (grounded && _velocity.distance < 160) {
        timer.cancel();
        mode = BuddyMode.idle;
        lean = 0;
        _savePos();
      }
      notifyListeners();
    });
  }

  void _startClock() {
    _minuteTimer?.cancel();
    _minuteTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      final now = DateTime.now();
      final wasMood = ambientMood;
      ambientMood = (now.hour >= 23 || now.hour < 7)
          ? CharacterMood.sleepy
          : CharacterMood.signature;
      if (hourlyEnabled && now.minute == 0 && mode == BuddyMode.idle) {
        perform();
      }
      if (wanderEnabled &&
          mode == BuddyMode.idle &&
          !anyPanelOpen &&
          now.minute % 4 == 2 &&
          math.Random().nextBool()) {
        _startWander();
      }
      if (wasMood != ambientMood) notifyListeners();
    });
  }

  void _startWander() {
    _refreshWorkArea();
    final range = _work.right - winSize.width - _work.left;
    _walkTargetX = _work.left + math.Random().nextDouble() * range;
    walkDir = _walkTargetX > _pos.dx ? 1 : -1;
    mode = BuddyMode.walking;
    walkStartedAt = DateTime.now();
    _physicsTimer?.cancel();
    _physicsTimer = Timer.periodic(const Duration(milliseconds: 50), (
      timer,
    ) async {
      final warmup = DateTime.now().difference(walkStartedAt!).inMilliseconds;
      if (warmup < 1250) {
        notifyListeners();
        return;
      }
      final step = 4.2 * walkDir;
      lean = 0.12 * walkDir;
      await _moveTo(Offset(_pos.dx + step, _pos.dy));
      if ((walkDir > 0 && _pos.dx >= _walkTargetX) ||
          (walkDir < 0 && _pos.dx <= _walkTargetX)) {
        timer.cancel();
        mode = BuddyMode.idle;
        lean = 0;
        _savePos();
        perform();
      }
      notifyListeners();
    });
  }

  Future<void> summon() async {
    await _refreshWorkArea();
    final cursor = await screenRetriever.getCursorScreenPoint();
    hidden = false;
    await windowManager.show();
    await _moveTo(cursor + const Offset(30, -0.6 * 270));
    _savePos();
    perform();
    notifyListeners();
  }

  static const _speechCooldown = Duration(seconds: 90);

  bool showBubble(
    String text, {
    Duration duration = const Duration(seconds: 4),
    bool throttle = false,
  }) {
    final now = DateTime.now();
    if (throttle && now.difference(_lastSpoke) < _speechCooldown) return false;
    _lastSpoke = now;
    bubbleText = text;
    _bubbleTimer?.cancel();
    _bubbleTimer = Timer(duration, () {
      bubbleText = null;
      notifyListeners();
    });
    notifyListeners();
    return true;
  }

  void _maybeGreet() {
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';
    if (now.hour >= 5 &&
        now.hour < 12 &&
        _prefs.getString('last_greet') != today) {
      _prefs.setString('last_greet', today);
      Future.delayed(const Duration(seconds: 2), () {
        if (naming) return;
        showBubble('morning! $petName reporting for duty');
        perform();
      });
    }
  }

  void _startStretch() {
    _stretchTimer?.cancel();
    if (!stretchEnabled) return;
    _stretchTimer = Timer.periodic(const Duration(minutes: 50), (_) {
      if (mode == BuddyMode.idle) {
        showBubble('stretch break? water counts too');
        perform();
      }
    });
  }

  void _watchBattery() {
    Timer.periodic(const Duration(minutes: 5), (_) async {
      try {
        final level = await _battery.batteryLevel;
        final state = await _battery.batteryState;
        if (level <= 15 && state == BatteryState.discharging) {
          showBubble('battery at $level%, maybe plug in?');
        }
      } catch (_) {}
    });
  }

  void startPomodoro() {
    pomodoroEnd = DateTime.now().add(const Duration(minutes: 25));
    _pomodoroTimer?.cancel();
    _pomodoroTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final left = pomodoroEnd!.difference(DateTime.now());
      if (left.isNegative) {
        timer.cancel();
        pomodoroEnd = null;
        bubbleText = null;
        showBubble('focus done! go be free');
        pinnedMood = null;
        perform();
        _rebuildTrayMenu();
      } else {
        final m = left.inMinutes.toString().padLeft(2, '0');
        final s = (left.inSeconds % 60).toString().padLeft(2, '0');
        bubbleText = 'focus $m:$s';
        notifyListeners();
      }
    });
    pinnedMood = CharacterMood.signature;
    _rebuildTrayMenu();
    notifyListeners();
  }

  void cancelPomodoro() {
    _pomodoroTimer?.cancel();
    pomodoroEnd = null;
    bubbleText = null;
    _rebuildTrayMenu();
    notifyListeners();
  }

  Future<void> _setGhost(bool on) async {
    ghostMode = on;
    await windowManager.setIgnoreMouseEvents(on);
    await _rebuildTrayMenu();
    notifyListeners();
  }

  Future<void> _toggleHidden() async {
    hidden = !hidden;
    if (hidden) {
      await windowManager.hide();
    } else {
      await windowManager.show();
    }
    await _rebuildTrayMenu();
  }

  Future<void> _setLaunchAtLogin(bool on) async {
    launchAtLogin = on;
    _prefs.setBool('launch_login', on);
    try {
      if (on) {
        await launchAtStartup.enable();
      } else {
        await launchAtStartup.disable();
      }
    } catch (_) {}
    await _rebuildTrayMenu();
  }

  Future<void> selectFood(String id) async {
    _foodSkin = id;
    _prefs.setString('food_skin', id);
    character = _buildCharacter();
    perform();
    await _rebuildTrayMenu();
    notifyListeners();
  }

  Future<void> selectBreed(String id) async {
    final breed = dogBreedById(id);
    _breedId = id;
    if (!unlockedAt(breed.coatById(_coatId).level) ||
        breed.coats.every((c) => c.id != _coatId)) {
      _coatId = breed.coats.first.id;
    }
    _foodSkin = null;
    _prefs.setString('dog_breed', _breedId);
    _prefs.setString('dog_coat', _coatId);
    _prefs.remove('food_skin');
    character = _buildCharacter();
    perform();
    await _rebuildTrayMenu();
    notifyListeners();
  }

  Future<void> selectCoat(String id) async {
    _coatId = id;
    _foodSkin = null;
    _prefs.setString('dog_coat', _coatId);
    _prefs.remove('food_skin');
    character = _buildCharacter();
    perform();
    await _rebuildTrayMenu();
    notifyListeners();
  }

  Future<void> _rebuildTrayMenu() async {
    final moodItems = <MenuItem>[
      MenuItem.checkbox(
        key: 'mood:auto',
        label: 'Auto',
        checked: pinnedMood == null,
      ),
      for (final m in CharacterMood.values)
        MenuItem.checkbox(
          key: 'mood:${m.name}',
          label: m.label,
          checked: pinnedMood == m,
        ),
    ];
    final breed = dogBreedById(_breedId);
    final dogItems = <MenuItem>[
      for (final b in dogBreeds)
        if (unlockedAt(b.level))
          MenuItem.checkbox(
            key: 'breed:${b.id}',
            label: b.id == 'golden' ? 'Maika (Golden)' : b.name,
            checked: _foodSkin == null && _breedId == b.id,
          )
        else
          MenuItem(
            key: 'locked',
            label: '🔒  ${b.name}  ·  Lv ${b.level}',
            disabled: true,
          ),
    ];
    final coatItems = <MenuItem>[
      for (final c in breed.coats)
        if (unlockedAt(c.level))
          MenuItem.checkbox(
            key: 'coat:${c.id}',
            label: c.name,
            checked: _foodSkin == null && _coatId == c.id,
          )
        else
          MenuItem(
            key: 'locked',
            label: '🔒  ${c.name}  ·  Lv ${c.level}',
            disabled: true,
          ),
    ];
    final skinItems = <MenuItem>[
      for (final family in characterFamilies)
        MenuItem.submenu(
          label: family.name,
          submenu: Menu(
            items: [
              for (final c in family.members)
                MenuItem.checkbox(
                  key: 'food:${c.id}',
                  label: c.name,
                  checked: character.id == c.id,
                ),
            ],
          ),
        ),
    ];
    final next = nextThresholdFor(level);
    final progress = next == null
        ? ''
        : '  ·  ${formatTokens((next - stats.totalTokens).clamp(0, next))} to Lv ${level + 1}';
    await trayManager.setContextMenu(
      Menu(
        items: [
          MenuItem(
            key: 'stats',
            label:
                'Lv $level  ·  ${formatTokens(stats.totalTokens)} XP$progress',
            disabled: true,
          ),
          MenuItem(
            key: 'stats2',
            label:
                'today ${formatTokens(stats.todayTokens)}  ·  streak ${stats.streakDays}d',
            disabled: true,
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'dashboard',
            label: dashboardOpen ? 'Close dashboard' : 'Dashboard',
          ),
          MenuItem(
            key: 'status',
            label: statusOpen ? 'Close activity' : 'Activity board',
          ),
          MenuItem(
            key: 'fieldnotes',
            label: fieldNotesOpen ? 'Close field notes' : 'Field notes',
          ),
          MenuItem(
            key: 'dogtag',
            label: dogTagOpen ? 'Close dog tag' : 'Dog tag',
          ),
          MenuItem(key: 'summon', label: 'Summon  (⌥⌘M)'),
          MenuItem(key: 'perform', label: 'Do a trick'),
          MenuItem(key: 'walk', label: 'Go for a walk'),
          MenuItem(
            key: 'den',
            label: denOpen ? 'Back outside' : 'Take her home',
          ),
          if (kDebugMode) MenuItem(key: 'phantom', label: 'Ghost pup (debug)'),
          MenuItem(
            key: 'hide',
            label: hidden ? 'Show $displayName' : 'Hide $displayName',
          ),
          MenuItem(key: 'rename', label: 'Rename $petName…'),
          MenuItem.separator(),
          MenuItem.submenu(
            label: 'Dog',
            submenu: Menu(items: dogItems),
          ),
          MenuItem.submenu(
            label: 'Coat',
            submenu: Menu(items: coatItems),
          ),
          MenuItem.submenu(
            label: 'Wardrobe',
            submenu: Menu(
              items: [
                MenuItem.checkbox(
                  key: 'acc:none',
                  label: DogAccessory.none.label,
                  checked: accessory == DogAccessory.none,
                ),
                for (final cat in DogAccessoryCategory.values)
                  MenuItem.submenu(
                    label: cat.label,
                    submenu: Menu(
                      items: [
                        for (final acc in DogAccessory.values)
                          if (acc != DogAccessory.none && acc.category == cat)
                            if (unlockedAt(acc.level))
                              MenuItem.checkbox(
                                key: 'acc:${acc.name}',
                                label: acc.label,
                                checked: accessory == acc,
                              )
                            else
                              MenuItem(
                                key: 'locked',
                                label:
                                    '\u{1F512}  ${acc.label}  \u{00B7}  Lv ${acc.level}',
                                disabled: true,
                              ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          MenuItem.submenu(
            label: 'House',
            submenu: Menu(
              items: [
                for (final h in dogHouses)
                  if (unlockedAt(h.level))
                    MenuItem.checkbox(
                      key: 'house:${h.id}',
                      label: h.name,
                      checked: houseId == h.id,
                    )
                  else
                    MenuItem(
                      key: 'locked',
                      label: '\u{1F512}  ${h.name}  \u{00B7}  Lv ${h.level}',
                      disabled: true,
                    ),
              ],
            ),
          ),
          MenuItem.submenu(
            label: 'Mood',
            submenu: Menu(items: moodItems),
          ),
          MenuItem.submenu(
            label: 'Flavor Folk',
            submenu: Menu(items: skinItems),
          ),
          MenuItem.separator(),
          pomodoroEnd == null
              ? MenuItem(key: 'pomodoro', label: 'Start 25 min focus')
              : MenuItem(key: 'pomodoro_cancel', label: 'Cancel focus timer'),
          MenuItem.checkbox(
            key: 'sidekick',
            label: 'Coding sidekick',
            checked: sidekickEnabled,
          ),
          MenuItem.checkbox(
            key: 'stretch',
            label: 'Stretch reminders',
            checked: stretchEnabled,
          ),
          MenuItem.checkbox(
            key: 'wander',
            label: 'Wandering',
            checked: wanderEnabled,
          ),
          MenuItem.checkbox(
            key: 'hourly',
            label: 'Hourly trick',
            checked: hourlyEnabled,
          ),
          MenuItem.separator(),
          MenuItem.checkbox(
            key: 'ghost',
            label: 'Ghost mode (click-through)',
            checked: ghostMode,
          ),
          MenuItem.checkbox(
            key: 'login',
            label: 'Launch at login',
            checked: launchAtLogin,
          ),
          MenuItem.separator(),
          MenuItem(key: 'quit', label: 'Quit'),
        ],
      ),
    );
  }

  @override
  void onTrayIconMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  Future<void> onTrayMenuItemClick(MenuItem menuItem) async {
    final key = menuItem.key ?? '';
    if (key.startsWith('mood:')) {
      final name = key.substring(5);
      pinnedMood = name == 'auto'
          ? null
          : CharacterMood.values.firstWhere((m) => m.name == name);
      await _rebuildTrayMenu();
      notifyListeners();
      return;
    }
    if (key.startsWith('food:')) {
      await selectFood(key.substring(5));
      return;
    }
    if (key.startsWith('breed:')) {
      await selectBreed(key.substring(6));
      return;
    }
    if (key.startsWith('coat:')) {
      await selectCoat(key.substring(5));
      return;
    }
    if (key.startsWith('house:')) {
      await selectHouse(key.substring(6));
      return;
    }
    if (key.startsWith('acc:')) {
      final acc = DogAccessory.values.firstWhere(
        (a) => a.name == key.substring(4),
        orElse: () => DogAccessory.none,
      );
      await selectAccessory(acc);
      return;
    }
    switch (key) {
      case 'summon':
        await summon();
      case 'perform':
        perform();
      case 'walk':
        if (mode == BuddyMode.idle && !anyPanelOpen) {
          _startWander();
        }
      case 'den':
        await toggleDen();
      case 'phantom':
        if (!denOpen) await _togglePanel(2);
        _yard?.debugAddPhantom();
      case 'rename':
        await startNaming();
      case 'dashboard':
        await toggleDashboard();
      case 'status':
        await toggleStatusBoard();
      case 'fieldnotes':
        await toggleFieldNotes();
      case 'dogtag':
        await toggleDogTag();
      case 'sidekick':
        sidekickEnabled = !sidekickEnabled;
        _prefs.setBool('sidekick', sidekickEnabled);
        await _rebuildTrayMenu();
      case 'hide':
        await _toggleHidden();
      case 'pomodoro':
        startPomodoro();
      case 'pomodoro_cancel':
        cancelPomodoro();
      case 'stretch':
        stretchEnabled = !stretchEnabled;
        _prefs.setBool('stretch', stretchEnabled);
        _startStretch();
        await _rebuildTrayMenu();
      case 'wander':
        wanderEnabled = !wanderEnabled;
        _prefs.setBool('wander', wanderEnabled);
        await _rebuildTrayMenu();
      case 'hourly':
        hourlyEnabled = !hourlyEnabled;
        _prefs.setBool('hourly', hourlyEnabled);
        await _rebuildTrayMenu();
      case 'ghost':
        await _setGhost(!ghostMode);
      case 'login':
        await _setLaunchAtLogin(!launchAtLogin);
      case 'quit':
        await trayManager.destroy();
        await windowManager.destroy();
    }
  }

  @override
  void dispose() {
    _physicsTimer?.cancel();
    _minuteTimer?.cancel();
    _stretchTimer?.cancel();
    _pomodoroTimer?.cancel();
    _bubbleTimer?.cancel();
    _usageTimer?.cancel();
    _reactTimer?.cancel();
    _sidekick?.stop();
    _yard?.dispose();
    trayManager.removeListener(this);
    super.dispose();
  }
}
