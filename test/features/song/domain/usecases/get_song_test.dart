import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:ohrwurm/features/music_player/domain/repositories/music_player_repository.dart';
import 'package:ohrwurm/features/song/domain/repositories/song_repository.dart';

import 'package:ohrwurm/features/song/domain/usecases/get_song.dart';

import '../../../../fixtures/song_fixtures.dart';

class MockSongRepository extends Mock implements SongRepository {}

main() {
  GetSong getSong;
  MockSongRepository mockSongRepository;

  setUp(() {
    mockSongRepository = MockSongRepository();
    getSong = GetSong(songRepository: mockSongRepository);
  });

  test('should get a [Song] from the [SongRepository]', () async {
    // arrange
    when(mockSongRepository.getSong(any))
        .thenAnswer((realInvocation) => Future.value(Right(tSong)));

    // act
    final result = await getSong(GetSongParams(songID: '1234'));

    // assert
    expect(result, Right(tSong));

    verify(mockSongRepository.getSong('1234'));
    verifyNoMoreInteractions(mockSongRepository);
  });
}
