import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/core/utils/id_generator.dart';
import 'package:ohrwurm/features/artist/data/datasources/artist_local_data_source.dart';
import 'package:ohrwurm/features/sql/data/datasources/sql_local_data_source.dart';
import 'package:uuid/uuid.dart';

import '../../../../fixtures/artist_fixtures.dart';

class MockSqlLocalDataSource extends Mock implements SqlLocalDataSource {}

class MockIdGenerator extends Mock implements IdGenerator {}

main() {
  ArtistLocalDataSourceImpl artistLocalDataSourceImpl;
  MockSqlLocalDataSource mockSqlLocalDataSource;
  MockIdGenerator mockIdGenerator;

  setUp(() {
    mockSqlLocalDataSource = MockSqlLocalDataSource();
    mockIdGenerator = MockIdGenerator();
    artistLocalDataSourceImpl = ArtistLocalDataSourceImpl(
        sqlLocalDataSource: mockSqlLocalDataSource,
        idGenerator: mockIdGenerator);
  });

  group('getArtist()', () {
    void getArtistSuccessfulSqlQuery() {
      when(mockSqlLocalDataSource.query(any,
              where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
          .thenAnswer((realInvocation) => Future.value([tArtistModelMap]));
    }

    test('should get an artist map from [SqlLocalDataSource]', () async {
      // arrange
      getArtistSuccessfulSqlQuery();

      // act
      await artistLocalDataSourceImpl.getArtist(tArtistId);

      // assert
      verify(mockSqlLocalDataSource.query(ARTISTS_TABLE,
          where: '$ARTISTS_TABLE=?', whereArgs: [tArtistId]));
      verifyNoMoreInteractions(mockSqlLocalDataSource);
    });

    test('should return an [ArtistModel]', () async {
      // arrange
      getArtistSuccessfulSqlQuery();

      // act
      final result = await artistLocalDataSourceImpl.getArtist(tArtistId);

      // assert
      expect(result, tArtistModel);
    });

    test(
        'should throw a [NotInDatabaseException] if call to [SqlLocalDatasource] returns an empty list',
        () {
      // arrange
      when(mockSqlLocalDataSource.query(any,
              where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
          .thenAnswer((realInvocation) => Future.value([]));

      // act
      final call = () => artistLocalDataSourceImpl.getArtist(tArtistId);

      // assert
      expect(call(), throwsA(isA<NotInDatabaseException>()));
    });
  });
  group('addArtist()', () {
    setUp(() {
      when(mockSqlLocalDataSource.query(any,
              where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
          .thenAnswer((realInvocation) => Future.value([]));
    });
    test('should check if artist name already exists', () async {
      // act
      await artistLocalDataSourceImpl.addArtist(tArtistModel);

      // assert
      verify(mockSqlLocalDataSource.query(ARTISTS_TABLE,
          where: '$ID_COLUMN=?', whereArgs: [tArtistName]));
    });

    group('if artist doesn\'t exist', () {
      setUp(() {
        when(mockIdGenerator()).thenReturn(tArtistId);
      });
      test('should generate an id for the artist', () async {
        // act
        await artistLocalDataSourceImpl.addArtist(tArtistModel);

        // assert
        verify(mockIdGenerator());
      });
      test(
          'should insert an artist map into the Artists table in the db if id doesn\'nt exist yet',
          () async {
        // act
        await artistLocalDataSourceImpl.addArtist(tArtistModel);

        // assert
        verify(mockSqlLocalDataSource.insert(ARTISTS_TABLE, tArtistModelMap));
      });
    });

    group('if artist already exists', () {
      test('return the artists id', () async {
        // arrange
        when(mockSqlLocalDataSource.query(ARTISTS_TABLE,
                where: '$ID_COLUMN=?', whereArgs: [tArtistName]))
            .thenAnswer((realInvocation) => Future.value([tArtistModelMap]));

        // act
        final result = await artistLocalDataSourceImpl.addArtist(tArtistModel);

        // assert
        expect(result, tArtistId);
        verify(mockSqlLocalDataSource.query(ARTISTS_TABLE,
            where: '$ID_COLUMN=?', whereArgs: [tArtistName]));
      });
    });
  });
}
