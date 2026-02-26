import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class LoginUseCase {
  final UserRepository userRepository;

  LoginUseCase(this.userRepository);

  Future<User?> execute(String username, String password) async {
    return await userRepository.login(username, password);
  }
}
