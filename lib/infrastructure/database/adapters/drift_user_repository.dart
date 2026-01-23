import 'package:bcrypt/bcrypt.dart';
import '../../../domain/entities/user.dart' as domain;
import '../../../domain/repositories/user_repository.dart';
import '../database.dart';

class DriftUserRepository implements UserRepository {
  final AppDatabase db;

  DriftUserRepository(this.db);

  @override
  Future<domain.User?> login(String username, String password) async {
    final query = db.select(db.users)..where((u) => u.username.equals(username));
    final user = await query.getSingleOrNull();

    if (user != null && BCrypt.checkpw(password, user.password)) {
      return _mapToDomain(user);
    }
    return null;
  }

  @override
  Future<domain.User?> findByUsername(String username) async {
    final query = db.select(db.users)..where((u) => u.username.equals(username));
    final user = await query.getSingleOrNull();
    return user != null ? _mapToDomain(user) : null;
  }

  @override
  Future<domain.User?> getUserById(int id) async {
    final query = db.select(db.users)..where((u) => u.id.equals(id));
    final user = await query.getSingleOrNull();
    return user != null ? _mapToDomain(user) : null;
  }

  @override
  Future<List<domain.User>> getAllUsers() async {
    final users = await db.select(db.users).get();
    return users.map(_mapToDomain).toList();
  }

  domain.User _mapToDomain(User user) {
    return domain.User(
      id: user.id,
      username: user.username,
      password: user.password,
      name: user.name,
      email: user.email,
    );
  }
}
