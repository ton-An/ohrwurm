import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/features/artist/data/datasources/artist_local_data_source.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ohrwurm/features/artist/domain/repositories/artist_repository.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

class ArtistRepositoryImpl extends ArtistRepository {
  final ArtistLocalDataSource artistLocalDataSource;

  ArtistRepositoryImpl({@required this.artistLocalDataSource});

  @override
  Future<Either<Failure, String>> addArtist(Artist artist) async {
    try {
      return Right(await artistLocalDataSource.addArtist(artist));
    } on OhrwurmDatabaseException catch (e) {
      return Left(DatabaseFaiure(e.message));
    }
  }

  @override
  Future<Either<Failure, Artist>> getArtist(String artistId) async {
    try {
      return Right(await artistLocalDataSource.getArtist(artistId));
    } on OhrwurmDatabaseException catch (e) {
      return Left(DatabaseFaiure(e.message));
    } on NotInDatabaseException catch (e) {
      return Left(NotInDatabaseFailure(e.message));
    }
  }
}
