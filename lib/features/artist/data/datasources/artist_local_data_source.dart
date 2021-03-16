import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/core/utils/id_generator.dart';
import 'package:ohrwurm/features/artist/data/models/artist_model.dart';
import 'package:ohrwurm/features/sql/data/datasources/sql_local_data_source.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

const ARTISTS_TABLE = 'Artists';

abstract class ArtistLocalDataSource {
  /// Gets an [Artist] from the Artists table in the SQL database for an ID
  ///
  /// Throws a [OhrwurmDatabaseException] if the database can't be accessed and a [NotInDatabaseException] if song can't be found
  Future<ArtistModel> getArtistFromId(String artistId);

  /// Gets an [Artist] from the Artists table in the SQL database for a name
  ///
  /// Throws a [OhrwurmDatabaseException] if the database can't be accessed and a [NotInDatabaseException] if song can't be found
  Future<ArtistModel> getArtistFromName(String artistName);

  /// Adds an [Artist] to the Artists table in the SQL database
  ///
  /// Throws a [OhrwurmDatabaseException] if the database can't be accessed
  Future<void> addArtist(ArtistModel artistModel);
}

class ArtistLocalDataSourceImpl extends ArtistLocalDataSource {
  final SqlLocalDataSource sqlLocalDataSource;
  final IdGenerator idGenerator;

  ArtistLocalDataSourceImpl({
    @required this.sqlLocalDataSource,
    @required this.idGenerator,
  });

  @override
  Future<void> addArtist(ArtistModel artistModel) async {
    try {
      return await sqlLocalDataSource.insert(
          ARTISTS_TABLE, artistModel.toMap());
    } on DatabaseException {
      throw OhrwurmDatabaseException('988973');
    }
  }

  @override
  Future<ArtistModel> getArtistFromId(String artistId) async {
    List<Map<String, Object>> artistMapList = await sqlLocalDataSource
        .query(ARTISTS_TABLE, where: '$ID_COLUMN=?', whereArgs: [artistId]);

    if (artistMapList.isNotEmpty)
      return ArtistModel.fromMap(artistMapList.first);
    else
      throw NotInDatabaseException();
  }

  @override
  Future<ArtistModel> getArtistFromName(String artistName) async {
    try {
      final List<Map<String, dynamic>> artists = await sqlLocalDataSource
          .query(ARTISTS_TABLE, where: 'name=?', whereArgs: [artistName]);

      if (artists.isNotEmpty)
        return ArtistModel.fromMap(artists.first);
      else
        throw NotInDatabaseException();
    } on DatabaseException {
      throw OhrwurmDatabaseException();
    }
  }
}
