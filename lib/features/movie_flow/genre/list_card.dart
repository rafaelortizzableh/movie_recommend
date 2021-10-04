import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../core/core.dart';
import 'genre_exports.dart';

class ListCard extends StatelessWidget {
  const ListCard({Key? key, required this.onTap, required this.genre})
      : super(key: key);
  final VoidCallback onTap;
  final Genre genre;
  static const double _listCardWidth = 280.0;
  static const double _listCardHorizontalPadding = 8.0;
  static const double _listCardVerticalPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      borderRadius: BorderRadius.circular(kBorderRadius),
      color: genre.isSelected ? theme.colorScheme.primary : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: Container(
          width: _listCardWidth,
          padding: const EdgeInsets.symmetric(
            horizontal: _listCardHorizontalPadding,
            vertical: _listCardVerticalPadding,
          ),
          child: Text(
            genre.name,
            textAlign: TextAlign.center,
            style: theme.textTheme.subtitle1?.copyWith(
              color: genre.isSelected
                  ? Colors.white
                  : theme.textTheme.subtitle1?.color,
            ),
          ),
        ),
      ),
    );
  }
}
