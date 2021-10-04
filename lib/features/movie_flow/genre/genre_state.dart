import 'genre_exports.dart';

class GenreState {
  static List<Genre> toggleSelected(Genre genre, List<Genre> genresList) {
    List<Genre> updatedGenres = [];
    for (var oldGenre in genresList) {
      late Genre newGenre;
      if (oldGenre == genre) {
        newGenre = genre.toggleSelected();
      } else {
        newGenre = oldGenre;
      }
      updatedGenres.add(newGenre);
    }
    return updatedGenres;
  }
}
