import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      curve: Curves.easeInOut,
      width: radius * 2,
      height: radius * 2,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99999),
        boxShadow: [
          BoxShadow(
            offset: Offset(radius / 10, radius / 10),
            spreadRadius: -radius / 3,
            blurRadius: radius,
          ),
        ],
        color: Theme.of(context).canvasColor,
      ),
      child: Image.file(
        File(coverArtPath),
      ),
    );
  }
}
