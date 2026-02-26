import '../../domain/entities/voter.dart';
import '../../domain/repositories/voter_repository.dart';

class SaveVoterUseCase {
  final VoterRepository _repository;

  SaveVoterUseCase(this._repository);

  Future<void> execute(Voter voter) {
    return _repository.saveVoter(voter);
  }
}
