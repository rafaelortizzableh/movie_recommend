import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/core.dart';
import '../movie_flow_export.dart';

class YearsBackScreen extends ConsumerWidget {
  const YearsBackScreen({
    Key? key,
  }) : super(key: key);
  static const double _yearsBackTextOpacity = 0.62;
  static const int _minRangeValue = 1880;
  static final int _maxRangeValue = DateTime.now().year;
  static final _numberOfDivisions = _maxRangeValue - _minRangeValue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yearsBack = ref.watch(movieFlowControllerProvider).yearsBack;
    final movie = ref.watch(movieFlowControllerProvider).movie;
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
                      '${AppLocalizations.of(context)?.yearsBackPickerTitle}',
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${AppLocalizations.of(context)?.yearsBack}',
                          style: theme.textTheme.headline4?.copyWith(
                              color: theme.textTheme.headline4?.color
                                  ?.withOpacity(_yearsBackTextOpacity)),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${yearsBack.start.ceil()} - ${yearsBack.end.ceil()}',
                          style: theme.textTheme.headline2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RangeSlider(
                      values: yearsBack,
                      min: _minRangeValue.toDouble(),
                      max: _maxRangeValue.toDouble(),
                      divisions: _numberOfDivisions,
                      labels: RangeLabels('${yearsBack.start.ceil()}',
                          '${yearsBack.end.ceil()}'),
                      onChanged: (value) {
                        ref
                            .read(movieFlowControllerProvider.notifier)
                            .updateYearsBack(value);
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              PrimaryButton(
                isLoading: movie.when(
                    data: (_) => false,
                    loading: () => true,
                    error: (_, __) => false),
                onPressed: () async {
                  final l10n = AppLocalizations.of(context);
                  final locale = Localizations.localeOf(context);
                  await ref.read(movieFlowControllerProvider.notifier).getMovie(
                        l10n: l10n,
                        languageCode: locale.languageCode,
                      );
                  Navigator.pushNamed(context, ResultScreen.routeName);
                },
                text: '${AppLocalizations.of(context)?.pageViewContinue}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
