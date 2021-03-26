import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/features/song/domain/repositories/song_repository.dart';
import 'package:ohrwurm/features/song/domain/usecases/add_song.dart';
import 'package:ohrwurm/features/song/domain/usecases/scan_directory_for_songs.dart';

import '../../../../fixtures/song_fixtures.dart';

class MockDirectory extends Mock implements Directory {}

class MockAddSong extends Mock implements AddSong {}

class MockSongRepository extends Mock implements SongRepository {}

main() {
  ScanDirectoryForSongs scanDirectoryForSongs;
  MockAddSong mockAddSong;
  MockSongRepository mockSongRepository;

  setUp(() {
    mockAddSong = MockAddSong();
    mockSongRepository = MockSongRepository();
    scanDirectoryForSongs = ScanDirectoryForSongs(
        addSong: mockAddSong, songRepository: mockSongRepository);
  });

  test(
      'should get a List of [FileSystemEntity]s from the [SongLocalRepository]',
      () async {
    // arrange
    when(mockSongRepository.scanDirectory(any))
        .thenAnswer((realInvocation) => Right([tSongFile]));

    // act
    await scanDirectoryForSongs(ScanDirectoryParams(directory: tDirectory));

    // assert
    verify(mockSongRepository.scanDirectory(tDirectory));
    verifyNoMoreInteractions(mockSongRepository);
  });

  test('should relay [Failure]s', () async {
    // arrange
    when(mockSongRepository.scanDirectory(any))
        .thenAnswer((realInvocation) => Left(tUnidentifiableFailure));

    // act
    final result =
        await scanDirectoryForSongs(ScanDirectoryParams(directory: tDirectory));

    // assert
    expect(result, Left(tUnidentifiableFailure));
    verify(mockSongRepository.scanDirectory(tDirectory));
    verifyNoMoreInteractions(mockSongRepository);
  });
}
