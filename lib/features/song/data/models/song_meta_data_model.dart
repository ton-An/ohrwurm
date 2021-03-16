import 'dart:typed_data';

import 'package:ohrwurm/features/song/data/models/song_model.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:meta/meta.dart';
import 'package:ohrwurm/features/song/domain/entities/song_meta_data.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

class SongMetaDataModel extends SongMetaData {
  SongMetaDataModel({
    String title,
    List<dynamic> artists,
    String authorName,
    String writerName,
    String albumName,
    String genre,
    int year,
    int trackDuration,
    Uint8List coverArt,
  }) : super(
          title: title,
          artists: artists,
          authorName: authorName,
          writerName: writerName,
          albumName: albumName,
          genre: genre,
          year: year,
          trackDuration: trackDuration,
          coverArt: coverArt,
        );
  factory SongMetaDataModel.fromMetaData(
      Metadata metadata, Uint8List coverArt) {
    return SongMetaDataModel(
      title: metadata.trackName,
      artists: metadata.trackArtistNames,
      authorName: metadata.authorName,
      writerName: metadata.writerName,
      albumName: metadata.albumName,
      genre: metadata.genre,
      year: metadata.year,
      trackDuration: metadata.trackDuration,
      coverArt: coverArt,
    );
  }

  @override
  List<Object> get props => [
        title,
        artists,
        authorName,
        writerName,
        albumName,
        genre,
        year,
        trackDuration,
        coverArt,
      ];
}
