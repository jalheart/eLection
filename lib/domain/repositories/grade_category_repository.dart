import '../entities/grado.dart';
import '../entities/category.dart';

abstract class GradeCategoryRepository {
  Future<List<Category>> getCategoriesByGrade(int gradeId);
  Future<List<Grado>> getGradesByCategory(int categoryId);
  Future<void> assignCategoryToGrade(int gradeId, int categoryId);
  Future<void> removeCategoryFromGrade(int gradeId, int categoryId);
  Future<List<Map<String, dynamic>>> getAllAssignments();
}
