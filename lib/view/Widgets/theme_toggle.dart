import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:news_app/View/Provider/theme_provider.dart';
import 'package:news_app/Constants/app_colors.dart';

class ThemeToggle extends StatelessWidget {
  final bool useContrastBackground;

  const ThemeToggle({
    Key? key,
    this.useContrastBackground = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDarkMode = themeProvider.isDarkMode;
        final isHomeScreen = !useContrastBackground;

        // Determine colors based on context
        final backgroundColor = isHomeScreen
            ? Colors.white.withOpacity(0.2)
            : isDarkMode
                ? AppColors.darkGrey.withOpacity(0.3)
                : AppColors.lightGrey;

        final iconColor = isHomeScreen
            ? Colors.white
            : isDarkMode
                ? Colors.white
                : AppColors.textColor;

        return GestureDetector(
          onTap: () {
            themeProvider.toggleTheme();
          },
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: iconColor,
              size: 24.w,
            ),
          ),
        );
      },
    );
  }
}
