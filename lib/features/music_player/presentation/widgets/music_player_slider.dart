import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MusicPlayerSlider extends StatelessWidget {
  const MusicPlayerSlider({
    Key key,
    @required this.trackHeight,
    @required this.trackRadius,
    @required this.thumbRadius,
    @required this.songDuration,
    @required this.songPosition,
    @required this.onChanged,
    @required this.onChangeEnd,
  }) : super(key: key);

  final double trackHeight;
  final double trackRadius;
  final double thumbRadius;
  final double songDuration;
  final double songPosition;
  final Function(double) onChanged;
  final Function(double) onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: trackHeight,
        overlayColor: Colors.transparent,
        activeTrackColor: Theme.of(context).accentColor,
        inactiveTrackColor: Colors.black,
        thumbColor: Theme.of(context).accentColor,
        trackShape: RoundSliderTrackShape(radius: trackRadius),
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: thumbRadius),
      ),
      child: Slider(
        onChangeEnd: onChangeEnd,
        value: songPosition,
        min: 0,
        max: songDuration,
        onChanged: onChanged,
        divisions: songDuration.round(),
      ),
    );
  }
}

class RoundSliderTrackShape extends SliderTrackShape {
  const RoundSliderTrackShape({this.disabledThumbGapWidth = 2.0, this.radius = 0});

  final double disabledThumbGapWidth;
  final double radius;

  @override
  Rect getPreferredRect({
    RenderBox parentBox,
    Offset offset = Offset.zero,
    SliderThemeData sliderTheme,
    bool isEnabled,
    bool isDiscrete,
  }) {
    final double overlayWidth =
        sliderTheme.overlayShape.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight;
    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);
    assert(parentBox.size.width >= overlayWidth);

    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;

    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    Animation<double> enableAnimation,
    TextDirection textDirection,
    Offset thumbCenter,
    bool isDiscrete,
    bool isEnabled,
  }) {
    if (sliderTheme.trackHeight == 0) {
      return;
    }

    final ColorTween activeTrackColorTween =
        ColorTween(begin: sliderTheme.disabledActiveTrackColor, end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor, end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation);
    final Paint inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation);
    Paint leftTrackPaint;
    Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    double horizontalAdjustment = 0.0;
    if (!isEnabled) {
      final double disabledThumbRadius =
          sliderTheme.thumbShape.getPreferredSize(false, isDiscrete).width / 2.0;
      final double gap = disabledThumbGapWidth * (1.0 - enableAnimation.value);
      horizontalAdjustment = disabledThumbRadius + gap;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    //Modify this side
    final RRect leftTrackSegment = RRect.fromLTRBAndCorners(
        trackRect.left, trackRect.top, thumbCenter.dx - horizontalAdjustment, trackRect.bottom,
        topLeft: Radius.circular(radius), bottomLeft: Radius.circular(radius));
    context.canvas.drawRRect(leftTrackSegment, leftTrackPaint);
    final RRect rightTrackSegment = RRect.fromLTRBAndCorners(
        thumbCenter.dx + horizontalAdjustment, trackRect.top, trackRect.right, trackRect.bottom,
        topRight: Radius.circular(radius), bottomRight: Radius.circular(radius));
    context.canvas.drawRRect(rightTrackSegment, rightTrackPaint);
  }
}
