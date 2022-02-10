import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/core.dart';
import '../movie_flow_export.dart';

class RatingsScreen extends ConsumerWidget {
  const RatingsScreen({
    Key? key,
  }) : super(key: key);

  static const _minRangeValue = 1.0;
  static const _maxRangeValue = 10.0;
  static const _starIconSize = 62.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rating = ref.watch(movieFlowControllerProvider).rating;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () =>
                ref.read(pageControllerProvider.notifier).previousPage()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.horizontalPadding),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      '${AppLocalizations.of(context)?.ratingPickRating}',
                      style: theme.textTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${rating.ceil()}',
                    style: theme.textTheme.headline2,
                  ),
                  const Icon(Icons.star_rounded,
                      color: Colors.amber, size: _starIconSize)
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Slider(
                      value: rating.toDouble(),
                      min: _minRangeValue,
                      max: _maxRangeValue,
                      divisions: _maxRangeValue.toInt(),
                      label: '${rating.ceil()}',
                      onChanged: (value) {
                        ref
                            .read(movieFlowControllerProvider.notifier)
                            .updateRating(value.ceil());
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () =>
                    ref.read(pageControllerProvider.notifier).nextPage(),
                text: '${AppLocalizations.of(context)?.pageViewContinue}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
