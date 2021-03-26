import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_cubit/music_player_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_size_cubit/music_player_size_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_animated_container.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_animated_control_button.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_control_button.dart';

class MusicPlayerControls extends StatefulWidget {
  final double width;
  final double height;

  const MusicPlayerControls({Key key, @required this.width, @required this.height})
      : super(key: key);

  @override
  _MusicPlayerControlsState createState() => _MusicPlayerControlsState();
}

class _MusicPlayerControlsState extends State<MusicPlayerControls> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerSizeCubit, MusicPlayerSizeState>(
      builder: (context, musicPlayerSizeState) {
        return BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
          builder: (context, state) {
            return MusicPlayerAnimatedContainer(
              width: widget.width,
              height: widget.height,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      opacity: musicPlayerSizeState is MusicPlayerSizeLarge ? 1 : 0,
                      child: PlayerControlButton(
                        icon: Icons.skip_previous_rounded,
                        boxShadow: false,
                        onPressed: () => _playSong(state, context),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      opacity: musicPlayerSizeState is MusicPlayerSizeLarge ? 1 : 0,
                      child: PlayerControlButton(
                        icon: Icons.skip_next_rounded,
                        boxShadow: false,
                        onPressed: () => _playSong(state, context),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: PlayerControlButton(
                      icon: state is MusicPlayerPlay ? Icons.add_rounded : Icons.play_arrow_rounded,
                      boxShadow: musicPlayerSizeState is MusicPlayerSizeLarge,
                      color: Theme.of(context).canvasColor,
                      onPressed: () => _playSong(state, context),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _playSong(MusicPlayerState state, BuildContext context) {
    if (state is MusicPlayerPlay) {
      BlocProvider.of<MusicPlayerCubit>(context).pauseSong(state.song);
    } else if (state is MusicPlayerPause) {
      BlocProvider.of<MusicPlayerCubit>(context)
          .playSong(state.song, BlocProvider.of<MusicPlayerSizeCubit>(context));
    }
  }
}
