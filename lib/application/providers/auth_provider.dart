import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../use_cases/login_use_case.dart';
import '../use_cases/check_username_use_case.dart';

class AuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
  final CheckUsernameUseCase checkUsernameUseCase;
  User? _currentUser;

  AuthProvider(this.loginUseCase, this.checkUsernameUseCase);

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<User?> checkUsername(String username) async {
    return await checkUsernameUseCase.execute(username);
  }

  Future<bool> login(String username, String password) async {
    final user = await loginUseCase.execute(username, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
