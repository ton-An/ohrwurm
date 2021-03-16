import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_animated_positioned.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_cubit/music_player_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_size_cubit/music_player_size_cubit.dart';
import 'package:ohrwurm/features/song/presentation/widgets/cd.dart';

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<MusicPlayerSizeCubit>(context).toggleMusicPlayerSize();
      },
      child: BlocBuilder<MusicPlayerSizeCubit, MusicPlayerSizeState>(
        builder: (context, musicPlayerSizeState) {
          double displayHeight = MediaQuery.of(context).size.height;
          double displayWidth = MediaQuery.of(context).size.width;

          double cdRadius = 0;
          double cdBottom = 0;
          double playerHeight = 60;
          if (musicPlayerSizeState is MusicPlayerSizeLarge) {
            cdRadius = 150;
            cdBottom = displayHeight - 400;
            playerHeight = displayHeight;
          }
          return AnimatedContainer(
            height: playerHeight,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).canvasColor,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
              builder: (context, state) {
                if (state is MusicPlayerPlayPauseState) {
                  return Stack(
                    children: [
                      MusicPlayerAnimatedPositioned(
                        left: 0,
                        bottom: cdBottom,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          height: cdRadius * 2,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: CD(
                              radius: cdRadius,
                              coverArtPath: state.song.coverArtPath,
                            ),
                          ),
                        ),
                      ),
                      MusicPlayerAnimatedPositioned(
                        left: 20,
                        top: 20,
                        child: Text(
                          state.song.title,
                          style: Theme.of(context).primaryTextTheme.bodyText1,
                        ),
                      ),
                      MusicPlayerAnimatedPositioned(
                        right: musicPlayerSizeState is MusicPlayerSizeLarge
                            ? displayWidth / 2 - 35
                            : standardPadding,
                        bottom: musicPlayerSizeState is MusicPlayerSizeLarge
                            ? 200
                            : playerHeight / 2 - 35,
                        child: MaterialButton(
                          height: 70,
                          minWidth: 70,
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          color: musicPlayerSizeState is MusicPlayerSizeLarge
                              ? Theme.of(context).canvasColor
                              : null,
                          onPressed: () {
                            BlocProvider.of<MusicPlayerCubit>(context)
                                .pauseSong(state.song);
                          },
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: 50,
                          ),
                        ),
                      )
                    ],
                  );
                }
                return Container();
              },
            ),
          );
        },
      ),
    );
  }
}
