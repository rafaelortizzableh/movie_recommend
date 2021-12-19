import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../movie_flow_export.dart';

final pageControllerProvider =
    StateNotifierProvider.autoDispose<PagingController, PageState>((ref) {
  ref.maintainState = true;
  final genres = ref.watch(movieFlowControllerProvider).genres.asData?.value;
  return PagingController(PageState(pageController: PageController()),
      genres: genres);
});

class PagingController extends StateNotifier<PageState> {
  PagingController(PageState state, {required this.genres}) : super(state);
  final List<Genre>? genres;

  void nextPage() {
    if (state.pageController.page! >= 1) {
      if (genres != null && !genres!.any((element) => element.isSelected)) {
        return;
      }
    }
    state.pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic);
  }

  void previousPage() {
    state.pageController.previousPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    state.pageController.dispose();
    super.dispose();
  }
}
