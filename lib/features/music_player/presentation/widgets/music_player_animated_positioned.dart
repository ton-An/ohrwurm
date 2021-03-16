import 'package:flutter/widgets.dart';

class MusicPlayerAnimatedPositioned extends AnimatedPositioned {
  MusicPlayerAnimatedPositioned({
    double left,
    double top,
    double right,
    double bottom,
    double width,
    double height,
    @required Widget child,
  }) : super(
          left: left,
          top: top,
          right: right,
          bottom: bottom,
          width: width,
          height: height,
          child: child,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
}
