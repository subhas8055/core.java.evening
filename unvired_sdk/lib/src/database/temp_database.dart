import 'package:drift/drift.dart';

export 'shared.dart';

part 'temp_database.g.dart';

@DriftDatabase(tables: [])
class TempDatabase extends _$TempDatabase {
  TempDatabase(QueryExecutor e) : super(e);

  TempDatabase.connect(DatabaseConnection connection) : super.connect(connection);

  @override
  int get schemaVersion => 1;


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

}
