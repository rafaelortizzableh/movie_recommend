import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_export.dart';

class ThemeView extends ConsumerWidget {
  const ThemeView({Key? key}) : super(key: key);

  static const routeName = '/theme';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(themeControllerProvider.notifier);
    final _currentThemeMode = ref.watch(themeControllerProvider);
    final translations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${translations?.theme}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButton<ThemeMode>(
          value: _currentThemeMode,
          onChanged: controller.updateThemeMode,
          items: [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text('${translations?.systemTheme}'),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text('${translations?.lightTheme}'),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text('${translations?.darkTheme}'),
            ),
          ],
        ),
      ),
    );
  }
}
