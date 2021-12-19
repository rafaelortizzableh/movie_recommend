import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'movie_flow_export.dart';
import '../../core/core.dart';

final movieRepositoryProvider = Provider<MovieRepository>(
    (ref) => TMDBMovieRepository(ref.watch(dioProvider)));

abstract class MovieRepository {
  Future<List<GenreEntity>> getMovieGenres();
  Future<List<MovieEntity>> getSimilarMovies(int movieId);
  Future<List<MovieEntity>> getRecommendedMovie(
      double rating, String startingDate, String endingDate, String genreIds);
}

class TMDBMovieRepository implements MovieRepository {
  final Dio _dio;

  TMDBMovieRepository(this._dio);

  @override
  Future<List<GenreEntity>> getMovieGenres() async {
    try {
      final languageCode =
          Localizations.localeOf(AppConstants.navigationKey.currentContext!)
              .languageCode;
      final response = await _dio.get('genre/movie/list', queryParameters: {
        'api_key': AppConstants.apiKey,
        'language': languageCode
      });
      final results = List<Map<String, dynamic>>.from(response.data['genres']);
      return results.map((e) => GenreEntity.fromMap(e)).toList();
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw Failure(
          message:
              '${AppLocalizations.of(AppConstants.navigationKey.currentContext!)?.noInternetConnection}',
          exception: e,
        );
      }

      throw Failure(
        message: e.response?.statusMessage ?? 'Something went wrong',
        code: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<MovieEntity>> getRecommendedMovie(double rating,
      String startingDate, String endingDate, String genreIds) async {
    try {
      final languageCode =
          Localizations.localeOf(AppConstants.navigationKey.currentContext!)
              .languageCode;

      final queryParams = {
        'api_key': AppConstants.apiKey,
        'language': languageCode,
        'sort_by': 'popularity.desc',
        'include_adult': false,
        'vote_average.gte': rating,
        'page': 1,
        'primary_release_date.gte': startingDate,
        'primary_release_date.lte': endingDate,
        'with_genres': genreIds,
      };

      final response =
          await _dio.get('discover/movie', queryParameters: queryParams);
      final results = List<Map<String, dynamic>>.from(response.data['results']);
      return results.map((e) => MovieEntity.fromMap(e)).toList();
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw Failure(
          message:
              '${AppLocalizations.of(AppConstants.navigationKey.currentContext!)?.noInternetConnection}',
          exception: e,
        );
      }

      throw Failure(
        message: e.response?.statusMessage ?? 'Something went wrong',
        code: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<MovieEntity>> getSimilarMovies(int movieId) async {
    try {
      final languageCode =
          Localizations.localeOf(AppConstants.navigationKey.currentContext!)
              .languageCode;

      final queryParams = {
        'api_key': AppConstants.apiKey,
        'page': 1,
        'language': languageCode,
      };

      final response = await _dio.get('movie/$movieId/similar',
          queryParameters: queryParams);
      final results = List<Map<String, dynamic>>.from(response.data['results']);
      return results.map((e) => MovieEntity.fromMap(e)).toList();
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw Failure(
          message:
              '${AppLocalizations.of(AppConstants.navigationKey.currentContext!)?.noInternetConnection}',
          exception: e,
        );
      }

      throw Failure(
        message: e.response?.statusMessage ?? 'Something went wrong',
        code: e.response?.statusCode,
      );
    }
  }
}
