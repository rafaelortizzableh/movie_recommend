import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'movie_flow_export.dart';

class MovieFlow extends ConsumerWidget {
  const MovieFlow({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return PageView(
      controller: ref.watch(pageControllerProvider).pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const LandingScreen(),
        GenreScreen(l10n: l10n, locale: locale),
        const RatingsScreen(),
        const YearsBackScreen(),
      ],
    );
  }
}
