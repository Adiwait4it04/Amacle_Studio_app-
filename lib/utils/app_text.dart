import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  double size;
  final String text;
  final dynamic fontFamily;
  final Color color;

  AppText({
    super.key,
    required this.text,
    this.fontFamily = "",
    this.color = Colors.white,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (size == 16) {
      size = 16;
    }
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontFamily: fontFamily,
      ),
    );
  }
}
