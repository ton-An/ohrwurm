import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_animated_container.dart';

class PlayerAnimatedControlButton extends StatelessWidget {
  final bool boxShadow;
  final AnimatedIconData icon;
  final Color color;
  final AnimationController animationController;

  final Function onPressed;
  const PlayerAnimatedControlButton({
    Key key,
    @required this.boxShadow,
    @required this.icon,
    @required this.animationController,
    this.color = Colors.transparent,
    @required this.onPressed,
  }) : super(key: key);

  final double radius = 35;

  @override
  Widget build(BuildContext context) {
    return MusicPlayerAnimatedContainer(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: boxShadow ? 1 : 0,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radius),
                elevation: 7,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: onPressed,
              child: MusicPlayerAnimatedContainer(
                height: radius * 2,
                width: radius * 2,
                child: Center(
                  child: AnimatedIcon(
                    icon: icon,
                    progress: animationController,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
