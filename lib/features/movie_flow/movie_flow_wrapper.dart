import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'movie_flow_export.dart';

class MovieFlow extends ConsumerWidget {
  const MovieFlow({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageView(
      controller: ref.watch(pageControllerProvider).pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        LandingScreen(),
        GenreScreen(),
        RatingsScreen(),
        YearsBackScreen(),
      ],
    );
  }
}
