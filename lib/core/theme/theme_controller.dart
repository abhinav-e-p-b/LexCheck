import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  bool get isDark => state == ThemeMode.dark;

  void toggle(bool dark) {
    state = dark ? ThemeMode.dark : ThemeMode.light;
  }

  void setMode(ThemeMode mode) {
    state = mode;
  }
}
