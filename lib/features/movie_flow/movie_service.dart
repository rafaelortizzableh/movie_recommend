import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/core.dart';
import 'movie_flow_export.dart';

const _tmdbImageUrlPrefix = 'https://image.tmdb.org/t/p/original';

final movieServiceProvider = Provider<MovieService>((ref) {
  final moviedbRepository = ref.watch(movieRepositoryProvider);
  return TMDBMovieService(moviedbRepository, _tmdbImageUrlPrefix);
});

abstract class MovieService {
  Future<Result<Failure, List<Genre>>> getGenres({
    String? languageCode,
    AppLocalizations? l10n,
  });
  Future<Result<Failure, List<Movie>>> getSimilarMovies(
    int movieId, {
    String? languageCode,
    AppLocalizations? l10n,
  });
  Future<Result<Failure, List<Movie>>> getRecommendedMovie(
    int rating,
    RangeValues yearsBack,
    List<Genre> genres, {
    String? languageCode,
    AppLocalizations? l10n,
  });
}

class TMDBMovieService implements MovieService {
  final MovieRepository _movieRepository;
  final String? _imageUrlPrefix;

  const TMDBMovieService(this._movieRepository, [this._imageUrlPrefix]);

  @override
  Future<Result<Failure, List<Genre>>> getGenres({
    String? languageCode,
    AppLocalizations? l10n,
  }) async {
    try {
      final _genreEntities = await _movieRepository.getMovieGenres(
        languageCode: languageCode,
        l10n: l10n,
      );
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

  @override
  Future<Result<Failure, List<Movie>>> getSimilarMovies(
    int movieId, {
    String? languageCode,
    AppLocalizations? l10n,
  }) async {
    try {
      final movieEntities = await _movieRepository.getSimilarMovies(
        movieId,
        l10n: l10n,
        languageCode: languageCode,
      );
      final movies = movieEntities
          .map(
            (e) => Movie.fromEntity(e, const [], _imageUrlPrefix ?? ''),
          )
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
