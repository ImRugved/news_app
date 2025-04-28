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

class HeadlinesCarousel extends StatelessWidget {
  const HeadlinesCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('MMM dd, yyyy');

    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.headlinesStatus == LoadingStatus.loading) {
          return _buildHeadlinesShimmer(context);
        }

        if (newsProvider.headlinesStatus == LoadingStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: AppColors.red, size: 48),
                SizedBox(height: 16.h),
                Text(
                  'Error loading headlines',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppThemeColors.textColor(context)),
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: () => newsProvider.fetchHeadlines(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final articles = newsProvider.headlines;

        if (articles.isEmpty) {
          return Center(
            child: Text(
              'No headlines available',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppThemeColors.textColor(context)),
            ),
          );
        }

        return PageView.builder(
          controller: PageController(viewportFraction: 0.9),
          itemCount: articles.length,
          physics: const BouncingScrollPhysics(),
          padEnds: true,
          itemBuilder: (context, index) {
            final article = articles[index];
            if (article.title == null) {
              return const SizedBox.shrink();
            }

            DateTime dateTime = article.publishedAt != null
                ? DateTime.parse(article.publishedAt!)
                : DateTime.now();
            String heroTag = "headline_${article.title}_$index";

            return Padding(
              padding: EdgeInsets.all(8.w),
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppThemeColors.shadowColor(context),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background image
                        Hero(
                          tag: heroTag,
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
                            placeholder: (context, url) =>
                                _buildImageShimmer(context),
                            errorWidget: (context, url, error) => Container(
                              color: AppThemeColors.grey(context),
                              child: Icon(
                                Icons.broken_image,
                                color: AppThemeColors.textColor(context),
                                size: 50,
                              ),
                            ),
                          ),
                        ),

                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.2),
                                Colors.black.withOpacity(0.6),
                                Colors.black.withOpacity(0.9),
                              ],
                            ),
                          ),
                        ),

                        // Content
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category/Source tag
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Text(
                                    article.source?.name ?? 'News',
                                    style: AppTextStyles.titleSmall,
                                  ),
                                ),

                                SizedBox(height: 12.h),

                                // Title
                                Text(
                                  article.title ?? '',
                                  style: AppTextStyles.titleLarge.copyWith(
                                    fontSize: 20.sp,
                                    height: 1.3,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.5),
                                        offset: const Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                )
                                    .animate()
                                    .fadeIn(duration: 300.ms, delay: 100.ms)
                                    .slideY(
                                        begin: 0.2,
                                        end: 0,
                                        duration: 300.ms,
                                        delay: 100.ms),

                                SizedBox(height: 12.h),

                                // Date and Read More button
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_rounded,
                                        size: 14, color: Colors.white70),
                                    SizedBox(width: 6.w),
                                    Text(
                                      format.format(dateTime),
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                      ),
                                      child: Text(
                                        'Read More',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(
                  duration: 300.ms, delay: Duration(milliseconds: index * 100)),
            );
          },
        );
      },
    );
  }

  Widget _buildHeadlinesShimmer(BuildContext context) {
    // Use the same height as actual content (35% of screen height)
    return SizedBox(
      height: 0.35.sh,
      child: PageView.builder(
        itemCount: 3,
        controller: PageController(viewportFraction: 0.9),
        padEnds: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.w),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: AppThemeColors.shadowColor(context),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image shimmer
                    _buildImageShimmer(context),

                    // Gradient overlay (same as real card)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.9),
                          ],
                        ),
                      ),
                    ),

                    // Content placeholders
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category/Source tag placeholder
                            Shimmer.fromColors(
                              baseColor:
                                  AppThemeColors.shimmerBaseColor(context),
                              highlightColor:
                                  AppThemeColors.shimmerHighlightColor(context),
                              child: Container(
                                width: 100.w,
                                height: 28.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                              ),
                            ),

                            SizedBox(height: 12.h),

                            // Title placeholders
                            Shimmer.fromColors(
                              baseColor:
                                  AppThemeColors.shimmerBaseColor(context),
                              highlightColor:
                                  AppThemeColors.shimmerHighlightColor(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Container(
                                    width: double.infinity,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Container(
                                    width: 200.w,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 12.h),

                            // Date and Read More button placeholders
                            Row(
                              children: [
                                Shimmer.fromColors(
                                  baseColor:
                                      AppThemeColors.shimmerBaseColor(context),
                                  highlightColor:
                                      AppThemeColors.shimmerHighlightColor(
                                          context),
                                  child: Container(
                                    width: 100.w,
                                    height: 14.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Shimmer.fromColors(
                                  baseColor:
                                      AppThemeColors.shimmerBaseColor(context),
                                  highlightColor:
                                      AppThemeColors.shimmerHighlightColor(
                                          context),
                                  child: Container(
                                    width: 80.w,
                                    height: 28.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30.r),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppThemeColors.shimmerBaseColor(context),
      highlightColor: AppThemeColors.shimmerHighlightColor(context),
      child: Container(
        color: Colors.white,
      ),
    );
  }
}
