import '../../domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository settingsRepository;

  GetSettingsUseCase(this.settingsRepository);

  Future<Settings> execute() async {
    return await settingsRepository.getSettings();
  }
}
