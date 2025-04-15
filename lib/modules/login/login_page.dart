import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handyman_bbk_panel/common_widget/snakbar.dart';
import 'package:handyman_bbk_panel/common_widget/svgicon.dart';
import 'package:handyman_bbk_panel/modules/login/otp/otp.dart';
import 'package:handyman_bbk_panel/services/auth_services.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false, // prevent Scaffold from resizing
      body: Stack(
        children: [
          // Fixed-size background that doesn't resize
          Container(
            decoration: BoxDecoration(color: AppColor.shammaam),
            child: SizedBox(
              height: screenHeight,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 70),
                child: SvgPicture.asset(
                  "assets/images/loginimage.svg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),

          // Foreground scrollable content that handles keyboard properly
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_imageView(), _loginForm()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageView() {
    return Container(
      color: AppColor.transparent,
      width: MediaQuery.of(context).size.width,
      height:
          MediaQuery.of(context).size.height * (Platform.isIOS ? 0.42 : 0.43),
      padding: EdgeInsets.fromLTRB(90, 0, 90, 90),
      child: Center(child: loadsvg("assets/images/logo.svg")),
    );
  }

  Widget _loginForm() {
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
              maxLength: 10,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                counterText: "",
                hintText: 'Enter 10 digit mobile number',
                prefixText: '+91 - ',
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
              const Text(
                'I agree with the ',
                style: TextStyle(color: Colors.black),
              ),
              GestureDetector(
                onTap: () => print("Terms & Conditions"),
                child: const Text(
                  'Terms & Conditions',
                  style: TextStyle(
                      color: AppColor.yellow, fontWeight: FontWeight.w700),
                ),
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
                                "Sending OTP...",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            "Get OTP",
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
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('OR', style: TextStyle(color: AppColor.greyDark)),
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

    if (phone.length == 10 && RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
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
                message: "OTP sent successfully",
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
                message: error.message ?? "Failed to send OTP",
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
            message: "An unexpected error occurred",
            isTrue: false,
          );
        }
      } else {
        HandySnackBar.show(
          context: context,
          message: "Please accept our terms and conditions",
          isTrue: false,
        );
      }
    } else {
      HandySnackBar.show(
        context: context,
        message: "Enter valid mobile number",
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
              "Continue with $title",
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
