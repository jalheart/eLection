import '../../domain/entities/candidate.dart';
import '../../domain/repositories/candidate_repository.dart';

class SaveCandidateUseCase {
  final CandidateRepository _repository;

  SaveCandidateUseCase(this._repository);

  Future<int> execute(Candidate candidate) {
    return _repository.saveCandidate(candidate);
  }
}
