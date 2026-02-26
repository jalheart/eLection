import '../../domain/repositories/category_repository.dart';

class DeleteCategoryUseCase {
  final CategoryRepository repository;

  DeleteCategoryUseCase(this.repository);

  Future<void> execute(int id) {
    return repository.deleteCategory(id);
  }
}
