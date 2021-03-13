import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/core/utils/id_generator.dart';
import 'package:ohrwurm/features/artist/data/datasources/artist_local_data_source.dart';
import 'package:ohrwurm/features/song/data/datasources/song_local_data_source.dart';
import 'package:ohrwurm/features/sql/data/datasources/sql_local_data_source.dart';
import '../../../../fixtures/artist_fixtures.dart';
import '../../../../fixtures/song_fixtures.dart';

class MockSqlLocalDataSource extends Mock implements SqlLocalDataSource {}

class MockArtistLocalDataSource extends Mock implements ArtistLocalDataSource {}

class MockIdGenerator extends Mock implements IdGenerator {}

main() {
  SongLocalDataSourceImpl songLocalDataSourceImpl;
  MockSqlLocalDataSource mockSqlLocalDataSource;
  MockArtistLocalDataSource mockArtistLocalDataSource;
  MockIdGenerator mockIdGenerator;

  setUp(() {
    mockSqlLocalDataSource = MockSqlLocalDataSource();
    mockArtistLocalDataSource = MockArtistLocalDataSource();
    mockIdGenerator = MockIdGenerator();
    songLocalDataSourceImpl = SongLocalDataSourceImpl(
      sqlLocalDataSource: mockSqlLocalDataSource,
      artistLocalDataSource: mockArtistLocalDataSource,
      idGenerator: mockIdGenerator,
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
        verify(mockArtistLocalDataSource.getArtist(tArtistId));
        verify(mockArtistLocalDataSource.getArtist('4321'));
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
    Map<String, Object> tSongMapWithoutArtists = tSongModel.toMap();
    tSongMapWithoutArtists.remove('artists');

    setUp(() {
      getSongSuccessfulSongQuery();
      when(mockSqlLocalDataSource.query(
        any,
        where: anyNamed('where'),
        whereArgs: anyNamed('whereArgs'),
      )).thenAnswer((realInvocation) => Future.value([]));

      when(mockIdGenerator()).thenReturn(tSongId);
      when(mockArtistLocalDataSource.addArtist(tArtistModel))
          .thenAnswer((realInvocation) => Future.value(tArtistId));
    });
    test('should generate a song id using the [IdGenerator]', () async {
      // act
      await songLocalDataSourceImpl.addSong(tSong);

      // assert
      verify(mockIdGenerator());
      verifyNoMoreInteractions(mockIdGenerator);
    });
    test(
        'should insert the song model map (without artists) into the songs table',
        () async {
      // act
      await songLocalDataSourceImpl.addSong(tSong);

      // assert
      verify(mockSqlLocalDataSource.insert(SONG_TABLE, tSongMapWithoutArtists));
    });

    test('should add artist', () async {
      // act
      await songLocalDataSourceImpl.addSong(tSong);

      // assert
      verify(mockArtistLocalDataSource.addArtist(tArtistModel));
    });

    test('should add song and it\'s artists to the SongsArtists table',
        () async {
      // act
      await songLocalDataSourceImpl.addSong(tSong);

      // assert
      verify(mockSqlLocalDataSource.insert(
          SONGS_ARTISTS_TABLE, tSongsArtistsList[0]));
      verify(mockSqlLocalDataSource.insert(
          SONGS_ARTISTS_TABLE, tSongsArtistsList[1]));
    });

    test('should return the songId', () async {
      // act
      final result = await songLocalDataSourceImpl.addSong(tSong);

      // assert
      expect(result, tSongId);
    });
  });
}
