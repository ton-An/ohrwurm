import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_cubit/music_player_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_size_cubit/music_player_size_cubit.dart';
import 'package:ohrwurm/features/song/domain/entities/song.dart';
import 'package:ohrwurm/features/song/presentation/widgets/cd.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final GlobalKey _key = GlobalKey();

  SongTile({Key key, @required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print('asdsadas - $song');
        await BlocProvider.of<MusicPlayerCubit>(context)
            .playSong(song, BlocProvider.of<MusicPlayerSizeCubit>(context));
      },
      borderRadius: standardRadius,
      child: Container(
        key: _key,
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: standardPadding / 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CD(
              radius: 30,
              coverArtPath: song.coverArtPath,
            ),
            SizedBox(
              width: standardPadding,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: Theme.of(context).primaryTextTheme.bodyText1,
                ),
                SizedBox(
                  height: smallPadding,
                ),
                if (song.artists.isNotEmpty)
                  Row(
                    children: [
                      for (Artist artist in song.artists)
                        Text(artist.name,
                            style:
                                Theme.of(context).primaryTextTheme.bodyText2),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class DialogTile extends StatelessWidget {
//   final IconData icon;
//   final String text;

//   DialogTile({
//     Key key,
//     @required this.icon,
//     @required this.text,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Theme.of(context).canvasColor,
//       child: InkWell(
//         borderRadius: standardRadius,
//         onTap: () {
//           print('asddsa');
//         },
//         child: Container(
//           width: 50,
//           height: 50,
//           child: Icon(
//             icon,
//             size: 30,
//           ),
//         ),
//       ),
//     );
//   }
// }

// onLongPress: () {
//         final RenderBox renderBox = _key.currentContext.findRenderObject();
//         double top = renderBox.localToGlobal(Offset(0, 0)).dy;
//         final double screenHeight = MediaQuery.of(context).size.height;
//         if (screenHeight < top + 165)
//           top = top - 100;
//         else
//           top = top + 60;
//         showDialog(
//           context: context,
//           builder: (context) => Stack(children: [
//             Positioned(
//               top: top,
//               left: standardPadding,
//               child: Material(
//                 borderRadius: standardRadius,
//                 child: Container(
//                   width:
//                       MediaQuery.of(context).size.width - standardPadding * 2,
//                   decoration: BoxDecoration(
//                     borderRadius: standardRadius,
//                     color: Colors.white,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: standardPadding, vertical: smallPadding),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         DialogTile(
//                           icon: Icons.queue_music,
//                           text: 'Add to Queue',
//                         ),
//                         DialogTile(
//                           icon: Icons.playlist_add,
//                           text: 'Add to Playlist',
//                         ),
//                         DialogTile(
//                           icon: Icons.favorite_outline,
//                           text: 'Add to Favourites',
//                         ),
//                         DialogTile(
//                           icon: Icons.info_outline,
//                           text: 'Show Info',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ]),
//         );
//       },