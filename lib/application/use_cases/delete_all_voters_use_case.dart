import '../../domain/repositories/voter_repository.dart';

class DeleteAllVotersUseCase {
  final VoterRepository _repository;

  DeleteAllVotersUseCase(this._repository);

  Future<void> execute() {
    return _repository.deleteAllVoters();
  }
}
