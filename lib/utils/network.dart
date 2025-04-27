import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:news_app/Models/news_model.dart';
import 'package:news_app/Utils/api.dart';
import 'package:news_app/Utils/global.dart';

class NewsApi {
  final API _api = API();

  // Fetch top headlines from a specific news source
  Future<NewsModel> fetchNewsHeadlines(String source) async {
    try {
      final response = await _api.sendRequest.get(
        '/top-headlines',
        queryParameters: {
          'sources': source,
        },
      );

      return NewsModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        print('DioError: ${e.message}');
        if (e.response != null) {
          print('DioError response: ${e.response!.data}');
        }
      } else {
        print('Error: $e');
      }
      throw Exception('Failed to fetch headlines: $e');
    }
  }

  // Fetch news articles by category
  Future<NewsModel> fetchNewsByCategory(String category) async {
    try {
      log("catego is $category");
      final response = await _api.sendRequest.get(
        '/everything',
        queryParameters: {
          'q': category,
          'pageSize': Global.defaultPageSize,
          'language': Global.defaultLanguage,
        },
      );

      // Add category field to each article for easier identification
      final newsModel = NewsModel.fromJson(response.data);
      if (newsModel.articles != null) {
        for (var article in newsModel.articles!) {
          article.category = category;
        }
      }

      return newsModel;
    } catch (e) {
      if (e is DioException) {
        print('DioError: ${e.message}');
        if (e.response != null) {
          print('DioError response: ${e.response!.data}');
        }
      } else {
        print('Error: $e');
      }
      throw Exception('Failed to fetch news by category: $e');
    }
  }

  // Search for news articles
  Future<NewsModel> searchNews(String query) async {
    try {
      final response = await _api.sendRequest.get(
        '/everything',
        queryParameters: {
          'q': query,
          'pageSize': Global.defaultPageSize,
          'language': Global.defaultLanguage,
          'sortBy': 'relevancy',
        },
      );

      return NewsModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        print('DioError: ${e.message}');
        if (e.response != null) {
          print('DioError response: ${e.response!.data}');
        }
      } else {
        print('Error: $e');
      }
      throw Exception('Failed to search news: $e');
    }
  }

  // Fetch top headlines by country
  Future<NewsModel> fetchTopHeadlinesByCountry({
    String country = 'us',
    String? category,
  }) async {
    try {
      final queryParams = {
        'country': country,
        'pageSize': Global.defaultPageSize,
      };

      if (category != null &&
          category.isNotEmpty &&
          category.toLowerCase() != 'general') {
        queryParams['category'] = category.toLowerCase();
      }

      final response = await _api.sendRequest.get(
        '/top-headlines',
        queryParameters: queryParams,
      );

      return NewsModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        print('DioError: ${e.message}');
        if (e.response != null) {
          print('DioError response: ${e.response!.data}');
        }
      } else {
        print('Error: $e');
      }
      throw Exception('Failed to fetch top headlines: $e');
    }
  }
}
