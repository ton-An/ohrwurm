import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:ohrwurm/core/constants.dart';
import 'package:ohrwurm/features/artist/domain/entities/artist.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_animated_container.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_animated_positioned.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_cubit/music_player_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/cubit/music_player_size_cubit/music_player_size_cubit.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_controls.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_slider.dart';
import 'package:ohrwurm/features/song/presentation/widgets/cd.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> with TickerProviderStateMixin {
  AnimationController musicPlayerOpenCloseController;
  Animation musicPlayerOpenCloseAnimation;
  AnimationController rotatingCdController;

  Stream<Duration> songPositionStream;
  Duration songDuration;
  bool isSliderChanging = false;
  double sliderChangePosition;

  Size displaySize;

  // * Player General *//
  double playerHeight;
  double playerContainerHeight;

  //* CD *//
  double cdRadius;
  double cdTop;
  double cdContainerWidth;

  //* Player Main Controls *//
  double playerControlsHeight;
  double playerControlsWidth;
  double playerControlsRight;
  double playerControlsTop;

  //* Song Info *//
  double songInfoWidth;
  double songInfoHeight;
  double songInfoLeft;
  double songInfoTop;

  //* Player Sub Controls *//
  double musicPlayerDurationTop;
  double musicPlayerDurationLeft;
  double musicPlayerDurationWidth;
  double musicPlayerDurationSliderHeight;
  double musicPlayerDurationSliderRadius;

  @override
  void initState() {
    super.initState();
    musicPlayerOpenCloseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    rotatingCdController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5000),
    )..repeat();

    // sliderHeightAnimation =
    //     CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

    musicPlayerOpenCloseAnimation =
        Tween<double>(begin: 0, end: 1).animate(musicPlayerOpenCloseController);
    musicPlayerOpenCloseAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    musicPlayerOpenCloseController.dispose();
    rotatingCdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // ignore: close_sinks
        MusicPlayerSizeCubit cubit = BlocProvider.of<MusicPlayerSizeCubit>(context);
        cubit.toggleMusicPlayerSize();
        if (cubit.state is MusicPlayerSizeSmall)
          musicPlayerOpenCloseController.reverse();
        else
          musicPlayerOpenCloseController.forward();
      },
      child: BlocListener<MusicPlayerCubit, MusicPlayerState>(
        listener: (context, state) {
          print(state);
          if (state is MusicPlayerPlay) {
            rotatingCdController.repeat();
            songDuration = state.duration;
            songPositionStream = state.positionStream;
          } else
            rotatingCdController.stop();
        },
        child: BlocBuilder<MusicPlayerSizeCubit, MusicPlayerSizeState>(
          builder: (context, musicPlayerSizeState) {
            _setDimensions(context, musicPlayerSizeState);

            return MusicPlayerAnimatedContainer(
              height: playerContainerHeight,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).canvasColor,
              child: BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
                builder: (context, state) {
                  if (state is MusicPlayerPlayPauseState) {
                    return StreamBuilder<Object>(
                        stream: songPositionStream,
                        builder: (context, snapshot) {
                          Duration songPosition = snapshot.data;
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: Stack(
                              children: [
                                MusicPlayerAnimatedPositioned(
                                  top: musicPlayerDurationTop,
                                  left: musicPlayerDurationLeft,
                                  child: MusicPlayerAnimatedContainer(
                                    width: musicPlayerDurationWidth,
                                    child: Column(
                                      children: [
                                        MusicPlayerSlider(
                                          trackHeight: musicPlayerOpenCloseAnimation.value * 10 + 5,
                                          trackRadius: musicPlayerOpenCloseAnimation.value * 5,
                                          songDuration: songDuration == null
                                              ? 0
                                              : (songDuration.inMilliseconds.toDouble() -
                                                  songDuration.inHours.toDouble() *
                                                      Duration.millisecondsPerHour),
                                          songPosition: !isSliderChanging
                                              ? (songPosition == null
                                                  ? 0
                                                  : songPosition.inMilliseconds.toDouble())
                                              : sliderChangePosition,
                                        ),
                                        if (songPosition != null && songDuration != null)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(_durationToString(songPosition)),
                                              Text(_durationToString(songDuration))
                                            ],
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: MusicPlayerAnimatedContainer(
                                    height: playerHeight,
                                    child: Stack(
                                      children: [
                                        MusicPlayerAnimatedPositioned(
                                          left: 0,
                                          top: cdTop,
                                          child: MusicPlayerAnimatedContainer(
                                            height: cdRadius * 2,
                                            width: cdContainerWidth,
                                            child: Center(
                                              child: RotationTransition(
                                                turns: rotatingCdController,
                                                alignment: Alignment.center,
                                                child: CD(
                                                  radius: cdRadius,
                                                  coverArtPath: state.song.coverArtPath,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        MusicPlayerAnimatedPositioned(
                                          left: songInfoLeft,
                                          top: songInfoTop,
                                          child: SongInfo(
                                            width: songInfoWidth,
                                            height: songInfoHeight,
                                            fontSizeTitle:
                                                musicPlayerOpenCloseAnimation.value * 24 + 16,
                                            fontSizeArists:
                                                musicPlayerOpenCloseAnimation.value * 14 + 16,
                                          ),
                                        ),
                                        MusicPlayerAnimatedPositioned(
                                          right: playerControlsRight,
                                          top: playerControlsTop,
                                          child: MusicPlayerControls(
                                            width: playerControlsWidth,
                                            height: playerControlsHeight,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
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
    displaySize = MediaQuery.of(context).size;

    // * Player General *//
    playerHeight = 70;
    playerContainerHeight = playerHeight + 5;

    //* CD *//
    cdRadius = 30;
    cdTop = playerHeight / 2 - cdRadius;
    cdContainerWidth = 100;

    //* Player Main Controls *//
    playerControlsHeight = playerHeight;
    playerControlsWidth = playerHeight;
    playerControlsRight = kSmallPadding;
    playerControlsTop = 0;

    //* Song Info *//
    songInfoWidth = displaySize.width - cdRadius * 2 - kStandardPadding * 4 - 70;
    songInfoHeight = playerHeight;
    songInfoLeft = cdRadius * 2 + kStandardPadding * 2;
    songInfoTop = 0;

    //* Player Sub Controls *//
    musicPlayerDurationTop = playerContainerHeight;
    musicPlayerDurationLeft = 0;
    musicPlayerDurationWidth = displaySize.width;
    musicPlayerDurationSliderHeight = playerControlsTop;
    musicPlayerDurationSliderRadius = 0;

    //* Song Duration *//

    if (musicPlayerSizeState is MusicPlayerSizeLarge) {
      playerHeight = displaySize.height;
      playerContainerHeight = playerHeight;

      cdContainerWidth = displaySize.width;
      cdRadius = 170;
      cdTop = 50;

      songInfoWidth = displaySize.width - kLargePadding * 2;
      songInfoHeight = 200;
      songInfoLeft = kLargePadding;
      songInfoTop = 400;
      musicPlayerDurationTop = songInfoTop + songInfoHeight + kStandardPadding;
      musicPlayerDurationLeft = kLargePadding;
      musicPlayerDurationWidth = displaySize.width - kLargePadding * 2;
      musicPlayerDurationSliderHeight = 15;
      musicPlayerDurationSliderRadius = 10;
      playerControlsHeight = 70;

      playerControlsWidth = displaySize.width - kLargePadding * 2;
      playerControlsRight = kLargePadding;
      playerControlsTop = musicPlayerDurationTop + kLargePadding;
      if (MediaQuery.of(context).orientation == Orientation.landscape) {
        cdTop = displaySize.height / 2 - cdRadius;
        cdContainerWidth = MediaQuery.of(context).size.width / 2;

        songInfoWidth = displaySize.width / 2;
        songInfoLeft = displaySize.width / 2;
        songInfoTop = 50;
      }
    }
  }

  String _durationToString(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes - duration.inHours * Duration.minutesPerHour;
    int seconds = duration.inSeconds - duration.inMinutes * Duration.secondsPerMinute;

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
}

class SongInfo extends StatelessWidget {
  const SongInfo({
    Key key,
    @required this.width,
    @required this.height,
    @required this.fontSizeTitle,
    @required this.fontSizeArists,
  }) : super(key: key);

  final double width;
  final double height;
  final double fontSizeTitle;
  final double fontSizeArists;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
      builder: (context, state) {
        if (state is MusicPlayerPlayPauseState)
          return MusicPlayerAnimatedContainer(
            width: width,
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MarqueeText(
                  text: state.song.title + '          ',
                  speed: 25,
                  style: Theme.of(context)
                      .primaryTextTheme
                      .headline1
                      .copyWith(fontSize: fontSizeTitle),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (Artist artist in state.song.artists)
                      Text(
                        artist.name,
                        style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                              fontSize: fontSizeArists,
                            ),
                      ),
                  ],
                ),
              ],
            ),
          );
        return null;
      },
    );
  }
}
