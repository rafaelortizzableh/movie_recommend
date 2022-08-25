import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

import 'package:ultimate_app/core/core.dart';
import 'package:ultimate_app/features/movie_flow/movie_flow_export.dart';

class MockMovieService extends Mock implements MovieService {
  final MovieRepository _movieRepository;
  final String? _imageUrlPrefix;
  MockMovieService(this._movieRepository, [this._imageUrlPrefix]);

  @override
  Future<Result<Failure, List<Movie>>> getRecommendedMovie(
    int rating,
    RangeValues yearsBack,
    List<Genre> genres, {
    String? languageCode,
    AppLocalizations? l10n,
  }) async {
    final startingDate = '${yearsBack.start.ceil()}-01-01';
    final endingDate = '${yearsBack.end.ceil()}-12-31';
    final selectedGenres = genres.where((element) => element.isSelected);
    final genreIds =
        selectedGenres.map((e) => e.id).toList(growable: false).join(',');

    try {
      final movieEntities = await _movieRepository.getRecommendedMovie(
        rating.toDouble(),
        startingDate,
        endingDate,
        genreIds,
        l10n: l10n,
        languageCode: languageCode,
      );
      final movies = movieEntities
          .map((e) => Movie.fromEntity(e, genres, _imageUrlPrefix ?? ''))
          .toList();
      if (movies.isEmpty) {
        return Error(Failure(message: 'No movies found'));
      }
      return Success(movies);
    } on Failure catch (failure) {
      return Error(failure);
    }
  }
}

void main() {
  late MovieRepository mockedMovieRepository;
  late MovieService mockedMovieService;
  late ProviderContainer container;
  late Genre genre;

  setUp(() {
    mockedMovieRepository = MockMovieRepository();
    mockedMovieService = MockMovieService(mockedMovieRepository);
    container = ProviderContainer(overrides: [
      movieServiceProvider.overrideWithValue(mockedMovieService),
    ]);
    genre = const Genre(name: 'Animation', id: 0);

    when(() => mockedMovieService.getGenres()).thenAnswer(
      (invocation) => Future.value(
        Success(
          [genre],
        ),
      ),
    );
  });

  tearDown(() {
    container.dispose();
  });

  group(
    'MovieFlowControllerTests - ',
    () {
      for (final rating in const [
        0,
        7,
        10,
        2,
        -2,
      ]) {
        test(
            'Given different ratings, When updating rating with $rating, Then that rating should be represented',
            () {
          container
              .read(movieFlowControllerProvider.notifier)
              .updateRating(rating);
          expect(container.read(movieFlowControllerProvider).rating,
              rating.isNegative ? 0 : rating);
        });
      }
      for (final yearsBack in const [
        RangeValues(1980, 1990),
        RangeValues(1990, 2000),
        RangeValues(2000, 2010),
        RangeValues(2010, 2020),
      ]) {
        test(
            'Given different ranges of years, When updating amount of years back with $yearsBack, Then that range should be represented',
            () {
          container
              .read(movieFlowControllerProvider.notifier)
              .updateYearsBack(yearsBack);
          expect(
              container.read(movieFlowControllerProvider).yearsBack, yearsBack);
        });
      }

      test(
        'Given succesfull call, When getting Recommended Movie, Then that movie should be represented',
        () async {
          await container.read(movieFlowControllerProvider.notifier).getMovie();

          expect(
            container.read(movieFlowControllerProvider).movie,
            AsyncValue.data(
              Movie.initial(),
            ),
          );
        },
      );
      test(
        'Given succesfull call, When getting Similar Movies, Then thaose movies should be represented',
        () async {
          await container.read(movieFlowControllerProvider.notifier).getMovie();

          expect(
            container.read(movieFlowControllerProvider).movie,
            AsyncValue.data(
              Movie.initial(),
            ),
          );
        },
      );
    },
  );
}

class MockMovieRepository extends Mock implements MovieRepository {
  MockMovieRepository();

  @override
  Future<List<MovieEntity>> getRecommendedMovie(
    double rating,
    String startingDate,
    String endingDate,
    String genreIds, {
    String? languageCode,
    AppLocalizations? l10n,
  }) async {
    try {
      return const [
        MovieEntity(
          title: '',
          overview: '',
          voteAverage: 0,
          id: 0,
          genreIds: [],
          releaseDate: '',
          backdropPath: '',
          posterPath: '',
        ),
      ];
    } catch (e) {
      throw Failure(
        message: 'Something went wrong',
        code: 001,
      );
    }
  }

  @override
  Future<List<MovieEntity>> getSimilarMovies(
    int movieId, {
    String? languageCode,
    AppLocalizations? l10n,
  }) async {
    try {
      return const [
        MovieEntity(
          title: '',
          overview: '',
          voteAverage: 0,
          id: 0,
          genreIds: [],
          releaseDate: '',
          backdropPath: '',
          posterPath: '',
        ),
      ];
    } catch (e) {
      throw Failure(
        message: 'Something went wrong',
        code: 001,
      );
    }
  }
}
