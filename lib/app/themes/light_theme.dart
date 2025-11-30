import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import 'constants/text_theme.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: AppColors.lightTextPrimary,
    onSurface: AppColors.lightTextPrimary,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.lightBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),
  textTheme: AppTextTheme.lightTextTheme,
  cardColor: AppColors.lightSurface,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
  ),
  dividerColor: Colors.grey.shade200,

  // ================= Modern TextField Style =================
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[100],
    contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    labelStyle: TextStyle(color: Colors.grey[700]),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.error, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.error, width: 2),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
  ),
);