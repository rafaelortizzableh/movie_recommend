import 'package:flutter/material.dart';

import '../../core/core.dart';

/// A service that stores and retrieves user theme.
///
/// By default, this class does not persist user theme. If you'd like to
/// persist the user theme locally, use the shared_preferences package. If
/// you'd like to store theme on a web server, use the http package.
class ThemeService {
  final SharedPreferencesService _sharedPreferencesService;
  ThemeService(
    this._sharedPreferencesService,
  );

  /// Loads the User's preferred ThemeMode from local or remote storage.
  ThemeMode themeMode() {
    switch (_sharedPreferencesService.getUserTheme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<bool> updateThemeMode(ThemeMode theme) async {
    switch (theme) {
      case ThemeMode.light:
        return await _sharedPreferencesService.setPreferredTheme('light');
      case ThemeMode.dark:
        return await _sharedPreferencesService.setPreferredTheme('dark');
      case ThemeMode.system:
        return await _sharedPreferencesService.setPreferredTheme('system');
    }
  }
}
