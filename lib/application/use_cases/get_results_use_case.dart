import '../../domain/repositories/vote_repository.dart';

class GetResultsUseCase {
  final VoteRepository repository;

  GetResultsUseCase(this.repository);

  Future<Map<int, int>> execute(int categoryId) async {
    return await repository.getResultsByCategory(categoryId);
  }
}
