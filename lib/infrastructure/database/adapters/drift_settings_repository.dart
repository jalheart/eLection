import 'package:drift/drift.dart';
import '../../../domain/entities/settings.dart' as domain;
import '../../../domain/repositories/settings_repository.dart';
import '../database.dart';

class DriftSettingsRepository implements SettingsRepository {
  final AppDatabase db;

  DriftSettingsRepository(this.db);

  @override
  Future<domain.Settings> getSettings() async {
    final setting = await db.select(db.settings).getSingle();
    return _mapToDomain(setting);
  }

  @override
  Future<void> updateSettings(domain.Settings settings) async {
    await db.update(db.settings).replace(
          SettingsCompanion(
            id: Value(settings.id),
            name: Value(settings.name),
            slogan: Value(settings.slogan),
            theme: Value(settings.theme),
            logo: Value(settings.logo),
            passRequired: Value(settings.passRequired),
          ),
        );
  }

  domain.Settings _mapToDomain(Setting setting) {
    return domain.Settings(
      id: setting.id,
      name: setting.name,
      slogan: setting.slogan,
      theme: setting.theme,
      logo: setting.logo,
      passRequired: setting.passRequired,
    );
  }
}
