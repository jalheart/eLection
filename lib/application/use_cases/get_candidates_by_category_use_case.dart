import '../../domain/entities/candidate.dart';
import '../../domain/repositories/candidate_repository.dart';

class GetCandidatesByCategoryUseCase {
  final CandidateRepository _repository;

  GetCandidatesByCategoryUseCase(this._repository);

  Future<List<Candidate>> execute(int categoryId) {
    return _repository.getCandidatesByCategory(categoryId);
  }
}
