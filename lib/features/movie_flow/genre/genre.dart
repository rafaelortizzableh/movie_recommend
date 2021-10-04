import 'dart:convert';
import 'genre_exports.dart';
import 'package:flutter/foundation.dart';

@immutable
class Genre {
  final String name;
  final bool isSelected;
  final int id;

  const Genre({
    required this.name,
    this.isSelected = false,
    this.id = 0,
  });

  factory Genre.fromEntity(GenreEntity entity) {
    return Genre(
      name: entity.name,
      id: entity.id,
      isSelected: false,
    );
  }

  Genre toggleSelected() => Genre(name: name, id: id, isSelected: !isSelected);

  @override
  String toString() => 'Genre(name: $name, isSelected: $isSelected, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Genre &&
        other.name == name &&
        other.isSelected == isSelected &&
        other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ isSelected.hashCode ^ id.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isSelected': isSelected,
      'id': id,
    };
  }

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      name: map['name'],
      isSelected: map['isSelected'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Genre.fromJson(String source) => Genre.fromMap(json.decode(source));
}
