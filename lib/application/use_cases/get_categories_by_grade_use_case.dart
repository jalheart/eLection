import '../../domain/entities/category.dart';
import '../../domain/repositories/grade_category_repository.dart';

class GetCategoriesByGradeUseCase {
  final GradeCategoryRepository repository;
  GetCategoriesByGradeUseCase(this.repository);

  Future<List<Category>> execute(int gradeId) {
    return repository.getCategoriesByGrade(gradeId);
  }
}
