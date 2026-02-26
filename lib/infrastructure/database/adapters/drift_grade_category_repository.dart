import 'package:drift/drift.dart';
import '../../../domain/entities/category.dart' as domain_cat;
import '../../../domain/entities/grado.dart' as domain_grado;
import '../../../domain/repositories/grade_category_repository.dart';
import '../database.dart';

class DriftGradeCategoryRepository implements GradeCategoryRepository {
  final AppDatabase db;

  DriftGradeCategoryRepository(this.db);

  @override
  Future<List<domain_cat.Category>> getCategoriesByGrade(int gradeId) async {
    final query = db.select(db.categories).join([
      innerJoin(
        db.gradeCategories,
        db.gradeCategories.categoryId.equalsExp(db.categories.id),
      ),
    ])..where(db.gradeCategories.gradeId.equals(gradeId));

    final results = await query.get();
    return results.map((row) {
      final category = row.readTable(db.categories);
      return domain_cat.Category(
        id: category.id,
        name: category.name,
        shortName: category.shortName,
        order: category.order,
      );
    }).toList();
  }

  @override
  Future<List<domain_grado.Grado>> getGradesByCategory(int categoryId) async {
    final query = db.select(db.grades).join([
      innerJoin(
        db.gradeCategories,
        db.gradeCategories.gradeId.equalsExp(db.grades.id),
      ),
    ])..where(db.gradeCategories.categoryId.equals(categoryId));

    final results = await query.get();
    return results.map((row) {
      final grade = row.readTable(db.grades);
      return domain_grado.Grado(
        id: grade.id,
        name: grade.name,
        shortName: grade.shortName,
        order: grade.order,
      );
    }).toList();
  }

  @override
  Future<void> assignCategoryToGrade(int gradeId, int categoryId) async {
    await db
        .into(db.gradeCategories)
        .insert(
          GradeCategoriesCompanion.insert(
            gradeId: gradeId,
            categoryId: categoryId,
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  @override
  Future<void> removeCategoryFromGrade(int gradeId, int categoryId) async {
    await (db.delete(db.gradeCategories)
          ..where((t) => t.gradeId.equals(gradeId))
          ..where((t) => t.categoryId.equals(categoryId)))
        .go();
  }

  @override
  Future<List<Map<String, dynamic>>> getAllAssignments() async {
    final query = db.select(db.gradeCategories).join([
      innerJoin(db.grades, db.grades.id.equalsExp(db.gradeCategories.gradeId)),
      innerJoin(
        db.categories,
        db.categories.id.equalsExp(db.gradeCategories.categoryId),
      ),
    ]);

    final results = await query.get();
    return results.map((row) {
      final grade = row.readTable(db.grades);
      final category = row.readTable(db.categories);
      return {
        'grade': domain_grado.Grado(
          id: grade.id,
          name: grade.name,
          shortName: grade.shortName,
          order: grade.order,
        ),
        'category': domain_cat.Category(
          id: category.id,
          name: category.name,
          shortName: category.shortName,
          order: category.order,
        ),
      };
    }).toList();
  }
}
