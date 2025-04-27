import 'package:flutter/material.dart';

class AppDurations {
  static const Duration animationDuration = Duration(milliseconds: 300);
  // Add more durations as needed
}

// Duration constants in milliseconds
class DurationConstants {
  static const int short = 300;
  static const int medium = 500;
  static const int long = 800;
}

// API constants
class ApiConstants {
  static const String baseUrl = 'https://newsapi.org/v2';

  // Endpoints
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';

  // Parameters
  static const String country = 'country';
  static const String category = 'category';
  static const String sources = 'sources';
  static const String q = 'q';
  static const String pageSize = 'pageSize';
  static const String page = 'page';
}
