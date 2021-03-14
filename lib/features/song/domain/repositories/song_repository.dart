import 'package:dartz/dartz.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';

abstract class SongRepository {
  /// Gets a [Song] from the [SongLocalDataSource]
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, Song>> getSong(String songID);

  /// Adds a [Song] using the [SongLocalDataSource]
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, void>> addSong(Song song);

  /// Adds and [Artist] and his/her [Song] to the SongsArtist table in the DB using the [SongLocalDataSource]
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, void>> addToSongsArtistTable(
      String songId, String artistId);
}
