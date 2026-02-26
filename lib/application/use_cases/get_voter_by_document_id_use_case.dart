import '../../domain/entities/voter.dart';
import '../../domain/repositories/voter_repository.dart';

class GetVoterByDocumentIdUseCase {
  final VoterRepository _repository;

  GetVoterByDocumentIdUseCase(this._repository);

  Future<Voter?> execute(String documentId) {
    return _repository.getVoterByDocumentId(documentId);
  }
}
