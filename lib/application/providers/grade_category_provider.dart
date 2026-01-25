import 'package:flutter/material.dart';
import '../../domain/entities/grado.dart';
import '../../domain/entities/category.dart';
import '../use_cases/get_categories_by_grade_use_case.dart';
import '../use_cases/get_grades_by_category_use_case.dart';
import '../use_cases/assign_category_to_grade_use_case.dart';
import '../use_cases/unassign_category_from_grade_use_case.dart';
import '../use_cases/get_all_assignments_use_case.dart';

class GradeCategoryProvider with ChangeNotifier {
  final GetCategoriesByGradeUseCase getCategoriesByGradeUC;
  final GetGradesByCategoryUseCase getGradesByCategoryUC;
  final AssignCategoryToGradeUseCase assignUC;
  final UnassignCategoryFromGradeUseCase unassignUC;
  final GetAllAssignmentsUseCase getAllAssignmentsUC;

  List<Map<String, dynamic>> _assignments = [];
  bool _isLoading = false;

  GradeCategoryProvider(
    this.getCategoriesByGradeUC,
    this.getGradesByCategoryUC,
    this.assignUC,
    this.unassignUC,
    this.getAllAssignmentsUC,
  );

  List<Map<String, dynamic>> get assignments => _assignments;
  bool get isLoading => _isLoading;

  Future<void> loadAssignments() async {
    _isLoading = true;
    notifyListeners();
    try {
      _assignments = await getAllAssignmentsUC.execute();
    } catch (e) {
      debugPrint('Error loading assignments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> assign(int gradeId, int categoryId) async {
    await assignUC.execute(gradeId, categoryId);
    await loadAssignments();
  }

  Future<void> unassign(int gradeId, int categoryId) async {
    await unassignUC.execute(gradeId, categoryId);
    await loadAssignments();
  }

  Future<List<Category>> getCategoriesByGrade(int gradeId) async {
    return await getCategoriesByGradeUC.execute(gradeId);
  }

  Future<List<Grado>> getGradesByCategory(int categoryId) async {
    return await getGradesByCategoryUC.execute(categoryId);
  }
}
