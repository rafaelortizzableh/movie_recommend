import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme_service.dart';

class ThemeController extends StateNotifier<ThemeMode> {
  ThemeController(this._themeService) : super(_themeService.themeMode());
  final ThemeService _themeService;

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (newThemeMode == state) return;

    // Otherwise, store the new theme mode in memory and save it to Shared Preferences
    await _themeService.updateThemeMode(newThemeMode);
    state = newThemeMode;
  }
}
