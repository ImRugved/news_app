import 'package:flutter/material.dart';
import 'package:news_app/Constants/app_colors.dart';

/// Provides dynamic colors that adapt to the current theme mode
class AppThemeColors {
  static Color primary(BuildContext context) => AppColors.primary;

  static Color secondary(BuildContext context) => AppColors.secondary;

  static Color accent(BuildContext context) => AppColors.accent;

  // Background colors
  static Color backgroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF121212)
          : AppColors.backgroundColor;

  static Color cardBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E1E1E)
          : AppColors.cardBackground;

  static Color lightGrey(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF2C2C2C)
          : AppColors.lightGrey;

  static Color grey(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3A3A3A)
          : AppColors.grey;

  static Color darkGrey(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF6C6C6C)
          : AppColors.darkGrey;

  // Text colors
  static Color textColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : AppColors.textColor;

  static Color secondaryTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white70
          : AppColors.secondaryTextColor;

  static Color lightTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white38
          : AppColors.lightTextColor;

  // Navigation
  static Color navBar(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1A1A1A)
          : AppColors.navBar;

  // Scaffold background
  static Color scaffoldBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF121212)
          : AppColors.scaffoldBackground;

  // Card accent colors
  static Color cardAccent1(BuildContext context) => AppColors.cardAccent1;

  static Color cardAccent2(BuildContext context) => AppColors.cardAccent2;

  // Search bar colors
  static Color searchBarBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF2C2C2C)
          : AppColors.searchBarBackground;

  static Color searchBarText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : AppColors.searchBarText;

  static Color searchBarHint(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white54
          : AppColors.searchBarHint;

  // Gradient colors
  static List<Color> primaryGradient(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? [const Color(0xFF303F9F), const Color(0xFF1A237E)]
          : AppColors.primaryGradient;

  static Color shadowColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.black45
          : AppColors.shadowColor;

  // Shimmer effects colors
  static Color shimmerBaseColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF2C2C2C)
          : Colors.grey.shade300;

  static Color shimmerHighlightColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3A3A3A)
          : Colors.grey.shade100;
}
