import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_cubit/music_player_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_size_cubit/music_player_size_cubit.dart';

import '../../../../fixtures/music_player_fixtures.dart';
import '../../../../fixtures/song_fixtures.dart';

class MockMusicPlayerSizeCubit extends Mock implements MusicPlayerSizeCubit {}

class MockAudioPlayer extends Mock implements AudioPlayer {}

main() {
  MusicPlayerCubit musicPlayerCubit;
  MockMusicPlayerSizeCubit mockMusicPlayerSizeCubit;
  MockAudioPlayer mockAudioPlayer;

  setUp(() {
    mockMusicPlayerSizeCubit = MockMusicPlayerSizeCubit();
    mockAudioPlayer = MockAudioPlayer();
    musicPlayerCubit = MusicPlayerCubit(audioPlayer: mockAudioPlayer);
  });

  setUp(() {
    when(mockMusicPlayerSizeCubit.state).thenReturn(MusicPlayerSizeHidden());
  });

  test('should have initial state of [MusicPlayerHidden]', () {
    // assert
    expect(musicPlayerCubit.state, MusicPlayerHidden());
  });

  group('playSong()', () {
    test('should call play on the [AudioPlayer]', () async {
      // act
      await musicPlayerCubit.playSong(tSong, mockMusicPlayerSizeCubit);

      // assert
      verify(mockAudioPlayer.play(tSong.songFilePath, isLocal: true));
    });

    test(
        'should call playSong on [MusicPlayerCubit] if the state of that Cubit is [MusicPlayerSizeHidden]',
        () async {
      // act
      await musicPlayerCubit.playSong(tSong, mockMusicPlayerSizeCubit);

      // assert
      verify(mockMusicPlayerSizeCubit.state);
      verify(mockMusicPlayerSizeCubit.toggleMusicPlayerSize());
      verifyNoMoreInteractions(mockMusicPlayerSizeCubit);
    });

    blocTest(
      'should emit the [MusicPlayerPlay] state if everything goes well',
      build: () => musicPlayerCubit,
      act: (cubit) async {
        await cubit.playSong(tSong, mockMusicPlayerSizeCubit);
      },
      expect: () => [MusicPlayerPlay(song: tSong)],
    );
  });

  group('pauseSong()', () {
    test('should call play on the [AudioPlayer]', () async {
      // act
      await musicPlayerCubit.pauseSong(tSong);

      // assert
      verify(mockAudioPlayer.pause());
    });
    blocTest(
      'should emit the [MusicPlayerPause] state if everything goes well',
      build: () => musicPlayerCubit,
      act: (cubit) async {
        await cubit.pauseSong(tSong);
      },
      expect: () => [MusicPlayerPause(song: tSong)],
    );
  });
}
