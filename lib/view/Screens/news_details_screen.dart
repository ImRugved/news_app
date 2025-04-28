import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Constants/app_colors.dart';
import 'package:news_app/Constants/app_text_styles.dart';
import 'package:news_app/Constants/app_theme_colors.dart';
import 'package:news_app/Utils/url_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsScreen extends StatelessWidget {
  final String newsImage;
  final String newsTitle;
  final String newsDate;
  final String newsAuthor;
  final String newsDesc;
  final String newsContent;
  final String newsSource;

  final String heroTag;
  final String newsUrl;

  const NewsDetailsScreen({
    super.key,
    required this.newsImage,
    required this.newsTitle,
    required this.newsDate,
    required this.newsAuthor,
    required this.newsDesc,
    required this.newsContent,
    required this.newsSource,
    required this.heroTag,
    required this.newsUrl,
  });

  static NewsDetailsScreen fromArguments(Map<String, dynamic> args) {
    return NewsDetailsScreen(
      newsImage: args['newsImage'] ?? '',
      newsTitle: args['newsTitle'] ?? '',
      newsDate: args['newsDate'] ?? '',
      newsAuthor: args['newsAuthor'] ?? '',
      newsDesc: args['newsDesc'] ?? '',
      newsContent: args['newsContent'] ?? '',
      newsSource: args['newsSource'] ?? '',
      heroTag: args['heroTag'] ?? 'heroTag',
      newsUrl: args['newsUrl'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeColors.backgroundColor(context),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            backgroundColor: AppThemeColors.backgroundColor(context),
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                margin: EdgeInsets.only(left: 16.w, top: 8.h),
                decoration: BoxDecoration(
                  color:
                      AppThemeColors.backgroundColor(context).withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () async {
                  await Share.share(
                    '$newsTitle\nRead more: $newsDesc',
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 16.w, top: 8.h),
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppThemeColors.backgroundColor(context)
                        .withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.share_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: heroTag,
                    child: CachedNetworkImage(
                      imageUrl: newsImage.isNotEmpty &&
                              (newsImage.startsWith('http://') ||
                                  newsImage.startsWith('https://'))
                          ? newsImage
                          : 'https://png.pngtree.com/png-vector/20190820/ourmid/pngtree-no-image-vector-illustration-isolated-png-image_1694547.jpg',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: AppThemeColors.lightGrey(context),
                        child: Icon(
                          Icons.image_not_supported_rounded,
                          color: AppColors.red,
                          size: 50,
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        color: AppThemeColors.lightGrey(context),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
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
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Article Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // Source and Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          newsSource,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                          .animate()
                          .slideX(begin: -0.2, end: 0, duration: 300.ms)
                          .fadeIn(),
                      Text(
                        newsDate.isNotEmpty
                            ? DateFormat('MMM dd, yyyy').format(
                                DateTime.parse(newsDate),
                              )
                            : 'Unknown date',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppThemeColors.darkGrey(context),
                        ),
                      )
                          .animate()
                          .slideX(begin: 0.2, end: 0, duration: 300.ms)
                          .fadeIn(),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Title
                  Text(
                    newsTitle,
                    style: AppTextStyles.headlineLarge.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                      color: AppThemeColors.textColor(context),
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2, end: 0),

                  SizedBox(height: 12.h),

                  // Author
                  if (newsAuthor.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 16.sp,
                          color: AppThemeColors.darkGrey(context),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'By $newsAuthor',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppThemeColors.secondaryTextColor(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                  SizedBox(height: 16.h),

                  // Description
                  Text(
                    newsDesc,
                    style: AppTextStyles.bodyMedium.copyWith(
                      height: 1.6,
                      color: AppThemeColors.textColor(context),
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  SizedBox(height: 16.h),

                  // Content
                  if (newsContent.isNotEmpty)
                    Text(
                      newsContent,
                      style: AppTextStyles.bodyMedium.copyWith(
                        height: 1.6,
                        color: AppThemeColors.secondaryTextColor(context),
                      ),
                    ).animate().fadeIn(delay: 400.ms),

                  // Full article button
                  if (newsUrl.isNotEmpty) ...[
                    SizedBox(height: 24.h),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await UrlHelper.openUrl(newsUrl);
                        },
                        icon: const Icon(Icons.public),
                        label: Text('Read Full Article'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
