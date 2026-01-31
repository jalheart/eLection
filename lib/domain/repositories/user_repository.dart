import '../entities/user.dart';

abstract class UserRepository {
  Future<User?> login(String username, String password);
  Future<User?> findByUsername(String username);
  Future<User?> getUserById(int id);
  Future<List<User>> getAllUsers();
  Future<void> updatePassword(int userId, String newPassword);
}
