import 'package:drift/drift.dart';
import '../../../domain/entities/vote.dart' as domain;
import '../../../domain/repositories/vote_repository.dart';
import '../database.dart';

class DriftVoteRepository implements VoteRepository {
  final AppDatabase db;

  DriftVoteRepository(this.db);

  @override
  Future<void> saveVote(domain.Vote vote) async {
    await db.into(db.votes).insert(
      VotesCompanion.insert(
        voterId: vote.voterId,
        candidateId: vote.candidateId,
      ),
    );
  }

  @override
  Future<void> saveVotes(List<domain.Vote> votes) async {
    await db.batch((batch) {
      batch.insertAll(
        db.votes,
        votes.map(
          (v) => VotesCompanion.insert(
            voterId: v.voterId,
            candidateId: v.candidateId,
          ),
        ),
      );
    });
  }

  @override
  Future<List<domain.Vote>> getVotesByVoter(int voterId) async {
    final query = db.select(db.votes)..where((v) => v.voterId.equals(voterId));
    final result = await query.get();
    return result.map(_mapToDomain).toList();
  }

  @override
  Future<Map<int, int>> getResultsByCategory(int categoryId) async {
    // This is a bit more complex since category is in Candidates table
    final count = db.votes.id.count();
    final query = db.select(db.votes).join([
      innerJoin(db.candidates, db.candidates.id.equalsExp(db.votes.candidateId)),
    ])
      ..where(db.candidates.categoryId.equals(categoryId))
      ..addColumns([count])
      ..groupBy([db.votes.candidateId]);

    final results = await query.get();
    final Map<int, int> resultMap = {};
    for (final row in results) {
      final candidateId = row.readTable(db.candidates).id;
      final voteCount = row.read(count);
      resultMap[candidateId] = voteCount ?? 0;
    }
    return resultMap;
  }

  @override
  Future<void> deleteAll() async {
    await db.delete(db.votes).go();
  }

  domain.Vote _mapToDomain(Vote vote) {
    return domain.Vote(
      id: vote.id,
      voterId: vote.voterId,
      candidateId: vote.candidateId,
    );
  }
}
