import 'package:drift/drift.dart';
import '../../../domain/entities/grado.dart' as domain;
import '../../../domain/repositories/grado_repository.dart';
import '../database.dart';

class DriftGradoRepository implements GradoRepository {
  final AppDatabase db;

  DriftGradoRepository(this.db);

  @override
  Future<List<domain.Grado>> getAllGrados() async {
    final query = db.select(db.grados)
      ..orderBy([(t) => OrderingTerm(expression: t.order)]);
    final results = await query.get();
    return results.map(_mapToDomain).toList();
  }

  @override
  Future<domain.Grado?> getGradoById(int id) async {
    final query = db.select(db.grados)..where((t) => t.id.equals(id));
    final result = await query.getSingleOrNull();
    return result != null ? _mapToDomain(result) : null;
  }

  @override
  Future<void> saveGrado(domain.Grado grado) async {
    if (grado.id == null) {
      await db
          .into(db.grados)
          .insert(
            GradosCompanion.insert(
              name: grado.name,
              shortName: grado.shortName,
              order: Value(grado.order),
            ),
          );
    } else {
      await (db.update(db.grados)..where((t) => t.id.equals(grado.id!))).write(
        GradosCompanion(
          name: Value(grado.name),
          shortName: Value(grado.shortName),
          order: Value(grado.order),
        ),
      );
    }
  }

  @override
  Future<void> deleteGrado(int id) async {
    await (db.delete(db.grados)..where((t) => t.id.equals(id))).go();
  }

  domain.Grado _mapToDomain(Grado grado) {
    return domain.Grado(
      id: grado.id,
      name: grado.name,
      shortName: grado.shortName,
      order: grado.order,
    );
  }
}
