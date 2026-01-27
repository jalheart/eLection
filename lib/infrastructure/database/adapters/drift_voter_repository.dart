import 'package:drift/drift.dart';
import '../../../domain/entities/voter.dart' as domain;
import '../../../domain/repositories/voter_repository.dart';
import '../database.dart';

class DriftVoterRepository implements VoterRepository {
  final AppDatabase db;

  DriftVoterRepository(this.db);

  @override
  Future<List<domain.Voter>> getVoters() async {
    final results = await db.select(db.voters).get();
    return results.map(_mapToDomain).toList();
  }

  @override
  Future<List<domain.Voter>> getVotersByGrade(int gradeId) async {
    final query = db.select(db.voters)..where((t) => t.gradeId.equals(gradeId));
    final results = await query.get();
    return results.map(_mapToDomain).toList();
  }

  @override
  Future<void> saveVoter(domain.Voter voter) async {
    if (voter.id == null) {
      await db
          .into(db.voters)
          .insert(
            VotersCompanion.insert(
              name: voter.name,
              documentId: voter.documentId,
              gradeId: voter.gradeId,
              hasVoted: Value(voter.hasVoted),
            ),
          );
    } else {
      await (db.update(db.voters)..where((t) => t.id.equals(voter.id!))).write(
        VotersCompanion(
          name: Value(voter.name),
          documentId: Value(voter.documentId),
          gradeId: Value(voter.gradeId),
          hasVoted: Value(voter.hasVoted),
        ),
      );
    }
  }

  @override
  Future<void> deleteVoter(int id) async {
    await (db.delete(db.voters)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> saveVoters(List<domain.Voter> voters) async {
    await db.batch((batch) {
      batch.insertAll(
        db.voters,
        voters.map(
          (v) => VotersCompanion.insert(
            name: v.name,
            documentId: v.documentId,
            gradeId: v.gradeId,
            hasVoted: Value(v.hasVoted),
          ),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> deleteAllVoters() async {
    await db.delete(db.voters).go();
  }

  @override
  Future<domain.Voter?> getVoterByDocumentId(String documentId) async {
    final query = db.select(db.voters)
      ..where((t) => t.documentId.equals(documentId));
    final result = await query.getSingleOrNull();
    return result != null ? _mapToDomain(result) : null;
  }

  domain.Voter _mapToDomain(Voter voter) {
    return domain.Voter(
      id: voter.id,
      name: voter.name,
      documentId: voter.documentId,
      gradeId: voter.gradeId,
      hasVoted: voter.hasVoted,
    );
  }
}
