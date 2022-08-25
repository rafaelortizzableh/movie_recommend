import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ultimate_app/core/failure.dart';
import 'package:ultimate_app/features/movie_flow/movie_flow_export.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MovieRepository mockedMovieRepository;

  setUp(() {
    mockedMovieRepository = MockMovieRepository();
  });

  test(
      'Given succesfull call, When getting GenreEntities, Then map to correct genres',
      () async {
    when(() => mockedMovieRepository.getMovieGenres())
        .thenAnswer((invocation) => Future.value([
              const GenreEntity(name: 'Animation', id: 1),
            ]));
    final movieService = TMDBMovieService(mockedMovieRepository);
    final result = await movieService.getGenres();
    expect(result.getSuccess(), [const Genre(name: 'Animation', id: 1)]);
  });

  test('Given failed call, When getting GenreEntities, then return failure',
      () async {
    when(() => mockedMovieRepository.getMovieGenres()).thenThrow(
        Failure(message: 'No Internet', exception: const SocketException('')));
    final movieService = TMDBMovieService(mockedMovieRepository);
    final result = await movieService.getGenres();
    expect(result.getError()?.exception, isA<SocketException>());
  });

  test('Given failed call, When getting MovieEntities, then return failure',
      () async {
    const genre = Genre(name: 'Animation', id: 1, isSelected: true);

    when(() =>
        mockedMovieRepository.getRecommendedMovie(
            any(), any(), any(), any())).thenThrow(
        Failure(message: 'No Internet', exception: const SocketException('')));
    final movieService = TMDBMovieService(mockedMovieRepository);

    final result = await movieService.getRecommendedMovie(
        3.5.round(), const RangeValues(1990, 2020), [genre]);

    expect(result.getError()?.exception, isA<SocketException>());
  });

  test(
    'Given succesfull call, When getting MovieEntity, Then map to correct movie',
    () async {
      const genre = Genre(name: 'Animation', id: 1, isSelected: true);
      const movieEntity = MovieEntity(
          title: 'title',
          overview: 'overview',
          voteAverage: 3.5,
          genreIds: [1],
          releaseDate: '2010-02-03',
          id: 1,
          backdropPath: 'x',
          posterPath: 'y');

      when(() => mockedMovieRepository.getRecommendedMovie(
          any(), any(), any(), any())).thenAnswer((invocation) {
        return Future.value([movieEntity]);
      });

      final movieService = TMDBMovieService(mockedMovieRepository);
      final result = await movieService.getRecommendedMovie(
        3.5.round(),
        const RangeValues(1990, 2020),
        [genre],
      );
      final movie = result.getSuccess()!.first;
      expect(
        movie,
        Movie.fromEntity(
          movieEntity,
          const [genre],
          '',
        ),
      );
    },
  );
}
