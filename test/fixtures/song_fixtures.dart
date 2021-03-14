import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/features/artist/data/models/artist_model.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
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
  year: '2016',
  trackDuration: Duration(minutes: 3, seconds: 54),
  songFilePath: 'songFilePath',
  coverArtPath: 'coverArtPath',
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
  year: '2016',
  trackDuration: Duration(minutes: 3, seconds: 54),
  songFilePath: 'songFilePath',
  coverArtPath: 'coverArtPath',
);

Song tSongWitoutArtists = SongModel(
  id: '1234',
  title: 'I Do This (feat. Roze) [Explicit]',
  artists: null,
  authorName: null,
  writerName: null,
  albumName: 'Something to Write Home About',
  genre: 'Rap & Hip-Hop',
  year: '2016',
  trackDuration: Duration(minutes: 3, seconds: 54),
  songFilePath: 'songFilePath',
  coverArtPath: 'coverArtPath',
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
  'year': '2016',
  'trackDuration': 234,
  'songFilePath': 'songFilePath',
  'coverArtPath': 'coverArtPath',
};

const Map<String, dynamic> tSongModelWithoutArtistsMap = {
  'id': '1234',
  'title': 'I Do This (feat. Roze) [Explicit]',
  'authorName': null,
  'writerName': null,
  'albumName': 'Something to Write Home About',
  'genre': 'Rap & Hip-Hop',
  'year': '2016',
  'trackDuration': 234,
  'songFilePath': 'songFilePath',
  'coverArtPath': 'coverArtPath',
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
