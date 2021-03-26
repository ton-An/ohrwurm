import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/features/song/data/models/song_meta_data_model.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:ohrwurm/features/song/domain/entities/song_meta_data.dart';

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

  /// Gets a [Song]s meta data from the [SongLocalDataSource]
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, SongMetaData>> getSongMetaData(File songFile);

  /// Gets a List of song ids
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, List<String>>> getSongIdList(int page);

  /// Gets a [Song] from an id
  ///
  /// Returns a [Failure] if something goes terribly wrong
  Future<Either<Failure, Song>> getSongFromFilePath(String filePath);

  /// Gets the List of [FileSystemEntity]s for a directory
  ///
  /// Returns an [OhrwurmFileSystemFailure] if something goes terribly wrong
  Either<Failure, List<FileSystemEntity>> scanDirectory(Directory directory);
}
