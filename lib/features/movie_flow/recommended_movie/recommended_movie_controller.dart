import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../movie_flow_export.dart';

abstract class RecommendedMovieState {}

class RecommendedMovieEmpty extends RecommendedMovieState {}

class RecommendedMovieSelected extends RecommendedMovieState {
  final Movie movie;
  RecommendedMovieSelected({
    required this.movie,
  });
}

class RecommendedMoviePreview extends RecommendedMovieState {
  final Movie movie;
  RecommendedMoviePreview({
    required this.movie,
  });
}

final recommendedMovieProvider =
    StateNotifierProvider<RecommendedMovieController, RecommendedMovieState>(
        (ref) => RecommendedMovieController());

class RecommendedMovieController extends StateNotifier<RecommendedMovieState> {
  RecommendedMovieController() : super(RecommendedMovieEmpty());

  void resetRecommendedMovie() {
    state = RecommendedMovieEmpty();
  }

  void previewMovie({required Movie movie}) {
    state = RecommendedMoviePreview(movie: movie);
  }

  void selectMovie({required Movie movie}) {
    state = RecommendedMovieSelected(movie: movie);
  }
}
