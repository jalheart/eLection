import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/candidate.dart';
import '../../domain/entities/voter.dart';
import '../use_cases/cast_votes_use_case.dart';
import '../use_cases/get_categories_by_grade_use_case.dart';
import '../use_cases/get_candidates_by_category_use_case.dart';

class VotingProvider with ChangeNotifier {
  final GetCategoriesByGradeUseCase _getCategoriesUC;
  final GetCandidatesByCategoryUseCase _getCandidatesUC;
  final CastVotesUseCase _castVotesUC;

  List<Category> _categories = [];
  final Map<int, List<Candidate>> _candidatesByCategory = {};
  final Map<int, int?> _selectedCandidates = {}; // categoryId -> candidateId
  bool _isLoading = false;
  bool _isSaving = false;

  VotingProvider(
    this._getCategoriesUC,
    this._getCandidatesUC,
    this._castVotesUC,
  );

  List<Category> get categories => _categories;
  Map<int, List<Candidate>> get candidatesByCategory => _candidatesByCategory;
  Map<int, int?> get selectedCandidates => _selectedCandidates;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  Future<void> initVoting(Voter voter) async {
    _isLoading = true;
    notifyListeners();
    try {
      final allCategories = await _getCategoriesUC.execute(voter.gradeId);
      _categories = [];
      _candidatesByCategory.clear();
      _selectedCandidates.clear();

      for (var category in allCategories) {
        if (category.id != null) {
          final candidates = await _getCandidatesUC.execute(category.id!);
          if (candidates.isNotEmpty) {
            _categories.add(category);
            _candidatesByCategory[category.id!] = candidates;
            _selectedCandidates[category.id!] = null;
          }
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCandidate(int categoryId, int candidateId) {
    _selectedCandidates[categoryId] = candidateId;
    notifyListeners();
  }

  bool isAllSelected() {
    for (var category in _categories) {
      if (_selectedCandidates[category.id!] == null) return false;
    }
    return true;
  }

  Future<bool> submitVotes(int voterId) async {
    if (!isAllSelected()) return false;
    
    _isSaving = true;
    notifyListeners();
    try {
      final List<int> candidateIds = _selectedCandidates.values.whereType<int>().toList();
      await _castVotesUC.execute(voterId, candidateIds);
      return true;
    } catch (e) {
      debugPrint('Error casting votes: $e');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
