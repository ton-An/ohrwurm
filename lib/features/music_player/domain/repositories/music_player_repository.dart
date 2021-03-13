import 'package:dartz/dartz.dart';
import 'package:ohrwurm/core/error/failures.dart';

abstract class MusicPlayerRepository {
  /// Gets a list of the recently played songs id's
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, List<String>>> getRecentlyPlayedList();

  /// Adds a song to the recently played list
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, void>> addSongToRecentlyPlayed(String songID);

  /// Removes a song from the recently played list
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, void>> removeSongFromRecentlyPlayed(String songID);
}
