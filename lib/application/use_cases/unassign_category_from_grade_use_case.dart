import '../../domain/repositories/grade_category_repository.dart';

class UnassignCategoryFromGradeUseCase {
  final GradeCategoryRepository repository;
  UnassignCategoryFromGradeUseCase(this.repository);

  Future<void> execute(int gradeId, int categoryId) {
    return repository.removeCategoryFromGrade(gradeId, categoryId);
  }
}
