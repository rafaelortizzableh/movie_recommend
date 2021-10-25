import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/core.dart';
import 'features/movie_flow/movie_flow_export.dart';
import 'features/theme/theme_export.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Builder(
      builder: (BuildContext context) {
        return MaterialApp(
          restorationScopeId: 'app',
          title: 'Movie Recomendation App',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: CustomTheme.lightTheme(),
          darkTheme: CustomTheme.darkTheme(),
          themeMode: ref.watch(themeControllerProvider),
          navigatorKey: AppConstants.navigationKey,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case ThemeView.routeName:
                    return const ThemeView();
                  case MovieFlow.routeName:
                    return const MovieFlow();
                  case ResultScreen.routeName:
                    return const ResultScreenAnimator();
                  default:
                    return const MovieFlow();
                }
              },
            );
          },
        );
      },
    );
  }
}
