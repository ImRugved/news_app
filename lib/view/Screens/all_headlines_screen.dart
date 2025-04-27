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

class AllHeadlinesScreen extends StatelessWidget {
  const AllHeadlinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildHeadlinesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.15),
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
    );
  }

  Widget _buildHeadlinesList() {
    final format = DateFormat('MMM dd, yyyy');

    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.headlinesStatus == LoadingStatus.loading) {
          return _buildLoadingShimmer();
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
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: () => newsProvider.fetchHeadlines(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
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
                color: AppColors.textColor,
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
                  article, dateTime, format, heroTag, index);
            } else {
              return _buildStandardCard(
                  article, dateTime, format, heroTag, index);
            }
          },
        );
      },
    );
  }

  Widget _buildFeaturedCard(Article article, DateTime dateTime,
      DateFormat format, String heroTag, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
              'heroTag': heroTag,
            },
          );
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage ?? '',
                  height: 180.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      _buildImageShimmer(height: 180.h),
                  errorWidget: (context, url, error) => Container(
                    height: 180.h,
                    color: AppColors.grey,
                    child:
                        const Icon(Icons.broken_image, color: AppColors.white),
                  ),
                ),
              ),
            ),

            // Content
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source badge
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: _getColorForIndex(index).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      article.source?.name ?? 'News',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _getColorForIndex(index),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Title
                  Text(
                    article.title ?? '',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),

                  // Description
                  if (article.description != null &&
                      article.description!.isNotEmpty)
                    Text(
                      article.description!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 12.h),

                  // Date and read more
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 12.sp,
                            color: AppColors.secondaryTextColor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            format.format(dateTime),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getColorForIndex(index),
                              _getColorForIndex(index).withOpacity(0.8),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Read More',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 10.sp,
                              color: Colors.white,
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
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: Duration(milliseconds: index * 100));
  }

  Widget _buildStandardCard(Article article, DateTime dateTime,
      DateFormat format, String heroTag, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
              'heroTag': heroTag,
            },
          );
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: article.urlToImage ?? '',
                    height: 100.h,
                    width: 100.w,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        _buildImageShimmer(height: 100.h, width: 100.w),
                    errorWidget: (context, url, error) => Container(
                      height: 100.h,
                      width: 100.w,
                      color: AppColors.grey,
                      child: const Icon(Icons.broken_image,
                          color: AppColors.white),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 12.h, 12.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container with a colored border on left
                    Container(
                      padding: EdgeInsets.only(left: 8.w),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: _getColorForIndex(index),
                            width: 3.w,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            article.title ?? '',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),

                          // Source and date
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color:
                                      _getColorForIndex(index).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  article.source?.name ?? 'News',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: _getColorForIndex(index),
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Icon(
                                Icons.access_time,
                                size: 12.sp,
                                color: AppColors.secondaryTextColor,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                format.format(dateTime),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.secondaryTextColor,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Description
                    if (article.description != null &&
                        article.description!.isNotEmpty)
                      Text(
                        article.description!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.secondaryTextColor,
                          fontSize: 11.sp,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                    SizedBox(height: 8.h),

                    // Read more
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Read More',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: _getColorForIndex(index),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: Duration(milliseconds: index * 50));
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: 6,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index % 3 == 0) {
          return _buildFeaturedShimmer();
        } else {
          return _buildStandardShimmer();
        }
      },
    );
  }

  Widget _buildFeaturedShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBaseColor,
        highlightColor: AppColors.shimmerHighlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    height: 18.h,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 0.8.sw,
                    height: 18.h,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    height: 12.h,
                    color: Colors.white,
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: 0.7.sw,
                    height: 12.h,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 80.w,
                        height: 14.h,
                        color: Colors.white,
                      ),
                      Container(
                        width: 80.w,
                        height: 25.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
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
    );
  }

  Widget _buildStandardShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                height: 100.h,
                width: 100.w,
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
                      width: double.infinity,
                      height: 16.h,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 0.6.sw,
                      height: 16.h,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Container(
                          width: 60.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          width: 80.w,
                          height: 12.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      height: 12.h,
                      color: Colors.white,
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      width: 0.7.sw,
                      height: 12.h,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 60.w,
                        height: 10.h,
                        color: Colors.white,
                      ),
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

  Widget _buildImageShimmer({double? height, double? width}) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Container(
        height: height ?? 180.h,
        width: width ?? double.infinity,
        color: Colors.white,
      ),
    );
  }

  Color _getColorForIndex(int index) {
    switch (index % 4) {
      case 0:
        return AppColors.primary;
      case 1:
        return AppColors.cardAccent2;
      case 2:
        return AppColors.cardAccent3;
      case 3:
        return AppColors.cardAccent4;
      default:
        return AppColors.primary;
    }
  }
}
