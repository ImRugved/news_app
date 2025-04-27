import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:news_app/Constants/app_colors.dart';
import 'package:news_app/Constants/app_constants.dart';
import 'package:news_app/Constants/app_text_styles.dart';
import 'package:news_app/Models/news_model.dart';
import 'package:news_app/Utils/routes.dart';
import 'package:news_app/View/Provider/news_provider.dart';
import 'package:news_app/View/Screens/news_details_screen.dart';

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem(this.name, this.icon, this.color);
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final PageController _pageController = PageController();
  String _categoryName = 'General';

  final List<CategoryItem> categories = [
    CategoryItem('General', Icons.public, AppColors.generalColor),
    CategoryItem('Entertainment', Icons.movie, AppColors.entertainmentColor),
    CategoryItem('Health', Icons.health_and_safety, AppColors.healthColor),
    CategoryItem('Sports', Icons.sports_basketball, AppColors.sportsColor),
    CategoryItem('Business', Icons.business, AppColors.businessColor),
    CategoryItem('Technology', Icons.computer, AppColors.technologyColor),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();

    // Initialize with the current category
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false)
          .setCategory(_categoryName);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildCategorySelector(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _categoryName = categories[index].name;
                    });
                    Provider.of<NewsProvider>(context, listen: false)
                        .setCategory(_categoryName);
                  },
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryContent();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
      decoration: BoxDecoration(
        //   color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
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
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.textColor,
              ),
            ),
          ),
          Text(
            'Discover',
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.textColor,
              fontWeight: FontWeight.w600,
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.3, end: 0, duration: 300.ms),
          IconButton(
            onPressed: () {
              // Search functionality
              Get.toNamed(AppRoutes.search);
            },
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.search,
                color: AppColors.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 100.h,
      // padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryItem(index);
        },
      ),
    );
  }

  Widget _buildCategoryItem(int index) {
    bool isSelected = _categoryName == categories[index].name;
    return GestureDetector(
      onTap: () {
        setState(() {
          _categoryName = categories[index].name;
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
          );
        });

        if (isSelected) return;
        HapticFeedback.lightImpact();
      },
      child: Container(
        width: 100.w,
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 60.h,
              width: 60.w,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          categories[index].color,
                          categories[index].color.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: categories[index].color.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                          spreadRadius: 2,
                        )
                      ]
                    : null,
              ),
              child: Icon(
                categories[index].icon,
                color: isSelected
                    ? Colors.white
                    : categories[index].color.withOpacity(0.7),
                size: 28,
              ),
            ),
            SizedBox(height: 8.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? categories[index].color
                    : AppColors.secondaryTextColor,
              ),
              child: Text(
                categories[index].name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      )
          .animate(
              delay: Duration(milliseconds: index * 70),
              controller: _animationController)
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.2, end: 0, duration: 300.ms),
    );
  }

  Widget _buildCategoryContent() {
    final format = DateFormat('MMM dd, yyyy');

    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.categoryNewsStatus == LoadingStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (newsProvider.categoryNewsStatus == LoadingStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    color: AppColors.errorColor, size: 48),
                SizedBox(height: 16.h),
                Text(
                  'Error loading news',
                  style: AppTextStyles.bodyMedium,
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: () => newsProvider.fetchNewsByCategory(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final articles = newsProvider.categoryArticles;

        if (articles.isEmpty) {
          return Center(
            child: Text(
              'No news available for this category',
              style: AppTextStyles.bodyMedium,
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          physics: const BouncingScrollPhysics(),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            if (article.title == null) {
              return const SizedBox.shrink();
            }

            DateTime dateTime = article.publishedAt != null
                ? DateTime.parse(article.publishedAt!)
                : DateTime.now();
            String heroTag = "category_${article.title}_$index";

            // Design alternating items differently
            if (index % 3 == 0) {
              return _buildFeaturedNewsCard(
                  article, dateTime, _categoryName, heroTag);
            } else {
              return _buildStandardNewsCard(
                  article, dateTime, _categoryName, heroTag);
            }
          },
        );
      },
    );
  }

  // Featured news card for highlighted articles
  Widget _buildFeaturedNewsCard(
      Article article, DateTime dateTime, String category, String heroTag) {
    Color categoryColor = _getCategoryColor(category);

    return Card(
      elevation: 4,
      shadowColor: AppColors.shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: Hero(
              tag: heroTag,
              child: Image.network(
                article.urlToImage ?? '',
                height: 200.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200.h,
                  color: Colors.grey[300],
                  child:
                      const Icon(Icons.image_not_supported, color: Colors.grey),
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
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        category,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: categoryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.calendar_today,
                        size: 12.sp, color: AppColors.lightTextColor),
                    SizedBox(width: 4.w),
                    Text(
                      DateFormat('MMM dd, yyyy').format(dateTime),
                      style: AppTextStyles.newsDate,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  article.title ?? '',
                  style: AppTextStyles.headlineLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Text(
                  article.description ?? '',
                  style: AppTextStyles.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        article.source?.name ?? '',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
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
                        backgroundColor: categoryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: const Text('Read More'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.2, end: 0, duration: 300.ms);
  }

  // Standard news card for regular articles
  Widget _buildStandardNewsCard(
      Article article, DateTime dateTime, String category, String heroTag) {
    return Card(
      elevation: 2,
      shadowColor: AppColors.shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.only(bottom: 12.h),
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
              // Thumbnail image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Hero(
                  tag: heroTag,
                  child: Image.network(
                    article.urlToImage ?? '',
                    width: 100.w,
                    height: 100.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100.w,
                      height: 100.h,
                      color: Colors.grey[300],
                      child:
                          Icon(Icons.image_not_supported, color: Colors.grey),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            category,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: _getCategoryColor(category),
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat('MMM dd').format(dateTime),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.lightTextColor,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      article.title ?? '',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      article.description ?? '',
                      style: AppTextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      article.source?.name ?? '',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.1, end: 0, duration: 300.ms);
  }

  // Helper method to get color for category
  Color _getCategoryColor(String category) {
    for (var item in categories) {
      if (item.name == category) {
        return item.color;
      }
    }
    return AppColors.primary; // Default color
  }
}
