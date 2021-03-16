import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_size_cubit/music_player_size_cubit.dart';

main() {
  MusicPlayerSizeCubit musicPlayerSizeCubit;

  setUp(() {
    musicPlayerSizeCubit = MusicPlayerSizeCubit();
  });

  test('should have initial state of [MusicPlayerSizeHidden]', () {
    // assert
    expect(musicPlayerSizeCubit.state, MusicPlayerSizeHidden());
  });

  blocTest(
    'should emit the [MusicPlayerSizeSmall] state if current state is [MusicPlayerSizeHidden]',
    build: () => musicPlayerSizeCubit,
    act: (cubit) {
      cubit.toggleMusicPlayerSize();
    },
    expect: () => [
      MusicPlayerSizeSmall(),
    ],
  );

  blocTest(
    'should emit the [MusicPlayerSizeLarge] state if current state is [MusicPlayerSizeSmall]',
    build: () => musicPlayerSizeCubit,
    act: (cubit) {
      cubit.toggleMusicPlayerSize();
      cubit.toggleMusicPlayerSize();
    },
    expect: () => [MusicPlayerSizeSmall(), MusicPlayerSizeLarge()],
  );

  blocTest(
    'should emit the [MusicPlayerSizeSmall] state if current state is [MusicPlayerSizeLarge]',
    build: () => musicPlayerSizeCubit,
    act: (cubit) {
      cubit.toggleMusicPlayerSize();
      cubit.toggleMusicPlayerSize();
      cubit.toggleMusicPlayerSize();
    },
    expect: () => [
      MusicPlayerSizeSmall(),
      MusicPlayerSizeLarge(),
      MusicPlayerSizeSmall()
    ],
  );
}
