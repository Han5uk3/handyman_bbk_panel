import 'dart:async';
import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/snakbar.dart';
import 'package:handyman_bbk_panel/helpers/hive_helpers.dart';
import 'package:handyman_bbk_panel/services/auth_services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  String currentText = "";
  bool hasError = false;
  bool isVerifying = false;
  bool isResending = false;
  int resendSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    errorController.close();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds > 0) {
        if (mounted) {
          setState(() {
            resendSeconds--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> resendOTP() async {
    if (resendSeconds > 0 || isResending) return;

    if (mounted) {
      setState(() {
        isResending = true;
      });
    }

    try {
      await AuthServices().sendOTP(
        phoneNumber: widget.phoneNumber,
        onCodeSent: (String newVerificationId) {
          if (mounted) {
            setState(() {
              resendSeconds = 30;
              isResending = false;
            });
          }
          startTimer();

          HandySnackBar.show(
            context: context,
            message: "OTP resent successfully",
            isTrue: true,
          );
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              isResending = false;
            });
          }

          HandySnackBar.show(
            context: context,
            message: error.message ?? "Failed to resend OTP",
            isTrue: false,
          );
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          isResending = false;
        });
      }
      HandySnackBar.show(
        context: context,
        message: "An unexpected error occurred",
        isTrue: false,
      );
    }
  }

  Future<void> verifyOTP() async {
    if (currentText.length != 6) {
      errorController.add(ErrorAnimationType.shake);
      if (mounted) {
        setState(() {
          hasError = true;
        });
      }

      HandySnackBar.show(
        context: context,
        message: "Please enter a valid 6-digit OTP",
        isTrue: false,
      );
      return;
    }

    if (mounted) {
      setState(() {
        isVerifying = true;
        hasError = false;
      });
    }

    try {
      final userCredential = await AuthServices().verifyOTP(
        otpController.text,
        verificationId: widget.verificationId,
        smsCode: currentText,
      );
      await HiveHelper.putUID(userCredential.user?.uid ?? '');
      if (!mounted) return;

      if (userCredential.user != null) {
        await AuthServices().checkUser(
          userCredential: userCredential,
          context: context,
        );
      } else {
        if (!mounted) return;
        setState(() {
          isVerifying = false;
          hasError = true;
        });

        errorController.add(ErrorAnimationType.shake);
        HandySnackBar.show(
          context: context,
          message: "Invalid OTP. Please try again.",
          isTrue: false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isVerifying = false;
          hasError = true;
        });
      }
      HandySnackBar.show(
        context: context,
        message: "Failed to verify OTP: ${e.toString()}",
        isTrue: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: handyAppBar("Verify Phone Number", context, isneedtopop: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: 'OTP has been sent to ',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
                children: [
                  TextSpan(
                    text: "+91 - ${widget.phoneNumber}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const TextSpan(
                    text: ' ✓',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Form(
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                controller: otpController,
                animationType: AnimationType.fade,
                enableActiveFill: true,
                errorAnimationController: errorController,
                keyboardType: TextInputType.number,
                animationDuration: const Duration(milliseconds: 300),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeColor: hasError ? Colors.red : const Color(0xFFD9D9D9),
                  inactiveColor: const Color(0xFFD9D9D9),
                  selectedColor: const Color(0xFF383838),
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                ),
                cursorColor: Colors.black,
                onCompleted: (value) {
                  if (mounted) {
                    verifyOTP();
                  }
                },
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      currentText = value;
                      hasError = false;
                    });
                  }
                },
                beforeTextPaste: (text) => true,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: resendSeconds > 0 || isResending ? null : resendOTP,
              child: Text(
                isResending
                    ? "Sending OTP..."
                    : (resendSeconds > 0
                        ? "Resend OTP in 00:${resendSeconds.toString().padLeft(2, '0')} s"
                        : "Resend OTP"),
                style: TextStyle(
                  color: resendSeconds > 0 || isResending
                      ? Colors.grey
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: HandymanButton(
                text: isVerifying ? "Verifying..." : "Verify",
                onPressed: isVerifying ? () {} : verifyOTP,
                color: Colors.black,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
