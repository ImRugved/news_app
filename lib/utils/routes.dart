import 'package:get/get.dart';
import 'package:news_app/View/Screens/home_screen.dart';
import 'package:news_app/View/Screens/categories_screen.dart';
import 'package:news_app/View/Screens/news_details_screen.dart';

class AppRoutes {
  // Route names
  static const String home = '/';
  static const String categories = '/categories';
  static const String newsDetails = '/news-details';

  // Get application routes
  static List<GetPage> getPages = [
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
          heroTag: args['heroTag'] ?? '',
        );
      },
      transition: Transition.fadeIn,
    ),
  ];
}
