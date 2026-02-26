import '../../domain/entities/grado.dart';
import '../../domain/repositories/grade_category_repository.dart';

class GetGradesByCategoryUseCase {
  final GradeCategoryRepository repository;
  GetGradesByCategoryUseCase(this.repository);

  Future<List<Grado>> execute(int categoryId) {
    return repository.getGradesByCategory(categoryId);
  }
}
