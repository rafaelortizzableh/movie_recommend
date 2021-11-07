import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recommended_movie_export.dart';
import '../movie_flow_export.dart';

class RecommendedMovieWidget extends ConsumerWidget {
  const RecommendedMovieWidget({Key? key}) : super(key: key);
  static const _padding8 = 8.0;
  static const _padding16 = 16.0;
  static const _radius16 = 16.0;
  static const _maxHeightFactor = 0.8;
  static const _backgroundColorOpacity = 0.75;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final recommendedMovieState = ref.watch(recommendedMovieProvider);
    if (recommendedMovieState is RecommendedMoviePreview) {
      final movie = recommendedMovieState.movie;
      return Scaffold(
        backgroundColor:
            theme.scaffoldBackgroundColor.withOpacity(_backgroundColorOpacity),
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: _padding8),
            constraints: BoxConstraints(
                maxWidth: size.width,
                maxHeight: size.height * _maxHeightFactor),
            decoration: BoxDecoration(
                color: theme.canvasColor.withOpacity(_backgroundColorOpacity),
                borderRadius:
                    const BorderRadius.all(Radius.circular(_radius16))),
            child: Hero(
              tag: movie.posterPath ?? movie.title,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      color: theme.canvasColor
                          .withOpacity(_backgroundColorOpacity),
                      padding: const EdgeInsets.symmetric(
                          horizontal: _padding8, vertical: _padding16),
                      child: Text(movie.title)),
                  movie.posterPath != null
                      ? Expanded(
                          child: SizedBox(
                            height: size.width,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(_radius16),
                                bottomRight: Radius.circular(_radius16),
                              ),
                              child: Image.network(
                                movie.posterPath!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : Container(color: theme.primaryColor),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
