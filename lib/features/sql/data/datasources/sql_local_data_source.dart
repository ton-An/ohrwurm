import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/src/exception.dart';

abstract class SqlLocalDataSource {
  /// Closes the database. After calling this method the db cannot be accessed anymore
  Future<void> close();

  /// Inserts a map of [values] into the specified [table]
  Future<void> insert(String table, Map<String, Object> values);

  /// Deletes rows from a [table] in the database
  ///
  /// [where] is the optional WHERE clause to apply when updating. Passing null will delete all rows.
  ///
  /// You may include ?s in the where clause, which will be replaced by the values from [whereArgs]
  Future<void> delete(String table, {String where, List<Object> whereArgs});

  /// Updates rows in the database
  ///
  /// Update [table] with [values], a map from column names to new column values. null is a valid value that will be translated to NULL.
  ///
  /// [where] is the optional WHERE clause to apply when updating. Passing null will update all rows.
  ///
  /// You may include ?s in the where clause, which will be replaced by the values from [whereArgs]
  Future<void> update(
    String table,
    Map<String, Object> values, {
    String where,
    List<Object> whereArgs,
  });

  /// Queries a table and returns the items found. All optional clauses and filters are formatted as SQL queries excluding the clauses' names.
  ///
  /// [table] contains the table names to compile the query against.
  ///
  /// [where] filters which rows to return. Passing null will return all rows for the given URL.
  ///
  /// You may include ?s in the where clause, which will be replaced by the values from [whereArgs]
  ///
  /// The [columns] list specify which columns to return. Passing null will return all columns, which is discouraged.
  ///
  /// [orderBy] declares how to order the rows, Passing null will use the default sort order, which may be unordered.
  ///
  /// [limit] limits the number of rows returned by the query.
  ///
  /// [offset] specifies the starting index.
  Future<List<Map<String, Object>>> query(
    String table, {
    String where,
    List<Object> whereArgs,
    List<String> columns,
    String orderBy,
    int limit,
    int offset,
  });
}

class SqlLocalDataSourceImpl extends SqlLocalDataSource {
  final Database db;

  SqlLocalDataSourceImpl({@required this.db}) : assert(db != null);

  @override
  Future<void> close() async {
    try {
      await db.close();
    } on SqfliteDatabaseException catch (e) {
      throw OhrwurmDatabaseException(e.message);
    }
  }

  @override
  Future<void> insert(String table, Map<String, Object> values) async {
    try {
      await db.insert(table, values);
    } on SqfliteDatabaseException catch (e) {
      throw OhrwurmDatabaseException(e.message);
    }
  }

  @override
  Future<void> delete(String table,
      {String where, List<Object> whereArgs}) async {
    try {
      await db.delete(table, where: where, whereArgs: whereArgs);
    } on SqfliteDatabaseException catch (e) {
      throw OhrwurmDatabaseException(e.message);
    }
  }

  @override
  Future<void> update(String table, Map<String, Object> values,
      {String where, List<Object> whereArgs}) async {
    try {
      await db.update(table, values, where: where, whereArgs: whereArgs);
    } on SqfliteDatabaseException catch (e) {
      throw OhrwurmDatabaseException(e.message);
    }
  }

  @override
  Future<List<Map<String, Object>>> query(
    String table, {
    String where,
    List<Object> whereArgs,
    List<String> columns,
    String orderBy,
    int limit,
    int offset,
  }) async {
    try {
      return await db.query(
        table,
        where: where,
        whereArgs: whereArgs,
        columns: columns,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
    } on SqfliteDatabaseException catch (e) {
      throw OhrwurmDatabaseException(e.message);
    }
  }
}
