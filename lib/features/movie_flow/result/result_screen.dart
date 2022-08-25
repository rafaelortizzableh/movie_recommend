import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import '../movie_flow_export.dart';

final _buttonShownStateProvider = StateProvider.autoDispose<bool>((_) => true);

class ResultScreenArguments {
  const ResultScreenArguments({this.movie});
  final Movie? movie;
}

class ResultScreenWrapper extends ConsumerStatefulWidget {
  const ResultScreenWrapper({
    Key? key,
    this.selectedRecommendedMovie,
  }) : super(key: key);
  final Movie? selectedRecommendedMovie;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResultScreenWrapperState();
}

class _ResultScreenWrapperState extends ConsumerState<ResultScreenWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _scrollController = ScrollController()..addListener(_hideButtonOnBottom);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _scrollController.dispose();
  }

  void _hideButtonOnBottom() {
    final scrollPosition = _scrollController.position.pixels;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;

    if (maxScrollExtent - scrollPosition <= 20) {
      ref.read(_buttonShownStateProvider.notifier).state = false;
      return;
    }
    ref.read(_buttonShownStateProvider.notifier).state = true;
    return;
  }

  @override
  Widget build(BuildContext context) {
    return ResultScreen(
      animationController: _controller,
      scrollController: _scrollController,
      selectedRecommendedMovie: widget.selectedRecommendedMovie,
    );
  }
}

class ResultScreen extends ConsumerWidget {
  const ResultScreen({
    Key? key,
    required this.animationController,
    required this.scrollController,
    this.selectedRecommendedMovie,
  }) : super(key: key);
  static const String routeName = '/result';
  final AnimationController animationController;
  final ScrollController scrollController;
  final Movie? selectedRecommendedMovie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final _selectedMovieData = ref.watch(movieFlowControllerProvider).movie;
    final buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.8, 1),
      ),
    );

    return Material(
      child: Stack(
        children: [
          Scaffold(
            extendBodyBehindAppBar: true,
            body: _selectedMovieData.when(
              data: (movie) => ResultMovie(
                movie: selectedRecommendedMovie ?? movie,
                mediaQuery: mediaQuery,
                theme: theme,
                animationController: animationController,
                scrollController: scrollController,
              ),
              loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              error: (error, _) => error is Failure
                  ? FailureBody(message: error.message)
                  : const SizedBox(),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.linear,
            bottom: ref.watch(_buttonShownStateProvider)
                ? AppConstants.mediumSpacing
                : -AppConstants.mediumSpacing * 4,
            child: SizedBox(
              width: mediaQuery.size.width,
              child: FadeTransition(
                opacity: buttonOpacity,
                child: PrimaryButton(
                    onPressed: () => _navigateBack(context),
                    text: '${AppLocalizations.of(context)?.resultsButtonText}'),
              ),
            ),
          ),
          Positioned(
            top: (kToolbarHeight / 2) + AppConstants.horizontalPadding,
            left: AppConstants.horizontalPadding,
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.75),
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white.withOpacity(0.75),
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          if ((ref.watch(recommendedMovieProvider))
              is RecommendedMoviePreview) ...[
            const Align(
              alignment: Alignment.center,
              child: RecommendedMovieWidget(),
            ),
          ],
        ],
      ),
    );
  }

  void _navigateBack(BuildContext context) {
    if (selectedRecommendedMovie == null) {
      Navigator.pop(context);
      return;
    }
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}

