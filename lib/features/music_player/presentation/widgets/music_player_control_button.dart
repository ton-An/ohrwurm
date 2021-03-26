import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_animated_container.dart';

class PlayerControlButton extends StatelessWidget {
  final bool boxShadow;
  final IconData icon;
  final Color color;

  final Function onPressed;
  const PlayerControlButton({
    Key key,
    @required this.boxShadow,
    @required this.icon,
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
                color: color,
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
                child: Icon(
                  icon,
                  size: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
