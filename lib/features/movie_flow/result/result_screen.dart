import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/core.dart';
import '../movie_flow_export.dart';

class ResultScreenAnimator extends StatefulWidget {
  const ResultScreenAnimator({Key? key}) : super(key: key);

  @override
  _ResultScreenAnimatorState createState() => _ResultScreenAnimatorState();
}

class _ResultScreenAnimatorState extends State<ResultScreenAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResultScreen(
      animationController: _controller,
    );
  }
}

class ResultScreen extends ConsumerWidget {
  const ResultScreen({
    Key? key,
    required this.animationController,
  }) : super(key: key);
  static const String routeName = '/result';
  final AnimationController animationController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final _selectedMovie = ref.read(movieFlowControllerProvider).movie;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: _selectedMovie.when(
            data: (movie) => ResultMovie(
                movie: movie,
                mediaQuery: mediaQuery,
                theme: theme,
                animationController: animationController),
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (error, _) => error is Failure
                ? FailureBody(message: error.message)
                : const SizedBox(),
          ),
        ),
        if ((ref.watch(recommendedMovieProvider)) is RecommendedMoviePreview)
          const Align(
              alignment: Alignment.center, child: RecommendedMovieWidget())
      ],
    );
  }
}

class ResultMovie extends StatelessWidget {
  ResultMovie({
    Key? key,
    required this.mediaQuery,
    required this.theme,
    required this.movie,
    required this.animationController,
  })  : titleOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: animationController, curve: const Interval(0, 0.3)),
        ),
        genreOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: animationController, curve: const Interval(0.3, 0.4)),
        ),
        ratingOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: animationController, curve: const Interval(0.4, 0.6)),
        ),
        descriptionOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: animationController, curve: const Interval(0.6, 0.8)),
        ),
        buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: animationController, curve: const Interval(0.8, 1)),
        ),
        super(key: key);
  static const double movieHeight = 150.0;

  final MediaQueryData mediaQuery;
  final AnimationController animationController;
  final Animation<double> titleOpacity;
  final Animation<double> genreOpacity;
  final Animation<double> ratingOpacity;
  final Animation<double> descriptionOpacity;
  final Animation<double> buttonOpacity;
  final ThemeData theme;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CoverImage(movie: movie),
                  Positioned(
                    width: mediaQuery.size.width,
                    bottom: -(movieHeight / 2),
                    child: MovieimageDetails(
                      movie: movie,
                      movieHeight: movieHeight,
                      genreOpacity: genreOpacity,
                      ratingOpacity: ratingOpacity,
                      titleOpacity: titleOpacity,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: movieHeight / 2),
              Padding(
                padding: const EdgeInsets.all(kHorizontalPadding),
                child: FadeTransition(
                  opacity: descriptionOpacity,
                  child: Text(
                    movie.overview,
                    style: theme.textTheme.bodyText2,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kHorizontalPadding),
                child: FadeTransition(
                    opacity: descriptionOpacity,
                    child: const SugggestedMovies()),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: kHorizontalPadding),
          child: FadeTransition(
            opacity: buttonOpacity,
            child: PrimaryButton(
                onPressed: () => Navigator.pop(context),
                text: '${AppLocalizations.of(context)?.resultsButtonText}'),
          ),
        ),
      ],
    );
  }
}

class CoverImage extends StatelessWidget {
  const CoverImage({Key? key, required this.movie}) : super(key: key);
  final Movie movie;

  static const double _minHeight = 298.0;
  static const double _emptyNumber = 0.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: _minHeight),
      child: ShaderMask(
        child: NetworkFadingImage(
          path: movie.backdropPath ?? '',
        ),
        blendMode: BlendMode.dstIn,
        shaderCallback: (rect) => LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [theme.scaffoldBackgroundColor, Colors.transparent])
            .createShader(
          Rect.fromLTRB(_emptyNumber, _emptyNumber, rect.width, rect.height),
        ),
      ),
    );
  }
}

