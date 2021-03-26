import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/core/usecases/usecase.dart';
import 'package:ohrwurm/core/utils/app_paths.dart';
import 'package:ohrwurm/core/utils/id_generator.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:ohrwurm/features/artist/domain/usecases/add_artist.dart';
import 'package:ohrwurm/features/song/data/models/song_meta_data_model.dart';
import 'package:ohrwurm/features/song/data/models/song_model.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:meta/meta.dart';
import 'package:ohrwurm/features/song/domain/entities/song_meta_data.dart';
import 'package:ohrwurm/features/song/domain/repositories/song_repository.dart';
import 'package:ohrwurm/features/song/domain/usecases/get_song.dart';

class AddSong extends UseCase<void, AddSongParams> {
  final SongRepository songRepository;
  final GetSong getSong;
  final AddArtist addArtist;
  final IdGenerator idGenerator;
  final AppPaths appPaths;

  AddSong({
    @required this.songRepository,
    @required this.getSong,
    @required this.addArtist,
    @required this.idGenerator,
    @required this.appPaths,
  })  : assert(songRepository != null),
        assert(getSong != null),
        assert(addArtist != null),
        assert(idGenerator != null);

  @override
  Future<Either<Failure, void>> call(AddSongParams params) async {
    Either<Failure, Song> getSongFromFilePathEither = await songRepository.getSongFromFilePath(params.songFile.path);

    return getSongFromFilePathEither.fold((l) async {
      if (l is NotInDatabaseFailure) {
        Either<Failure, SongMetaData> songMetaDataEither = await songRepository.getSongMetaData(params.songFile);
        return songMetaDataEither.fold((l) {
          print('AddSong - $l');
          return Left(l);
        }, (r) async {
          SongMetaDataModel songMetaDataModel = r;
          print(params.songFile.path);
          final String id = idGenerator();
          final Either<Failure, Song> doesSongIdExistEither = await getSong(GetSongParams(songID: id));

          return doesSongIdExistEither.fold((l) async {
            if (l is NotInDatabaseFailure) {
              String appDirectoryPath = await appPaths.getAppDocumentsDirectoryPath();

              if (!await Directory('$appDirectoryPath/coverArt/').exists()) {
                Directory('$appDirectoryPath/coverArt/').create();
              }
              String coverArtPath = '$appDirectoryPath/coverArt/$id.jpg';
              (await File(coverArtPath).create()).writeAsBytesSync(songMetaDataModel.coverArt);

              final Either<Failure, void> addSongEither = await songRepository.addSong(
                SongModel(
                  id: id,
                  title: songMetaDataModel.title,
                  artists: null,
                  authorName: songMetaDataModel.authorName,
                  writerName: songMetaDataModel.writerName,
                  albumName: songMetaDataModel.albumName,
                  genre: songMetaDataModel.genre,
                  year: songMetaDataModel.year,
                  trackDuration: Duration(milliseconds: songMetaDataModel.trackDuration),
                  songFilePath: params.songFile.path,
                  coverArtPath: coverArtPath,
                ),
              );

              return addSongEither.fold((l) => Left(l), (r) async {
                print(4);

                for (String artistName in songMetaDataModel.artists) {
                  print(artistName);
                  final addArtistEither = await addArtist(AddArtistParams(artistName: artistName));
                  print(addArtistEither);
                  // if (addArtistEither.isLeft()) return addArtistEither;
                  bool failed = false;
                  addArtistEither.fold((l) async {
                    if (l is ArtistAlreadyExistsFailure)
                      await songRepository.addToSongsArtistTable(id, l.artistId);
                    else
                      failed = true;
                  }, (r) async {
                    print(r);
                    await songRepository.addToSongsArtistTable(id, r);
                  });

                  if (failed == true) return addArtistEither;
                }
                print('message ${l.message}');

                return Right(id);
              });
            } else {
              print('message ${l.message}');
              return Left(l);
            }
          }, (r) => call(params));
        });
      } else {
        return Left(l);
      }
    }, (r) => Left(SongAlreadyExistsFailure(message: '421', songId: r.id)));
  }
}

class AddSongParams extends Equatable {
  final File songFile;

  AddSongParams({@required this.songFile}) : assert(songFile != null);

  @override
  List<Object> get props => [songFile];
}

  // should generate a song id using the [IdGenerator]
  // should insert the song model map (without artists) into the songs table
  // should add artist
  // should add song and it\'s artists to the SongsArtists table
  // should return the songId

// final String songId = idGenerator();

//     try {
//       await getSong(songId);
//       return addSong(song);
//     } on NotInDatabaseException {
//       songMapWithoutArtists.update('id', (value) => songId);

//       await sqlLocalDataSource.insert(SONG_TABLE, songMapWithoutArtists);

//       List<Artist> artistList = song.artists;

//       for (Artist artist in artistList) {
//         // String artistId = await artistLocalDataSource.addArtist(artist);

//         await sqlLocalDataSource.insert(
//             SONGS_ARTISTS_TABLE, {'artistId': 'artistId', 'songId': song.id});
//       }
//     }
//     return songId;
