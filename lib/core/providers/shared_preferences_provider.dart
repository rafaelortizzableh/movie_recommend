import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/shared_preferences_service.dart';

/// Provider of [SharedPreferencesService]. Overriden on main method.
final sharedPreferencesServiceProvider =
    Provider<SharedPreferencesService>((ref) => throw UnimplementedError());
