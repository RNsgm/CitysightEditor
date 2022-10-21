import 'package:flutter/material.dart';

class TextWithBorder extends StatelessWidget {
  const TextWithBorder({Key? key, required this.text, required this.textColor, required this.borderColor}) : super(key: key);
  final String text;
  final Color textColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            // The text border
            Text(
              text,
              style: TextStyle(
                letterSpacing: .5,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = borderColor
              ),
            ),
            // The text inside
            Text(
              text,
              style: TextStyle(
                letterSpacing: .5,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        );
  }
}