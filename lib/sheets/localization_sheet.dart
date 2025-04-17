import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/common_widget/svgicon.dart';
import 'package:handyman_bbk_panel/modules/profile/bloc/profile_bloc.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class Localization {
  static void showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Choose Language",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    buildLanguageOption(
                      context,
                      "English",
                      "assets/icons/united-states.svg",
                      "en",
                    ),
                    SizedBox(height: 15),
                    Divider(height: 1),
                    SizedBox(height: 15),
                    buildLanguageOption(
                      context,
                      "العربية",
                      "assets/icons/flag.svg",
                      "ar",
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: AppColor.lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget buildLanguageOption(
    BuildContext context,
    String language,
    String flagAsset,
    String langCode,
  ) {
    return InkWell(
      onTap: () {
        context.read<ProfileBloc>().add(ChangeLocale(languageCode: langCode));
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            SizedBox(height: 40, width: 40, child: loadsvg(flagAsset)),
            SizedBox(width: 15),
            Text(
              language,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
