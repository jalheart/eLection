import '../../domain/entities/voter.dart';
import '../../domain/repositories/voter_repository.dart';

class GetVotersByGradeUseCase {
  final VoterRepository _repository;

  GetVotersByGradeUseCase(this._repository);

  Future<List<Voter>> execute(int gradeId) {
    return _repository.getVotersByGrade(gradeId);
  }
}
