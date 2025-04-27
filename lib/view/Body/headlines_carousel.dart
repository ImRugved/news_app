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

class HeadlinesCarousel extends StatelessWidget {
  const HeadlinesCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('MMM dd, yyyy');

    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.headlinesStatus == LoadingStatus.loading) {
          return _buildHeadlinesShimmer();
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
                      .copyWith(color: AppColors.textColor),
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
              style:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.textColor),
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
                        color: AppColors.shadowColor.withOpacity(0.3),
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
                                : 'https://via.placeholder.com/400x300?text=No+Image',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => _buildImageShimmer(),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.grey,
                              child: const Icon(
                                Icons.broken_image,
                                color: AppColors.white,
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
                                    .fadeIn(duration: 300.ms, delay: 200.ms)
                                    .slideY(begin: 0.2, end: 0),

                                SizedBox(height: 12.h),

                                // Date and read more button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_rounded,
                                          size: 14,
                                          color: AppColors.white,
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          format.format(dateTime),
                                          style:
                                              AppTextStyles.titleSmall.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary,
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Read More',
                                            style: AppTextStyles.titleSmall
                                                .copyWith(
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 12,
                                            color: AppColors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Page indicator
                        Positioned(
                          top: 20.h,
                          right: 20.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              '${index + 1}/${articles.length}',
                              style: AppTextStyles.titleSmall.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeadlinesShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBaseColor,
        highlightColor: AppColors.shimmerHighlightColor,
        child: Container(
          height: 0.35.sh,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
      ),
    );
  }

  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Container(
        color: Colors.white,
      ),
    );
  }
}
