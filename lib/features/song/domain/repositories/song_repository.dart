import 'package:dartz/dartz.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';

abstract class SongRepository {
  /// Gets a [Song] from the [SongRepository]
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, Song>> getSong(String songID);

  /// Adds a [Song] using the [SongRepository]
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, String>> addSong(Song song);
}
