import '../../domain/entities/voter.dart';
import '../../domain/repositories/voter_repository.dart';

class GetVotersUseCase {
  final VoterRepository _repository;

  GetVotersUseCase(this._repository);

  Future<List<Voter>> execute() {
    return _repository.getVoters();
  }
}
