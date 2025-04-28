import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:news_app/Constants/app_colors.dart';
import 'package:news_app/Constants/app_text_styles.dart';
import 'package:news_app/Constants/app_theme_colors.dart';
import 'package:news_app/Utils/routes.dart';
import 'package:news_app/View/Body/headlines_carousel.dart';
import 'package:news_app/View/Body/latest_news_list.dart';
import 'package:news_app/View/Body/news_source_selector.dart';
import 'package:news_app/View/Provider/news_provider.dart';
import 'package:news_app/View/Widgets/theme_toggle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final format = DateFormat('MMM dd, yyyy');
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    // Initialize the news provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (_isSearchActive) {
        _searchFocus.requestFocus();
      } else {
        _searchController.clear();
      }
    });
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      Provider.of<NewsProvider>(context, listen: false).searchNews(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppThemeColors.backgroundColor(context),
        body: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _isSearchActive && _searchController.text.isNotEmpty
                  ? _buildSearchResults()
                  : _buildMainContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppThemeColors.primaryGradient(context),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.shadowColor(context),
            offset: const Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: _isSearchActive ? _buildSearchBar() : _buildTitleBar(),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildTitleBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Get.toNamed(AppRoutes.categories);
          },
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.interests,
              color: Colors.white,
            ),
          ),
        ).animate().scale(
            begin: const Offset(0.5, 0.5),
            end: const Offset(1, 1),
            duration: 300.ms,
            delay: 100.ms),
        Text(
          'News Today',
          style: AppTextStyles.headlineLarge.copyWith(
            fontSize: 22.sp,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                offset: const Offset(1, 1),
                blurRadius: 3.0,
                color: Colors.black.withOpacity(0.3),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 300.ms, delay: 200.ms)
            .slideY(begin: 0.3, end: 0, duration: 300.ms, delay: 200.ms),
        Row(
          children: [
            ThemeToggle(),
            SizedBox(width: 8.w),
            IconButton(
              onPressed: _toggleSearch,
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ).animate().scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                duration: 300.ms,
                delay: 100.ms),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        IconButton(
          onPressed: _toggleSearch,
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: TextFormField(
            controller: _searchController,
            focusNode: _searchFocus,
            decoration: InputDecoration(
              hintText: 'Search for news...',
              hintStyle: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
                icon: Icon(
                  Icons.clear,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
            ),
            onChanged: (value) {
              setState(() {});
              if (value.isNotEmpty) {
                _performSearch(value);
              }
            },
            onFieldSubmitted: _performSearch,
            textInputAction: TextInputAction.search,
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => _performSearch(_searchController.text),
            icon: Icon(
              Icons.search,
              color: AppColors.primary,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // News Source Selector
        SliverToBoxAdapter(
          child: Consumer<NewsProvider>(
            builder: (context, newsProvider, child) {
              return NewsSourceSelector(
                newsSources: newsProvider.newsSources,
                onSourceSelected: (sourceValue) {
                  newsProvider.setNewsSource(sourceValue);
                },
              );
            },
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 300.ms)
              .slideY(begin: 0.3, end: 0, duration: 300.ms, delay: 300.ms),
        ),

        // Headlines Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Headlines',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppThemeColors.textColor(context),
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 400.ms).slideX(
                    begin: -0.3, end: 0, duration: 300.ms, delay: 400.ms),
                TextButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.allHeadlines),
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('See All'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 400.ms).slideX(
                    begin: 0.3, end: 0, duration: 300.ms, delay: 400.ms),
              ],
            ),
          ),
        ),

        // Headlines Carousel
        SliverToBoxAdapter(
          child: SizedBox(
            height: 0.35.sh, // 35% of screen height
            child: const HeadlinesCarousel(),
          ),
        ),

        // Latest News Section Title
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Latest News',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppThemeColors.textColor(context),
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 500.ms).slideX(
                    begin: -0.3, end: 0, duration: 300.ms, delay: 500.ms),
                Consumer<NewsProvider>(
                  builder: (context, newsProvider, child) {
                    return TextButton.icon(
                      onPressed: () {
                        // Show refresh indicator
                        newsProvider.fetchNewsByCategory();
                      },
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Refresh'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        textStyle: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ).animate().fadeIn(duration: 300.ms, delay: 500.ms).slideX(
                    begin: 0.3, end: 0, duration: 300.ms, delay: 500.ms),
              ],
            ),
          ),
        ),

        // Latest News List
        Consumer<NewsProvider>(
          builder: (context, newsProvider, child) {
            return SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              sliver: const LatestNewsList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.searchStatus == LoadingStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (newsProvider.searchStatus == LoadingStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: AppColors.red, size: 48),
                SizedBox(height: 16.h),
                Text(
                  'Error searching news',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppThemeColors.textColor(context),
                  ),
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: () => _performSearch(_searchController.text),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final articles = newsProvider.searchArticles;

        if (articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: AppThemeColors.darkGrey(context),
                ),
                SizedBox(height: 16.h),
                Text(
                  'No results found for "${_searchController.text}"',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppThemeColors.textColor(context),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Try different keywords or check your spelling',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppThemeColors.darkGrey(context),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Card(
              margin: EdgeInsets.only(bottom: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: InkWell(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.newsDetails,
                    arguments: {
                      'newsImage': article.urlToImage ?? '',
                      'newsTitle': article.title ?? '',
                      'newsDate': article.publishedAt ?? '',
                      'newsAuthor': article.author ?? '',
                      'newsDesc': article.description ?? '',
                      'newsContent': article.content ?? '',
                      'newsSource': article.source?.name ?? '',
                      'newsUrl': article.url ?? '',
                      'heroTag': 'search_${article.title}_$index',
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          article.urlToImage ??
                              'https://via.placeholder.com/100',
                          width: 100.w,
                          height: 100.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100.w,
                              height: 100.h,
                              color: AppThemeColors.grey(context),
                              child: Icon(Icons.broken_image,
                                  color: AppThemeColors.textColor(context)),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.title ?? '',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppThemeColors.textColor(context),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              article.description ?? '',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppThemeColors.darkGrey(context),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  article.source?.name ?? '',
                                  style: AppTextStyles.headlineSmall.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                if (article.publishedAt != null)
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(
                                      DateTime.parse(article.publishedAt!),
                                    ),
                                    style: AppTextStyles.headlineSmall.copyWith(
                                      color: AppThemeColors.darkGrey(context),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(
                duration: 300.ms, delay: Duration(milliseconds: index * 100));
          },
        );
      },
    );
  }
}
