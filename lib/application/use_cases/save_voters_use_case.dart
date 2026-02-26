import '../../domain/entities/voter.dart';
import '../../domain/repositories/voter_repository.dart';

class SaveVotersUseCase {
  final VoterRepository _repository;

  SaveVotersUseCase(this._repository);

  Future<void> execute(List<Voter> voters) {
    return _repository.saveVoters(voters);
  }
}
