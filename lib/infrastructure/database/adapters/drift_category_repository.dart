import 'package:drift/drift.dart';
import '../../../domain/entities/category.dart' as domain;
import '../../../domain/repositories/category_repository.dart';
import '../database.dart';

class DriftCategoryRepository implements CategoryRepository {
  final AppDatabase db;

  DriftCategoryRepository(this.db);

  @override
  Future<List<domain.Category>> getCategories() async {
    final query = db.select(db.categories)
      ..orderBy([(t) => OrderingTerm(expression: t.order)]);
    final results = await query.get();
    return results.map(_mapToDomain).toList();
  }

  @override
  Future<void> saveCategory(domain.Category category) async {
    if (category.id == null) {
      await db
          .into(db.categories)
          .insert(
            CategoriesCompanion.insert(
              name: category.name,
              shortName: category.shortName,
              order: Value(category.order),
            ),
          );
    } else {
      await (db.update(
        db.categories,
      )..where((t) => t.id.equals(category.id!))).write(
        CategoriesCompanion(
          name: Value(category.name),
          shortName: Value(category.shortName),
          order: Value(category.order),
        ),
      );
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    await (db.delete(db.categories)..where((t) => t.id.equals(id))).go();
  }

  domain.Category _mapToDomain(Category category) {
    return domain.Category(
      id: category.id,
      name: category.name,
      shortName: category.shortName,
      order: category.order,
    );
  }
}
