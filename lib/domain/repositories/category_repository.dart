import '../entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<void> saveCategory(Category category);
  Future<void> deleteCategory(int id);
}
