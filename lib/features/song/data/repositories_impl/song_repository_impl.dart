import 'dart:io';

import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/features/song/data/datasources/song_local_data_source.dart';
import 'package:ohrwurm/features/song/data/models/song_meta_data_model.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ohrwurm/features/song/domain/entities/song_meta_data.dart';
import 'package:ohrwurm/features/song/domain/repositories/song_repository.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

class SongRepositoryImpl extends SongRepository {
  final SongLocalDataSource songLocalDataSource;

  SongRepositoryImpl({@required this.songLocalDataSource});
  @override
  Future<Either<Failure, Song>> getSong(String songID) async {
    try {
      return Right(await songLocalDataSource.getSong(songID));
    } on OhrwurmDatabaseException catch (exception) {
      return Left(DatabaseFailure(exception.message));
    } on NotInDatabaseException catch (exception) {
      return Left(NotInDatabaseFailure(exception.message));
    }
  }

  @override
  Future<Either<Failure, void>> addSong(Song song) async {
    try {
      await songLocalDataSource.addSong(song);
      return Right(null);
    } on OhrwurmDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addToSongsArtistTable(
      String songId, String artistId) async {
    try {
      await songLocalDataSource.addToSongsArtistTable(songId, artistId);
      return Right(null);
    } on OhrwurmDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, SongMetaData>> getSongMetaData(File songFile) async {
    try {
      return Right(await songLocalDataSource.getSongMetaData(songFile));
    } on FileDoesNotExistException catch (e) {
      return Left(FileDoesNotExistFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSongIdList(int page) async {
    try {
      return Right(await songLocalDataSource.getSongIdList(page));
    } on OhrwurmDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NoMoreResultsException catch (e) {
      return Left(NoMoreResultsFailure(e.message));
    } on NoResultsException catch (e) {
      return Left(NoResultsFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Song>> getSongFromFilePath(String filePath) async {
    try {
      return Right(await songLocalDataSource.getSongFromFilePath(filePath));
    } on OhrwurmDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NotInDatabaseException catch (e) {
      return Left(NotInDatabaseFailure(e.message));
    }
  }

  @override
  Either<Failure, List<FileSystemEntity>> scanDirectory(Directory directory) {
    try {
      return Right(songLocalDataSource.scanDirectory(directory));
    } on OhrwurmFileSystemException catch (e) {
      return Left(OhrwurmFileSystemFailure(e.message, e.path));
    }
  }
}
