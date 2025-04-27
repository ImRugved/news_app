import 'package:flutter/material.dart';
import 'package:news_app/View/Screens/categories_screen.dart';

Color getCategoryColor(String category, List<CategoryItem> categories) {
  for (var item in categories) {
    if (item.name == category) {
      return item.color;
    }
  }
  return Colors.blue; // Default color
}
