import '../entities/vote.dart';

abstract class VoteRepository {
  Future<void> saveVote(Vote vote);
  Future<void> saveVotes(List<Vote> votes);
  Future<List<Vote>> getVotesByVoter(int voterId);
  Future<Map<int, int>> getResultsByCategory(int categoryId);
}
