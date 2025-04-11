import 'package:flutter/material.dart';

import 'package:handyman_bbk_panel/common_widget/loader.dart';

class HandymanButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double padding;
  final bool isLoading;

  const HandymanButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.borderRadius = 8.0,
    this.padding = 16.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading ? Colors.green : color,
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? HandymanLoader()
            : Text(
                text,
                style: TextStyle(color: textColor, fontSize: 14.0),
              ),
      ),
    );
  }
}
