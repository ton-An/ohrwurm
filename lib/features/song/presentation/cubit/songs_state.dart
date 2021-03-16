part of 'songs_cubit.dart';

abstract class SongsState extends Equatable {
  const SongsState();

  @override
  List<Object> get props => [];
}

class SongsInitial extends SongsState {}

class SongsLoading extends SongsState {}

class SongsLoaded extends SongsState {
  final List<Song> songs;

  SongsLoaded({@required this.songs});
}

class SongsError extends SongsState {
  final String message;

  SongsError({@required this.message});
}
