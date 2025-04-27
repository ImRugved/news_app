class AppConstants {
  // App general constants
  static const String appName = 'News App';
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double defaultMargin = 16.0;

  // Animation durations
  static const int defaultAnimationDuration = 300; // milliseconds
  static const int mediumAnimationDuration = 500; // milliseconds
  static const int longAnimationDuration = 800; // milliseconds

  // NewsAPI categories
  static const List<String> newsCategories = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
    'Science',
  ];

  // News sources
  static const Map<String, String> newsSources =
      //  {
      //   'BBC News': 'bbc-news',
      //   'ARY News': 'ary-news',
      //   'BBC Sports': 'bbc-sport',
      //   'Al Jazeera': 'al-jazeera-english',
      //   'CNN': 'cnn',
      //   'NBC News': 'nbc-news',
      //   'The Washington Post': 'the-washington-post',
      // };
      {
    'The Hindu': 'the-hindu',
    'The Times of India': 'the-times-of-india',
    'BBC News': 'bbc-news',
    'TOI': 'the-times-of-india',
    'CNN': 'cnn',
    'BBC Sports': 'bbc-sport',
    'Business Insider': 'business-insider',
    'Hacker News': 'hacker-news',
    'Medical News': 'medical-news-today',
    'Science News': 'new-scientist',
  };
}
