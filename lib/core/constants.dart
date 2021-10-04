import 'package:flutter/material.dart';

const double kBorderRadius = 8.0;
const double kMediumSpacing = 24.0;
const double kHorizontalPadding = 12.0;
const double kListItemSpacing = 8.0;

class AppConstants {
  static const String apiKey = String.fromEnvironment('MOVIE_API');
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
}
