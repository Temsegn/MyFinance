// category_provider.dart
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List<String> _categories = [
    'Groceries',
    'Rent',
    'Salary',
    'Entertainment',
  ];

  List<String> get categories => _categories;

  void addCategory(String category) {
    if (category.isNotEmpty && !_categories.contains(category)) {
      _categories.add(category);
      notifyListeners();
    }
  }

  void editCategory(String oldCategory, String newCategory) {
    if (newCategory.isNotEmpty && oldCategory != newCategory && !_categories.contains(newCategory)) {
      final index = _categories.indexOf(oldCategory);
      if (index != -1) {
        _categories[index] = newCategory;
        notifyListeners();
      }
    }
  }

  void deleteCategory(String category) {
    if (_categories.contains(category)) {
      _categories.remove(category);
      notifyListeners();
    }
  }
}