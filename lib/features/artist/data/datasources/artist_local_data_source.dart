import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/core/error/exceptions.dart';
import 'package:ohrwurm/core/utils/id_generator.dart';
import 'package:ohrwurm/features/artist/data/models/artist_model.dart';
import 'package:ohrwurm/features/sql/data/datasources/sql_local_data_source.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

const ARTISTS_TABLE = 'Artists';

abstract class ArtistLocalDataSource {
  /// Gets an [Artist] from the Artists table in the SQL database
  ///
  /// Throws a [OhrwurmDatabaseException] if the database can't be accessed and a [NotInDatabaseException] if song can't be found
  Future<ArtistModel> getArtist(String artistId);

  /// Adds an [Artist] to the Artists table in the SQL database
  ///
  /// Throws a [OhrwurmDatabaseException] if the database can't be accessed
  Future<String> addArtist(ArtistModel artistModel);
}

class ArtistLocalDataSourceImpl extends ArtistLocalDataSource {
  final SqlLocalDataSource sqlLocalDataSource;
  final IdGenerator idGenerator;

  ArtistLocalDataSourceImpl({
    @required this.sqlLocalDataSource,
    @required this.idGenerator,
  });

  @override
  Future<String> addArtist(ArtistModel artistModel) async {
    List<Map<String, dynamic>> artistList = await sqlLocalDataSource.query(
        ARTISTS_TABLE,
        where: '$ID_COLUMN=?',
        whereArgs: [artistModel.name]);
    // return await getArtistId(artistModel.name);

    if (artistList.isEmpty) {
      String id = idGenerator();
      try {
        await getArtist(id);
        return addArtist(artistModel);
      } on NotInDatabaseException {
        Map<String, String> artistModelMap = artistModel.toMap();
        artistModelMap.update('id', (value) => id);
        await sqlLocalDataSource.insert(ARTISTS_TABLE, artistModelMap);
      }
    } else {
      return artistList.first['id'];
    }
  }

  @override
  Future<ArtistModel> getArtist(String artistId) async {
    List<Map<String, Object>> artistMapList = await sqlLocalDataSource
        .query(ARTISTS_TABLE, where: '$ARTISTS_TABLE=?', whereArgs: [artistId]);

    if (artistMapList.isNotEmpty)
      return ArtistModel.fromMap(artistMapList.first);
    else
      throw NotInDatabaseException();
  }
}
