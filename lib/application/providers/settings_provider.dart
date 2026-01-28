import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/settings.dart';
import '../use_cases/get_settings_use_case.dart';
import '../use_cases/update_settings_use_case.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class SettingsProvider with ChangeNotifier {
  final GetSettingsUseCase getSettingsUseCase;
  final UpdateSettingsUseCase updateSettingsUseCase;
  Settings? _settings;

  SettingsProvider(this.getSettingsUseCase, this.updateSettingsUseCase);

  Settings? get settings => _settings;

  String? _appDocDir;

  Future<void> _initAppDocDir() async {
    if (_appDocDir != null) return;
    final directory = await getApplicationDocumentsDirectory();
    _appDocDir = directory.path;
  }

  String? resolvePath(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) return null;
    if (relativePath.startsWith('http') || relativePath.startsWith('assets')) {
      return relativePath;
    }
    if (_appDocDir == null) return null; // Should be loaded
    return p.join(_appDocDir!, relativePath);
  }

  Future<void> loadSettings() async {
    await _initAppDocDir();
    _settings = await getSettingsUseCase.execute();
    notifyListeners();
  }

  Locale get locale => Locale(_settings?.language ?? 'es');

  Future<void> updateLanguage(String langCode) async {
    if (_settings == null) return;
    final newSettings = Settings(
      id: _settings!.id,
      name: _settings!.name,
      slogan: _settings!.slogan,
      theme: _settings!.theme,
      logo: _settings!.logo,
      passRequired: _settings!.passRequired,
      language: langCode,
    );
    await updateSettingsUseCase.execute(newSettings);
    _settings = newSettings;
    notifyListeners();
  }

  Future<void> updateSettings({
    required String name,
    required String slogan,
    required String theme,
    required String logo,
    required bool passRequired,
  }) async {
    if (_settings == null) return;
    await _initAppDocDir();

    String finalLogoPath = logo;

    // Handle Logo File if it's a new absolute path
    if (logo.isNotEmpty && !logo.startsWith('assets/') && p.isAbsolute(logo)) {
       final appDir = Directory(_appDocDir!);
       final electionDir = Directory(p.join(appDir.path, 'election'));
       if (!await electionDir.exists()) {
         await electionDir.create(recursive: true);
       }

       // Delete old logo if it exists and is different (though here we are overwriting 'logo.*')
       // We need to cleanup any previous logo files in the destination to avoid ambiguity
       final possibleExtensions = ['.png', '.jpg', '.jpeg', '.webp'];
       for (final ext in possibleExtensions) {
         final oldFile = File(p.join(electionDir.path, 'logo$ext'));
         if (await oldFile.exists()) {
           await oldFile.delete();
         }
       }

       final sourceFile = File(logo);
       final extension = p.extension(logo);
       final newFileName = 'logo$extension';
       final newPath = p.join(electionDir.path, newFileName);
       
       await sourceFile.copy(newPath);
       
       // Store relative path: 'election/logo.ext'
       // Note: candidates_images was in root app doc dir. 
       // DB is in 'election/election.db'. 
       // User asked for "same level as bd", so 'election/logo.ext'.
       // Relative to AppDocDir, this is 'election/logo.ext'.
       finalLogoPath = p.join('election', newFileName);
    }

    final newSettings = Settings(
      id: _settings!.id,
      name: name,
      slogan: slogan,
      theme: theme,
      logo: finalLogoPath,
      passRequired: passRequired,
      language: _settings!.language,
    );
    await updateSettingsUseCase.execute(newSettings);
    _settings = newSettings;
    notifyListeners();
  }
}
