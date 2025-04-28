import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:news_app/Constants/app_colors.dart';
import 'package:news_app/Constants/app_text_styles.dart';
import 'package:news_app/Utils/routes.dart';
import 'package:news_app/View/Provider/news_provider.dart';
import 'package:news_app/View/Provider/theme_provider.dart';
import 'package:news_app/View/Screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set up ScreenUtil for responsive UI
    return ScreenUtilInit(
      designSize: const Size(392, 850), // Based on a common screen size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => NewsProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'News App',
                theme: ThemeData(
                  primaryColor: AppColors.primary,
                  textTheme: getTextTheme(),
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: AppColors.primary,
                    brightness: Brightness.light,
                    primary: AppColors.primary,
                    secondary: AppColors.secondary,
                    background: AppColors.backgroundColor,
                    error: AppColors.red,
                  ),
                  scaffoldBackgroundColor: AppColors.backgroundColor,
                  cardTheme: CardTheme(
                    color: AppColors.cardBackground,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  appBarTheme: const AppBarTheme(
                    backgroundColor: AppColors.white,
                    elevation: 0,
                    iconTheme: IconThemeData(color: AppColors.textColor),
                    titleTextStyle: TextStyle(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.dark,
                    ),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                  ),
                  useMaterial3: true,
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: AppColors.primary,
                  scaffoldBackgroundColor: const Color(0xFF121212),
                  colorScheme: ColorScheme.dark(
                    primary: AppColors.primary,
                    secondary: AppColors.secondary,
                    surface: const Color(0xFF1E1E1E),
                    background: const Color(0xFF121212),
                    error: AppColors.red,
                    onBackground: Colors.white,
                    onSurface: Colors.white,
                    onPrimary: Colors.white,
                    onSecondary: Colors.white,
                    onError: Colors.white,
                  ),
                  cardTheme: CardTheme(
                    color: const Color(0xFF1E1E1E),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    shadowColor: Colors.black38,
                  ),
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Color(0xFF1A1A1A),
                    elevation: 0,
                    iconTheme: IconThemeData(color: Colors.white),
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.light,
                    ),
                  ),
                  textTheme: getTextTheme(isDark: true),
                  dividerTheme: const DividerThemeData(
                    color: Color(0xFF2C2C2C),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                  ),
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  popupMenuTheme: PopupMenuThemeData(
                    color: const Color(0xFF1E1E1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  useMaterial3: true,
                ),
                themeMode: themeProvider.themeMode,
                getPages: AppRoutes.getPages,
                initialRoute: '/',
                defaultTransition: Transition.fadeIn,
              );
            },
          ),
        );
      },
    );
  }
}
