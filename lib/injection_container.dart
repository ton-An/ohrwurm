import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get_it/get_it.dart';
import 'package:ohrwurm/core/utils/app_paths.dart';
import 'package:ohrwurm/core/utils/id_generator.dart';
import 'package:ohrwurm/features/artist/data/datasources/artist_local_data_source.dart';
import 'package:ohrwurm/features/artist/data/repositories_impl/artist_repository_impl.dart';
import 'package:ohrwurm/features/artist/domain/repositories/artist_repository.dart';
import 'package:ohrwurm/features/artist/domain/usecases/add_artist.dart';
import 'package:ohrwurm/features/artist/domain/usecases/get_artist.dart';
import 'package:ohrwurm/features/home/presentation/cubit/home_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_cubit/music_player_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_size_cubit/music_player_size_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player.dart';
import 'package:ohrwurm/features/song/data/datasources/song_local_data_source.dart';
import 'package:ohrwurm/features/song/data/repositories_impl/song_repository_impl.dart';
import 'package:ohrwurm/features/song/domain/repositories/song_repository.dart';
import 'package:ohrwurm/features/song/domain/usecases/add_song.dart';
import 'package:ohrwurm/features/song/domain/usecases/get_song.dart';
import 'package:ohrwurm/features/song/domain/usecases/get_song_list.dart';
import 'package:ohrwurm/features/song/domain/usecases/scan_directory_for_songs.dart';
import 'package:ohrwurm/features/song/presentation/cubit/songs_cubit.dart';
import 'package:ohrwurm/features/sql/data/datasources/sql_local_data_source.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

final sl = GetIt.instance;

Future<void> init() async {
  String databasesPath = await getDatabasesPath();
  String ohrwurmDbPath = '$databasesPath/orhwurm.db';

  Database db = await openDatabase(ohrwurmDbPath, version: 1, onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE Songs (id STRING PRIMARY KEY, title STRING, authorName STRING, writerName STRING, albumId STRING, genreId STRING, year INTEGER, trackDuration INTEGER, songFilePath STRING, coverArtPath STRING, isActive BOOL, FOREIGN KEY(albumId) REFERENCES Albums(id), FOREIGN KEY(genreId) REFERENCES Genres(id))');
    await db.execute('CREATE TABLE Artists (id STRING PRIMARY KEY, name STRING)');
    await db.execute(
        'CREATE TABLE SongsArtists (songId STRING, artistId STRING, FOREIGN KEY(songId) REFERENCES Songs(id), FOREIGN KEY(artistId) REFERENCES Artists(id))');
  });

  // await db.delete('Songs');
  // await db.delete('SongsArtists');
  // await db.delete('Artists');

  // await db.execute(
  //     'CREATE TABLE Songs (id STRING PRIMARY KEY, title STRING, authorName STRING, writerName STRING, albumId STRING, genreId STRING, year INTEGER, trackDuration INTEGER, songFilePath STRING, coverArtPath STRING, isActive BOOL, FOREIGN KEY(albumId) REFERENCES Albums(id), FOREIGN KEY(genreId) REFERENCES Genres(id))');
  // await db.execute('CREATE TABLE Artists (id STRING PRIMARY KEY, name STRING)');
  // await db.execute(
  //     'CREATE TABLE SongsArtists (songId STRING, artistId STRING, FOREIGN KEY(songId) REFERENCES Songs(id), FOREIGN KEY(artistId) REFERENCES Artists(id))');

  //! Features !//

  //* Home
  sl.registerFactory(() => HomeCubit());

  //* Music Player
  sl.registerFactory(() => MusicPlayerCubit(audioPlayer: sl()));

  sl.registerFactory(() => MusicPlayerSizeCubit());

  //* Song
  sl.registerFactory(() => SongsCubit(getSongListUseCase: sl()));

  sl.registerLazySingleton(() => ScanDirectoryForSongs(addSong: sl(), songRepository: sl()));

  sl.registerLazySingleton(() => AddSong(
        songRepository: sl(),
        getSong: sl(),
        addArtist: sl(),
        idGenerator: sl(),
        appPaths: sl(),
      ));

  sl.registerLazySingleton(() => GetSong(songRepository: sl()));
  sl.registerLazySingleton(() => GetSongList(songRepository: sl(), getSong: sl()));

  sl.registerLazySingleton<SongRepository>(() => SongRepositoryImpl(songLocalDataSource: sl()));

  sl.registerLazySingleton<SongLocalDataSource>(() => SongLocalDataSourceImpl(
        sqlLocalDataSource: sl(),
        artistLocalDataSource: sl(),
        idGenerator: sl(),
        metadataRetriever: sl(),
      ));

  // * Artist
  sl.registerLazySingleton(() => AddArtist(
        artistRepository: sl(),
        getArtist: sl(),
        idGenerator: sl(),
      ));
  sl.registerLazySingleton(() => GetArtist(artistRepository: sl()));

  sl.registerLazySingleton<ArtistRepository>(() => ArtistRepositoryImpl(artistLocalDataSource: sl()));

  sl.registerLazySingleton<ArtistLocalDataSource>(
    () => ArtistLocalDataSourceImpl(sqlLocalDataSource: sl(), idGenerator: sl()),
  );

  //! Core !//
  sl.registerLazySingleton(() => IdGenerator(uuid: sl()));
  sl.registerLazySingleton(() => AppPaths());
  sl.registerLazySingleton<SqlLocalDataSource>(() => SqlLocalDataSourceImpl(db: db));

  //! External !//
  sl.registerLazySingleton(() => MetadataRetriever());
  sl.registerLazySingleton(() => Uuid());
  sl.registerLazySingleton(() => AudioPlayer());
}
