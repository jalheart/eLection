import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class CheckUsernameUseCase {
  final UserRepository userRepository;

  CheckUsernameUseCase(this.userRepository);

  Future<User?> execute(String username) async {
    return await userRepository.findByUsername(username);
  }
}
