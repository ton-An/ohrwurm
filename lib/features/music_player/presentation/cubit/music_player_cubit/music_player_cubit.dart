import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_size_cubit/music_player_size_cubit.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:ohrwurm/injection_container.dart';
import 'package:meta/meta.dart';

part 'music_player_state.dart';

class MusicPlayerCubit extends Cubit<MusicPlayerState> {
  final AudioPlayer audioPlayer;

  MusicPlayerCubit({@required this.audioPlayer}) : super(MusicPlayerHidden());

  Future<void> playSong(
      Song song, MusicPlayerSizeCubit musicPlayerSizeCubit) async {
    await audioPlayer.play(song.songFilePath, isLocal: true);
    emit(MusicPlayerPlay(
      song: song,
    ));
    if (musicPlayerSizeCubit.state is MusicPlayerSizeHidden)
      musicPlayerSizeCubit.toggleMusicPlayerSize();
  }

  Future<void> pauseSong(Song song) async {
    await audioPlayer.pause();
    emit(MusicPlayerPause(song: song));
  }
}
