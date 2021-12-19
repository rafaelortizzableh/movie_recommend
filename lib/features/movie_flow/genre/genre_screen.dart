import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../movie_flow_export.dart';
import '../../../core/core.dart';

class GenreScreen extends ConsumerWidget {
  const GenreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genres = ref.watch(movieFlowControllerProvider).genres;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () =>
                ref.read(pageControllerProvider.notifier).previousPage()),
      ),
      body: genres.when(
          data: (genres) => GenresSelector(genres: genres),
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (error, _) => error is Failure
              ? FailureBody(message: '$error')
              : const SizedBox()),
    );
  }
}

class GenresSelector extends ConsumerWidget {
  const GenresSelector({
    Key? key,
    required this.genres,
  }) : super(key: key);

  final List<Genre> genres;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(kHorizontalPadding),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '${AppLocalizations.of(context)?.genreStartWithGenre}',
                    style: theme.textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: kListItemSpacing),
                itemBuilder: (context, index) {
                  final genre = genres[index];
                  return ListCard(
                    genre: genre,
                    onTap: () {
                      ref
                          .read(movieFlowControllerProvider.notifier)
                          .toggleSelected(genre);
                    },
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: kListItemSpacing,
                ),
                itemCount: genres.length,
              ),
            ),
            PrimaryButton(
              onPressed: () =>
                  ref.read(pageControllerProvider.notifier).nextPage(),
              text: '${AppLocalizations.of(context)?.pageViewContinue}',
            ),
          ],
        ),
      ),
    );
  }
}
