import '../../domain/repositories/voter_repository.dart';

class DeleteVoterUseCase {
  final VoterRepository _repository;

  DeleteVoterUseCase(this._repository);

  Future<void> execute(int id) {
    return _repository.deleteVoter(id);
  }
}
