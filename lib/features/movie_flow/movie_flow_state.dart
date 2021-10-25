import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movie_flow_export.dart';

@immutable
class MovieFlowState {
  final int rating;
  final RangeValues yearsBack;
  final AsyncValue<List<Genre>> genres;
  final AsyncValue<List<Movie>> similarMovies;
  final AsyncValue<Movie> movie;

  const MovieFlowState({
    this.rating = 5,
    this.yearsBack = const RangeValues(1980, 2006),
    required this.genres,
    required this.movie,
    required this.similarMovies,
  });

  MovieFlowState copyWith({
    PageController? pageController,
    int? rating,
    RangeValues? yearsBack,
    AsyncValue<List<Genre>>? genres,
    AsyncValue<List<Movie>>? similarMovies,
    AsyncValue<Movie>? movie,
  }) {
    return MovieFlowState(
        rating: rating ?? this.rating,
        yearsBack: yearsBack ?? this.yearsBack,
        genres: genres ?? this.genres,
        movie: movie ?? this.movie,
        similarMovies: similarMovies ?? this.similarMovies);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieFlowState &&
        other.rating == rating &&
        other.yearsBack == yearsBack &&
        other.genres == genres &&
        other.similarMovies == similarMovies &&
        other.movie == movie;
  }

  @override
  int get hashCode {
    return rating.hashCode ^
        yearsBack.hashCode ^
        genres.hashCode ^
        similarMovies.hashCode ^
        movie.hashCode;
  }
}
