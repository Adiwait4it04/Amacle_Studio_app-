// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

import 'constant.dart';
import 'styles.dart';

class Clipper extends CustomClipper<Rect> {
  final int part;

  Clipper({required this.part});
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
        (size.width / 10) * part, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}

Widget starBar(Size _screenSize, double rating) {
  return Row(
    children: [
      Wrap(
        children: List.generate(5, (index) {
          double size = _screenSize.height / 40;
          double stars = rating;
          int wholeRating = stars.floor();
          int fractRating = ((stars - wholeRating) * 10).ceil();
          if (index < wholeRating) {
            return Icon(Icons.star, color: Colors.amber, size: size);
          } else if (index == wholeRating) {
            return SizedBox(
              height: size,
              width: size,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: size,
                  ),
                  ClipRect(
                    clipper: Clipper(part: fractRating),
                    child: Icon(
                      Icons.star,
                      color: grey,
                      size: size,
                    ),
                  )
                ],
              ),
            );
          } else {
            return Icon(Icons.star, color: grey, size: size);
          }
        }),
      ),
    ],
  );
}

class ImageOpener extends StatelessWidget {
  final File? imageFile;

  const ImageOpener({
    super.key,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: imageFile != null
            ? PhotoView(
                imageProvider: FileImage(imageFile!),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.0,
              )
            : Text('No Image Selected'),
      ),
    );
  }
}

Widget loadingState() {
  return Center(
    child: CircularProgressIndicator(),
  );
}
