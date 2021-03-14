import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/features/sql/data/datasources/sql_local_data_source.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/src/exception.dart';

import '../../../../fixtures/sql_fixtures.dart';
import '../../../../fixtures/song_fixtures.dart';

class MockDatabase extends Mock implements Database {}

main() {
  SqlLocalDataSourceImpl sqlLocalDataSourceImpl;
  MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
    sqlLocalDataSourceImpl = SqlLocalDataSourceImpl(db: mockDatabase);
  });

  DatabaseException tDatabaseException =
      SqfliteDatabaseException('message', 'result');

  group('close()', () {
    test('should call close on the [Database]', () async {
      // act
      await sqlLocalDataSourceImpl.close();

      // assert
      verify(mockDatabase.close());
      verifyNoMoreInteractions(mockDatabase);
    });

    test(
        'should throw a [OhrwurmDatabaseException] if close call on db throws a [DatabaseException]',
        () {
      // arrange
      when(mockDatabase.close()).thenThrow(tDatabaseException);

      // act
      final call = () => sqlLocalDataSourceImpl.close();

      // assert
      expect(call(), throwsA(isA<OhrwurmDatabaseException>()));
    });
  });

  group('insert()', () {
    test('should call insert on the [Database]', () async {
      // act
      await sqlLocalDataSourceImpl.insert(tTable, tSongModelMap);

      // assert
      verify(mockDatabase.insert(tTable, tSongModelMap));
      verifyNoMoreInteractions(mockDatabase);
    });
    test(
        'should throw a [OhrwurmDatabaseException] if insert call on db throws a [DatabaseException]',
        () {
      // arrange
      when(mockDatabase.insert(any, any)).thenThrow(tDatabaseException);

      // act
      final call = () => sqlLocalDataSourceImpl.insert(tTable, tSongModelMap);

      // assert
      expect(call(), throwsA(isA<OhrwurmDatabaseException>()));
    });
  });

  group('delete()', () {
    test('should call delete on the [Database]', () async {
      // act
      await sqlLocalDataSourceImpl.delete(tTable,
          where: tWhere, whereArgs: tWhereArgs);

      // assert
      verify(mockDatabase.delete(tTable, where: tWhere, whereArgs: tWhereArgs));
      verifyNoMoreInteractions(mockDatabase);
    });
    test(
        'should throw a [OhrwurmDatabaseException] if delete call on db throws a [DatabaseException]',
        () {
      // arrange
      when(mockDatabase.delete(any)).thenThrow(tDatabaseException);

      // act
      final call = () => sqlLocalDataSourceImpl.delete(tTable);

      // assert
      expect(call(), throwsA(isA<OhrwurmDatabaseException>()));
    });
  });

  group('update()', () {
    test('should call update on the [Database]', () async {
      // act
      await sqlLocalDataSourceImpl.update(tTable, tSongModelMap,
          where: tWhere, whereArgs: tWhereArgs);

      // assert
      verify(mockDatabase.update(tTable, tSongModelMap,
          where: tWhere, whereArgs: tWhereArgs));
      verifyNoMoreInteractions(mockDatabase);
    });
    test(
        'should throw a [OhrwurmDatabaseException] if update call on db throws a [DatabaseException]',
        () {
      // arrange
      when(mockDatabase.update(any, any)).thenThrow(tDatabaseException);

      // act
      final call = () => sqlLocalDataSourceImpl.update(tTable, tSongModelMap);

      // assert
      expect(call(), throwsA(isA<OhrwurmDatabaseException>()));
    });
  });

  group('query()', () {
    test('should call query on the [Database] and return a value map',
        () async {
      // arrange
      when(mockDatabase.query(any,
              where: anyNamed('where'),
              whereArgs: anyNamed('whereArgs'),
              columns: anyNamed('columns'),
              orderBy: anyNamed('orderBy'),
              limit: anyNamed('limit'),
              offset: anyNamed('offset')))
          .thenAnswer((realInvocation) => Future.value([tSongModelMap]));

      // act
      final result = await sqlLocalDataSourceImpl.query(
        tTable,
        where: tWhere,
        whereArgs: tWhereArgs,
        columns: tColumns,
        orderBy: 'Title',
        limit: 1,
        offset: 0,
      );

      // assert
      expect(result, [tSongModelMap]);
      verify(mockDatabase.query(
        tTable,
        where: tWhere,
        whereArgs: tWhereArgs,
        columns: tColumns,
        orderBy: 'Title',
        limit: 1,
        offset: 0,
      ));
      verifyNoMoreInteractions(mockDatabase);
    });
    test(
        'should throw a [OhrwurmDatabaseException] if query call on db throws a [DatabaseException]',
        () {
      // arrange
      when(mockDatabase.query(any)).thenThrow(tDatabaseException);

      // act
      final call = () => sqlLocalDataSourceImpl.query(tTable);

      // assert
      expect(call(), throwsA(isA<OhrwurmDatabaseException>()));
    });
  });
}
