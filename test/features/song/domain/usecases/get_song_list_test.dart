import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/features/song/domain/repositories/song_repository.dart';
import 'package:ohrwurm/features/song/domain/usecases/get_song.dart';
import 'package:ohrwurm/features/song/domain/usecases/get_song_list.dart';

import '../../../../fixtures/song_fixtures.dart';

class MockSongRepository extends Mock implements SongRepository {}

class MockGetSong extends Mock implements GetSong {}

main() {
  GetSongList getSongIdList;
  MockSongRepository mockSongRepository;
  MockGetSong mockGetSong;

  setUp(() {
    mockSongRepository = MockSongRepository();
    mockGetSong = MockGetSong();
    getSongIdList =
        GetSongList(songRepository: mockSongRepository, getSong: mockGetSong);
  });

  setUp(() {
    when(mockSongRepository.getSongIdList(any))
        .thenAnswer((realInvocation) => Future.value(Right(tSongIdList)));
    when(mockGetSong(GetSongParams(songID: tSongIdList[0])))
        .thenAnswer((realInvocation) => Future.value(Right(tSongModel)));
    when(mockGetSong(GetSongParams(songID: tSongIdList[1])))
        .thenAnswer((realInvocation) => Future.value(Right(tSongModel2)));
  });

  test('should get a list of song ids from the [SongRepository]', () async {
    // act
    await getSongIdList(GetSongListParams(page: tSongPage));

    // assert
    verify(mockSongRepository.getSongIdList(1));
  });

  test('should relay/return the [Failure] if one happens to happen', () async {
    // arrange
    when(mockSongRepository.getSongIdList(any)).thenAnswer(
        (realInvocation) => Future.value(Left(tUnidentifiableFailure)));
    // act
    final result = await getSongIdList(GetSongListParams(page: tSongPage));

    // assert
    expect(result, Left(tUnidentifiableFailure));
  });

  group('if getSongIdList call was successful', () {
    test(
        'should call [GetSong] for every song in the songIdList and return the Songs',
        () async {
      // act
      final result = await getSongIdList(GetSongListParams(page: tSongPage));

      // assert
      expect(result, Right(tSongModelList));
      verify(mockGetSong(GetSongParams(songID: tSongIdList[0])));
      verify(mockGetSong(GetSongParams(songID: tSongIdList[1])));
      verifyNoMoreInteractions(mockGetSong);
    });
  });
}
