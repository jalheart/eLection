import '../../domain/repositories/grade_category_repository.dart';

class GetAllAssignmentsUseCase {
  final GradeCategoryRepository repository;
  GetAllAssignmentsUseCase(this.repository);

  Future<List<Map<String, dynamic>>> execute() {
    return repository.getAllAssignments();
  }
}
