import '../../domain/entities/candidate.dart';
import '../../domain/repositories/candidate_repository.dart';

class GetCandidatesUseCase {
  final CandidateRepository _repository;

  GetCandidatesUseCase(this._repository);

  Future<List<Candidate>> execute() {
    return _repository.getCandidates();
  }
}
