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
import 'package:news_app/View/Widgets/theme_toggle.dart';

class AllHeadlinesScreen extends StatelessWidget {
  const AllHeadlinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeColors.backgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildHeadlinesList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Text(
            'All Headlines',
            style: AppTextStyles.headlineLarge.copyWith(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.3, end: 0, duration: 300.ms),
          Row(
            children: [
              ThemeToggle(),
              SizedBox(width: 8.w),
              IconButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.search);
                },
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeadlinesList(BuildContext context) {
    final format = DateFormat('MMM dd, yyyy');

    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.headlinesStatus == LoadingStatus.loading) {
          return _buildLoadingShimmer(context);
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
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppThemeColors.textColor(context),
                  ),
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
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppThemeColors.textColor(context),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: articles.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final article = articles[index];
            if (article.title == null) {
              return const SizedBox.shrink();
            }

            DateTime dateTime = article.publishedAt != null
                ? DateTime.parse(article.publishedAt!)
                : DateTime.now();
            String heroTag = "headline_list_${article.title}_$index";

            // Create an alternating card design
            if (index % 3 == 0) {
              return _buildFeaturedCard(
                  context, article, dateTime, format, heroTag, index);
            } else {
              return _buildStandardCard(
                  context, article, dateTime, format, heroTag, index);
            }
          },
        );
      },
    );
  }

  Widget _buildFeaturedCard(BuildContext context, Article article,
      DateTime dateTime, DateFormat format, String heroTag, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.shadowColor(context),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: Hero(
                tag: heroTag,
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage ?? '',
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildImageShimmer(context),
                  errorWidget: (context, url, error) => Container(
                    height: 200.h,
                    color: AppThemeColors.grey(context),
                    child: Icon(
                      Icons.broken_image,
                      color: AppThemeColors.textColor(context),
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          article.source?.name ?? 'News Source',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 12.sp,
                            color: AppThemeColors.darkGrey(context),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            format.format(dateTime),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppThemeColors.darkGrey(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Title
                  Text(
                    article.title ?? '',
                    style: AppTextStyles.headlineLarge.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppThemeColors.textColor(context),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 8.h),

                  // Description
                  Text(
                    article.description ?? '',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppThemeColors.secondaryTextColor(context),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 16.h),

                  // Read more button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
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
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                      ),
                      child: const Text('Read More'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
          duration: 300.ms,
          delay: Duration(milliseconds: index * 100),
        );
  }

  Widget _buildStandardCard(BuildContext context, Article article,
      DateTime dateTime, DateFormat format, String heroTag, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 2,
      shadowColor: AppThemeColors.shadowColor(context),
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
              'heroTag': heroTag,
            },
          );
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Hero(
                  tag: heroTag,
                  child: CachedNetworkImage(
                    imageUrl: article.urlToImage ?? '',
                    width: 100.w,
                    height: 100.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        _buildSmallImageShimmer(context),
                    errorWidget: (context, url, error) => Container(
                      width: 100.w,
                      height: 100.h,
                      color: AppThemeColors.grey(context),
                      child: Icon(
                        Icons.broken_image,
                        color: AppThemeColors.textColor(context),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source name chip
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          article.source?.name ?? 'News Source',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          format.format(dateTime),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppThemeColors.darkGrey(context),
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

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

                    SizedBox(height: 6.h),

                    // Description preview
                    Text(
                      article.description ?? '',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppThemeColors.secondaryTextColor(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
        );
  }

  Widget _buildLoadingShimmer(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index % 3 == 0) {
          return Container(
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: AppThemeColors.cardBackground(context),
              boxShadow: [
                BoxShadow(
                  color: AppThemeColors.shadowColor(context),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Shimmer.fromColors(
                  baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                  highlightColor:
                      isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                  child: Container(
                    height: 200.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildShimmerRect(context, 80.w, 20.h, radius: 8.r),
                          _buildShimmerRect(context, 60.w, 16.h),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      _buildShimmerRect(context, double.infinity, 24.h),
                      SizedBox(height: 8.h),
                      _buildShimmerRect(context, double.infinity, 16.h),
                      SizedBox(height: 4.h),
                      _buildShimmerRect(context, double.infinity, 16.h),
                      SizedBox(height: 16.h),
                      Center(
                        child: _buildShimmerRect(context, 120.w, 36.h,
                            radius: 8.r),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            margin: EdgeInsets.only(bottom: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 2,
            shadowColor: AppThemeColors.shadowColor(context),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerRect(context, 100.w, 100.h, radius: 8.r),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildShimmerRect(context, 80.w, 16.h),
                            _buildShimmerRect(context, 60.w, 14.h),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        _buildShimmerRect(context, double.infinity, 20.h),
                        SizedBox(height: 6.h),
                        _buildShimmerRect(context, double.infinity, 16.h),
                        SizedBox(height: 4.h),
                        _buildShimmerRect(context, double.infinity, 16.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildShimmerRect(BuildContext context, double width, double height,
      {double? radius}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius ?? 4.r),
        ),
      ),
    );
  }

  Widget _buildImageShimmer(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        height: 200.h,
        width: double.infinity,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSmallImageShimmer(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
