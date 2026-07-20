import 'package:flutter/material.dart';

/// UI-only theme state. Toggled from the Profile screen's
/// "Terminal Night Mode" switch, exactly like the mock shows.
class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggle(bool dark) {
    _mode = dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void set(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }
}
