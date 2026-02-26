import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<Category>> execute() {
    return repository.getCategories();
  }
}
