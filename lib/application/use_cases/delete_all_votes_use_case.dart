import '../../domain/repositories/vote_repository.dart';
import '../../domain/repositories/voter_repository.dart';

class DeleteAllVotesUseCase {
  final VoteRepository voteRepository;
  final VoterRepository voterRepository;

  DeleteAllVotesUseCase(this.voteRepository, this.voterRepository);

  Future<void> execute() async {
    await voteRepository.deleteAll();
    await voterRepository.resetAllVotersStatus();
  }
}
