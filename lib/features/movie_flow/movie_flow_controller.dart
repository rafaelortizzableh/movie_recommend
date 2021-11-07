import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  MovieFlowController(MovieFlowState state, this._movieService) : super(state) {
    loadGenres();
  }
  final MovieService _movieService;

  Future<void> getMovie() async {
    state = state.copyWith(movie: const AsyncValue.loading());
    final result = await _movieService.getRecommendedMovie(
        state.rating, state.yearsBack, state.genres.asData!.value);
    result
        .when((error) => state = state.copyWith(movie: AsyncValue.error(error)),
            (movies) {
      final random = Random();
      final movie = movies[random.nextInt(movies.length)];
      getSimilarMovies(movie.id);
      state = state.copyWith(movie: AsyncValue.data(movie));
    });
  }

  Future<void> getSimilarMovies(int movieId) async {
    state = state.copyWith(similarMovies: const AsyncValue.loading());
    final result = await _movieService.getSimilarMovies(movieId);
    result.when(
        (error) =>
            state = state.copyWith(similarMovies: AsyncValue.error(error)),
        (similarMovies) => state =
            state.copyWith(similarMovies: AsyncValue.data(similarMovies)));
  }

  Future<void> loadGenres() async {
    state = state.copyWith(genres: const AsyncValue.loading());
    final result = await _movieService.getGenres();
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
    state = state.copyWith(rating: updatedRating);
  }

  void updateYearsBack(RangeValues updatedYearsBack) {
    state = state.copyWith(yearsBack: updatedYearsBack);
  }
}
