import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/voter.dart';
import '../use_cases/login_use_case.dart';
import '../use_cases/login_voter_use_case.dart';
import '../use_cases/identify_user_use_case.dart';
import '../use_cases/update_password_use_case.dart';

class AuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LoginVoterUseCase loginVoterUseCase;
  final IdentifyUserUseCase identifyUserUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;
  Object? _currentUser;

  AuthProvider({
    required this.loginUseCase,
    required this.loginVoterUseCase,
    required this.identifyUserUseCase,
    required this.updatePasswordUseCase,
  });

  Object? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser is User;
  bool get isVoter => _currentUser is Voter;

  Future<IdentificationResult?> identifyUser(String identifier) async {
    return await identifyUserUseCase.execute(identifier);
  }

  Future<bool> loginAdmin(String username, String password) async {
    final user = await loginUseCase.execute(username, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> loginVoter(
    String documentId,
    String? password, {
    bool passRequired = true,
  }) async {
    if (!passRequired) {
      final voter = await identifyUserUseCase.voterRepository
          .getVoterByDocumentId(documentId);
      if (voter != null) {
        _currentUser = voter;
        notifyListeners();
        return true;
      }
      return false;
    }

    if (password == null) return false;

    final voter = await loginVoterUseCase.execute(documentId, password);
    if (voter != null) {
      _currentUser = voter;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> refreshVoter() async {
    if (_currentUser is Voter) {
      final voter = _currentUser as Voter;
      final updatedVoter = await identifyUserUseCase.voterRepository
          .getVoterById(voter.id!);
      if (updatedVoter != null) {
        _currentUser = updatedVoter;
        notifyListeners();
      }
    }
  }

  Future<void> updatePassword(int userId, String newPassword) async {
    await updatePasswordUseCase.execute(userId, newPassword);
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
