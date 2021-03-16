import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/core/usecases/usecase.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:ohrwurm/features/song/domain/repositories/song_repository.dart';
import 'package:ohrwurm/features/song/domain/usecases/get_song.dart';

class GetSongList extends UseCase<List<Song>, GetSongListParams> {
  final SongRepository songRepository;
  final GetSong getSong;

  GetSongList({
    @required this.songRepository,
    @required this.getSong,
  });

  @override
  Future<Either<Failure, List<Song>>> call(GetSongListParams params) async {
    final Either<Failure, List<String>> songIdListEither =
        await songRepository.getSongIdList(params.page);

    return songIdListEither.fold((l) => Left(l), (r) async {
      List<Song> songList = [];
      for (String songId in r) {
        (await getSong(GetSongParams(songID: songId)))
            .fold((l) => null, (r) => songList.add(r));
      }

      return Right(songList);
    });
  }
}

class GetSongListParams extends Equatable {
  final int page;

  GetSongListParams({@required this.page});

  @override
  List<Object> get props => [page];
}
