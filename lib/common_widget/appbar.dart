import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

PreferredSizeWidget handyAppBar(
  String title,
  BuildContext context, {
  PreferredSizeWidget? bottom,
  Color textColor = Colors.black,
  Color iconColor = Colors.black,
  bool isneedtopop = false,
  void Function()? onpop,
  bool iswhite = true,
  bool isneedchat = false,
  bool isCenter = true,
  List<Widget>? actions,
}) {
  return AppBar(
    bottom: bottom,
    scrolledUnderElevation: 0,
    centerTitle: isCenter,
    toolbarHeight: 75,
    title: Padding(
      padding: isneedtopop ? EdgeInsets.all(0) : EdgeInsets.only(left: 10),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    ),
    shape: BorderDirectional(
      bottom: BorderSide(color: AppColor.lightGrey100, width: 1),
    ),
    leadingWidth: isneedtopop ? 75 : 0,
    leading: isneedtopop
        ? GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Icon(CupertinoIcons.back, color: AppColor.blue),
                Text(
                  "Back",
                  style: TextStyle(color: AppColor.blue, fontSize: 16),
                ),
              ],
            ),
          )
        : SizedBox(),
    backgroundColor: iswhite ? AppColor.white : AppColor.black,
    actions: isneedchat
        ? [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.chat_bubble_outline_outlined,
                color: iconColor,
              ),
            ),
          ]
        : actions,
  );
}
