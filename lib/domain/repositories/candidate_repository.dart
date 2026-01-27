import '../entities/candidate.dart';

abstract class CandidateRepository {
  Future<List<Candidate>> getCandidates();
  Future<List<Candidate>> getCandidatesByCategory(int categoryId);
  Future<int> saveCandidate(Candidate candidate);
  Future<void> deleteCandidate(int id);
}
