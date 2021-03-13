import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/features/song/data/datasources/song_local_data_source.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ohrwurm/features/song/domain/repositories/song_repository.dart';
import 'package:meta/meta.dart';

class SongRepositoryImpl extends SongRepository {
  final SongLocalDataSource songLocalDataSource;

  SongRepositoryImpl({@required this.songLocalDataSource});
  @override
  Future<Either<Failure, Song>> getSong(String songID) async {
    try {
      return Right(await songLocalDataSource.getSong(songID));
    } on OhrwurmDatabaseException catch (exception) {
      return Left(DatabaseFaiure(exception.message));
    } on NotInDatabaseException catch (exception) {
      return Left(NotInDatabaseFailure(exception.message));
    }
  }

  @override
  Future<Either<Failure, String>> addSong(Song song) async {
    try {
      return Right(await songLocalDataSource.addSong(song));
    } on OhrwurmDatabaseException catch (e) {
      return Left(DatabaseFaiure(e.message));
    }
  }
}
