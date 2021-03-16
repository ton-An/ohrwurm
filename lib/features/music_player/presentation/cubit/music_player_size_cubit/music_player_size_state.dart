part of 'music_player_size_cubit.dart';

abstract class MusicPlayerSizeState extends Equatable {
  const MusicPlayerSizeState();

  @override
  List<Object> get props => [];
}

class MusicPlayerSizeHidden extends MusicPlayerSizeState {}

class MusicPlayerSizeSmall extends MusicPlayerSizeState {}

class MusicPlayerSizeLarge extends MusicPlayerSizeState {}
