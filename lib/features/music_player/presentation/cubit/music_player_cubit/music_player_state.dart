part of 'music_player_cubit.dart';

abstract class MusicPlayerState extends Equatable {
  const MusicPlayerState();

  @override
  List<Object> get props => [];
}

class MusicPlayerHidden extends MusicPlayerState {}

abstract class MusicPlayerPlayPauseState extends MusicPlayerState {
  final Song song;

  MusicPlayerPlayPauseState({
    @required this.song,
  });

  @override
  List<Object> get props => [song];
}

class MusicPlayerPause extends MusicPlayerPlayPauseState {
  MusicPlayerPause({
    @required Song song,
  }) : super(song: song);
}

class MusicPlayerPlay extends MusicPlayerPlayPauseState {
  final Stream<Duration> positionStream;
  final Duration duration;
  MusicPlayerPlay({
    @required Song song,
    @required this.duration,
    @required this.positionStream,
  }) : super(song: song);

  @override
  List<Object> get props => [song, duration, positionStream];
}

class MusicPlayerError extends MusicPlayerState {}
