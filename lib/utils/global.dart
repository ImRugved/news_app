class Global {
  // API settings
  static const String hostUrl = 'https://newsapi.org/v2';
  static const String apiKey =
      '4299caf3c54049fea5020ea1cc0e0753'; // Your API key

  // App settings
  static const String defaultLanguage = 'en';
  static const String defaultCountry = 'us';
  static const int defaultPageSize = 20;

  // Storage keys
  static const String preferredCategoryKey = 'preferred_category';
  static const String preferredSourceKey = 'preferred_source';
  static const String savedArticlesKey = 'saved_articles';
}
