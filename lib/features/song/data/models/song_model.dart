import 'package:ohrwurm/features/artist/data/models/artist_model.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';

class SongModel extends Song {
  SongModel({
    String id,
    String title,
    List<Artist> artists,
    String authorName,
    String writerName,
    String albumName,
    String genre,
    int year,
    Duration trackDuration,
    String songFilePath,
    String coverArtPath,
  })  : assert(title != null),
        assert(songFilePath != null),
        super(
          id: id,
          title: title,
          artists: artists,
          authorName: authorName,
          writerName: writerName,
          albumName: albumName,
          genre: genre,
          year: year,
          trackDuration: trackDuration,
          songFilePath: songFilePath,
          coverArtPath: coverArtPath,
        );

  /// Converts a Map to a [SongModel]
  factory SongModel.fromMap(Map<String, dynamic> songMap) {
    List<ArtistModel> artists = songMap['artists']
        .map<ArtistModel>(
            (Map<String, dynamic> artistMap) => ArtistModel.fromMap(artistMap))
        .toList();

    return SongModel(
      id: songMap['id'],
      title: songMap['title'].toString(),
      artists: artists,
      authorName: songMap['authorName'],
      writerName: songMap['writerName'],
      albumName: songMap['albumName'],
      genre: songMap['genre'],
      year: songMap['year'],
      trackDuration: Duration(seconds: songMap['trackDuration'].round()),
      songFilePath: songMap['songFilePath'],
      coverArtPath: songMap['coverArtPath'],
    );
  }

  /// Converts a [SongModel] to a Map
  Map<String, dynamic> toMap() {
    print(super.albumName);

    return {
      'id': super.id,
      'title': super.title,
      'artists': super.artists == null
          ? null
          : super
              .artists
              .map((Artist artist) => {'id': artist.id, 'name': artist.name})
              .toList(),
      'authorName': super.authorName,
      'writerName': super.writerName,
      'albumName': super.albumName,
      'genre': super.genre,
      'year': super.year,
      'trackDuration': super.trackDuration.inSeconds,
      'songFilePath': super.songFilePath,
      'coverArtPath': super.coverArtPath,
    };
  }
}
