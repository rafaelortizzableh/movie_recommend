import 'dart:convert';

class GenreEntity {
  final String name;
  final int id;

  const GenreEntity({
    required this.name,
    required this.id,
  });

  GenreEntity copyWith({
    String? name,
    int? id,
  }) {
    return GenreEntity(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  factory GenreEntity.fromMap(Map<String, dynamic> map) {
    return GenreEntity(
      name: map['name'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GenreEntity.fromJson(String source) =>
      GenreEntity.fromMap(json.decode(source));

  @override
  String toString() => 'GenreEntity(name: $name, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GenreEntity && other.name == name && other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
