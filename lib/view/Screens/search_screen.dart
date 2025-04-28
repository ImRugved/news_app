import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:news_app/Constants/app_colors.dart';
import 'package:news_app/Constants/app_text_styles.dart';
import 'package:news_app/Constants/app_theme_colors.dart';
import 'package:news_app/Utils/routes.dart';
import 'package:news_app/View/Provider/news_provider.dart';
import 'package:news_app/View/Widgets/theme_toggle.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocus.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      Provider.of<NewsProvider>(context, listen: false).searchNews(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeColors.backgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _buildSearchResults(),
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
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
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
          ThemeToggle(),
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
                color: AppColors.secondary,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildSearchResults() {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (_searchController.text.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 64,
                  color: AppThemeColors.darkGrey(context),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Search for your favorite news',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppThemeColors.textColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Find the latest articles from around the world',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppThemeColors.secondaryTextColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (newsProvider.searchStatus == LoadingStatus.loading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
            ),
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
                    fontWeight: FontWeight.w600,
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
                    color: AppThemeColors.secondaryTextColor(context),
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
              elevation: 2,
              shadowColor: AppThemeColors.shadowColor(context),
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
                borderRadius: BorderRadius.circular(12.r),
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
                              child: Icon(
                                Icons.broken_image,
                                color: AppThemeColors.textColor(context),
                              ),
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
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppThemeColors.textColor(context),
                                fontSize: 16.sp,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              article.description ?? '',
                              style: AppTextStyles.bodySmall.copyWith(
                                color:
                                    AppThemeColors.secondaryTextColor(context),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    article.source?.name ?? '',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (article.publishedAt != null)
                                  Text(
                                    article.publishedAt!.substring(0, 10),
                                    style: AppTextStyles.bodySmall.copyWith(
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
                  duration: 300.ms,
                  delay: Duration(milliseconds: index * 100),
                );
          },
        );
      },
    );
  }
}
