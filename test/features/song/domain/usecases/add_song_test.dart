import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/core/utils/app_paths.dart';
import 'package:ohrwurm/core/utils/id_generator.dart';
import 'package:ohrwurm/features/artist/domain/usecases/add_artist.dart';
import 'package:ohrwurm/features/song/domain/repositories/song_repository.dart';
import 'package:ohrwurm/features/song/domain/usecases/add_song.dart';
import 'package:ohrwurm/features/song/domain/usecases/get_song.dart';

import '../../../../fixtures/artist_fixtures.dart';
import '../../../../fixtures/song_fixtures.dart';

class MockSongRepository extends Mock implements SongRepository {}

class MockGetSong extends Mock implements GetSong {}

class MockAddArtist extends Mock implements AddArtist {}

class MockIdGenerator extends Mock implements IdGenerator {}

class MockAppPaths extends Mock implements AppPaths {}

main() {
  AddSong addSong;
  MockSongRepository mockSongRepository;
  MockGetSong mockGetSong;
  MockAddArtist mockAddArtist;
  MockIdGenerator mockIdGenerator;
  MockAppPaths mockAppPaths;

  setUp(() {
    mockSongRepository = MockSongRepository();
    mockGetSong = MockGetSong();
    mockAddArtist = MockAddArtist();
    mockIdGenerator = MockIdGenerator();
    mockAppPaths = MockAppPaths();
    addSong = AddSong(
      songRepository: mockSongRepository,
      getSong: mockGetSong,
      addArtist: mockAddArtist,
      idGenerator: mockIdGenerator,
      appPaths: mockAppPaths,
    );
  });

  setUp(() {
    // arrange
    when(mockSongRepository.getSongFromFilePath(any)).thenAnswer(
        (realInvocation) => Future.value(Left(NotInDatabaseFailure(''))));
    when(mockSongRepository.getSongMetaData(any)).thenAnswer(
        (realInvocation) => Future.value(Right(tSongMetaDataModel)));
    when(mockIdGenerator()).thenReturn(tSongId);
    when(mockGetSong(any)).thenAnswer(
        (realInvocation) => Future.value(Left(tNotInDatabaseFailure)));
    when(mockAppPaths.getAppDocumentsDirectoryPath())
        .thenAnswer((realInvocation) => Future.value(tAppPath));
    when(mockSongRepository.addSong(any))
        .thenAnswer((realInvocation) => Future.value(Right(null)));
    when(mockAddArtist(AddArtistParams(artistName: tArtistModelList[0].name)))
        .thenAnswer(
            (realInvocation) => Future.value(Right(tArtistModelList[0].id)));
    when(mockAddArtist(AddArtistParams(artistName: tArtistModelList[1].name)))
        .thenAnswer(
            (realInvocation) => Future.value(Right(tArtistModelList[1].id)));
  });

  test(
      'should check if songFile is already in the db by calling getSongFromFilePath on the [SongRepository]',
      () async {
    // act
    await addSong(AddSongParams(songFile: tSongFile));

    // assert
    verify(mockSongRepository.getSongFromFilePath(tSongFile.path));
  });

  group('if the songFile is already in the db', () {
    test('should return a SongAlreadyExistsFailure with the songs id',
        () async {
      // arrange
      when(mockSongRepository.getSongFromFilePath(any))
          .thenAnswer((realInvocation) => Future.value(Right(tSong)));

      // act
      final result = await addSong(AddSongParams(songFile: tSongFile));

      // assert
      expect(result,
          Left(SongAlreadyExistsFailure(message: '421', songId: tSongId)));
    });
  });

  group('if songFile isn\'t in the db', () {
    test('should get meta data from the repository using the song file',
        () async {
      // act
      await addSong(AddSongParams(songFile: tSongFile));

      // assert
      verify(mockSongRepository.getSongMetaData(tSongFile));
    });

    test('should relay [Failure]s from getSongMetaData call', () async {
      // arrange
      when(mockSongRepository.getSongMetaData(any)).thenAnswer(
          (realInvocation) => Future.value(Left(tUnidentifiableFailure)));

      // act
      final result = await addSong(AddSongParams(songFile: tSongFile));

      // assert
      expect(result, Left(tUnidentifiableFailure));
    });
    test('should generate a song id using the [IdGenerator]', () async {
      // act
      await addSong(AddSongParams(songFile: tSongFile));

      // assert
      verify(mockIdGenerator());
      verifyNoMoreInteractions(mockIdGenerator);
    });

    test('should getSong to check if song id already exists', () async {
      // act
      await addSong(AddSongParams(songFile: tSongFile));

      // assert
      verify(mockGetSong(GetSongParams(songID: tSongId)));
      verifyNoMoreInteractions(mockGetSong);
    });

    test(
        'should relay the [Failure] if getSong\'s left results in antorher [Failure] than [NotInDatabaseFailure]',
        () async {
      // arrange
      when(mockGetSong(any)).thenAnswer(
          (realInvocation) => Future.value(Left(tUnidentifiableFailure)));

      // act
      final result = await addSong(AddSongParams(songFile: tSongFile));

      // assert
      expect(result, Left(tUnidentifiableFailure));
    });

    group('if song id doesn\'t exist', () {
      test('should get app path to save the cover art', () async {
        // act
        await addSong(AddSongParams(songFile: tSongFile));

        // assert
        verify(mockAppPaths.getAppDocumentsDirectoryPath());
        verifyNoMoreInteractions(mockAppPaths);
      });
      test('should call addSong on the [SongRepository]', () async {
        // act
        await addSong(AddSongParams(songFile: tSongFile));

        // assert
        verify(mockSongRepository.addSong(tSongWitoutArtists));
      });

      test('should relay addSongs\'s [Failure]s', () async {
        // arrange
        when(mockSongRepository.addSong(any)).thenAnswer(
            (realInvocation) => Future.value(Left(tUnidentifiableFailure)));
        // act
        final result = await addSong(AddSongParams(songFile: tSongFile));

        // assert
        expect(result, Left(tUnidentifiableFailure));
      });

      group('if song was added successfully', () {
        test('should add artists', () async {
          // act
          await addSong(AddSongParams(songFile: tSongFile));

          // assert
          verify(mockAddArtist(
              AddArtistParams(artistName: tArtistModelList[0].name)));
          verify(mockAddArtist(
              AddArtistParams(artistName: tArtistModelList[1].name)));
          verifyNoMoreInteractions(mockAddArtist);
        });

        test(
            'should return a [Failure] if adding the artists goes terribly wrong',
            () async {
          // arrange
          when(mockAddArtist(
                  AddArtistParams(artistName: tArtistModelList[1].name)))
              .thenAnswer((realInvocation) =>
                  Future.value(Left(tUnidentifiableFailure)));

          // act
          final result = await addSong(AddSongParams(songFile: tSongFile));

          // assert
          expect(result, Left(tUnidentifiableFailure));
        });

        test('should add song and it\'s artists to the SongsArtists table',
            () async {
          // act
          await addSong(AddSongParams(songFile: tSongFile));

          // assert
          verify(mockSongRepository.addToSongsArtistTable(
              tSongId, tArtistModelList[0].id));
          verify(mockSongRepository.addToSongsArtistTable(
              tSongId, tArtistModelList[1].id));
        });
        test('should return the songs id', () async {
          // act
          final result = await addSong(AddSongParams(songFile: tSongFile));

          // assert
          expect(result, Right(tSongId));
        });
      });
    });
  });
}
