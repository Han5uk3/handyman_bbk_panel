import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handyman_bbk_panel/common_widget/snakbar.dart';
import 'package:handyman_bbk_panel/common_widget/svgicon.dart';
import 'package:handyman_bbk_panel/modules/login/otp/otp.dart';
import 'package:handyman_bbk_panel/services/auth_services.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isChecked = false;
  bool isLoading = false;
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final reducedKeyboardInset = MediaQuery.of(context).viewInsets.bottom * 0.1;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOut,
            top: -reducedKeyboardInset,
            left: 0,
            right: 0,
            bottom: -160,
            child: Container(
              width: screenWidth,
              decoration: BoxDecoration(color: AppColor.shammaam),
              child: Padding(
                padding: const EdgeInsets.only(top: 90),
                child: SvgPicture.asset(
                  "assets/images/loginimage.svg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            reverse: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: reducedKeyboardInset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedPadding(
                  padding: EdgeInsets.only(top: reducedKeyboardInset + 60),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: _imageView(context),
                ),
                AnimatedPadding(
                  padding: EdgeInsets.only(top: 0),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: _loginForm(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageView(BuildContext context) {
    return Container(
      color: AppColor.transparent,
      width: MediaQuery.of(context).size.width,
      height:
          MediaQuery.of(context).size.height * (Platform.isIOS ? 0.35 : 0.35),
      padding: EdgeInsets.fromLTRB(90, 90, 90, 90),
      child: Center(child: loadsvg("assets/images/logo.svg")),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              controller: _phoneController,
              maxLength: 9,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                counterText: "",
                hintText:
                    AppLocalizations.of(context)!.enter9digitmobilenumber,
                prefixText: '+966 - ',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _isChecked,
                  onChanged: (value) =>
                      setState(() => _isChecked = value ?? false),
                  activeColor: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.iAgreeWithTheTermsAndConditions,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _sendOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.black,
                      foregroundColor: AppColor.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: isLoading ? 0 : 2,
                    ),
                    child: isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColor.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                AppLocalizations.of(context)!.sendingOtp,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            AppLocalizations.of(context)!.getOtp,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(AppLocalizations.of(context)!.or,
                    style: TextStyle(color: AppColor.greyDark)),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 10),
          Platform.isIOS
              ? _loginButtonTile(
                  onTap: () async {
                    final user = await AuthServices().signInWithApple();
                    if (user != null) {
                      await AuthServices().checkUser(
                        userCredential: user,
                        context: context,
                      );
                    }
                  },
                  title: "Apple",
                )
              : SizedBox(),
          _loginButtonTile(
            onTap: () async {
              final user = await AuthServices().signInWithGoogle();
              if (user != null) {
                await AuthServices().checkUser(
                  userCredential: user,
                  context: context,
                );
              }
            },
            title: "Google",
          ),
        ],
      ),
    );
  }

  Future<void> _sendOTP() async {
    final phone = _phoneController.text.trim();

    if (phone.length == 9 && RegExp(r'^[0-9]{9}$').hasMatch(phone)) {
      if (_isChecked) {
        setState(() {
          isLoading = true;
        });

        try {
          await AuthServices().sendOTP(
            phoneNumber: phone,
            onCodeSent: (verificationId) {
              setState(() {
                isLoading = false;
              });

              // Subtle success feedback
              HandySnackBar.show(
                context: context,
                message: AppLocalizations.of(context)!.oTPsentsuccessfully,
                isTrue: true,
              );

              // Navigate with a smoother transition
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      OtpVerificationScreen(
                    phoneNumber: phone,
                    verificationId: verificationId,
                  ),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  transitionDuration: Duration(milliseconds: 300),
                ),
              );
            },
            onError: (error) {
              setState(() {
                isLoading = false;
              });

              HandySnackBar.show(
                context: context,
                message: error.message ??
                    AppLocalizations.of(context)!.failedtosendOTP,
                isTrue: false,
              );
            },
          );
        } catch (e) {
          setState(() {
            isLoading = false;
          });

          HandySnackBar.show(
            context: context,
            message: AppLocalizations.of(context)!.anunexpectederroroccurred,
            isTrue: false,
          );
        }
      } else {
        HandySnackBar.show(
          context: context,
          message: AppLocalizations.of(context)!.pleaseacceptterms,
          isTrue: false,
        );
      }
    } else {
      HandySnackBar.show(
        context: context,
        message: AppLocalizations.of(context)!.entervalidmobilenumber,
        isTrue: false,
      );
    }
  }

  Widget _loginButtonTile({void Function()? onTap, String? title}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Image.asset("assets/logos/$title.png"),
            ),
            const SizedBox(width: 15),
            Text(
              title == "Apple"
                  ? AppLocalizations.of(context)!.applelogin
                  : AppLocalizations.of(context)!.googlelogin,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
