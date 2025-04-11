import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/loader.dart';
import 'package:handyman_bbk_panel/styles/color.dart';


class HandymanOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;
  final double borderRadius;
  final double padding;
  final TextStyle? style;
  final bool? isLoading;
  final double? borderThickness;
  final bool? hasIcon;
  final IconData? icon;

  const HandymanOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderColor = Colors.black,
    this.textColor = Colors.black,
    this.borderRadius = 8.0,
    this.padding = 16.0,
    this.style,
    this.isLoading,
    this.borderThickness,
    this.hasIcon = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor, width: borderThickness ?? 2.0),
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: (isLoading ?? false) ? null : onPressed,
      child:
          (isLoading ?? false)
              ? HandymanLoader()
              : (hasIcon ?? false)
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Icon(icon, color: AppColor.black),
                  Text(
                    text,
                    style: style ?? TextStyle(color: textColor, fontSize: 14.0),
                  ),
                ],
              )
              : Text(
                text,
                style: style ?? TextStyle(color: textColor, fontSize: 14.0),
              ),
    );
  }
}
