import 'package:flutter/material.dart';

class TextNormal extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final TextAlign textAlign;
  const TextNormal(
      {super.key,
      this.size = 20,
      required this.text,
      this.textAlign = TextAlign.center,
      this.color = Colors.black45});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
        style: TextStyle(color: color, fontSize: size));
  }
}
