import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences prefs;

  SharedPreferencesService(this.prefs);
  String? get getUserTheme => prefs.getString('selectedTheme');

  Future<bool> setPreferredTheme(String theme) async {
    try {
      return await prefs.setString('selectedTheme', theme);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
