import 'package:flutter/material.dart';
import '../../domain/entities/voter.dart';
import '../use_cases/get_voters_use_case.dart';
import '../use_cases/get_voters_by_grade_use_case.dart';
import '../use_cases/save_voter_use_case.dart';
import '../use_cases/delete_voter_use_case.dart';
import '../use_cases/save_voters_use_case.dart';
import '../use_cases/delete_all_voters_use_case.dart';
import '../use_cases/get_voter_by_document_id_use_case.dart';

class VotersProvider with ChangeNotifier {
  final GetVotersUseCase _getVotersUC;
  final GetVotersByGradeUseCase _getVotersByGradeUC;
  final SaveVoterUseCase _saveVoterUC;
  final DeleteVoterUseCase _deleteVoterUC;
  final SaveVotersUseCase _saveVotersUC;
  final DeleteAllVotersUseCase _deleteAllVotersUC;
  final GetVoterByDocumentIdUseCase _getVoterByDocumentIdUC;

  List<Voter> _voters = [];
  bool _isLoading = false;

  VotersProvider(
    this._getVotersUC,
    this._getVotersByGradeUC,
    this._saveVoterUC,
    this._deleteVoterUC,
    this._saveVotersUC,
    this._deleteAllVotersUC,
    this._getVoterByDocumentIdUC,
  );

  List<Voter> get voters => _voters;
  bool get isLoading => _isLoading;

  Future<void> loadVoters() async {
    _isLoading = true;
    notifyListeners();
    try {
      _voters = await _getVotersUC.execute();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Voter>> getVotersByGrade(int gradeId) async {
    return await _getVotersByGradeUC.execute(gradeId);
  }

  Future<void> saveVoter(Voter voter) async {
    await _saveVoterUC.execute(voter);
    await loadVoters();
  }

  Future<void> deleteVoter(int id) async {
    await _deleteVoterUC.execute(id);
    await loadVoters();
  }

  Future<void> importVoters(List<Voter> voters) async {
    await _saveVotersUC.execute(voters);
    await loadVoters();
  }

  Future<void> deleteAllVoters() async {
    await _deleteAllVotersUC.execute();
    await loadVoters();
  }

  Future<Voter?> getVoterByDocumentId(String documentId) async {
    return await _getVoterByDocumentIdUC.execute(documentId);
  }
}
