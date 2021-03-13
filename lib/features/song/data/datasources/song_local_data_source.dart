import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/core/utils/id_generator.dart';
import 'package:ohrwurm/features/artist/data/datasources/artist_local_data_source.dart';
import 'package:ohrwurm/features/artist/data/models/artist_model.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:ohrwurm/features/artist/domain/usecases/get_artist.dart';
import 'package:ohrwurm/features/song/data/models/song_model.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:ohrwurm/features/sql/data/datasources/sql_local_data_source.dart';
import 'package:meta/meta.dart';

const SONG_TABLE = 'Songs';
const SONG_ID_COLUMN = 'SongId';
const SONGS_ARTISTS_TABLE = 'SongsArtists';

abstract class SongLocalDataSource {
  /// Gets a [Song] from the Songs table in the SQL database
  ///
  /// Throws a [OhrwurmDatabaseException] if the database can't be accessed and a [NotInDatabaseException] if song can't be found
  Future<Song> getSong(String songID);

  /// Adds a [Song] to the Songs table in the SQL database
  ///
  /// Throws a [OhrwurmDatabaseException] if the database can't be accessed
  Future<String> addSong(SongModel song);
}

class SongLocalDataSourceImpl extends SongLocalDataSource {
  final SqlLocalDataSource sqlLocalDataSource;
  final ArtistLocalDataSource artistLocalDataSource;
  final IdGenerator idGenerator;

  SongLocalDataSourceImpl(
      {@required this.sqlLocalDataSource,
      @required this.artistLocalDataSource,
      @required this.idGenerator})
      : assert(sqlLocalDataSource != null),
        assert(artistLocalDataSource != null),
        assert(idGenerator != null);

  @override
  Future<Song> getSong(String songID) async {
    final List<Map<String, dynamic>> songMapList =
        await sqlLocalDataSource.query(
      SONG_TABLE,
      where: '$ID_COLUMN=?',
      whereArgs: [songID],
    );

    if (songMapList.isNotEmpty) {
      final List<Map<String, Object>> songsArtistsList =
          await sqlLocalDataSource.query(
        SONGS_ARTISTS_TABLE,
        where: '$SONG_ID_COLUMN=?',
        whereArgs: [songID],
      );

      List<Map<String, Object>> artistMaps = [];

      for (Map<String, Object> songsArtist in songsArtistsList) {
        Map<String, Object> artist =
            (await artistLocalDataSource.getArtist(songsArtist['artistId']))
                .toMap();
        artistMaps.add(artist);
      }

      Map<String, Object> songMap = Map.from(songMapList.first);
      songMap['artists'] = artistMaps;

      return SongModel.fromMap(songMap);
    } else
      throw NotInDatabaseException();
  }

  @override
  Future<String> addSong(SongModel song) async {
    Map<String, dynamic> songMapWithoutArtists = song.toMap();
    songMapWithoutArtists.remove('artists');

    final String songId = idGenerator();

    try {
      await getSong(songId);
      return addSong(song);
    } on NotInDatabaseException {
      songMapWithoutArtists.update('id', (value) => songId);

      await sqlLocalDataSource.insert(SONG_TABLE, songMapWithoutArtists);

      List<Artist> artistList = song.artists;

      for (Artist artist in artistList) {
        String artistId = await artistLocalDataSource.addArtist(artist);

        await sqlLocalDataSource.insert(
            SONGS_ARTISTS_TABLE, {'artistId': artistId, 'songId': song.id});
      }
    }
    return songId;
  }
}
