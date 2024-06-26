import 'package:drift/drift.dart';
import 'package:flutter_course/src/common/database/database.dart' as db;
import 'package:flutter_course/src/features/menu/data/data_sources/category_data_source.dart';
import 'package:flutter_course/src/features/menu/model/category.dart';

abstract interface class ISavableCategoriesDataSource
    implements ICategoriesDataSource {
  Future<void> saveCategories({required List<Category> categories});
}

final class DbCategoriesDataSource implements ISavableCategoriesDataSource {
  final db.AppDatabase _db;

  const DbCategoriesDataSource({required db.AppDatabase db}) : _db = db;

  @override
  Future<List<Category>> fetchCategories({int page = 0, int limit = 25}) async {
    final result = await (_db.select(_db.category)
          ..where((u) => u.id.isBiggerThanValue(limit * page))
          ..limit(limit))
        .get();
    return List<Category>.of(
        result.map((e) => Category(id: e.id, slug: e.slug)));
  }

  @override
  Future<void> saveCategories({required List<Category> categories}) async {
    for (var category in categories) {
      _db.into(_db.category).insertOnConflictUpdate(db.CategoryCompanion.insert(
          id: Value(category.id), slug: category.slug));
    }
  }
}
