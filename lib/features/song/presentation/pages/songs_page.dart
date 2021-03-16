import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:ohrwurm/features/song/domain/usecases/add_song.dart';
import 'package:ohrwurm/features/song/domain/usecases/scan_directory_for_songs.dart';
import 'package:ohrwurm/features/song/presentation/cubit/songs_cubit.dart';
import 'package:ohrwurm/features/song/presentation/widgets/song_tile.dart';
import 'package:ohrwurm/injection_container.dart';
import 'package:path_provider/path_provider.dart';

class SongsPage extends StatefulWidget {
  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  ScrollController _scrollController = new ScrollController();
  int page = 0;
  List<Song> songs = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SongsCubit>(context).getSongList(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        BlocProvider.of<SongsCubit>(context).getSongList(page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<SongsCubit>(context).getSongList(page);
              },
              child: Text('Get Song'),
            ),
            ElevatedButton(
              onPressed: () async {
                String storagePath = (await getExternalStorageDirectory()).path;
                File songFile =
                    File('storage/emulated/0/Music/So Much Love.mp3');
                print('sdsdas');
                sl<AddSong>()(AddSongParams(songFile: songFile));
              },
              child: Text('Add Song'),
            ),
            ElevatedButton(
              onPressed: () {
                print('asd');
                sl<ScanDirectoryForSongs>()(ScanDirectoryForSongsParams(
                    directory: Directory('storage/emulated/0/Music')));
              },
              child: Text('Scan For Song'),
            ),
          ],
        ),
        Expanded(
          child: BlocConsumer<SongsCubit, SongsState>(
            listener: (context, state) {
              if (state is SongsLoaded) {
                setState(() {
                  songs.addAll(state.songs);
                });
              }
            },
            builder: (context, state) {
              if (state is SongsLoading && songs.isEmpty)
                return Center(
                  child: CircularProgressIndicator(),
                );

              if (state is SongsLoaded || (state is SongsLoading && page > 0)) {
                return Center(
                  child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: standardPadding / 2,
                      ),
                      child: SongTile(song: songs[index]),
                    ),
                    controller: _scrollController,
                  ),
                );
              }
              if (state is SongsError)
                return Center(
                  child: Text('${state.message}'),
                );
              return Center(
                child: Text('JUST DO IT!'),
              );
            },
          ),
        ),
      ],
    );
  }
}
