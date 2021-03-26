import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ohrwurm/features/music_player/presentation/widgets/music_player_animated_container.dart';

class CD extends StatelessWidget {
  final double radius;
  const CD({
    Key key,
    @required this.radius,
    @required this.coverArtPath,
  }) : super(key: key);

  final String coverArtPath;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      clipBehavior: Clip.antiAlias,
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            offset: Offset(radius / 15, radius / 15), blurRadius: radius * .25,
            spreadRadius: -radius * 0.12,
            // spreadRadius: -radius / 4,
            // blurRadius: radius * 2,
          ),
        ],
        color: Theme.of(context).canvasColor,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: MusicPlayerAnimatedContainer(
                height: radius * 2, width: radius * 2, child: Image.asset('assets/images/CD.png')),
          ),
          Align(
            alignment: Alignment.center,
            child: MusicPlayerAnimatedContainer(
              width: radius * 2,
              height: radius * 2,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
              child: ClipPath(
                clipper: InvertedCircleClipper(),
                child: Image.file(
                  File(coverArtPath),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InvertedCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return new Path()
      ..addOval(new Rect.fromCircle(
          center: new Offset(size.width / 2, size.height / 2), radius: size.width * 0.163))
      ..addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
