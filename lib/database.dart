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
  TextColumn get name => text()();
  TextColumn get slogan => text()();
  TextColumn get theme => text()();
  TextColumn get logo => text()();
  BoolColumn get passRequired => boolean()();
}

@DriftDatabase(tables: [Todos, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 1;
}
