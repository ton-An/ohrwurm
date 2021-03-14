import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/features/song/data/datasources/song_local_data_source.dart';
import 'package:ohrwurm/features/artist/data/models/artist_model.dart';
import 'package:ohrwurm/features/song/data/models/song_model.dart';
import 'package:ohrwurm/features/song/data/repositories_impl/song_repository_impl.dart';

import '../../../../fixtures/artist_fixtures.dart';
import '../../../../fixtures/song_fixtures.dart';

class MockSongLocalDataSource extends Mock implements SongLocalDataSource {}

main() {
  SongRepositoryImpl songRepositoryImpl;
  MockSongLocalDataSource mockSongLocalDataSource;

  setUp(() {
    mockSongLocalDataSource = MockSongLocalDataSource();
    songRepositoryImpl =
        SongRepositoryImpl(songLocalDataSource: mockSongLocalDataSource);
  });

  group('getSong()', () {
    test('should get [SongModel] from [SongLocalDataSource] and return it',
        () async {
      // arrange
      when(mockSongLocalDataSource.getSong(any))
          .thenAnswer((realInvocation) => Future.value(tSongModel));

      // act
      final result = await songRepositoryImpl.getSong('1234');

      // assert
      expect(result, Right(tSongModel));
      verify(mockSongLocalDataSource.getSong('1234'));
      verifyNoMoreInteractions(mockSongLocalDataSource);
    });

    test('should return a [DatabaseFailure] on [DatabaseException]', () async {
      // arrange
      when(mockSongLocalDataSource.getSong(any))
          .thenThrow(OhrwurmDatabaseException('Failure'));

      // act
      final result = await songRepositoryImpl.getSong('1234');

      // assert
      expect(result, Left(DatabaseFailure('Failure')));
    });

    test('should return a [NotInDatabaseFailure] on [NotInDatabaseException]',
        () async {
      // arrange
      when(mockSongLocalDataSource.getSong(any))
          .thenThrow(NotInDatabaseException('Failure'));

      // act
      final result = await songRepositoryImpl.getSong('1234');

      // assert
      expect(result, Left(NotInDatabaseFailure('Failure')));
    });
  });

  group('addSong()', () {
    test(
        'should add a [Song] using the [SongLocalDataSource] and return it\'s id',
        () async {
      when(mockSongLocalDataSource.addSong(any))
          .thenAnswer((realInvocation) => Future.value(tSongId));

      // act
      final result = await songRepositoryImpl.addSong(tSongModel);

      // assert
      expect(result, Right(null));
      verify(mockSongLocalDataSource.addSong(tSongModel));
      verifyNoMoreInteractions(mockSongLocalDataSource);
    });

    test('should return a [DatabaseFailure] on [DatabaseException]', () async {
      // arrange
      when(mockSongLocalDataSource.addSong(any))
          .thenThrow(OhrwurmDatabaseException('Failure'));

      // act
      final result = await songRepositoryImpl.addSong(tSong);

      // assert
      expect(result, Left(DatabaseFailure('Failure')));
    });
  });
  group('addToSongsArtistTable()', () {
    test(
        'should a song id and artist id to the SongsArtists table using the [SongLocalDataSource]',
        () async {
      // act
      await songRepositoryImpl.addToSongsArtistTable(tSongId, tArtistId);

      // assert
      verify(mockSongLocalDataSource.addToSongsArtistTable(tSongId, tArtistId));
      verifyNoMoreInteractions(mockSongLocalDataSource);
    });

    test('should return a [DatabaseFailure] on [DatabaseException]', () async {
      // arrange
      when(mockSongLocalDataSource.addToSongsArtistTable(any, any))
          .thenThrow(OhrwurmDatabaseException('Failure'));

      // act
      final result =
          await songRepositoryImpl.addToSongsArtistTable(tSongId, tArtistId);

      // assert
      expect(result, Left(DatabaseFailure('Failure')));
    });
  });
}
