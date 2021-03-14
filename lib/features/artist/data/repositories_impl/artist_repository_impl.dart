import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/features/artist/data/datasources/artist_local_data_source.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ohrwurm/features/artist/domain/repositories/artist_repository.dart';
import 'package:meta/meta.dart';

class ArtistRepositoryImpl extends ArtistRepository {
  final ArtistLocalDataSource artistLocalDataSource;

  ArtistRepositoryImpl({@required this.artistLocalDataSource});

  @override
  Future<Either<Failure, void>> addArtist(Artist artist) async {
    try {
      await artistLocalDataSource.addArtist(artist);
      return Right(null);
    } on OhrwurmDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Artist>> getArtistFromId(String artistId) async {
    try {
      return Right(await artistLocalDataSource.getArtistFromId(artistId));
    } on OhrwurmDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NotInDatabaseException catch (e) {
      return Left(NotInDatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Artist>> getArtistFromName(String artistName) async {
    try {
      return Right(await artistLocalDataSource.getArtistFromName(artistName));
    } on OhrwurmDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NotInDatabaseException catch (e) {
      return Left(NotInDatabaseFailure(e.message));
    }
  }
}
