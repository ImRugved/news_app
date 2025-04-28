import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

TextTheme getTextTheme({bool isDark = false}) {
  Color textColor = isDark ? Colors.white : AppColors.textColor;
  Color primaryColor = AppColors.primary;
  Color whiteColor = isDark ? Colors.white : AppColors.white;
  Color darkGreyColor = isDark ? Colors.white70 : AppColors.darkGrey;

  return TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontWeight: FontWeight.w600,
      color: textColor,
      fontSize: 16.sp,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      color: textColor,
      fontSize: 14.sp,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontWeight: FontWeight.w400,
      color: textColor,
      fontSize: 12.sp,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      color: primaryColor,
      fontSize: 18.sp,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      color: primaryColor,
      fontSize: 14.sp,
    ),
    bodySmall: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      color: primaryColor,
      fontSize: 12.sp,
    ),
    titleLarge: GoogleFonts.poppins(
      fontWeight: FontWeight.w600,
      color: whiteColor,
      fontSize: 18.sp,
    ),
    titleMedium: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      color: whiteColor,
      fontSize: 16.sp,
    ),
    titleSmall: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      color: whiteColor,
      fontSize: 14.sp,
    ),
    displayLarge: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      color: AppColors.red2,
      fontSize: 18.sp,
    ),
    displayMedium: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      color: AppColors.red2,
      fontSize: 14.sp,
    ),
    displaySmall: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
      color: AppColors.red2,
    ),
    labelSmall: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
      color: AppColors.green,
    ),
    labelMedium: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      fontSize: 14.sp,
      color: AppColors.green,
    ),
    labelLarge: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      fontSize: 15.sp,
      color: AppColors.green,
    ),
  );
}

// For direct use in widgets
class AppTextStyles {
  // Headings - for main titles and headers
  static TextStyle headlineLarge = getTextTheme().headlineLarge!;
  static TextStyle headlineMedium = getTextTheme().headlineMedium!;
  static TextStyle headlineSmall = getTextTheme().headlineSmall!;

  // Body text - for general content text
  static TextStyle bodyLarge = getTextTheme().bodyLarge!;
  static TextStyle bodyMedium = getTextTheme().bodyMedium!;
  static TextStyle bodySmall = getTextTheme().bodySmall!;

  // Title text - for section titles, usually on colored backgrounds
  static TextStyle titleLarge = getTextTheme().titleLarge!;
  static TextStyle titleMedium = getTextTheme().titleMedium!;
  static TextStyle titleSmall = getTextTheme().titleSmall!;

  // Display text - for highlighted text in red
  static TextStyle displayLarge = getTextTheme().displayLarge!;
  static TextStyle displayMedium = getTextTheme().displayMedium!;
  static TextStyle displaySmall = getTextTheme().displaySmall!;

  // Label text - for success or action text in green
  static TextStyle labelLarge = getTextTheme().labelLarge!;
  static TextStyle labelMedium = getTextTheme().labelMedium!;
  static TextStyle labelSmall = getTextTheme().labelSmall!;

  // Special styles
  static TextStyle newsSource = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static TextStyle newsDate = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.darkGrey,
  );

  static TextStyle newsTitle = GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static TextStyle newsDescription = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );
}
