import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ultimate_app/core/core.dart';
import 'theme_export.dart';

class CustomTheme {
  static const double _buttonFontSize = 16.0;
  static const double _appBarElevation = 0;
  static ThemeData darkTheme() {
    final theme = ThemeData.dark();
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        primarySwatch: MaterialColor(
          Palette.red500.value,
          const {
            100: Palette.red100,
            200: Palette.red200,
            300: Palette.red300,
            400: Palette.red400,
            500: Palette.red500,
            600: Palette.red600,
            700: Palette.red700,
            800: Palette.red800,
            900: Palette.red900,
          },
        ),
        accentColor: Palette.red500,
      ),
      scaffoldBackgroundColor: Palette.black,
      appBarTheme: const AppBarTheme(
        elevation: _appBarElevation,
        color: Palette.black,
      ),
      textTheme: theme.primaryTextTheme
          .copyWith(
            button: theme.primaryTextTheme.button?.copyWith(
              color: Colors.white,
              fontSize: _buttonFontSize,
            ),
          )
          .apply(displayColor: Colors.white),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: Palette.red500,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          enableFeedback: true,
          padding: const EdgeInsets.symmetric(
              horizontal: kHorizontalPadding, vertical: kHorizontalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
        ),
      ),
    );
  }

  static ThemeData lightTheme() {
    final theme = ThemeData.light();
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.light,
        primarySwatch: MaterialColor(
          Palette.red500.value,
          const {
            100: Palette.red100,
            200: Palette.red200,
            300: Palette.red300,
            400: Palette.red400,
            500: Palette.red500,
            600: Palette.red600,
            700: Palette.red700,
            800: Palette.red800,
            900: Palette.red900,
          },
        ),
        accentColor: Palette.red500,
      ),
      scaffoldBackgroundColor: Palette.white,
      appBarTheme: const AppBarTheme(
          elevation: _appBarElevation,
          color: Palette.white,
          foregroundColor: Palette.red500),
      textTheme: theme.primaryTextTheme
          .copyWith(
            button: theme.primaryTextTheme.button?.copyWith(
              color: Colors.white,
              fontSize: _buttonFontSize,
            ),
          )
          .apply(displayColor: Colors.black, bodyColor: Colors.black),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: Palette.red500,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          enableFeedback: true,
          padding: const EdgeInsets.symmetric(
              horizontal: kHorizontalPadding, vertical: kHorizontalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
        ),
      ),
    );
  }
}