class ResultMovie extends StatelessWidget {
  ResultMovie({
    Key? key,
    required this.mediaQuery,
    required this.theme,
    required this.movie,
    required this.animationController,
    required this.scrollController,
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
        super(key: key);
  static const double movieHeight = 150.0;

  final MediaQueryData mediaQuery;
  final AnimationController animationController;
  final ScrollController scrollController;
  final Animation<double> titleOpacity;
  final Animation<double> genreOpacity;
  final Animation<double> ratingOpacity;
  final Animation<double> descriptionOpacity;
  final ThemeData theme;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Stack(
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
        ),
        const SliverPadding(
          padding: EdgeInsets.only(bottom: movieHeight / 2),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.horizontalPadding),
            child: FadeTransition(
              opacity: descriptionOpacity,
              child: Text(
                movie.overview,
                style: theme.textTheme.bodyText2,
              ),
            ),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.only(bottom: AppConstants.horizontalPadding),
        ),
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: descriptionOpacity,
            child: const _SuggestedMovieTitle(),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.only(
            top: AppConstants.horizontalPadding,
            bottom: AppConstants.mediumSpacing * 3,
          ),
          sliver: _SuggestedMovies(),
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

    final size = MediaQuery.of(context).size;
    return Container(
      constraints: const BoxConstraints(minHeight: _minHeight),
      child: ShaderMask(
        child: Stack(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: _minHeight),
              child: NetworkFadingImage(
                path: movie.backdropPath ?? '',
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxHeight: kToolbarHeight * 2,
                minWidth: size.width,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.scaffoldBackgroundColor.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
        blendMode: BlendMode.dstIn,
        shaderCallback: (rect) => LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          colors: [
            theme.scaffoldBackgroundColor,
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromLTRB(
            _emptyNumber,
            _emptyNumber,
            rect.width,
            rect.height,
          ),
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
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.mediumSpacing),
      child: Row(
        children: [
          SizedBox(
            width: _sizedBoxWidth,
            height: movieHeight,
            child: NetworkFadingImage(
              path: movie.posterPath ?? '',
            ),
          ),
          const SizedBox(width: AppConstants.mediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: titleOpacity,
                  child: Text(movie.title, style: theme.textTheme.headline6),
                ),
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
                              ?.withOpacity(_resultDetatilTextOpacity),
                        ),
                      ),
                      const Icon(
                        Icons.star_rounded,
                        size: _iconSize,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ),
                FadeTransition(
                  opacity: ratingOpacity,
                  child: Text(
                    movie.releaseDate,
                    style: theme.textTheme.bodyText2?.copyWith(
                      color: theme.textTheme.bodyText2?.color?.withOpacity(
                        _resultDetatilTextOpacity,
                      ),
                    ),
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

class _SuggestedMovieTitle extends StatelessWidget {
  const _SuggestedMovieTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding),
      child: Text(
        '${AppLocalizations.of(context)?.similarMovies}',
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class _SuggestedMovies extends ConsumerWidget {
  const _SuggestedMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final movies = ref.watch(movieFlowControllerProvider).similarMovies;
    return movies.when(
      data: (movies) => SuggestedMoviesGrid(movies: movies),
      loading: () => SliverToBoxAdapter(
        child: SizedBox(
          width: width,
          height: width / 2,
          child: const Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
      error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
    );
  }
}

class SuggestedMoviesGrid extends StatelessWidget {
  const SuggestedMoviesGrid({Key? key, required this.movies}) : super(key: key);
  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => Hero(
          tag: movies[index].posterPath ?? movies[index].title,
          child: MovieBox(
            movie: movies[index],
          ),
        ),
        childCount: movies.length,
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisSpacing: 0,
        childAspectRatio: 0.7,
        crossAxisSpacing: 0,
      ),
    );
  }
}

class MovieBox extends ConsumerWidget {
  const MovieBox({
    Key? key,
    required this.movie,
    this.tappable = true,
  }) : super(key: key);
  final Movie movie;
  final bool tappable;
  static const double _emptyNumber = 0.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendedMovieNotifier =
        ref.watch(recommendedMovieProvider.notifier);
    return Material(
      child: PeekAndPop(
        onPeek: () {
          recommendedMovieNotifier.previewMovie(movie: movie);
        },
        onPop: () {
          recommendedMovieNotifier.resetRecommendedMovie();
        },
        child: GestureDetector(
          onTap: () => _openMovie(context, movie),
          child: Stack(
            children: [
              SizedBox.expand(
                child: movie.posterPath != null
                    ? NetworkFadingImage(path: movie.posterPath!)
                    : const Center(child: Text('🍿')),
              ),
              SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [
                        0.55,
                        1.0,
                      ],
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: AppConstants.horizontalPadding * 2,
                left: _emptyNumber,
                right: _emptyNumber,
                child: Text(
                  movie.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMovie(BuildContext context, Movie movie) {
    Navigator.pushNamed(
      context,
      ResultScreen.routeName,
      arguments: ResultScreenArguments(
        movie: movie,
      ),
    );
  }
}
