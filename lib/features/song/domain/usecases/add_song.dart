import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/core/usecases/usecase.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:meta/meta.dart';
import 'package:ohrwurm/features/song/domain/repositories/song_repository.dart';

class AddSong extends UseCase<void, Params> {
  final SongRepository songRepository;

  AddSong({@required this.songRepository}) : assert(songRepository != null);

  @override
  Future<Either<Failure, void>> call(Params params) =>
      songRepository.addSong(params.song);
}

class Params extends Equatable {
  final Song song;

  Params({@required this.song}) : assert(song != null);

  @override
  List<Object> get props => [song];
}
