import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'genre/genre_exports.dart';
import '../../core/core.dart';
import 'movie_flow_export.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final moviedbRepository = ref.watch(movieRepositoryProvider);
  return TMDBMovieService(moviedbRepository);
});

abstract class MovieService {
  Future<Result<Failure, List<Genre>>> getGenres();
  Future<Result<Failure, List<Movie>>> getSimilarMovies(int movieId);
  Future<Result<Failure, List<Movie>>> getRecommendedMovie(
      int rating, RangeValues yearsBack, List<Genre> genres);
}

class TMDBMovieService implements MovieService {
  final MovieRepository _tmdbMovieRepository;

  TMDBMovieService(this._tmdbMovieRepository);
  @override
  Future<Result<Failure, List<Genre>>> getGenres() async {
    try {
      final _genreEntities = await _tmdbMovieRepository.getMovieGenres();
      final _genres = _genreEntities
          .map((e) => Genre.fromEntity(e))
          .toList(growable: false);
      return Success(_genres);
    } on Failure catch (failure) {
      return Error(failure);
    }
  }

  @override
  Future<Result<Failure, List<Movie>>> getRecommendedMovie(
    int rating,
    RangeValues yearsBack,
    List<Genre> genres,
  ) async {
    final startingDate = '${yearsBack.start.ceil()}-01-01';
    final endingDate = '${yearsBack.end.ceil()}-12-31';
    final selectedGenres = genres.where((element) => element.isSelected);
    final genreIds =
        selectedGenres.map((e) => e.id).toList(growable: false).join(',');

    try {
      final movieEntities = await _tmdbMovieRepository.getRecommendedMovie(
          rating.toDouble(), startingDate, endingDate, genreIds);
      final movies =
          movieEntities.map((e) => Movie.fromEntity(e, genres)).toList();
      if (movies.isEmpty) {
        return Error(Failure(message: 'No movies found'));
      }
      return Success(movies);
    } on Failure catch (failure) {
      return Error(failure);
    }
  }

  @override
  Future<Result<Failure, List<Movie>>> getSimilarMovies(int movieId) async {
    try {
      final movieEntities =
          await _tmdbMovieRepository.getSimilarMovies(movieId);
      final movies =
          movieEntities.map((e) => Movie.fromEntity(e, const [])).toList();
      if (movies.isEmpty) {
        return Error(Failure(message: 'No movies found'));
      }
      return Success(movies);
    } on Failure catch (failure) {
      return Error(failure);
    }
  }
}
