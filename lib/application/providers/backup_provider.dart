import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../infrastructure/services/backup_service.dart';
import '../use_cases/export_data_use_case.dart';
import '../use_cases/import_data_use_case.dart';
import '../../infrastructure/database/database.dart';

class BackupProvider with ChangeNotifier {
  final ExportDataUseCase exportUC;
  final ImportDataUseCase importUC;
  final AppDatabase db;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  BackupProvider({
    required this.exportUC,
    required this.importUC,
    required this.db,
  });

  Future<void> exportData() async {
    _isLoading = true;
    notifyListeners();
    try {
      final zipPath = await exportUC.execute();
      
      String? outputPath = await FilePicker.saveFile(
        dialogTitle: 'Exportar Datos',
        fileName: 'backup_election.zip',
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (outputPath != null) {
        // file_picker on desktop might not add extension automatically in some cases
        if (!outputPath.endsWith('.zip')) {
          outputPath += '.zip';
        }
        await File(zipPath).copy(outputPath);
      }
    } catch (e) {
      debugPrint('Error exportando datos: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> importData() async {
    _isLoading = true;
    notifyListeners();
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result != null && result.files.single.path != null) {
        // 1. Close the database
        await db.close();
        
        // 2. Restore the files
        await importUC.execute(result.files.single.path!);
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error importando datos: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
