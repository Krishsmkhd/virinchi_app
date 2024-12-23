import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  const TextTitle({
    super.key,
    this.size = 30,
    required this.text,
    this.color = Colors.black,
    this.textAlign = TextAlign.center,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: fontWeight,
        ));
  }
}
