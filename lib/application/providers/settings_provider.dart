import 'package:flutter/material.dart';
import '../../domain/entities/settings.dart';
import '../use_cases/get_settings_use_case.dart';
import '../use_cases/update_settings_use_case.dart';

class SettingsProvider with ChangeNotifier {
  final GetSettingsUseCase getSettingsUseCase;
  final UpdateSettingsUseCase updateSettingsUseCase;
  Settings? _settings;

  SettingsProvider(this.getSettingsUseCase, this.updateSettingsUseCase);

  Settings? get settings => _settings;

  Future<void> loadSettings() async {
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
}
