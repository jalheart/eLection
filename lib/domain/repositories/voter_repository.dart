import '../entities/voter.dart';

abstract class VoterRepository {
  Future<List<Voter>> getVoters();
  Future<List<Voter>> getVotersByGrade(int gradeId);
  Future<void> saveVoter(Voter voter);
  Future<void> deleteVoter(int id);
  Future<void> saveVoters(List<Voter> voters);
  Future<void> deleteAllVoters();
  Future<Voter?> getVoterByDocumentId(String documentId);
}
