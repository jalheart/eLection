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

class Grades extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get shortName => text()();
  IntColumn get order => integer().withDefault(const Constant(0))();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get shortName => text()();
  IntColumn get order => integer().withDefault(const Constant(0))();
}

@DriftDatabase(tables: [Settings, Users, Grades, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 7;

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
        if (from < 5) {
          await m.createTable(grades);
        }
        if (from < 6) {
          // Rename table grados to grades
          await m.issueCustomQuery('ALTER TABLE grados RENAME TO grades');
        }
        if (from < 7) {
          await m.createTable(categories);
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
              theme: '0xFF2196F3',
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

        // Populate grades if empty
        final allGrades = await select(grades).get();
        if (allGrades.isEmpty) {
          final defaultGrades = [
            {'name': 'Tercero', 'shortName': '3', 'order': 3},
            {'name': 'Cuarto', 'shortName': '4', 'order': 4},
            {'name': 'Quinto', 'shortName': '5', 'order': 5},
            {'name': 'Sexto', 'shortName': '6', 'order': 6},
            {'name': 'Séptimo', 'shortName': '7', 'order': 7},
            {'name': 'Octavo', 'shortName': '8', 'order': 8},
            {'name': 'Noveno', 'shortName': '9', 'order': 9},
            {'name': 'Décimo', 'shortName': '10', 'order': 10},
            {'name': 'Undécimo', 'shortName': '11', 'order': 11},
          ];

          for (final grado in defaultGrades) {
            await into(grades).insert(
              GradesCompanion.insert(
                name: grado['name'] as String,
                shortName: grado['shortName'] as String,
                order: Value(grado['order'] as int),
              ),
            );
          }
        }

        // Populate categories if empty
        final allCategories = await select(categories).get();
        if (allCategories.isEmpty) {
          final defaultCategories = [
            {'name': 'Personero', 'shortName': 'Per', 'order': 0},
            {'name': 'Contralor', 'shortName': 'Con', 'order': 1},
            {'name': 'Representante tercero', 'shortName': 'Rep 3', 'order': 3},
            {'name': 'Representante cuarto', 'shortName': 'Rep 4', 'order': 4},
            {'name': 'Representante quinto', 'shortName': 'Rep 5', 'order': 5},
            {'name': 'Representante sexto', 'shortName': 'Rep 6', 'order': 6},
            {'name': 'Representante séptimo', 'shortName': 'Rep 7', 'order': 7},
            {'name': 'Representante octavo', 'shortName': 'Rep 8', 'order': 8},
            {'name': 'Representante noveno', 'shortName': 'Rep 9', 'order': 9},
            {
              'name': 'Representante décimo',
              'shortName': 'Rep 10',
              'order': 10,
            },
            {
              'name': 'Representante undécimo',
              'shortName': 'Rep 11',
              'order': 11,
            },
          ];

          for (final category in defaultCategories) {
            await into(categories).insert(
              CategoriesCompanion.insert(
                name: category['name'] as String,
                shortName: category['shortName'] as String,
                order: Value(category['order'] as int),
              ),
            );
          }
        }
      },
    );
  }
}
