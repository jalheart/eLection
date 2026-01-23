import 'package:drift/drift.dart';
import 'package:bcrypt/bcrypt.dart';
import 'connection/connection.dart' as impl;

part 'database.g.dart';

// Removed Todos table
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

@DriftDatabase(tables: [Settings, Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 4;

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
        if (from < 4) {
          await m.issueCustomQuery('DROP TABLE IF EXISTS todos;');
        }
      },
      beforeOpen: (details) async {
        // Populate settings if empty
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

        // Populate users if empty
        final allUsers = await select(users).get();
        if (allUsers.isEmpty) {
          final hashedPassword = BCrypt.hashpw('admin', BCrypt.gensalt());
          await into(users).insert(
            UsersCompanion.insert(
              username: 'admin',
              password: hashedPassword,
              name: 'Administrador',
              email: 'admin@mail.com',
            ),
          );
        }
      },
    );
  }
}
