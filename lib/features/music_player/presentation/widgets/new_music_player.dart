import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_cubit/music_player_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_size_cubit/music_player_size_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_animated_container.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_animated_positioned.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_controls.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_slider.dart';
import 'package:ohrwurm/features/song/presentation/widgets/cd.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> with TickerProviderStateMixin {
  // * General * //
  Size displaySize;
  double paddingTop;

  // * Player General * //
  Size playerSize;
  AnimationController playerSizeChangeController;
  Animation playerSizeChangeAnimation;
  AnimationController rotatingCdController;
  bool disablePlayerBGAnimation;
  MusicPlayerSizeState previousPlayerSizeState;
  bool playerExpandPositionVisible;

  // * Player Sub-Controls * //
  Size playerSubControlsSize;
  Offset playerSubControlsPosition;

  // * Player Controls * //
  Size playerControlsSize;
  Offset playerControlsPosition;

  // * Player Duration * //
  Stream<Duration> songPositionStream;
  Duration songDuration;
  bool isSliderPositionChanging = false;
  double sliderChangePosition;

  Size playerDurationSize;
  Offset playerDurationPosition;
  Size playerDurationSliderSize;

  // * Song Info * //
  Size songInfoSize;
  Offset songInfoPosition;

  // * CD * //
  Size cdContainerSize;
  double cdRadius;
  Offset cdPosition;

  double sliderValue = 2;

  @override
  void initState() {
    super.initState();
    playerSizeChangeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    final Animation<double> curve =
        CurvedAnimation(parent: playerSizeChangeController, curve: Curves.easeInOut);

    rotatingCdController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5000),
    )..repeat();

    playerSizeChangeAnimation = Tween<double>(begin: 0, end: 1).animate(curve);
    playerSizeChangeAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    playerSizeChangeController.dispose();
    rotatingCdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: BlocProvider.of<MusicPlayerSizeCubit>(context).state is MusicPlayerSizeSmall
          ? _toggleSize
          : null,
      child: BlocListener<MusicPlayerCubit, MusicPlayerState>(
        listener: (context, state) => _musicPlayerListener(context, state),
        child: BlocBuilder<MusicPlayerSizeCubit, MusicPlayerSizeState>(
          builder: (context, musicPlayerSizeState) {
            _setDimensions(context, musicPlayerSizeState);
            return MusicPlayerAnimatedContainer(
              height: playerSize.height,
              width: playerSize.width,
              disableAnimation: disablePlayerBGAnimation,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(.2),
                      offset: Offset(0, -12),
                      blurRadius: 10)
                ],
              ),
              child: BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
                builder: (context, state) {
                  if (state is MusicPlayerPlayPauseState) {
                    return StreamBuilder<Object>(
                      stream: songPositionStream,
                      builder: (context, snapshot) {
                        Duration songPosition = snapshot.data;
                        print('=== $songPosition ===');
                        print('=== $songDuration ===');
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Stack(
                            children: [
                              //* Player Duration *//
                              MusicPlayerAnimatedPositioned(
                                left: playerDurationPosition.dx,
                                bottom: playerDurationPosition.dy,
                                child: MusicPlayerAnimatedContainer(
                                  width: playerDurationSize.width,
                                  height: playerDurationSize.height,
                                  child: Column(
                                    children: [
                                      MusicPlayerAnimatedContainer(
                                        width: playerDurationSliderSize.width,
                                        height: playerDurationSliderSize.height,
                                        child: Center(
                                          child: MusicPlayerSlider(
                                            trackHeight: playerSizeChangeAnimation.value * 10 + 5,
                                            trackRadius: playerSizeChangeAnimation.value * 5,
                                            thumbRadius: playerSizeChangeAnimation.value * 13,
                                            songDuration: songDuration == null
                                                ? 0
                                                : ((songDuration.inMilliseconds /
                                                        Duration.millisecondsPerSecond)
                                                    .round()
                                                    .toDouble()),
                                            songPosition: !isSliderPositionChanging
                                                ? (songPosition == null
                                                    ? 0
                                                    : (songPosition.inMilliseconds /
                                                            Duration.millisecondsPerSecond)
                                                        .round()
                                                        .toDouble())
                                                : sliderChangePosition,
                                            onChanged: (value) {
                                              setState(() {
                                                isSliderPositionChanging = true;
                                                sliderChangePosition = value;
                                              });
                                            },
                                            onChangeEnd: (value) {
                                              BlocProvider.of<MusicPlayerCubit>(context)
                                                  .setPositionOfSong(value);
                                              isSliderPositionChanging = false;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(_durationToString(songPosition ?? Duration.zero)),
                                          Text(_durationToString(songDuration ?? Duration.zero))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              //* Player Sub-Controls *//
                              MusicPlayerAnimatedPositioned(
                                bottom: playerSubControlsPosition.dy,
                                left: playerSubControlsPosition.dx,
                                child: MusicPlayerAnimatedContainer(
                                  width: playerSubControlsSize.width,
                                  height: playerSubControlsSize.height,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      PlayerIconButton(icon: Icons.repeat),
                                      PlayerIconButton(icon: Icons.queue_music_outlined),
                                      PlayerIconButton(icon: Icons.shuffle),
                                    ],
                                  ),
                                ),
                              ),

                              // * Song Info * //
                              MusicPlayerAnimatedPositioned(
                                left: songInfoPosition.dx,
                                bottom: songInfoPosition.dy,
                                child: SongInfo(
                                  width: songInfoSize.width,
                                  height: songInfoSize.height,
                                  fontSizeTitle: playerSizeChangeAnimation.value * 24 + 16,
                                  fontSizeArists: playerSizeChangeAnimation.value * 14 + 16,
                                ),
                              ),

                              // * Player Controls *//
                              MusicPlayerAnimatedPositioned(
                                left: playerControlsPosition.dx,
                                bottom: playerControlsPosition.dy,
                                child: MusicPlayerControls(
                                  width: playerControlsSize.width,
                                  height: playerControlsSize.height,
                                ),
                              ),

                              // * CD * //
                              MusicPlayerAnimatedPositioned(
                                left: cdPosition.dx,
                                bottom: cdPosition.dy,
                                child: MusicPlayerAnimatedContainer(
                                  width: cdContainerSize.width,
                                  height: cdContainerSize.height,
                                  child: Center(
                                    child: RotationTransition(
                                      turns: rotatingCdController,
                                      child: CD(
                                        radius: cdRadius,
                                        coverArtPath: state.song.coverArtPath,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                replacement: Container(),
                                visible: playerExpandPositionVisible,
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding:
                                      EdgeInsets.symmetric(vertical: paddingTop, horizontal: 0),
                                  child: PlayerIconButton(
                                    icon: Icons.expand_more,
                                    size: 42,
                                    onPressed: _toggleSize,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _setDimensions(BuildContext context, MusicPlayerSizeState musicPlayerSizeState) {
    // * General * //
    displaySize = MediaQuery.of(context).size;
    paddingTop = MediaQuery.of(context).padding.top;

    if (musicPlayerSizeState is MusicPlayerSizeHidden) {
      // * Player General *//
      playerSize = Size(displaySize.width, 0);
      disablePlayerBGAnimation = false;
      playerExpandPositionVisible = false;

      //* Player Sub-Controls *//
      playerSubControlsSize =
          Size(playerSize.width - kLargePadding * 2 + kIconButtonPadding * 2, 50);
      playerSubControlsPosition =
          Offset(kLargePadding - kIconButtonPadding, -playerSubControlsSize.height);

      //* Player Controls *//
      playerControlsSize = Size(playerSize.height, playerSize.height);
      playerControlsPosition = Offset(kLargePadding, -playerControlsSize.height);

      //* Player Duration *//
      playerDurationSize = Size(playerSize.width, 70);
      playerDurationPosition = Offset(0, 0);
      playerDurationSliderSize = Size(playerDurationSize.width, 5);

      // * CD * //
      cdRadius = 30;
      cdContainerSize = Size(cdRadius * 2, cdRadius * 2);
      cdPosition = Offset(kStandardPadding, (playerSize.height + 5) / 2 - cdRadius);

      // * Song Info * //
      songInfoSize = Size(
          playerSize.width -
              cdRadius * 2 -
              cdPosition.dx -
              kStandardPadding -
              playerControlsSize.width -
              (playerSize.width - playerControlsSize.width - playerControlsPosition.dx),
          playerSize.height);
      songInfoPosition = Offset(kStandardPadding * 2 + cdRadius * 2, 2.5);
    } else if (musicPlayerSizeState is MusicPlayerSizeSmall) {
      // * Player General *//
      playerSize = Size(displaySize.width, 85);
      disablePlayerBGAnimation = false;
      playerExpandPositionVisible = false;

      // Todo: make bg of playbutton transparent when small player and make other two buttons invisible
      //* Player Sub-Controls *//
      playerSubControlsSize =
          Size(playerSize.width - kLargePadding * 2 + kIconButtonPadding * 2, 50);
      playerSubControlsPosition =
          Offset(kLargePadding - kIconButtonPadding, -playerSubControlsSize.height);

      //* Player Controls *//
      playerControlsSize = Size(playerSize.height, playerSize.height);
      playerControlsPosition =
          Offset(displaySize.width - playerControlsSize.width - kSmallPadding, 2.5);

      //* Player Duration *//
      playerDurationSize = Size(playerSize.width, 31);
      playerDurationPosition = Offset(0, -26);
      playerDurationSliderSize = Size(playerDurationSize.width, 5);

      // * CD * //
      cdRadius = 30;
      cdContainerSize = Size(cdRadius * 2, cdRadius * 2);
      cdPosition = Offset(kStandardPadding, (playerSize.height + 5) / 2 - cdRadius);

      // * Song Info * //
      songInfoSize = Size(
          playerSize.width -
              cdRadius * 2 -
              cdPosition.dx -
              kStandardPadding -
              playerControlsSize.width -
              (playerSize.width - playerControlsSize.width - playerControlsPosition.dx),
          playerSize.height - 5);
      songInfoPosition = Offset(kStandardPadding * 2 + cdRadius * 2, 5);
    } else if (musicPlayerSizeState is MusicPlayerSizeLarge) {
      // * General * //
      Orientation orientation = MediaQuery.of(context).orientation;

      // * Player General *//
      playerSize = displaySize;
      disablePlayerBGAnimation = (previousPlayerSizeState is MusicPlayerSizeLarge ? true : false);
      playerExpandPositionVisible = true;

      if (orientation == Orientation.portrait) {
        //* Player Sub-Controls *//
        playerSubControlsSize =
            Size(playerSize.width - kLargePadding * 2 + kIconButtonPadding * 2, 50);
        playerSubControlsPosition = Offset(kLargePadding - kIconButtonPadding, kStandardPadding);

        //* Player Controls *//
        playerControlsSize = Size(playerSize.width - kSmallPadding * 2, 70);
        playerControlsPosition = Offset(kSmallPadding,
            playerSubControlsPosition.dy + playerControlsSize.height + kLargePadding);

        //* Player Duration *//
        playerDurationSize = Size(playerSize.width - kLargePadding * 2, 56);
        playerDurationPosition = Offset(
            kLargePadding, playerControlsPosition.dy + playerControlsSize.height + kLargePadding);
        playerDurationSliderSize = Size(playerDurationSize.width, 30);

        // * Song Info * //
        songInfoSize = Size(playerSize.width - kLargePadding * 2, 106);
        songInfoPosition = Offset(
            kLargePadding, playerDurationPosition.dy + playerDurationSize.height + kLargePadding);

        double restHeight =
            playerSize.height - songInfoPosition.dy - songInfoSize.height - paddingTop;

        // * CD * //
        if (restHeight < playerSize.width - kLargePadding * 2) {
          cdRadius = restHeight / 2;
          cdContainerSize = Size(playerSize.width - kLargePadding * 2, restHeight);
          cdPosition =
              Offset(playerSize.width / 2 - cdRadius, playerSize.height - restHeight - paddingTop);
        } else {
          cdRadius = playerSize.width / 2 - kLargePadding;
          cdContainerSize = Size(playerSize.width - kLargePadding * 2, restHeight);
          cdPosition =
              Offset(playerSize.width / 2 - cdRadius, playerSize.height - restHeight - paddingTop);
        }
      } else if (orientation == Orientation.landscape) {
        double thirdOfHeight = (playerSize.height - paddingTop) / 3;
        //* Player Sub-Controls *//
        playerSubControlsSize =
            Size(playerSize.width / 2 - kLargePadding * 2 + kIconButtonPadding * 2, 50);
        playerSubControlsPosition = Offset(
            playerSize.width / 2 + kLargePadding - kIconButtonPadding,
            thirdOfHeight / 2 - playerSubControlsSize.height / 2);

        //* Player Controls *//
        playerControlsSize = Size(playerSize.width / 2 - kSmallPadding * 2, 70);
        playerControlsPosition = Offset(displaySize.width / 2 + kSmallPadding,
            thirdOfHeight + thirdOfHeight / 2 - playerControlsSize.height / 2);
        playerDurationSliderSize = Size(playerDurationSize.width, 15);

        //* Player Duration *//
        playerDurationSize = Size(playerSize.width / 2 - kLargePadding * 2, 41);
        playerDurationPosition = Offset(playerSize.width / 2 + kLargePadding,
            thirdOfHeight * 2 + thirdOfHeight / 2 - playerDurationSize.height / 2);

        // * Song Info * //
        songInfoSize = Size(playerSize.width / 2 - kLargePadding * 2, 106);
        songInfoPosition = Offset(kLargePadding, kLargePadding);

        double restHeight =
            playerSize.height - songInfoPosition.dy - songInfoSize.height - paddingTop;

        // * CD * //
        if (restHeight < playerSize.width / 2 - kLargePadding * 2) {
          cdRadius = (restHeight - 40) / 2;
          cdContainerSize = Size(playerSize.width / 2 - kLargePadding * 2, restHeight);
          cdPosition = Offset(kLargePadding, playerSize.height - restHeight - paddingTop);
        } else {
          cdRadius = playerSize.width / 2 - kLargePadding * 2;
          cdContainerSize = Size(playerSize.width / 2 - kLargePadding * 2, restHeight);
          cdPosition = Offset(kLargePadding, playerSize.height - restHeight - paddingTop);
        }
      }
    }
    previousPlayerSizeState = musicPlayerSizeState;
  }

  String _durationToString(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes - duration.inHours * Duration.minutesPerHour;
    int seconds =
        ((duration.inMilliseconds - duration.inMinutes * Duration.millisecondsPerMinute) / 1000)
            .round();

    if (minutes > 9 && seconds > 9) {
      if (hours > 0) {
        return '$hours:$minutes:$seconds';
      } else {
        return '$minutes:$seconds';
      }
    } else if (minutes <= 9 && seconds > 9) {
      if (hours > 0) {
        return '$hours:0$minutes:$seconds';
      } else {
        return '0$minutes:$seconds';
      }
    } else if (minutes > 9 && seconds <= 9) {
      if (hours > 0) {
        return '$hours:$minutes:0$seconds';
      } else {
        return '$minutes:0$seconds';
      }
    } else {
      if (hours > 0) {
        return '$hours:0$minutes:0$seconds';
      } else {
        return '0$minutes:0$seconds';
      }
    }
  }

  void _musicPlayerListener(BuildContext context, MusicPlayerState state) {
    if (state is MusicPlayerPlay) {
      rotatingCdController.repeat();

      songDuration = state.duration;
      songPositionStream = state.positionStream;
    } else {
      rotatingCdController.stop();
    }
  }

  void _toggleSize() {
    MusicPlayerSizeCubit cubit = BlocProvider.of<MusicPlayerSizeCubit>(context);
    cubit.toggleMusicPlayerSize();
    if (cubit.state is MusicPlayerSizeSmall) {
      playerSizeChangeController.reverse();
    } else {
      playerSizeChangeController.forward();
    }
  }
}

class PlayerIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Function onPressed;

  const PlayerIconButton({
    Key key,
    @required this.icon,
    this.size = 35,
    @required this.onPressed,
  })  : assert(icon != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: kStandardRadius,
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(kIconButtonPadding),
          child: Icon(
            icon,
            size: size,
          ),
        ),
      ),
    );
  }
}
