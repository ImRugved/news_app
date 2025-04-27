import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:news_app/Constants/app_colors.dart';
import 'package:news_app/Constants/app_text_styles.dart';
import 'package:news_app/Utils/routes.dart';
import 'package:news_app/View/Body/headlines_carousel.dart';
import 'package:news_app/View/Body/latest_news_list.dart';
import 'package:news_app/View/Body/news_source_selector.dart';
import 'package:news_app/View/Provider/news_provider.dart';

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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
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
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
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
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(
              Icons.category_outlined,
              color: AppColors.primary,
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
            fontSize: 20.sp,
            color: AppColors.primary,
          ),
        )
            .animate()
            .fadeIn(duration: 300.ms, delay: 200.ms)
            .slideY(begin: 0.3, end: 0, duration: 300.ms, delay: 200.ms),
        IconButton(
          onPressed: _toggleSearch,
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(
              Icons.search,
              color: AppColors.primary,
            ),
          ),
        ).animate().scale(
            begin: const Offset(0.5, 0.5),
            end: const Offset(1, 1),
            duration: 300.ms,
            delay: 100.ms),
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
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.primary,
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
              hintStyle:
                  AppTextStyles.bodySmall.copyWith(color: AppColors.darkGrey),
              filled: true,
              fillColor: AppColors.lightGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
                icon: Icon(Icons.clear, color: AppColors.darkGrey),
              ),
            ),
            onChanged: (value) {
              setState(() {});
            },
            onFieldSubmitted: _performSearch,
            textInputAction: TextInputAction.search,
          ),
        ),
        SizedBox(width: 8.w),
        ElevatedButton(
          onPressed: () => _performSearch(_searchController.text),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            backgroundColor: AppColors.primary,
          ),
          child: Icon(Icons.search, color: AppColors.white),
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
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Headlines',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppColors.textColor,
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 400.ms).slideX(
                    begin: -0.3, end: 0, duration: 300.ms, delay: 400.ms),
                TextButton.icon(
                  onPressed: () {},
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
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Latest News',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppColors.textColor,
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 500.ms).slideX(
                    begin: -0.3, end: 0, duration: 300.ms, delay: 500.ms),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Refresh'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 500.ms).slideX(
                    begin: 0.3, end: 0, duration: 300.ms, delay: 500.ms),
              ],
            ),
          ),
        ),

        // Latest News List
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          sliver: LatestNewsList(),
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
                  style: AppTextStyles.bodyMedium,
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
                  color: Colors.grey,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No results found for "${_searchController.text}"',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textColor),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Try different keywords or check your spelling',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.darkGrey),
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
                              color: AppColors.grey,
                              child: Icon(Icons.broken_image,
                                  color: AppColors.white),
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
                                color: AppColors.textColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              article.description ?? '',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.darkGrey,
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
                                      color: AppColors.darkGrey,
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
