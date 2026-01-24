import 'package:flutter/material.dart';
import '../../domain/entities/grado.dart';
import '../use_cases/get_grados_use_case.dart';
import '../use_cases/save_grado_use_case.dart';
import '../use_cases/delete_grado_use_case.dart';

class GradosProvider with ChangeNotifier {
  final GetGradosUseCase _getGradosUC;
  final SaveGradoUseCase _saveGradoUC;
  final DeleteGradoUseCase _deleteGradoUC;

  List<Grado> _grados = [];
  bool _isLoading = false;

  GradosProvider(this._getGradosUC, this._saveGradoUC, this._deleteGradoUC);

  List<Grado> get grados => _grados;
  bool get isLoading => _isLoading;

  Future<void> loadGrados() async {
    _isLoading = true;
    notifyListeners();
    try {
      _grados = await _getGradosUC.execute();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveGrado(Grado grado) async {
    await _saveGradoUC.execute(grado);
    await loadGrados();
  }

  Future<void> deleteGrado(int id) async {
    await _deleteGradoUC.execute(id);
    await loadGrados();
  }
}
