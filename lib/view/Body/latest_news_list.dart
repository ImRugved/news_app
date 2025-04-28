import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:news_app/Constants/app_colors.dart';
import 'package:news_app/Constants/app_text_styles.dart';
import 'package:news_app/Constants/app_theme_colors.dart';
import 'package:news_app/Models/news_model.dart';
import 'package:news_app/Utils/routes.dart';
import 'package:news_app/View/Provider/news_provider.dart';

class LatestNewsList extends StatefulWidget {
  const LatestNewsList({super.key});

  @override
  State<LatestNewsList> createState() => _LatestNewsListState();
}

class _LatestNewsListState extends State<LatestNewsList> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    if (!_isLoadingMore &&
        newsProvider.loadMoreStatus != LoadingStatus.loading &&
        newsProvider.hasMoreData) {
      setState(() {
        _isLoadingMore = true;
      });

      // Call the provider to load more data
      newsProvider.loadMoreCategoryNews().then((_) {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('MMM dd, yyyy');

    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.categoryNewsStatus == LoadingStatus.loading &&
            !_isLoadingMore) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildLatestNewsShimmer(),
              childCount: 5,
            ),
          );
        }

        if (newsProvider.categoryNewsStatus == LoadingStatus.error &&
            !_isLoadingMore) {
          return SliverToBoxAdapter(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: AppColors.red, size: 48),
                  SizedBox(height: 16.h),
                  Text(
                    'Error loading latest news',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppThemeColors.textColor(context)),
                  ),
                  SizedBox(height: 8.h),
                  ElevatedButton(
                    onPressed: () => newsProvider.fetchNewsByCategory(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final articles = newsProvider.categoryArticles;

        if (articles.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(
                'No news available',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppThemeColors.textColor(context)),
              ),
            ),
          );
        }

        // Create multi-sliver list for content + loading indicator
        return SliverList(
          delegate: SliverChildListDelegate([
            // Main list of articles
            ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                if (article.title == null) {
                  return const SizedBox.shrink();
                }

                DateTime dateTime = article.publishedAt != null
                    ? DateTime.parse(article.publishedAt!)
                    : DateTime.now();
                String heroTag = "latest_${article.title}_$index";

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                  child: GestureDetector(
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
                          'heroTag': heroTag,
                        },
                      );
                    },
                    child: Card(
                      elevation: 2,
                      shadowColor: AppThemeColors.shadowColor(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: heroTag,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: CachedNetworkImage(
                                  imageUrl: (article.urlToImage != null &&
                                          article.urlToImage!.isNotEmpty &&
                                          (article.urlToImage!
                                                  .startsWith('http://') ||
                                              article.urlToImage!
                                                  .startsWith('https://')))
                                      ? article.urlToImage!
                                      : 'https://png.pngtree.com/png-vector/20190820/ourmid/pngtree-no-image-vector-illustration-isolated-png-image_1694547.jpg',
                                  fit: BoxFit.cover,
                                  height: 90.h,
                                  width: 90.w,
                                  placeholder: (context, url) =>
                                      _buildSmallImageShimmer(),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    height: 90.h,
                                    width: 90.w,
                                    color: AppThemeColors.grey(context),
                                    child: Icon(Icons.broken_image,
                                        color:
                                            AppThemeColors.textColor(context)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
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

                                  // Description (if available)
                                  if (article.description != null &&
                                      article.description!.isNotEmpty)
                                    Text(
                                      article.description!,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color:
                                            AppThemeColors.secondaryTextColor(
                                                context),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  SizedBox(height: 8.h),

                                  // Source and date
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          article.source?.name ?? '',
                                          style:
                                              AppTextStyles.bodySmall.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        format.format(dateTime),
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color:
                                              AppThemeColors.darkGrey(context),
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
                        delay: Duration(milliseconds: index * 50),
                      ),
                );
              },
            ),

            // Loading indicator for pagination
            if (_isLoadingMore && newsProvider.hasMoreData)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ),

            // "No more news" indicator
            if (!newsProvider.hasMoreData && articles.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Center(
                  child: Text(
                    'No more news to load',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppThemeColors.darkGrey(context),
                    ),
                  ),
                ),
              ),
          ]),
        );
      },
    );
  }

  Widget _buildLatestNewsShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      child: Card(
        elevation: 2,
        shadowColor: AppThemeColors.shadowColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSmallImageShimmer(),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerLine(width: double.infinity, height: 16.h),
                    SizedBox(height: 8.h),
                    _buildShimmerLine(width: double.infinity, height: 16.h),
                    SizedBox(height: 8.h),
                    _buildShimmerLine(width: 200.w, height: 16.h),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildShimmerLine(width: 100.w, height: 12.h),
                        _buildShimmerLine(width: 80.w, height: 12.h),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallImageShimmer() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[800]! : AppColors.shimmerBaseColor,
      highlightColor:
          isDarkMode ? Colors.grey[700]! : AppColors.shimmerHighlightColor,
      child: Container(
        height: 90.h,
        width: 90.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  Widget _buildShimmerLine({required double width, required double height}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[800]! : AppColors.shimmerBaseColor,
      highlightColor:
          isDarkMode ? Colors.grey[700]! : AppColors.shimmerHighlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }
}
