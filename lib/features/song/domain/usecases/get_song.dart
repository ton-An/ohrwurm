import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/core/usecases/usecase.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:meta/meta.dart';
import 'package:ohrwurm/features/song/domain/repositories/song_repository.dart';

class GetSong extends UseCase<Song, GetSongParams> {
  final SongRepository songRepository;

  GetSong({@required this.songRepository}) : assert(songRepository != null);

  @override
  Future<Either<Failure, Song>> call(GetSongParams params) =>
      songRepository.getSong(params.songID);
}

class GetSongParams extends Equatable {
  final String songID;

  GetSongParams({@required this.songID}) : assert(songID != null);

  @override
  List<Object> get props => [songID];
}
