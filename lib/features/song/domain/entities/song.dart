import 'package:equatable/equatable.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:meta/meta.dart';

abstract class Song extends Equatable {
  final String id;
  final String title;
  final List<Artist> artists;
  final String authorName;
  final String writerName;
  final String albumName;
  final String genre;
  final String year;
  final Duration trackDuration;
  final String songFilePath;
  final String coverArtPath;

  Song({
    @required this.id,
    @required this.title,
    @required this.artists,
    @required this.authorName,
    @required this.writerName,
    @required this.albumName,
    @required this.genre,
    @required this.year,
    @required this.trackDuration,
    @required this.songFilePath,
    @required this.coverArtPath,
  })  : assert(id != null),
        assert(title != null),
        assert(songFilePath != null);

  @override
  List<Object> get props => [
        id,
        title,
        artists,
        authorName,
        writerName,
        albumName,
        genre,
        year,
        trackDuration,
        songFilePath,
        coverArtPath,
      ];
}
