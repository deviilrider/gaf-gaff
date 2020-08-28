import 'package:flutter/material.dart';

class CategorySelectorViewModel with ChangeNotifier {
  List<String> categoryList = [
    "Recommended",
    "Politics",
    "Social issues",
    "Literature",
    "Entertainment",
    "Sports",
    "Entrepreneurship",
    "Others"
  ];

  Map<String, bool> isCategorySelected = {};
  String selectedCategory;

  CategorySelectorViewModel() {
    setCategory("Recommended");
  }

  setCategory(String e) {
    isCategorySelected.clear();
    isCategorySelected[e] = true;
    selectedCategory = e;
    notifyListeners();
  }
}
