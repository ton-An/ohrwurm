import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:ohrwurm/features/song/data/models/song_model.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:meta/meta.dart';

abstract class SongMetaData extends Equatable {
  final String title;
  final List<dynamic> artists;
  final String authorName;
  final String writerName;
  final String albumName;
  final String genre;
  final int year;
  final int trackDuration;
  final Uint8List coverArt;

  SongMetaData({
    @required this.title,
    @required this.artists,
    @required this.authorName,
    @required this.writerName,
    @required this.albumName,
    @required this.genre,
    @required this.year,
    @required this.trackDuration,
    @required this.coverArt,
  });
}
