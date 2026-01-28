import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../domain/entities/candidate.dart';
import '../use_cases/get_candidates_use_case.dart';
import '../use_cases/get_candidates_by_category_use_case.dart';
import '../use_cases/save_candidate_use_case.dart';
import '../use_cases/delete_candidate_use_case.dart';

class CandidatesProvider with ChangeNotifier {
  final GetCandidatesUseCase _getCandidatesUC;
  final GetCandidatesByCategoryUseCase _getCandidatesByCategoryUC;
  final SaveCandidateUseCase _saveCandidateUC;
  final DeleteCandidateUseCase _deleteCandidateUC;

  List<Candidate> _candidates = [];
  bool _isLoading = false;
  String? _appDocDir;

  CandidatesProvider(
    this._getCandidatesUC,
    this._getCandidatesByCategoryUC,
    this._saveCandidateUC,
    this._deleteCandidateUC,
  );

  List<Candidate> get candidates => _candidates;
  bool get isLoading => _isLoading;

  Future<String> getAppDocDir() async {
    if (_appDocDir != null) return _appDocDir!;
    final directory = await getApplicationDocumentsDirectory();
    _appDocDir = p.join(directory.path, 'election');
    return _appDocDir!;
  }

  Future<void> loadCandidates() async {
    _isLoading = true;
    notifyListeners();
    try {
      await getAppDocDir(); // Ensure app dir is loaded
      _candidates = await _getCandidatesUC.execute();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Candidate>> getCandidatesByCategory(int categoryId) async {
    return await _getCandidatesByCategoryUC.execute(categoryId);
  }

  String? resolvePath(String? relativePath) {
    if (relativePath == null) return null;
    if (relativePath.startsWith('http') || relativePath.startsWith('assets')) {
      return relativePath;
    }
    
    // If _appDocDir is null, we can't resolve the path yet.
    // However, since resolvePath is synchronous, we can't await getAppDocDir here.
    // We should ensure it's loaded during Provider initialization or in the view.
    if (_appDocDir == null) return null; 
    
    return p.join(_appDocDir!, relativePath);
  }

  Future<void> saveCandidate(Candidate candidate) async {
    // If updating, check if we need to delete old image
    String? oldPicturePath;
    if (candidate.id != null) {
      try {
        final oldCandidate = _candidates.firstWhere(
          (c) => c.id == candidate.id,
        );
        oldPicturePath = oldCandidate.picture;
      } catch (_) {}
    }

    // 1. Save candidate first to get/confirm the ID
    final id = await _saveCandidateUC.execute(candidate);

    String? picturePath = candidate.picture;

    if (picturePath != null &&
        !picturePath.startsWith('http') &&
        !picturePath.startsWith('assets')) {
      // If the path is absolute (from picker), copy it with the new name
      if (p.isAbsolute(picturePath)) {
        final appDir = await getAppDocDir();
        final candidatesImagesDir = Directory(
          p.join(appDir, 'candidates_images'),
        );
        if (!await candidatesImagesDir.exists()) {
          await candidatesImagesDir.create(recursive: true);
        }

        final extension = p.extension(picturePath);
        final newFileName =
            'candidate_${id}_${DateTime.now().millisecondsSinceEpoch}$extension';
        final newPath = p.join(candidatesImagesDir.path, newFileName);

        // Delete old image if it exists
        if (oldPicturePath != null) {
          final oldFullPath = resolvePath(oldPicturePath);
          if (oldFullPath != null) {
            final oldFile = File(oldFullPath);
            if (await oldFile.exists()) {
              await oldFile.delete();
            }
          }
        }

        final file = File(picturePath);
        await file.copy(newPath);

        picturePath = p.join('candidates_images', newFileName);

        // 2. Update candidate with the new picture path
        final updatedCandidate = Candidate(
          id: id,
          name: candidate.name,
          picture: picturePath,
          categoryId: candidate.categoryId,
        );
        await _saveCandidateUC.execute(updatedCandidate);
      }
    }

    await loadCandidates();
  }

  Future<void> deleteCandidate(int id) async {
    try {
      final candidate = _candidates.firstWhere((c) => c.id == id);
      if (candidate.picture != null &&
          !candidate.picture!.startsWith('http') &&
          !candidate.picture!.startsWith('assets')) {
        final fullPath = resolvePath(candidate.picture);
        if (fullPath != null) {
          final file = File(fullPath);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }
    } catch (_) {}

    await _deleteCandidateUC.execute(id);
    await loadCandidates();
  }
}
