import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/core/usecases/usecase.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:meta/meta.dart';
import 'package:ohrwurm/features/song/domain/repositories/song_repository.dart';

class GetSong extends UseCase<Song, GetSongsParams> {
  final SongRepository songRepository;

  GetSong({@required this.songRepository}) : assert(songRepository != null);

  @override
  Future<Either<Failure, Song>> call(GetSongsParams params) =>
      songRepository.getSong(params.songID);
}

class GetSongsParams extends Equatable {
  final String songID;

  GetSongsParams({@required this.songID}) : assert(songID != null);

  @override
  List<Object> get props => [songID];
}
