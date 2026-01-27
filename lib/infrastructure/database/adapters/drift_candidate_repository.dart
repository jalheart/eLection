import 'package:drift/drift.dart';
import '../../../domain/entities/candidate.dart' as domain;
import '../../../domain/repositories/candidate_repository.dart';
import '../database.dart';

class DriftCandidateRepository implements CandidateRepository {
  final AppDatabase db;

  DriftCandidateRepository(this.db);

  @override
  Future<List<domain.Candidate>> getCandidates() async {
    final results = await db.select(db.candidates).get();
    return results.map(_mapToDomain).toList();
  }

  @override
  Future<List<domain.Candidate>> getCandidatesByCategory(int categoryId) async {
    final query = db.select(db.candidates)
      ..where((t) => t.categoryId.equals(categoryId));
    final results = await query.get();
    return results.map(_mapToDomain).toList();
  }

  @override
  Future<int> saveCandidate(domain.Candidate candidate) async {
    if (candidate.id == null) {
      return await db
          .into(db.candidates)
          .insert(
            CandidatesCompanion.insert(
              name: candidate.name,
              picture: Value(candidate.picture),
              categoryId: candidate.categoryId,
            ),
          );
    } else {
      await (db.update(
        db.candidates,
      )..where((t) => t.id.equals(candidate.id!))).write(
        CandidatesCompanion(
          name: Value(candidate.name),
          picture: Value(candidate.picture),
          categoryId: Value(candidate.categoryId),
        ),
      );
      return candidate.id!;
    }
  }

  @override
  Future<void> deleteCandidate(int id) async {
    await (db.delete(db.candidates)..where((t) => t.id.equals(id))).go();
  }

  domain.Candidate _mapToDomain(Candidate candidate) {
    return domain.Candidate(
      id: candidate.id,
      name: candidate.name,
      picture: candidate.picture,
      categoryId: candidate.categoryId,
    );
  }
}
