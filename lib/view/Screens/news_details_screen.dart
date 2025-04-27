import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Constants/app_colors.dart';
import 'package:news_app/Constants/app_text_styles.dart';
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 300.h,
              pinned: true,
              backgroundColor: AppColors.backgroundColor,
              elevation: 0,
              leading: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  margin: EdgeInsets.only(left: 16.w, top: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor.withOpacity(0.7),
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
                      color: AppColors.backgroundColor.withOpacity(0.7),
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
                        imageUrl: newsImage,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.lightGrey,
                          child: Icon(
                            Icons.image_not_supported_rounded,
                            color: AppColors.red,
                            size: 50,
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          color: AppColors.lightGrey,
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
                            AppColors.black.withOpacity(0.7),
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
                            color: AppColors.darkGrey,
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
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                        .animate()
                        .slideY(begin: 0.2, end: 0, duration: 400.ms)
                        .fadeIn(),

                    SizedBox(height: 20.h),

                    // Author
                    if (newsAuthor.isNotEmpty)
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Author',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                                Text(
                                  newsAuthor,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .slideY(begin: 0.2, end: 0, duration: 500.ms)
                          .fadeIn(),

                    SizedBox(height: 20.h),

                    // Description
                    Text(
                      newsDesc,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textColor,
                        height: 1.5,
                      ),
                    )
                        .animate()
                        .slideY(begin: 0.2, end: 0, duration: 600.ms)
                        .fadeIn(),

                    SizedBox(height: 16.h),

                    // Content
                    Text(
                      newsContent.isNotEmpty
                          ? newsContent.replaceAll(
                              RegExp(r'\[\+\d+ chars\]'), '')
                          : 'No content available',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textColor.withOpacity(0.9),
                        height: 1.6,
                      ),
                    )
                        .animate()
                        .slideY(begin: 0.2, end: 0, duration: 700.ms)
                        .fadeIn(),

                    SizedBox(height: 30.h),

                    // Read More Button - Disabled since we don't have URL in this version
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Use a default URL since we don't have the original article URL
                          final url = Uri.parse(
                              'https://news.google.com/search?q=$newsTitle');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Read Full Article',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ).animate().scale(duration: 300.ms).fadeIn(),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
