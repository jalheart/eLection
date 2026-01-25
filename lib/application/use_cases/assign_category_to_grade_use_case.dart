import '../../domain/repositories/grade_category_repository.dart';

class AssignCategoryToGradeUseCase {
  final GradeCategoryRepository repository;
  AssignCategoryToGradeUseCase(this.repository);

  Future<void> execute(int gradeId, int categoryId) {
    return repository.assignCategoryToGrade(gradeId, categoryId);
  }
}
