class Global {
  // API settings
  static const String hostUrl = 'https://newsapi.org/v2';
  static const String apiKey =
      'b53455bd3edf41f19769aaf32d4cdd1d'; // Your API key

  // App settings
  static const String defaultLanguage = 'en';
  static const String defaultCountry = 'us';
  static const int defaultPageSize = 20;

  // Storage keys
  static const String preferredCategoryKey = 'preferred_category';
  static const String preferredSourceKey = 'preferred_source';
  static const String savedArticlesKey = 'saved_articles';
}
