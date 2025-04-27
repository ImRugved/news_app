import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/Constants/app_colors.dart';
import 'package:news_app/Constants/app_text_styles.dart';

class NewsSourceSelector extends StatelessWidget {
  final List<Map<String, dynamic>> newsSources;
  final Function(String) onSourceSelected;

  const NewsSourceSelector({
    super.key,
    required this.newsSources,
    required this.onSourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: SizedBox(
        height: 90.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
          itemCount: newsSources.length,
          itemBuilder: (context, index) {
            final source = newsSources[index];
            final bool isSelected = source['isSelected'] ?? false;

            return GestureDetector(
              onTap: () => onSourceSelected(source['value']),
              child: Container(
                width: 90.w,
                margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 50.h,
                      width: 50.h,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          source['icon'],
                          color:
                              isSelected ? AppColors.white : AppColors.primary,
                          size: 24,
                        ),
                      ),
                    ).animate(target: isSelected ? 1 : 0).scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.05, 1.05),
                        duration: 300.ms),
                    SizedBox(height: 8.h),
                    Text(
                      source['name'],
                      style: isSelected
                          ? AppTextStyles.headlineSmall.copyWith(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w600,
                            )
                          : AppTextStyles.headlineSmall.copyWith(
                              color: AppColors.darkGrey,
                              fontWeight: FontWeight.w500,
                            ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
                  .animate(delay: Duration(milliseconds: index * 70))
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.2, end: 0, duration: 300.ms),
            );
          },
        ),
      ),
    );
  }
}
