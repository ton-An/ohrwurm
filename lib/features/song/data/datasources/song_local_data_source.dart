import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:id3/id3.dart';
import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/core/utils/id_generator.dart';
import 'package:ohrwurm/features/artist/data/datasources/artist_local_data_source.dart';
import 'package:ohrwurm/features/artist/data/models/artist_model.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:ohrwurm/features/artist/domain/usecases/get_artist.dart';
import 'package:ohrwurm/features/song/data/models/song_meta_data_model.dart';
import 'package:ohrwurm/features/song/data/models/song_model.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:ohrwurm/features/song/domain/entities/song_meta_data.dart';
import 'package:ohrwurm/features/song/domain/usecases/add_song.dart';
import 'package:ohrwurm/features/sql/data/datasources/sql_local_data_source.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

const SONG_TABLE = 'Songs';
const SONG_ID_COLUMN = 'SongId';
const SONGS_ARTISTS_TABLE = 'SongsArtists';
const SONG_FILE_PATH_COLUMN = 'songFilePath';

abstract class SongLocalDataSource {
  /// Gets a [Song] from the Songs table in the SQL database
  ///
  /// Throws a [OhrwurmDatabaseException] if the database can't be accessed and a [NotInDatabaseException] if song can't be found
  Future<Song> getSong(String songID);

  /// Adds a [Song] to the Songs table in the SQL database
  ///
  /// Throws a [OhrwurmDatabaseException] if the database can't be accessed
  Future<void> addSong(SongModel song);

  /// Adds a song and it's artist to the SongsArtists table in the SQL database
  ///
  /// Throws a [OhrwurmDatabaseException] if the database can't be accessed
  Future<void> addToSongsArtistTable(String songId, String artistId);

  /// Gets the songs meta data from a file using [MetaDataRetriever]
  ///
  /// Throws a [OhrwurmDatabaseException] if the database can't be accessed
  Future<SongMetaData> getSongMetaData(File songFile);

  /// Gets a List of song ids from the Songs table in the SQL database
  ///
  /// Throws a [OhrwurmDatabaseException] if the database can't be accessed, a [NoResultsException] if result is empty and a [NoMoreResultsException] if result is empty and page != null
  Future<List<String>> getSongIdList(int page);

  /// Gets a [Song], for a filePath, from the Songs table in the SQL database
  ///
  /// Throws a [OhrwurmDatabaseException] if the database can't be accessed and a [NotInDatabaseException] if song can't be found
  Future<Song> getSongFromFilePath(String filePath);

  /// Gets the List of [FileSystemEntity]s for a directory
  ///
  /// Throws an [OhrwurmFileSystemException] if something goes terribly wrong
  List<FileSystemEntity> scanDirectory(Directory directory);
}

class SongLocalDataSourceImpl extends SongLocalDataSource {
  final SqlLocalDataSource sqlLocalDataSource;
  final ArtistLocalDataSource artistLocalDataSource;
  final IdGenerator idGenerator;
  final MetadataRetriever metadataRetriever;

  SongLocalDataSourceImpl({
    @required this.sqlLocalDataSource,
    @required this.artistLocalDataSource,
    @required this.idGenerator,
    @required this.metadataRetriever,
  })  : assert(sqlLocalDataSource != null),
        assert(artistLocalDataSource != null),
        assert(idGenerator != null);

  @override
  Future<Song> getSong(String songId) async =>
      _getSongWhere('$ID_COLUMN=?', [songId]);

  @override
  Future<Song> getSongFromFilePath(String filePath) async =>
      _getSongWhere('$SONG_FILE_PATH_COLUMN=?', [filePath]);

  Future<Song> _getSongWhere(String where, List<String> whereArgs) async {
    final List<Map<String, dynamic>> songMapList =
        await sqlLocalDataSource.query(
      SONG_TABLE,
      where: where,
      whereArgs: whereArgs,
    );

    if (songMapList.isNotEmpty) {
      final List<Map<String, Object>> songsArtistsList =
          await sqlLocalDataSource.query(
        SONGS_ARTISTS_TABLE,
        where: '$SONG_ID_COLUMN=?',
        whereArgs: [songMapList.first['id']],
      );

      List<Map<String, Object>> artistMaps = [];

      for (Map<String, Object> songsArtist in songsArtistsList) {
        Map<String, Object> artist = (await artistLocalDataSource
                .getArtistFromId(songsArtist['artistId']))
            .toMap();
        artistMaps.add(artist);
      }

      Map<String, Object> songMap = Map.from(songMapList.first);
      songMap['artists'] = artistMaps;

      return SongModel.fromMap(songMap);
    } else
      throw NotInDatabaseException('4354');
  }

  @override
  Future<void> addSong(SongModel song) async {
    Map<String, dynamic> songDbMap = song.toMap();
    songDbMap.remove('artists');
    songDbMap.remove('albumName');
    songDbMap.remove('genre');

    try {
      await sqlLocalDataSource.insert(SONG_TABLE, songDbMap);
    } on DatabaseException {
      throw OhrwurmDatabaseException('756');
    }
  }

  @override
  Future<void> addToSongsArtistTable(String songId, String artistId) async {
    try {
      await sqlLocalDataSource.insert(SONGS_ARTISTS_TABLE, {
        'songId': songId,
        'artistId': artistId,
      });
    } on DatabaseException {
      throw OhrwurmDatabaseException('547654');
    }
  }

  @override
  Future<SongMetaData> getSongMetaData(File songFile) async {
    try {
      await metadataRetriever.setFile(songFile);
    } catch (e) {
      throw UnidentifiableException('453671');
    }
    Metadata metadata = await metadataRetriever.metadata;
    Uint8List coverArt = metadataRetriever.albumArt;
    return SongMetaDataModel.fromMetaData(metadata, coverArt);
  }

  @override
  Future<List<String>> getSongIdList(int page) async {
    try {
      List<String> songIds = (await sqlLocalDataSource.query(SONG_TABLE,
              columns: [ID_COLUMN], limit: 28, offset: page * 28))
          .map<String>((idMap) => idMap['id'])
          .toList();

      if (songIds.isEmpty && page == 0) throw NoResultsException('435423');

      if (songIds.isEmpty && page > 0)
        throw NoMoreResultsException('3456');
      else
        return songIds;
    } on DatabaseException {
      throw OhrwurmDatabaseException('5476');
    }
  }

  List<FileSystemEntity> scanDirectory(Directory directory) {
    try {
      return directory.listSync(recursive: true);
    } on FileSystemException catch (e) {
      throw OhrwurmFileSystemException(e.message, e.path);
    }
  }
}
