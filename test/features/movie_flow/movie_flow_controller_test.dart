import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:ultimate_app/features/movie_flow/movie_flow_export.dart';

class MockMovieService extends Mock implements MovieService {}

void main() {
  late MovieService mockedMovieService;
  late ProviderContainer container;
  late Genre genre;

  setUp(() {
    mockedMovieService = MockMovieService();
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

  group('MovieFlowControllerTests - ', () {
    test(
        'Given succesfull call, When getting Recommended Movie, Then that movie should be represented',
        () async {
      const movieEntity = MovieEntity(
          title: 'title',
          overview: 'overview',
          voteAverage: 3.5,
          genreIds: [1],
          releaseDate: '2010-02-03',
          id: 1,
          backdropPath: 'x',
          posterPath: 'y');

      when(() => mockedMovieService.getRecommendedMovie(
              any(), const RangeValues(2009, 2011), any()))
          .thenAnswer((invocation) {
        return Future.value(Success([
          Movie.fromEntity(movieEntity, [genre])
        ]));
      });

      await container.read(movieFlowControllerProvider.notifier).getMovie();

      expect(container.read(movieFlowControllerProvider).movie,
          Movie.fromEntity(movieEntity, [genre]));
    });

    for (final rating in [0, 7, 10, 2, -2]) {
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
      RangeValues(2010, 2020)
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
  });
}
