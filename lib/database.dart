import 'package:drift/drift.dart';
import 'database/connection/connection.dart' as impl;

part 'database.g.dart';

@DataClassName('Todo')
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  TextColumn get content => text().named('body')();
  IntColumn get category => integer().nullable()();
}

class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get slogan => text()();
  TextColumn get theme => text()();
  TextColumn get logo => text()();
  BoolColumn get passRequired => boolean()();
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text()();
  TextColumn get password => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
}

@DriftDatabase(tables: [Todos, Settings, Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // Add the id column to the settings table
          await m.addColumn(settings, settings.id);
        }
        if (from < 3) {
          await m.createTable(users);
        }
      },
      beforeOpen: (details) async {
        final allSettings = await select(settings).get();
        if (allSettings.isEmpty) {
          await into(settings).insert(
            SettingsCompanion.insert(
              name: 'Escuela prueba',
              slogan: 'Mi escuelita',
              theme: 'primary',
              logo: 'sin-logo.png',
              passRequired: true,
            ),
          );
        }
      },
    );
  }
}
