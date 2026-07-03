import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkBox,
        brightness: Brightness.light,
      ).copyWith(
        surface: AppColors.background,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.newsreader(
          fontSize: 40,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        displayMedium: GoogleFonts.newsreader(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.workSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.workSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        labelLarge: GoogleFonts.workSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  static TextStyle accentStyle({
    double fontSize = 20,
    Color color = AppColors.textAccent,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return GoogleFonts.caveat(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
      fontStyle: fontStyle,
    );
  }

  static TextStyle titleStyle({
    double fontSize = 38,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return GoogleFonts.newsreader(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
    );
  }

  static TextStyle bodyStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textSecondary,
  }) {
    return GoogleFonts.workSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
