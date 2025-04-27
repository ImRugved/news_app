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
                        .copyWith(color: AppColors.textColor),
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
                    .copyWith(color: AppColors.textColor),
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
                          'heroTag': heroTag,
                        },
                      );
                    },
                    child: Card(
                      elevation: 2,
                      shadowColor: AppColors.shadowColor.withOpacity(0.2),
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
                                  imageUrl: article.urlToImage ?? '',
                                  fit: BoxFit.cover,
                                  height: 90.h,
                                  width: 90.w,
                                  placeholder: (context, url) =>
                                      _buildSmallImageShimmer(),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    height: 90.h,
                                    width: 90.w,
                                    color: AppColors.grey,
                                    child: Icon(Icons.broken_image,
                                        color: AppColors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // News title
                                  Text(
                                    article.title ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        AppTextStyles.headlineMedium.copyWith(
                                      color: AppColors.textColor,
                                      height: 1.3,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  if (article.description != null &&
                                      article.description!.isNotEmpty)
                                    Text(
                                      article.description!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.darkGrey,
                                      ),
                                    ),
                                  SizedBox(height: 8.h),
                                  // Source and date
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: _buildSourceBadge(
                                            article.source?.name ?? ''),
                                      ),
                                      Flexible(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.calendar_today_rounded,
                                              size: 12,
                                              color: AppColors.darkGrey,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              format.format(dateTime),
                                              style: AppTextStyles.headlineSmall
                                                  .copyWith(
                                                color: AppColors.darkGrey,
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ],
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
                  )
                      .animate(delay: Duration(milliseconds: index * 80))
                      .fadeIn(duration: 300.ms, curve: Curves.easeOutCubic)
                      .slideX(
                          begin: index.isEven ? -0.1 : 0.1,
                          end: 0,
                          duration: 300.ms,
                          curve: Curves.easeOutCubic),
                );
              },
            ),

            // Loading indicator at the bottom
            if (_isLoadingMore ||
                newsProvider.loadMoreStatus == LoadingStatus.loading)
              Padding(
                padding: EdgeInsets.only(top: 8.h, bottom: 20.h),
                child: _buildLatestNewsShimmer(),
              ),

            // End of list message when no more data
            if (!newsProvider.hasMoreData &&
                !_isLoadingMore &&
                newsProvider.loadMoreStatus != LoadingStatus.loading &&
                articles.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Center(
                  child: Text(
                    'No more news to load',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.darkGrey,
                    ),
                  ),
                ),
              ),
          ]),
        );
      },
    );
  }

  Widget _buildSourceBadge(String sourceName) {
    if (sourceName.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        sourceName,
        style: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.primary,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLatestNewsShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      child: Card(
        elevation: 2,
        shadowColor: AppColors.shadowColor.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Shimmer.fromColors(
          baseColor: AppColors.shimmerBaseColor,
          highlightColor: AppColors.shimmerHighlightColor,
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 90.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12.h,
                        color: Colors.white,
                        width: double.infinity,
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        height: 12.h,
                        color: Colors.white,
                        width: 0.7.sw,
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 10.h,
                        color: Colors.white,
                        width: 0.5.sw,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 16.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          Container(
                            height: 10.h,
                            width: 80.w,
                            color: Colors.white,
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
      ),
    );
  }

  Widget _buildSmallImageShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Container(
        height: 90.h,
        width: 90.w,
        color: Colors.white,
      ),
    );
  }
}
