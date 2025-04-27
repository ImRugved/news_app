import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app/Constants/app_constants.dart';
import 'package:news_app/Models/news_model.dart';
import 'package:news_app/Utils/network.dart';

enum LoadingStatus { initial, loading, loaded, error }

class NewsProvider extends ChangeNotifier {
  final NewsApi _newsApi = NewsApi();

  // State variables
  LoadingStatus _headlinesStatus = LoadingStatus.initial;
  LoadingStatus _categoryNewsStatus = LoadingStatus.initial;
  LoadingStatus _searchStatus = LoadingStatus.initial;
  LoadingStatus _loadMoreStatus = LoadingStatus.initial;

  String _currentNewsSource = 'the-hindu';
  String _currentCategory = 'General';
  String _searchQuery = '';
  String _errorMessage = '';

  int _currentPage = 1;
  int _pageSize = 10;
  bool _hasMoreData = true;

  NewsModel? _headlinesNews;
  NewsModel? _categoryNews;
  NewsModel? _searchResults;

  // Getters
  LoadingStatus get headlinesStatus => _headlinesStatus;
  LoadingStatus get categoryNewsStatus => _categoryNewsStatus;
  LoadingStatus get searchStatus => _searchStatus;
  LoadingStatus get loadMoreStatus => _loadMoreStatus;

  String get currentNewsSource => _currentNewsSource;
  String get currentCategory => _currentCategory;
  String get searchQuery => _searchQuery;
  String get errorMessage => _errorMessage;

  bool get hasMoreData => _hasMoreData;

  NewsModel? get headlinesNews => _headlinesNews;
  NewsModel? get categoryNews => _categoryNews;
  NewsModel? get searchResults => _searchResults;

  List<Article> get headlines => _headlinesNews?.articles ?? [];
  List<Article> get categoryArticles => _categoryNews?.articles ?? [];
  List<Article> get searchArticles => _searchResults?.articles ?? [];

  // Load more articles for current category (pagination)
  Future<void> loadMoreCategoryNews() async {
    if (!_hasMoreData || _loadMoreStatus == LoadingStatus.loading) {
      return;
    }

    _loadMoreStatus = LoadingStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      // Increment page number
      _currentPage++;

      // Simulate network delay for demonstration
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, you would fetch more data from API with _currentPage
      // final result = await _newsApi.fetchNewsByCategory(_currentCategory, page: _currentPage, pageSize: _pageSize);

      // For demo, we'll reuse the same data but limit when to stop
      if (_currentPage > 3) {
        _hasMoreData = false;
      } else if (_categoryNews != null && _categoryNews!.articles != null) {
        // For demo purposes, we're adding the same articles again
        // In a real app, you'd merge the new articles from API
        final existingArticles = _categoryNews!.articles!;

        // Create a new instance with combined articles
        _categoryNews = NewsModel(
          status: _categoryNews!.status,
          totalResults: _categoryNews!.totalResults,
          articles: [...existingArticles, ...existingArticles.take(5)],
        );
      }

      _loadMoreStatus = LoadingStatus.loaded;
    } catch (e) {
      _loadMoreStatus = LoadingStatus.error;
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('Error loading more category news: $e');
      }
    } finally {
      notifyListeners();
    }
  }

  // Reset pagination when changing category or source
  void _resetPagination() {
    _currentPage = 1;
    _hasMoreData = true;
  }

  // Set current news source
  void setNewsSource(String source) {
    if (_currentNewsSource != source) {
      _currentNewsSource = source;
      _resetPagination();
      fetchHeadlines();
    }
  }

  // Set current category
  void setCategory(String category) {
    if (_currentCategory != category) {
      _currentCategory = category;
      _resetPagination();
      fetchNewsByCategory();
    }
  }

  // Fetch headlines from current news source
  Future<void> fetchHeadlines() async {
    _headlinesStatus = LoadingStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _newsApi.fetchNewsHeadlines(_currentNewsSource);
      _headlinesNews = result;
      _headlinesStatus = LoadingStatus.loaded;
    } catch (e) {
      _headlinesStatus = LoadingStatus.error;
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('Error fetching headlines: $e');
      }
    } finally {
      notifyListeners();
    }
  }

  // Fetch news by category
  Future<void> fetchNewsByCategory() async {
    _categoryNewsStatus = LoadingStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _newsApi.fetchNewsByCategory(_currentCategory);
      _categoryNews = result;
      _categoryNewsStatus = LoadingStatus.loaded;
    } catch (e) {
      _categoryNewsStatus = LoadingStatus.error;
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('Error fetching category news: $e');
      }
    } finally {
      notifyListeners();
    }
  }

  // Search news
  Future<void> searchNews(String query) async {
    if (query.isEmpty) return;

    _searchQuery = query;
    _searchStatus = LoadingStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _newsApi.searchNews(query);
      _searchResults = result;
      _searchStatus = LoadingStatus.loaded;
    } catch (e) {
      _searchStatus = LoadingStatus.error;
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('Error searching news: $e');
      }
    } finally {
      notifyListeners();
    }
  }

  // Initialize the provider
  Future<void> initialize() async {
    await Future.wait([
      fetchHeadlines(),
      fetchNewsByCategory(),
    ]);
  }

  // Get available sources
  List<Map<String, dynamic>> get newsSources {
    final sources = <Map<String, dynamic>>[];

    AppConstants.newsSources.forEach((name, value) {
      sources.add({
        'name': name,
        'value': value,
        'icon': _getIconForSource(name),
        'isSelected': value == _currentNewsSource,
      });
    });

    return sources;
  }

  // Helper method to get icon for news source
  // IconData _getIconForSource(String sourceName) {
  //   switch (sourceName.toLowerCase()) {
  //     case 'bbc news':
  //       return Icons.public;
  //     case 'Cryoto News':
  //       return Icons.tv;
  //     case 'bbc sports':
  //       return Icons.sports_soccer;
  //     case 'al jazeera':
  //       return Icons.language;
  //     case 'cnn':
  //       return Icons.live_tv;
  //     case 'nbc news':
  //       return Icons.newspaper;
  //     case 'the washington post':
  //       return Icons.article;
  //     default:
  //       return Icons.public;
  //   }
  // }
  IconData _getIconForSource(String sourceName) {
    switch (sourceName.toLowerCase()) {
      case 'the hindu':
        return Icons.menu_book;
      case 'the times of india':
      case 'toi':
        return Icons.book;
      case 'bbc news':
        return Icons.public;
      case 'cnn':
        return Icons.live_tv;
      case 'bbc sports':
      case 'bbc sport':
        return Icons.sports_soccer;
      case 'business insider':
        return Icons.business_center;
      case 'hacker news':
        return Icons.code;
      case 'medical news':
      case 'medical news today':
        return Icons.local_hospital;
      case 'science news':
      case 'new scientist':
        return Icons.science;
      default:
        return Icons.public;
    }
  }
}
