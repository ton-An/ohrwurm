import 'package:dartz/dartz.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';

abstract class ArtistRepository {
  /// Gets an [Artist] from the [SongRepository] using an ID
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, Artist>> getArtistFromId(String artistId);

  /// Gets an [Artist] from the [SongRepository] using a name
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, Artist>> getArtistFromName(String artistName);

  /// Adds an [Artist] using the [SongRepository]
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, void>> addArtist(Artist artist);
}
