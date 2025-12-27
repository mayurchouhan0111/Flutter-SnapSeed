import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_palette.dart';

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppPalette.backgroundLight,
    primaryColor: AppPalette.primary,
    dividerColor: AppPalette.borderLight,
    
    colorScheme: const ColorScheme.light(
      primary: AppPalette.primary,
      secondary: AppPalette.accent,
      surface: AppPalette.surfaceLight,
      error: AppPalette.error,
      background: AppPalette.backgroundLight,
    ),

    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: AppPalette.textMainLight,
      displayColor: AppPalette.textMainLight,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.backgroundLight,
      elevation: 0,
      iconTheme: IconThemeData(color: AppPalette.textMainLight),
      titleTextStyle: TextStyle(
        color: AppPalette.textMainLight,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    

  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppPalette.backgroundDark,
    primaryColor: AppPalette.white,
    dividerColor: AppPalette.borderDark,
    
    colorScheme: const ColorScheme.dark(
      primary: AppPalette.white,
      secondary: AppPalette.accent,
      surface: AppPalette.surfaceDark,
      error: AppPalette.error,
      background: AppPalette.backgroundDark,
    ),

    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: AppPalette.textMainDark,
      displayColor: AppPalette.textMainDark,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.backgroundDark,
      elevation: 0,
      iconTheme: IconThemeData(color: AppPalette.textMainDark),
      titleTextStyle: TextStyle(
        color: AppPalette.textMainDark,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

  );
}
