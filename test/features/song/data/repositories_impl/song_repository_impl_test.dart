import 'dart:io';

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

    test('should return a [DatabaseFailure] on [OhrwurmDatabaseException]',
        () async {
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

    test('should return a [DatabaseFailure] on [OhrwurmDatabaseException]',
        () async {
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

    test('should return a [DatabaseFailure] on [OhrwurmDatabaseException]',
        () async {
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

  group('getSongMetaData()', () {
    test('should get a [SongMetaData] entity from the [SongLocalDataSource]',
        () async {
      when(mockSongLocalDataSource.getSongMetaData(any))
          .thenAnswer((realInvocation) => Future.value(tSongMetaDataModel));

      // act
      final result = await songRepositoryImpl.getSongMetaData(tSongFile);

      // assert
      expect(result, Right(tSongMetaDataModel));
      verify(mockSongLocalDataSource.getSongMetaData(tSongFile));
      verifyNoMoreInteractions(mockSongLocalDataSource);
    });

    test(
        'should return a [FileDoesNotExistFailure] on [FileDoesNotExistException]',
        () async {
      // arrange
      when(mockSongLocalDataSource.getSongMetaData(any))
          .thenThrow(FileDoesNotExistException(''));

      // act
      final result = await songRepositoryImpl.getSongMetaData(tSongFile);

      // assert
      expect(result, Left(FileDoesNotExistFailure('')));
    });
  });
  group('getSongIdList()', () {
    test('should get a a List of song ids from the [SongLocalDataSource]',
        () async {
      when(mockSongLocalDataSource.getSongIdList(any))
          .thenAnswer((realInvocation) => Future.value(tSongIdList));
      // act
      final result = await songRepositoryImpl.getSongIdList(tSongPage);

      // assert
      expect(result, Right(tSongIdList));
      verify(mockSongLocalDataSource.getSongIdList(tSongPage));
      verifyNoMoreInteractions(mockSongLocalDataSource);
    });

    test('should return a [DatabaseFailure] on [OhrwurmDatabaseException]',
        () async {
      // arrange
      when(mockSongLocalDataSource.getSongIdList(any))
          .thenThrow(OhrwurmDatabaseException(''));

      // act
      final result = await songRepositoryImpl.getSongIdList(tSongPage);

      // assert
      expect(result, Left(DatabaseFailure('')));
    });
    test('should return a [NoMoreResultsFailure] on [NoMoreResultsException]',
        () async {
      // arrange
      when(mockSongLocalDataSource.getSongIdList(any))
          .thenThrow(NoMoreResultsException(''));

      // act
      final result = await songRepositoryImpl.getSongIdList(tSongPage);

      // assert
      expect(result, Left(NoMoreResultsFailure('')));
    });
    test('should return a [NoResultsFailure] on [NoResultsException]',
        () async {
      // arrange
      when(mockSongLocalDataSource.getSongIdList(any))
          .thenThrow(NoResultsException(''));

      // act
      final result = await songRepositoryImpl.getSongIdList(tSongPage);

      // assert
      expect(result, Left(NoResultsFailure('')));
    });
  });

  group('getSongFromFilePath()', () {
    test(
        'should get a [SongModel], for a filePath, from [SongLocalDataSource] and return it',
        () async {
      // arrange
      when(mockSongLocalDataSource.getSongFromFilePath(any))
          .thenAnswer((realInvocation) => Future.value(tSongModel));

      // act
      final result =
          await songRepositoryImpl.getSongFromFilePath(tSongFile.path);

      // assert
      expect(result, Right(tSongModel));
      verify(mockSongLocalDataSource.getSongFromFilePath(tSongFile.path));
      verifyNoMoreInteractions(mockSongLocalDataSource);
    });

    test('should return a [DatabaseFailure] on [OhrwurmDatabaseException]',
        () async {
      // arrange
      when(mockSongLocalDataSource.getSongFromFilePath(any))
          .thenThrow(OhrwurmDatabaseException('Failure'));

      // act
      final result =
          await songRepositoryImpl.getSongFromFilePath(tSongFile.path);

      // assert
      expect(result, Left(DatabaseFailure('Failure')));
    });

    test('should return a [NotInDatabaseFailure] on [NotInDatabaseException]',
        () async {
      // arrange
      when(mockSongLocalDataSource.getSongFromFilePath(any))
          .thenThrow(NotInDatabaseException('Failure'));

      // act
      final result =
          await songRepositoryImpl.getSongFromFilePath(tSongFile.path);

      // assert
      expect(result, Left(NotInDatabaseFailure('Failure')));
    });
  });

  group('scanDirectory()', () {
    test(
        'should get a List of [FileEntity]s from the [SongLocalDataSource] and return it',
        () {
      // arrange
      when(mockSongLocalDataSource.scanDirectory(any)).thenReturn([tSongFile]);

      // act
      final result = mockSongLocalDataSource.scanDirectory(tDirectory);

      // assert
      expect(result, [tSongFile]);
      verify(mockSongLocalDataSource.scanDirectory(tDirectory));
      verifyNoMoreInteractions(mockSongLocalDataSource);
    });
    test(
        'should return an [OhrwurmFileSystemFailure] on an [OhrwurmFileSystemException]',
        () {
      // arrange
      when(mockSongLocalDataSource.scanDirectory(any))
          .thenThrow(OhrwurmFileSystemException('', ''));

      // act
      final result = mockSongLocalDataSource.scanDirectory(tDirectory);

      // assert
      expect(result, Left(OhrwurmFileSystemFailure('', '')));
    });
  });
}
