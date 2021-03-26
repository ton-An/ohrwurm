import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MusicPlayerAnimatedContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final BoxDecoration decoration;
  final Clip clipBehavior;
  final bool disableAnimation;
  final Widget child;

  const MusicPlayerAnimatedContainer({
    Key key,
    this.width,
    this.height,
    this.color,
    this.decoration,
    this.clipBehavior = Clip.none,
    this.disableAnimation = false,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: width,
      height: height,
      duration: disableAnimation ? Duration.zero : Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      color: color,
      decoration: decoration,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}
