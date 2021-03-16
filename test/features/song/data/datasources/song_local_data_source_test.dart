import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/core/utils/id_generator.dart';
import 'package:ohrwurm/features/artist/data/datasources/artist_local_data_source.dart';
import 'package:ohrwurm/features/song/data/datasources/song_local_data_source.dart';
import 'package:ohrwurm/features/sql/data/datasources/sql_local_data_source.dart';
import 'package:sqflite/src/exception.dart';
import '../../../../fixtures/artist_fixtures.dart';
import '../../../../fixtures/song_fixtures.dart';

class MockSqlLocalDataSource extends Mock implements SqlLocalDataSource {}

class MockArtistLocalDataSource extends Mock implements ArtistLocalDataSource {}

class MockIdGenerator extends Mock implements IdGenerator {}

class MockMetadataRetriever extends Mock implements MetadataRetriever {}

main() {
  SongLocalDataSourceImpl songLocalDataSourceImpl;
  MockSqlLocalDataSource mockSqlLocalDataSource;
  MockArtistLocalDataSource mockArtistLocalDataSource;
  MockIdGenerator mockIdGenerator;
  MockMetadataRetriever mockMetadataRetriever;

  setUp(() {
    mockSqlLocalDataSource = MockSqlLocalDataSource();
    mockArtistLocalDataSource = MockArtistLocalDataSource();
    mockIdGenerator = MockIdGenerator();
    mockMetadataRetriever = MockMetadataRetriever();
    songLocalDataSourceImpl = SongLocalDataSourceImpl(
      sqlLocalDataSource: mockSqlLocalDataSource,
      artistLocalDataSource: mockArtistLocalDataSource,
      idGenerator: mockIdGenerator,
      metadataRetriever: mockMetadataRetriever,
    );
  });
  void getSongSuccessfulSongQuery() {
    when(mockSqlLocalDataSource.query(
      SONG_TABLE,
      where: '$ID_COLUMN=?',
      whereArgs: [tSongId],
    )).thenAnswer(
        (realInvocation) => Future.value([tSongModelWithoutArtistsMap]));

    when(mockSqlLocalDataSource.query(
      SONGS_ARTISTS_TABLE,
      where: '$SONG_ID_COLUMN=?',
      whereArgs: [tSongId],
    )).thenAnswer((realInvocation) => Future.value(tSongsArtistsList));

    when(mockArtistLocalDataSource.addArtist(tArtistModelList[0]))
        .thenAnswer((realInvocation) => Future.value(tArtistModelList[0].id));
    when(mockArtistLocalDataSource.addArtist(tArtistModelList[1]))
        .thenAnswer((realInvocation) => Future.value(tArtistModelList[1].id));
  }

  group('getSong()', () {
    test('should get a song map from the Songs table for a song id', () async {
      // arrange
      getSongSuccessfulSongQuery();

      // act
      await songLocalDataSourceImpl.getSong(tSongId);

      // assert
      verify(mockSqlLocalDataSource
          .query(SONG_TABLE, where: '$ID_COLUMN=?', whereArgs: [tSongId]));
    });

    group('artists', () {
      setUp(() {
        getSongSuccessfulSongQuery();
      });

      test(
          'should get a list of artist maps for a song id from the SongsArtists for a song id',
          () async {
        // act
        await songLocalDataSourceImpl.getSong(tSongId);

        // assert
        verify(mockSqlLocalDataSource.query(SONGS_ARTISTS_TABLE,
            where: '$SONG_ID_COLUMN=?', whereArgs: [tSongId]));
      });

      test('should get artists from the [ArtistLocalDataSource]', () async {
        // act
        await songLocalDataSourceImpl.getSong(tSongId);

        // assert
        verify(mockArtistLocalDataSource.getArtistFromId(tArtistId));
        verify(mockArtistLocalDataSource.getArtistFromId('4321'));
        verifyNoMoreInteractions(mockArtistLocalDataSource);
      });

      test(
          'should throw an [OhrwurmDatabaseException] if connection to db fails',
          () {
        // arrange
        when(mockSqlLocalDataSource.query(
          SONGS_ARTISTS_TABLE,
          where: '$SONG_ID_COLUMN=?',
          whereArgs: [tSongId],
        )).thenThrow(OhrwurmDatabaseException());

        // act
        final call = () => songLocalDataSourceImpl.getSong(tSongId);

        // assert
        expect(call(), throwsA(isA<OhrwurmDatabaseException>()));
      });
    });

    test('should return a [SongModel]', () async {
      // arrange
      getSongSuccessfulSongQuery();

      // act
      final result = await songLocalDataSourceImpl.getSong(tSongId);

      // assert
      expect(result, tSongModel);
    });

    test('should throw an [OhrwurmDatabaseException] if connection to db fails',
        () {
      // arrange
      when(mockSqlLocalDataSource.query(
        any,
        where: anyNamed('where'),
        whereArgs: anyNamed('whereArgs'),
      )).thenThrow(OhrwurmDatabaseException());

      // act
      final call = () => songLocalDataSourceImpl.getSong(tSongId);

      // assert
      expect(call(), throwsA(isA<OhrwurmDatabaseException>()));
    });

    test('should throw a [NotInDatabaseException] if call to db returns null',
        () {
      // arrange
      when(mockSqlLocalDataSource.query(
        any,
        where: anyNamed('where'),
        whereArgs: anyNamed('whereArgs'),
      )).thenAnswer((realInvocation) => Future.value([]));

      // act
      final call = () => songLocalDataSourceImpl.getSong(tSongId);

      // assert
      expect(call(), throwsA(isA<NotInDatabaseException>()));
    });
  });

  group('addSong()', () {
    Map<String, Object> tSongDbMap = tSongModel.toMap();
    tSongDbMap.remove('artists');
    tSongDbMap.remove('albumName');
    tSongDbMap.remove('genre');

    test(
        'should insert the song model map (without artists) into the songs table',
        () async {
      // act
      await songLocalDataSourceImpl.addSong(tSong);

      // assert
      verify(mockSqlLocalDataSource.insert(SONG_TABLE, tSongDbMap));
    });

    test('should throw an [OhrwurmDatabaseException] on a [DatabaseException]',
        () {
      // arrange
      when(mockSqlLocalDataSource.insert(any, any))
          .thenThrow(SqfliteDatabaseException('', 404));

      // act
      final call = () => songLocalDataSourceImpl.addSong(tSong);

      // assert
      expect(call(), throwsA(isA<OhrwurmDatabaseException>()));
    });
  });
  group('addToSongsArtistTable()', () {
    test(
        'should insert the song model map (without artists) into the songs table',
        () async {
      // act
      await songLocalDataSourceImpl.addToSongsArtistTable(tSongId, tArtistId);

      // assert
      verify(mockSqlLocalDataSource.insert(SONGS_ARTISTS_TABLE, tSongsArtist));
    });
    test('should throw an [OhrwurmDatabaseException] on a [DatabaseException]',
        () {
      // arrange
      when(mockSqlLocalDataSource.insert(any, any))
          .thenThrow(SqfliteDatabaseException('', 404));

      // act
      final call = () =>
          songLocalDataSourceImpl.addToSongsArtistTable(tSongId, tArtistId);

      // assert
      expect(call(), throwsA(isA<OhrwurmDatabaseException>()));
    });
  });
  group('getSongMetaData()', () {
    setUp(() {
      when(mockMetadataRetriever.metadata)
          .thenAnswer((realInvocation) => Future.value(tMetadata));
      when(mockMetadataRetriever.albumArt).thenReturn(tCoverArt);
    });
    test('should set file of [MetadataRetriever]', () async {
      // act
      await songLocalDataSourceImpl.getSongMetaData(tSongFile);

      // assert
      verify(mockMetadataRetriever.setFile(tSongFile));
    });

    test('should throw a [FileDoesNotExistException] on exception', () {
      // arrange
      when(mockMetadataRetriever.setFile(any)).thenThrow('');

      // act
      final call = () => songLocalDataSourceImpl.getSongMetaData(tSongFile);

      // assert
      expect(call(), throwsA(isA<FileDoesNotExistException>()));
    });

    test('should get metadata from [MetadataRetriever]', () async {
      // act
      await songLocalDataSourceImpl.getSongMetaData(tSongFile);

      // assert
      verify(mockMetadataRetriever.metadata);
    });

    test('should get cover art from [MetadataRetriever]', () async {
      // act
      await songLocalDataSourceImpl.getSongMetaData(tSongFile);

      // assert
      verify(mockMetadataRetriever.albumArt);
    });

    test('should return a [SongMetaData] entity', () async {
      // act
      final result = await songLocalDataSourceImpl.getSongMetaData(tSongFile);

      // assert
      expect(result, tSongMetaDataModel);
    });
  });

  group('getSongIdList()', () {
    test(
        'should get list of 28 song ids if page != null the offset will be calculated like this (28 * page)',
        () async {
      // arrange
      when(mockSqlLocalDataSource.query(any,
              columns: anyNamed('columns'),
              limit: anyNamed('limit'),
              offset: anyNamed('offset')))
          .thenAnswer((realInvocation) => Future.value(tSongIdMapList));

      // act
      final result = await songLocalDataSourceImpl.getSongIdList(tSongPage);

      // assert
      expect(result, tSongIdList);
      verify(
        mockSqlLocalDataSource.query(SONG_TABLE,
            columns: [ID_COLUMN], limit: 28, offset: tSongPage * 28),
      );
      verifyNoMoreInteractions(mockSqlLocalDataSource);
    });
    test('should throw a [OhrwurmDatabaseException] on [DatabaseException]',
        () async {
      // arrange
      when(mockSqlLocalDataSource.query(any,
              columns: anyNamed('columns'),
              limit: anyNamed('limit'),
              offset: anyNamed('offset')))
          .thenThrow(SqfliteDatabaseException('', 404));

      // act
      final call = () => songLocalDataSourceImpl.getSongIdList(0);

      // assert
      expect(call(), throwsA(isA<OhrwurmDatabaseException>()));
    });
    test('should throw a [NoResultsException] if result is empty and page == 0',
        () async {
      // arrange
      when(mockSqlLocalDataSource.query(any,
              columns: anyNamed('columns'),
              limit: anyNamed('limit'),
              offset: anyNamed('offset')))
          .thenAnswer((realInvocation) => Future.value([]));

      // act
      final call = () => songLocalDataSourceImpl.getSongIdList(0);

      // assert
      expect(call(), throwsA(isA<NoResultsException>()));
    });
    test('should throw a [NoResultsException] if result is empty and page == 0',
        () async {
      // arrange
      when(mockSqlLocalDataSource.query(any,
              columns: anyNamed('columns'),
              limit: anyNamed('limit'),
              offset: anyNamed('offset')))
          .thenAnswer((realInvocation) => Future.value([]));

      // act
      final call = () => songLocalDataSourceImpl.getSongIdList(tSongPage);

      // assert
      expect(call(), throwsA(isA<NoMoreResultsException>()));
    });
  });

  group('getSongFromFilePath()', () {
    test(
        'should query the [SqlLocalDataSource] for the songs file path and return a [Song]',
        () async {
      // arrange
      when(mockSqlLocalDataSource.query(any,
              where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
          .thenAnswer((realInvocation) => Future.value([tSongModelMap]));

      // act
      final result =
          await songLocalDataSourceImpl.getSongFromFilePath(tSongFile.path);

      // assert
      expect(result, tSong);
    });

    test('should throw a [NotInDatabaseException] if result is empty', () {
      // arrange
      when(mockSqlLocalDataSource.query(any,
              where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
          .thenAnswer((realInvocation) => Future.value([]));

      // act
      final call =
          () => songLocalDataSourceImpl.getSongFromFilePath(tSongFile.path);

      // assert
      expect(call(), throwsA(isA<NotInDatabaseException>()));
    });
    test('should throw an [OhrwurmDatabaseException] on a [DatabaseException]',
        () {
      // arrange
      when(mockSqlLocalDataSource.query(any,
              where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
          .thenThrow(SqfliteDatabaseException('', 404));

      // act
      final call =
          () => songLocalDataSourceImpl.getSongFromFilePath(tSongFile.path);

      // assert
      expect(call(), throwsA(isA<NotInDatabaseException>()));
    });
  });
}
