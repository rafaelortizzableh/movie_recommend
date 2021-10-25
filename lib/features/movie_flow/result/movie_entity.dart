import 'dart:convert';

import 'package:flutter/foundation.dart';

class MovieEntity {
  final String title;
  final String overview;
  final num voteAverage;
  final List<int> genreIds;
  final String releaseDate;
  final String? backdropPath;
  final String? posterPath;
  final int id;

  MovieEntity({
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.genreIds,
    required this.releaseDate,
    this.backdropPath,
    this.posterPath,
    required this.id,
  });
  MovieEntity copyWith({
    String? title,
    String? overview,
    num? voteAverage,
    List<int>? genreIds,
    String? releaseDate,
    String? backdropPath,
    String? posterPath,
    int? id,
  }) {
    return MovieEntity(
      title: title ?? this.title,
      overview: overview ?? this.overview,
      voteAverage: voteAverage ?? this.voteAverage,
      genreIds: genreIds ?? this.genreIds,
      releaseDate: releaseDate ?? this.releaseDate,
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'overview': overview,
      'voteAverage': voteAverage,
      'genreIds': genreIds,
      'releaseDate': releaseDate,
      'backdropPath': backdropPath,
      'posterPath': posterPath,
      'id': id,
    };
  }

  String toJson() => json.encode(toMap());

  factory MovieEntity.fromMap(Map<String, dynamic> map) {
    return MovieEntity(
      title: map['title'],
      overview: map['overview'],
      voteAverage: map['vote_average'],
      genreIds: List<int>.from(map['genre_ids']),
      releaseDate: map['release_date'],
      backdropPath: map['backdrop_path'],
      posterPath: map['poster_path'],
      id: map['id'],
    );
  }

  factory MovieEntity.fromJson(String source) =>
      MovieEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MovieEntity(title: $title, overview: $overview, voteAverage: $voteAverage, genreIds: $genreIds, releaseDate: $releaseDate, backdropPath: $backdropPath, posterPath: $posterPath, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieEntity &&
        other.title == title &&
        other.overview == overview &&
        other.voteAverage == voteAverage &&
        listEquals(other.genreIds, genreIds) &&
        other.releaseDate == releaseDate &&
        other.backdropPath == backdropPath &&
        other.posterPath == posterPath &&
        other.id == id;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        overview.hashCode ^
        voteAverage.hashCode ^
        genreIds.hashCode ^
        releaseDate.hashCode ^
        backdropPath.hashCode ^
        posterPath.hashCode ^
        id.hashCode;
  }
}
