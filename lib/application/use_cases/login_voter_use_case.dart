import '../../domain/entities/voter.dart';
import '../../domain/repositories/voter_repository.dart';

class LoginVoterUseCase {
  final VoterRepository voterRepository;

  LoginVoterUseCase(this.voterRepository);

  Future<Voter?> execute(String documentId, String password) async {
    return await voterRepository.login(documentId, password);
  }
}
