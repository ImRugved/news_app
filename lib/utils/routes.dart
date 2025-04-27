import 'package:get/get.dart';
import 'package:news_app/view/Screens/home_screen.dart';
import 'package:news_app/view/Screens/categories_screen.dart';
import 'package:news_app/view/Screens/news_details_screen.dart';
import 'package:news_app/view/Screens/search_screen.dart';
import 'package:news_app/view/Screens/all_headlines_screen.dart';
import 'package:news_app/view/Screens/splash_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/splash';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String newsDetails = '/news-details';
  static const String search = '/search';
  static const String allHeadlines = '/all-headlines';

  // Get application routes
  static List<GetPage> getPages = [
    GetPage(
      name: '/',
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: categories,
      page: () => const CategoriesScreen(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: newsDetails,
      page: () {
        final args = Get.arguments;
        return NewsDetailsScreen(
          newsImage: args['newsImage'] ?? '',
          newsTitle: args['newsTitle'] ?? '',
          newsDate: args['newsDate'] ?? '',
          newsAuthor: args['newsAuthor'] ?? '',
          newsDesc: args['newsDesc'] ?? '',
          newsContent: args['newsContent'] ?? '',
          newsSource: args['newsSource'] ?? '',
          newsUrl: args['newsUrl'] ?? '',
          heroTag: args['heroTag'] ?? '',
        );
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: search,
      page: () => const SearchScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: allHeadlines,
      page: () => const AllHeadlinesScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
