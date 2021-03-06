import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/core/utils/id_generator.dart';
import 'package:ohrwurm/features/artist/data/datasources/artist_local_data_source.dart';
import 'package:ohrwurm/features/sql/data/datasources/sql_local_data_source.dart';
import 'package:uuid/uuid.dart';

import '../../../../fixtures/artist_fixtures.dart';
import '../../../../fixtures/song_fixtures.dart';

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
      await artistLocalDataSourceImpl.getArtistFromId(tArtistId);

      // assert
      verify(mockSqlLocalDataSource
          .query(ARTISTS_TABLE, where: '$ID_COLUMN=?', whereArgs: [tArtistId]));
      verifyNoMoreInteractions(mockSqlLocalDataSource);
    });

    test('should return an [ArtistModel]', () async {
      // arrange
      getArtistSuccessfulSqlQuery();

      // act
      final result = await artistLocalDataSourceImpl.getArtistFromId(tArtistId);

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
      final call = () => artistLocalDataSourceImpl.getArtistFromId(tArtistId);

      // assert
      expect(call(), throwsA(isA<NotInDatabaseException>()));
    });
  });
  group('addArtist()', () {
    test('should insert an artist map into the Artists table', () async {
      // act
      await artistLocalDataSourceImpl.addArtist(tArtistModel);

      // assert
      verify(mockSqlLocalDataSource.insert(ARTISTS_TABLE, tArtistModelMap));
    });
  });
}
