import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'movie_flow_export.dart';

final movieFlowControllerProvider =
    StateNotifierProvider.autoDispose<MovieFlowController, MovieFlowState>(
  (ref) => MovieFlowController(
    MovieFlowState(
      genres: const AsyncValue.data(
        [],
      ),
      similarMovies: const AsyncValue.data(
        [],
      ),
      movie: AsyncValue.data(Movie.initial()),
    ),
    ref.watch(movieServiceProvider),
  ),
);

class MovieFlowController extends StateNotifier<MovieFlowState> {
  MovieFlowController(MovieFlowState state, this._movieService) : super(state);
  final MovieService _movieService;

  Future<void> getMovie({
    String? languageCode,
    AppLocalizations? l10n,
  }) async {
    state = state.copyWith(movie: const AsyncValue.loading());
    final result = await _movieService.getRecommendedMovie(
      state.rating,
      state.yearsBack,
      state.genres.asData!.value,
      l10n: l10n,
      languageCode: languageCode,
    );
    result
        .when((error) => state = state.copyWith(movie: AsyncValue.error(error)),
            (movies) {
      final random = Random();
      final movie = movies[random.nextInt(movies.length)];
      _getSimilarMovies(
        movie.id,
        l10n: l10n,
        languageCode: languageCode,
      );
      state = state.copyWith(movie: AsyncValue.data(movie));
    });
  }

  Future<void> _getSimilarMovies(
    int movieId, {
    String? languageCode,
    AppLocalizations? l10n,
  }) async {
    state = state.copyWith(similarMovies: const AsyncValue.loading());
    final result = await _movieService.getSimilarMovies(
      movieId,
      l10n: l10n,
      languageCode: languageCode,
    );
    result.when(
      (error) => state = state.copyWith(
        similarMovies: AsyncValue.error(error),
      ),
      (similarMovies) => state = state.copyWith(
        similarMovies: AsyncValue.data(similarMovies),
      ),
    );
  }

  Future<void> loadGenres({
    String? languageCode,
    AppLocalizations? l10n,
  }) async {
    state = state.copyWith(genres: const AsyncValue.loading());
    final result = await _movieService.getGenres(
      l10n: l10n,
      languageCode: languageCode,
    );
    result.when(
        (error) => state = state.copyWith(genres: AsyncValue.error(error)),
        (data) => state = state.copyWith(genres: AsyncValue.data(data)));
  }

  void toggleSelected(Genre genre) {
    List<Genre> updatedGenres = [];
    List<Genre> oldGenres = state.genres.asData!.value;
    late Genre newGenre;
    for (var oldGenre in oldGenres) {
      if (oldGenre == genre) {
        newGenre = genre.toggleSelected();
      } else {
        newGenre = oldGenre;
      }

      updatedGenres.add(newGenre);
    }
    state = state.copyWith(genres: AsyncValue.data(updatedGenres));
  }

  void updateRating(int updatedRating) {
    state =
        state.copyWith(rating: updatedRating.isNegative ? 0 : updatedRating);
  }

  void updateYearsBack(RangeValues updatedYearsBack) {
    state = state.copyWith(yearsBack: updatedYearsBack);
  }
}
