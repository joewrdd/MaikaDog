import 'package:flutter/material.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'buddy_brain.dart';
import 'buddy_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  launchAtStartup.setup(appName: 'Maika', appPath: '/Applications/Maika.app');
  final prefs = await SharedPreferences.getInstance();
  final brain = BuddyBrain(prefs);
  await brain.initWindow();
  runApp(BuddyApp(brain: brain));
  await brain.initTray();
  await brain.initHotkey();
}

class BuddyApp extends StatelessWidget {
  const BuddyApp({super.key, required this.brain});

  final BuddyBrain brain;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maika',
      debugShowCheckedModeBanner: false,
      color: Colors.transparent,
      home: BuddyShell(brain: brain),
    );
  }
}
