import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Constants/app_colors.dart';
import 'package:news_app/Constants/app_text_styles.dart';
import 'package:news_app/Utils/routes.dart';
import 'package:news_app/models/news_model.dart';

class NewsItem extends StatelessWidget {
  final Article article;
  final int index;

  const NewsItem({
    super.key,
    required this.article,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a unique hero tag
    final String heroTag = "news_${article.title ?? ''}_$index";

    return GestureDetector(
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
        margin: EdgeInsets.only(
          bottom: 20.h,
          left: 20.w,
          right: 20.w,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              child: Hero(
                tag: heroTag,
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage != null &&
                          article.urlToImage!.isNotEmpty &&
                          (article.urlToImage!.startsWith('http://') ||
                              article.urlToImage!.startsWith('https://'))
                      ? article.urlToImage!
                      : 'https://png.pngtree.com/png-vector/20190820/ourmid/pngtree-no-image-vector-illustration-isolated-png-image_1694547.jpg',
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.lightGrey,
                    height: 200.h,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.lightGrey,
                    height: 200.h,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported_rounded,
                          color: AppColors.red,
                          size: 40,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Image not available',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          article.source?.name ?? 'Unknown',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        article.publishedAt != null
                            ? DateFormat('MMM dd, yyyy').format(
                                DateTime.parse(article.publishedAt!),
                              )
                            : 'Unknown date',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Title
                  Text(
                    article.title ?? 'No Title',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 12.h),

                  // Description
                  Text(
                    article.description ?? 'No description available',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textColor.withOpacity(0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 16.h),

                  // Read More
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Read More',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.primary,
                              size: 14,
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
        .fade(
          duration: 400.ms,
          delay: Duration(milliseconds: 100 * index),
        )
        .slideY(
          begin: 0.2,
          end: 0,
          duration: 400.ms,
          delay: Duration(milliseconds: 100 * index),
          curve: Curves.easeOutQuad,
        );
  }
}
