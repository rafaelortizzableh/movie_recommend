import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../movie_flow_export.dart';

@immutable
class Movie {
  final String title;
  final String overview;
  final num voteAverage;
  final List<Genre> genres;
  final String releaseDate;
  final String? backdropPath;
  final String? posterPath;

  const Movie({
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.genres,
    required this.releaseDate,
    this.backdropPath,
    this.posterPath,
  });

  Movie.initial()
      : title = '',
        overview = '',
        voteAverage = 0,
        genres = [],
        releaseDate = '',
        backdropPath = '',
        posterPath = '';

  String get genresCommaSeparated =>
      genres.map((genre) => genre.name).toList().join(', ');

  Movie copyWith({
    String? title,
    String? overview,
    num? voteAverage,
    List<Genre>? genres,
    String? releaseDate,
    String? backdropPath,
    String? posterPath,
  }) {
    return Movie(
      title: title ?? this.title,
      overview: overview ?? this.overview,
      voteAverage: voteAverage ?? this.voteAverage,
      genres: genres ?? this.genres,
      releaseDate: releaseDate ?? this.releaseDate,
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'overview': overview,
      'voteAverage': voteAverage,
      'genres': genres.map((x) => x.toMap()).toList(),
      'releaseDate': releaseDate,
      'backdropPath': backdropPath,
      'posterPath': posterPath,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      title: map['title'],
      overview: map['overview'],
      voteAverage: map['voteAverage'],
      genres: List<Genre>.from(map['genres']?.map((x) => Genre.fromMap(x))),
      releaseDate: map['releaseDate'],
      backdropPath: map['backdropPath'],
      posterPath: map['posterPath'],
    );
  }

  factory Movie.fromEntity(MovieEntity movieEntity, List<Genre> genres) {
    return Movie(
        title: movieEntity.title,
        overview: movieEntity.overview,
        backdropPath:
            'https://image.tmdb.org/t/p/original/${movieEntity.backdropPath}',
        posterPath:
            'https://image.tmdb.org/t/p/original/${movieEntity.posterPath}',
        voteAverage: movieEntity.voteAverage,
        genres: genres
            .where((element) => movieEntity.genreIds.contains(element.id))
            .toList(),
        releaseDate: movieEntity.releaseDate);
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) => Movie.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Movie(title: $title, overview: $overview, voteAverage: $voteAverage, genres: $genres, releaseDate: $releaseDate, backdropPath: $backdropPath, posterPath: $posterPath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Movie &&
        other.title == title &&
        other.overview == overview &&
        other.voteAverage == voteAverage &&
        listEquals(other.genres, genres) &&
        other.releaseDate == releaseDate &&
        other.backdropPath == backdropPath &&
        other.posterPath == posterPath;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        overview.hashCode ^
        voteAverage.hashCode ^
        genres.hashCode ^
        releaseDate.hashCode ^
        backdropPath.hashCode ^
        posterPath.hashCode;
  }
}
