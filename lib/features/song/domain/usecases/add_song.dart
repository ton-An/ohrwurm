import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ohrwurm/core/error/failures.dart';
import 'package:ohrwurm/core/usecases/usecase.dart';
import 'package:ohrwurm/core/utils/id_generator.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:ohrwurm/features/artist/domain/usecases/add_artist.dart';
import 'package:ohrwurm/features/song/data/models/song_model.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:meta/meta.dart';
import 'package:ohrwurm/features/song/domain/repositories/song_repository.dart';
import 'package:ohrwurm/features/song/domain/usecases/get_song.dart';

class AddSong extends UseCase<void, AddSongParams> {
  final SongRepository songRepository;
  final GetSong getSong;
  final AddArtist addArtist;
  final IdGenerator idGenerator;

  AddSong({
    @required this.songRepository,
    @required this.getSong,
    @required this.addArtist,
    @required this.idGenerator,
  })  : assert(songRepository != null),
        assert(getSong != null),
        assert(addArtist != null),
        assert(idGenerator != null);

  @override
  Future<Either<Failure, void>> call(AddSongParams params) async {
    final String id = idGenerator();
    final Either<Failure, Song> doesSongIdExistEither =
        await getSong(GetSongsParams(songID: id));

    return doesSongIdExistEither.fold((l) async {
      if (l is NotInDatabaseFailure) {
        final Either<Failure, void> addSongEither =
            await songRepository.addSong(
          SongModel(
            id: id,
            title: params.song.title,
            artists: null,
            authorName: params.song.authorName,
            writerName: params.song.writerName,
            albumName: params.song.albumName,
            genre: params.song.genre,
            year: params.song.year,
            trackDuration: params.song.trackDuration,
            songFilePath: params.song.songFilePath,
            coverArtPath: params.song.coverArtPath,
          ),
        );

        return addSongEither.fold((l) => Left(l), (r) async {
          for (Artist artist in params.song.artists) {
            final addArtistEither =
                await addArtist(AddArtistParams(artistName: artist.name));

            if (addArtistEither.isLeft()) return addArtistEither;
            await songRepository.addToSongsArtistTable(
                id, addArtistEither.getOrElse(() => null));
          }

          return Right(id);
        });
      } else {
        return Left(l);
      }
    }, (r) => call(params));
    // songRepository.addSong(params.song);
  }
}

class AddSongParams extends Equatable {
  final Song song;

  AddSongParams({@required this.song}) : assert(song != null);

  @override
  List<Object> get props => [song];
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
