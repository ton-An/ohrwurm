import 'package:dartz/dartz.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';

abstract class ArtistRepository {
  /// Gets an [Artist] from the [SongRepository]
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, Artist>> getArtist(String artistId);

  /// Adds an [Artist] using the [SongRepository]
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, String>> addArtist(Artist artist);

  // ToDo: deleteArtist

}
