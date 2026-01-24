import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../use_cases/get_categories_use_case.dart';
import '../use_cases/save_category_use_case.dart';
import '../use_cases/delete_category_use_case.dart';

class CategoriesProvider with ChangeNotifier {
  final GetCategoriesUseCase _getCategoriesUC;
  final SaveCategoryUseCase _saveCategoryUC;
  final DeleteCategoryUseCase _deleteCategoryUC;

  List<Category> _categories = [];
  bool _isLoading = false;

  CategoriesProvider(
    this._getCategoriesUC,
    this._saveCategoryUC,
    this._deleteCategoryUC,
  );

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await _getCategoriesUC.execute();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveCategory(Category category) async {
    await _saveCategoryUC.execute(category);
    await loadCategories();
  }

  Future<void> deleteCategory(int id) async {
    await _deleteCategoryUC.execute(id);
    await loadCategories();
  }
}
