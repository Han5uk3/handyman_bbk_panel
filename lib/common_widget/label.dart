import 'package:flutter/material.dart';

class HandyLabel extends StatelessWidget {
  final String text;
  final bool isBold;
  final double? fontSize;
  final Color? textcolor;
  const HandyLabel({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.textcolor,
    this.isBold = false,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: TextAlign.justify,
      text,
      style: TextStyle(
        fontSize: fontSize ?? 16,
        fontWeight: isBold ? FontWeight.w900 : FontWeight.w500,
        color: textcolor ?? Colors.black,
      ),
    );
  }
}
