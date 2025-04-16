import 'package:flutter/material.dart';

import 'package:handyman_bbk_panel/styles/color.dart';

class LocationHistoryDisplay extends StatelessWidget {
  final bool isActive;
  final String customerLocation;
  final TextStyle textStyle;

  final Color? iconColor;

  const LocationHistoryDisplay({
    super.key,
    required this.customerLocation,
    required this.isActive,

    this.textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColor.black,
    ),

    this.iconColor = AppColor.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.location_on_outlined, size: 28, color: iconColor),
        const SizedBox(width: 5.0),

        Text(
          maxLines: 1,
          textScaler: TextScaler.linear(0.8),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          isActive ? customerLocation : "Fetching...",
          style: textStyle,
        ),
      ],
    );
  }
}
