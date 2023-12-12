import 'package:drift/drift.dart';

export 'shared.dart';

part 'database.g.dart';

@DriftDatabase(tables: [])
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  Database.connect(DatabaseConnection connection) : super.connect(connection);

  @override
  int get schemaVersion => 1;

  // @override
  // MigrationStrategy get migration {
  //   return _migrationStrategy;
  // }

  Iterable<TableInfo<Table, dynamic>> getAllTables() {
    return allTables;
  }

  Future<void> insertRow(
    TableInfo table,
    Insertable insertable,
  ) async {
    await this.into(table).insert(insertable);
  }

  Stream<List<DataClass>> watchAll(
    Table table,
  ) {
    return this.select(table as TableInfo).watch() as Stream<List<DataClass>>;
  }

  /*Stream<List<CategoryWithCount>> categoriesWithCount() {
    // select all categories and load how many associated entries there are for
    // each category
    return customSelect(
      'SELECT c.id, c.desc, '
          '(SELECT COUNT(*) FROM todos WHERE category = c.id) AS amount '
          'FROM categories c '
          'UNION ALL SELECT null, null, '
          '(SELECT COUNT(*) FROM todos WHERE category IS NULL)',
      readsFrom: {todos, categories},
    ).map((row) {
      // when we have the result set, map each row to the data class
      final hasId = row.data['id'] != null;

      return CategoryWithCount(
        hasId ? Category.fromData(row.data, this) : null,
        row.readInt('amount'),
      );
    }).watch();
  }

  /// Watches all entries in the given [category]. If the category is null, all
  /// entries will be shown instead.
  Stream<List<EntryWithCategory>> watchEntriesInCategory(Category category) {
    final query = select(todos).join(
        [leftOuterJoin(categories, categories.id.equalsExp(todos.category))]);

    if (category != null) {
      query.where(categories.id.equals(category.id));
    } else {
      query.where(isNull(categories.id));
    }

    return query.watch().map((rows) {
      // read both the entry and the associated category for each row
      return rows.map((row) {
        return EntryWithCategory(
          row.readTable(todos),
          row.readTable(categories),
        );
      }).toList();
    });
  }

  Future createEntry(TodosCompanion entry) async {
    final _todos = await (select(todos)
      ..orderBy([
            (u) => OrderingTerm(expression: u.id, mode: OrderingMode.desc),
      ]))
        .get();
    entry = entry.copyWith(id: Value(_todos.first.id + 1));
    return insertRow(cs, todos, entry);
  }

  /// Updates the row in the database represents this entry by writing the
  /// updated data.
  Future updateEntry(TodoEntry entry) async {
    return updateRow(cs, todos, entry);
  }

  Future deleteEntry(TodoEntry entry) {
    return deleteRow(cs, todos, entry);
  }

  Future<int> createCategory(String description) {
    return insertRow(
      cs,
      categories,
      CategoriesCompanion(description: Value(description)),
    );
  }

  Future deleteCategory(Category category) {
    return transaction(() async {
      await _resetCategory(category.id);
      await deleteRow(cs, categories, category);
    });
  }*/
}