class MovieimageDetails extends StatelessWidget {
  const MovieimageDetails({
    Key? key,
    required this.movieHeight,
    required this.movie,
    required this.titleOpacity,
    required this.genreOpacity,
    required this.ratingOpacity,
  }) : super(key: key);
  final double movieHeight;
  final Movie movie;
  final Animation<double> titleOpacity;
  final Animation<double> genreOpacity;
  final Animation<double> ratingOpacity;

  static const double _sizedBoxWidth = 100.0;
  static const double _resultDetatilTextOpacity = 0.62;
  static const double _iconSize = 20.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kMediumSpacing),
      child: Row(
        children: [
          SizedBox(
            width: _sizedBoxWidth,
            height: movieHeight,
            child: NetworkFadingImage(
              path: movie.posterPath ?? '',
            ),
          ),
          const SizedBox(width: kMediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                    opacity: titleOpacity,
                    child: Text(movie.title, style: theme.textTheme.headline6)),
                FadeTransition(
                  opacity: genreOpacity,
                  child: Text(movie.genresCommaSeparated,
                      style: theme.textTheme.bodyText2),
                ),
                FadeTransition(
                  opacity: ratingOpacity,
                  child: Row(
                    children: [
                      Text(
                        '${movie.voteAverage}',
                        style: theme.textTheme.bodyText2?.copyWith(
                            color: theme.textTheme.bodyText2?.color
                                ?.withOpacity(_resultDetatilTextOpacity)),
                      ),
                      const Icon(Icons.star_rounded,
                          size: _iconSize, color: Colors.amber),
                    ],
                  ),
                ),
                FadeTransition(
                  opacity: ratingOpacity,
                  child: Text(
                    movie.releaseDate,
                    style: theme.textTheme.bodyText2?.copyWith(
                        color: theme.textTheme.bodyText2?.color
                            ?.withOpacity(_resultDetatilTextOpacity)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SugggestedMovies extends ConsumerWidget {
  const SugggestedMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final movies = ref.watch(movieFlowControllerProvider).similarMovies;
    return movies.when(
      data: (movies) => SuggestedMoviesGrid(movies: movies),
      loading: () => SizedBox(
        width: width,
        height: width / 2,
        child: const Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (_, __) => const SizedBox(),
    );
  }
}

class SuggestedMoviesGrid extends StatelessWidget {
  const SuggestedMoviesGrid({Key? key, required this.movies}) : super(key: key);
  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: Text(
            '${AppLocalizations.of(context)?.similarMovies}',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const SizedBox(height: kHorizontalPadding),
        GridView.builder(
          shrinkWrap: true,
          itemCount: movies.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            mainAxisSpacing: 0,
            childAspectRatio: 0.7,
            crossAxisSpacing: 0,
          ),
          itemBuilder: (BuildContext context, int index) => Hero(
            tag: movies[index].posterPath ?? movies[index].title,
            child: MovieBox(
              movie: movies[index],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieBox extends StatelessWidget {
  const MovieBox({Key? key, required this.movie, this.tappable = true})
      : super(key: key);
  final Movie movie;
  final bool tappable;
  static const double _emptyNumber = 0.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer(builder: (context, ref, _) {
      final recommendedMovieNotifier =
          ref.watch(recommendedMovieProvider.notifier);
      return PeekAndPop(
        onPeek: () {
          recommendedMovieNotifier.previewMovie(movie: movie);
        },
        onPop: () {
          recommendedMovieNotifier.resetRecommendedMovie();
        },
        child: Stack(
          children: [
            ShaderMask(
              child: movie.posterPath != null
                  ? NetworkFadingImage(path: movie.posterPath!)
                  : const Center(child: Text('🍿')),
              blendMode: BlendMode.dstIn,
              shaderCallback: (rect) => LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.scaffoldBackgroundColor,
                    Colors.transparent
                  ]).createShader(
                Rect.fromLTRB(
                    _emptyNumber, _emptyNumber, rect.width, rect.height),
              ),
            ),
            Positioned(
              bottom: kHorizontalPadding * 2,
              left: _emptyNumber,
              right: _emptyNumber,
              child: Text(movie.title, textAlign: TextAlign.center),
            ),
          ],
        ),
      );
    });
  }
}
