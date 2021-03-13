import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/features/song/domain/repositories/song_repository.dart';
import 'package:ohrwurm/features/song/domain/usecases/add_song.dart';

import '../../../../fixtures/song_fixtures.dart';

class MockSongRepository extends Mock implements SongRepository {}

main() {
  AddSong addSong;
  MockSongRepository mockSongRepository;

  setUp(() {
    mockSongRepository = MockSongRepository();
    addSong = AddSong(songRepository: mockSongRepository);
  });

  test(
      'should call the [SongRepository] to add a [Song] and return the song id',
      () async {
    // assert
    when(mockSongRepository.addSong(any))
        .thenAnswer((realInvocation) => Future.value(Right(tSongId)));

    // act
    final result = await addSong(Params(song: tSong));

    // assert
    expect(result, Right(tSongId));
    verify(mockSongRepository.addSong(tSong));
    verifyNoMoreInteractions(mockSongRepository);
  });
}
