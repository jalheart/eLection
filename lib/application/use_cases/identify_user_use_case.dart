import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/voter_repository.dart';

enum UserType { admin, voter }

class IdentificationResult {
  final UserType type;
  final Object user;

  IdentificationResult(this.type, this.user);
}

class IdentifyUserUseCase {
  final UserRepository userRepository;
  final VoterRepository voterRepository;

  IdentifyUserUseCase(this.userRepository, this.voterRepository);

  Future<IdentificationResult?> execute(String identifier) async {
    // Check if it's an admin first
    final admin = await userRepository.findByUsername(identifier);
    if (admin != null) {
      return IdentificationResult(UserType.admin, admin);
    }

    // Check if it's a voter
    final voter = await voterRepository.getVoterByDocumentId(identifier);
    if (voter != null) {
      return IdentificationResult(UserType.voter, voter);
    }

    return null;
  }
}
