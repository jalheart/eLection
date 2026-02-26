import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class SaveCategoryUseCase {
  final CategoryRepository repository;

  SaveCategoryUseCase(this.repository);

  Future<void> execute(Category category) {
    return repository.saveCategory(category);
  }
}
