part of 'music_player_cubit.dart';

abstract class MusicPlayerState extends Equatable {
  const MusicPlayerState();

  @override
  List<Object> get props => [];
}

class MusicPlayerHidden extends MusicPlayerState {}

abstract class MusicPlayerPlayPauseState extends MusicPlayerState {
  final Song song;

  MusicPlayerPlayPauseState({@required this.song});
}

class MusicPlayerPause extends MusicPlayerPlayPauseState {
  MusicPlayerPause({@required song}) : super(song: song);
}

class MusicPlayerPlay extends MusicPlayerPlayPauseState {
  MusicPlayerPlay({@required song}) : super(song: song);
}

class MusicPlayerError extends MusicPlayerState {}
