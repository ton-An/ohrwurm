import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/core/error/failures.dart';
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

main() {
  AddSong addSong;
  MockSongRepository mockSongRepository;
  MockGetSong mockGetSong;
  MockAddArtist mockAddArtist;
  MockIdGenerator mockIdGenerator;

  setUp(() {
    mockSongRepository = MockSongRepository();
    mockGetSong = MockGetSong();
    mockAddArtist = MockAddArtist();
    mockIdGenerator = MockIdGenerator();
    addSong = AddSong(
      songRepository: mockSongRepository,
      getSong: mockGetSong,
      addArtist: mockAddArtist,
      idGenerator: mockIdGenerator,
    );
  });

  setUp(() {
    // arrange
    when(mockIdGenerator()).thenReturn(tSongId);
    when(mockGetSong(any)).thenAnswer(
        (realInvocation) => Future.value(Left(tNotInDatabaseFailure)));
    when(mockSongRepository.addSong(any))
        .thenAnswer((realInvocation) => Future.value(Right(null)));
    when(mockAddArtist(AddArtistParams(artistName: tArtistModelList[0].name)))
        .thenAnswer(
            (realInvocation) => Future.value(Right(tArtistModelList[0].id)));
    when(mockAddArtist(AddArtistParams(artistName: tArtistModelList[1].name)))
        .thenAnswer(
            (realInvocation) => Future.value(Right(tArtistModelList[1].id)));
  });
  test('should generate a song id using the [IdGenerator]', () async {
    // act
    await addSong(AddSongParams(song: tSong));

    // assert
    verify(mockIdGenerator());
    verifyNoMoreInteractions(mockIdGenerator);
  });

  test('should getSong to check if song id already exists', () async {
    // act
    await addSong(AddSongParams(song: tSong));

    // assert
    verify(mockGetSong(GetSongsParams(songID: tSongId)));
    verifyNoMoreInteractions(mockGetSong);
  });

  test(
      'should relay the [Failure] if getSong\'s left results in antorher [Failure] than [NotInDatabaseFailure]',
      () async {
    // arrange
    when(mockGetSong(any)).thenAnswer(
        (realInvocation) => Future.value(Left(tUnidentifiableFailure)));

    // act
    final result = await addSong(AddSongParams(song: tSong));

    // assert
    expect(result, Left(tUnidentifiableFailure));
  });

  group('if song id doesn\'t exist', () {
    test('should call addSong on the [SongRepository]', () async {
      // act
      await addSong(AddSongParams(song: tSong));

      // assert
      verify(mockSongRepository.addSong(tSongWitoutArtists));
    });

    test('should relay addSongs\'s [Failure]s', () async {
      // arrange
      when(mockSongRepository.addSong(any)).thenAnswer(
          (realInvocation) => Future.value(Left(tUnidentifiableFailure)));
      // act
      final result = await addSong(AddSongParams(song: tSong));

      // assert
      expect(result, Left(tUnidentifiableFailure));
    });

    group('if song was added successfully', () {
      test('should add artists', () async {
        // act
        await addSong(AddSongParams(song: tSong));

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
            .thenAnswer(
                (realInvocation) => Future.value(Left(tUnidentifiableFailure)));

        // act
        final result = await addSong(AddSongParams(song: tSong));

        // assert
        expect(result, Left(tUnidentifiableFailure));
      });

      test('should add song and it\'s artists to the SongsArtists table',
          () async {
        // act
        await addSong(AddSongParams(song: tSong));

        // assert
        verify(mockSongRepository.addToSongsArtistTable(
            tSongId, tArtistModelList[0].id));
        verify(mockSongRepository.addToSongsArtistTable(
            tSongId, tArtistModelList[1].id));
      });
      test('should return the songs id', () async {
        // act
        final result = await addSong(AddSongParams(song: tSong));

        // assert
        expect(result, Right(tSongId));
      });
    });
  });

  // should generate a song id using the [IdGenerator]
  // should getSong to check if song id already exists
  // should insert the song model map (without artists) into the songs table
  // should add artist
  // should add song and it\'s artists to the SongsArtists table
  // should return the songId

  // test(
  //     'should call the [SongRepository] to add a [Song] and return the song id',
  //     () async {
  //   // assert
  //   when(mockSongRepository.addSong(any))
  //       .thenAnswer((realInvocation) => Future.value(Right(tSongId)));

  //   // act
  //   final result = await addSong(Params(song: tSong));

  //   // assert
  //   expect(result, Right(tSongId));
  //   verify(mockSongRepository.addSong(tSong));
  //   verifyNoMoreInteractions(mockSongRepository);
  // });
}
