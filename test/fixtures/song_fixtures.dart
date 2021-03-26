import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/features/artist/data/models/artist_model.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:ohrwurm/features/song/data/models/song_meta_data_model.dart';
import 'package:ohrwurm/features/song/data/models/song_model.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';

import 'artist_fixtures.dart';

final SongModel tSongModel = SongModel(
  id: '1234',
  title: 'I Do This (feat. Roze) [Explicit]',
  artists: [
    ArtistModel(id: '321', name: 'Abstract'),
    ArtistModel(id: '4321', name: 'RoZe'),
  ],
  authorName: null,
  writerName: null,
  albumName: 'Something to Write Home About',
  genre: 'Rap & Hip-Hop',
  year: 2016,
  trackDuration: Duration(minutes: 3, seconds: 54),
  songFilePath: 'songFilePath',
  coverArtPath: tCoverArtPath,
);

final SongModel tSongModel2 = SongModel(
  id: '12345',
  title: 'Im Good (feat. Roze & Drumma Battalion)',
  artists: [
    ArtistModel(id: '321', name: 'Abstract'),
    ArtistModel(id: '4321', name: 'RoZe'),
    ArtistModel(id: '54321', name: 'Drumma Battalion'),
  ],
  authorName: null,
  writerName: null,
  albumName: null,
  genre: 'Rap & Hip-Hop',
  year: 2014,
  trackDuration: Duration(minutes: 3, seconds: 32),
  songFilePath: 'songFilePath',
  coverArtPath: tCoverArtPath,
);

Song tSong = SongModel(
  id: '1234',
  title: 'I Do This (feat. Roze) [Explicit]',
  artists: [
    ArtistModel(id: '321', name: 'Abstract'),
    ArtistModel(id: '4321', name: 'RoZe'),
  ],
  authorName: null,
  writerName: null,
  albumName: 'Something to Write Home About',
  genre: 'Rap & Hip-Hop',
  year: 2016,
  trackDuration: Duration(minutes: 3, seconds: 54),
  songFilePath: 'songFilePath',
  coverArtPath: tCoverArtPath,
);

Song tSongWitoutArtists = SongModel(
  id: '1234',
  title: 'I Do This (feat. Roze) [Explicit]',
  artists: null,
  authorName: null,
  writerName: null,
  albumName: 'Something to Write Home About',
  genre: 'Rap & Hip-Hop',
  year: 2016,
  trackDuration: Duration(minutes: 3, seconds: 54),
  songFilePath: 'songFilePath',
  coverArtPath: tCoverArtPath,
);

const Map<String, dynamic> tSongModelMap = {
  'id': '1234',
  'title': 'I Do This (feat. Roze) [Explicit]',
  'artists': [
    {'id': '321', 'name': 'Abstract'},
    {'id': '4321', 'name': 'RoZe'},
  ],
  'authorName': null,
  'writerName': null,
  'albumName': 'Something to Write Home About',
  'genre': 'Rap & Hip-Hop',
  'year': 2016,
  'trackDuration': 234,
  'songFilePath': 'songFilePath',
  'coverArtPath': tCoverArtPath,
};

const Map<String, dynamic> tSongModelWithoutArtistsMap = {
  'id': '1234',
  'title': 'I Do This (feat. Roze) [Explicit]',
  'authorName': null,
  'writerName': null,
  'albumName': 'Something to Write Home About',
  'genre': 'Rap & Hip-Hop',
  'year': 2016,
  'trackDuration': 234,
  'songFilePath': 'songFilePath',
  'coverArtPath': tCoverArtPath,
};

const String tSongId = '1234';

const List<Map<String, String>> tSongsArtistsList = [
  {'songId': '1234', 'artistId': '321'},
  {'songId': '1234', 'artistId': '4321'},
];

final UnidentifiableFailure tUnidentifiableFailure = UnidentifiableFailure('');

final Map<String, String> tSongsArtist = {
  'songId': tSongId,
  'artistId': tArtistId,
};

final File tSongFile = File('songFilePath');

final Directory tDirectory = Directory('directoryPath');

final Metadata tMetadata = Metadata(
  albumName: tSong.albumName,
  authorName: tSong.authorName,
  genre: tSong.genre,
  trackArtistNames: ['Abstract', 'RoZe'],
  trackDuration: tSong.trackDuration.inSeconds,
  trackName: tSong.title,
  writerName: tSong.writerName,
  year: tSong.year,
);

final Uint8List tCoverArt = Uint8List(1);

final SongMetaDataModel tSongMetaDataModel = SongMetaDataModel(
  title: 'I Do This (feat. Roze) [Explicit]',
  artists: ['Abstract', 'RoZe'],
  authorName: null,
  writerName: null,
  albumName: 'Something to Write Home About',
  genre: 'Rap & Hip-Hop',
  year: 2016,
  trackDuration: 234,
  coverArt: tCoverArt,
);

const String tAppPath =
    'C:/Users/ton-A/OneDrive/Desktop/flutter_projects/ohrwurm/test';

const String tCoverArtPath =
    'C:/Users/ton-A/OneDrive/Desktop/flutter_projects/ohrwurm/test/coverArt/1234.jpg';

const int tSongPage = 1;

const List<String> tSongIdList = ['1234', '12345'];

final List<Song> tSongModelList = [tSongModel, tSongModel2];

final List<Map<String, dynamic>> tSongIdMapList = [
  {'id': '1234'},
  {'id': '12345'}
];

String tSongSampleFilePath =
    'C:/Users/ton-A/OneDrive/Desktop/flutter_projects/ohrwurm/test/song_files/i_do_this.mp3';
