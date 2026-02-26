import '../../domain/repositories/candidate_repository.dart';

class DeleteCandidateUseCase {
  final CandidateRepository _repository;

  DeleteCandidateUseCase(this._repository);

  Future<void> execute(int id) {
    return _repository.deleteCandidate(id);
  }
}
