import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/candidate.dart';
import '../use_cases/get_categories_use_case.dart';
import '../use_cases/get_candidates_by_category_use_case.dart';
import '../use_cases/get_results_use_case.dart';

class ResultData {
  final Category category;
  final List<CandidateResult> candidates;

  ResultData({required this.category, required this.candidates});
}

class CandidateResult {
  final Candidate candidate;
  final int votes;

  CandidateResult({required this.candidate, required this.votes});
}

class ResultsProvider with ChangeNotifier {
  final GetCategoriesUseCase _getCategoriesUC;
  final GetCandidatesByCategoryUseCase _getCandidatesUC;
  final GetResultsUseCase _getResultsUC;

  List<ResultData> _results = [];
  bool _isLoading = false;

  ResultsProvider(
    this._getCategoriesUC,
    this._getCandidatesUC,
    this._getResultsUC,
  );

  List<ResultData> get results => _results;
  bool get isLoading => _isLoading;

  Future<void> loadResults() async {
    _isLoading = true;
    notifyListeners();

    try {
      final categories = await _getCategoriesUC.execute();
      List<ResultData> loadedResults = [];

      for (var category in categories) {
        if (category.id != null) {
          final candidates = await _getCandidatesUC.execute(category.id!);
          final voteCounts = await _getResultsUC.execute(category.id!);

          List<CandidateResult> candidateResults = candidates.map((c) {
            return CandidateResult(
              candidate: c,
              votes: voteCounts[c.id] ?? 0,
            );
          }).toList();

          // Sort by votes descending
          candidateResults.sort((a, b) => b.votes.compareTo(a.votes));

          loadedResults.add(ResultData(
            category: category,
            candidates: candidateResults,
          ));
        }
      }
      _results = loadedResults;
    } catch (e) {
      debugPrint('Error loading results: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
