import 'package:flutter/material.dart';
import '../../domain/entities/settings.dart';
import '../use_cases/get_settings_use_case.dart';

class SettingsProvider with ChangeNotifier {
  final GetSettingsUseCase getSettingsUseCase;
  Settings? _settings;

  SettingsProvider(this.getSettingsUseCase);

  Settings? get settings => _settings;

  Future<void> loadSettings() async {
    _settings = await getSettingsUseCase.execute();
    notifyListeners();
  }
}
