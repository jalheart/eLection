import '../../domain/repositories/user_repository.dart';

class UpdatePasswordUseCase {
  final UserRepository userRepository;

  UpdatePasswordUseCase(this.userRepository);

  Future<void> execute(int userId, String newPassword) async {
    await userRepository.updatePassword(userId, newPassword);
  }
}
