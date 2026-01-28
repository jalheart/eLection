import '../../domain/entities/vote.dart';
import '../../domain/repositories/vote_repository.dart';
import '../../domain/repositories/voter_repository.dart';

class CastVotesUseCase {
  final VoteRepository voteRepository;
  final VoterRepository voterRepository;

  CastVotesUseCase(this.voteRepository, this.voterRepository);

  Future<void> execute(int voterId, List<int> candidateIds) async {
    // 1. Save the votes
    final votes = candidateIds.map((cid) => Vote(
      voterId: voterId,
      candidateId: cid,
    )).toList();
    
    await voteRepository.saveVotes(votes);

    // 2. Mark voter as having voted
    final voter = await voterRepository.getVoterById(voterId);
    if (voter != null) {
      final updatedVoter = voter.copyWith(hasVoted: true);
      await voterRepository.saveVoter(updatedVoter);
    }
  }
}
