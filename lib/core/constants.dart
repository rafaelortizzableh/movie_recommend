import 'package:flutter/material.dart';

class AppConstants {
  static const String apiKey = String.fromEnvironment('MOVIE_API');
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  static const double borderRadius = 8.0;
  static const double mediumSpacing = 24.0;
  static const double horizontalPadding = 12.0;
  static const double listItemSpacing = 8.0;
}
