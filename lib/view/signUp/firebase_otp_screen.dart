// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vendor_app/res/colors/app_color.dart';
import 'package:vendor_app/utils/Colors.dart';
import 'package:vendor_app/utils/Fontfamily.dart';
import 'package:vendor_app/utils/Custom_widget.dart';
import 'package:vendor_app/view_models/controller/signup/signup_view_model.dart';
import 'package:vendor_app/view_models/controller/firebase_phone_auth_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Firebase OTP Verification Screen
///
/// This screen handles OTP verification using Firebase Phone Auth.
/// After successful verification, it creates the vendor account via API.
class FirebaseOtpScreen extends StatefulWidget {
  final String countryCode;
  final String phoneNumber;
  final Map<String, Object> signupData;

  const FirebaseOtpScreen({
    super.key,
    required this.countryCode,
    required this.phoneNumber,
    required this.signupData,
  });

  @override
  State<FirebaseOtpScreen> createState() => _FirebaseOtpScreenState();
}

class _FirebaseOtpScreenState extends State<FirebaseOtpScreen> {
  final TextEditingController otpController = TextEditingController();
  final SignupViewModel signupViewModel = Get.find<SignupViewModel>();

  FirebasePhoneAuthController get phoneAuthController =>
      signupViewModel.phoneAuthController;

  String otpCode = "";

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: BlackColor.withOpacity(0.9),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      body: Column(
        children: [
          // Header
          _buildHeader(),

          SizedBox(height: 40),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),

                    // Info text
                    Text(
                      "${"We have sent the verification code to".tr}\n${widget.countryCode} ${widget.phoneNumber}",
                      maxLines: 2,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontFamily: FontFamily.gilroyMedium,
                        color: greyColor,
                      ),
                    ),

                    SizedBox(height: 20),

                    // OTP Input
                    _buildOtpInput(),

                    SizedBox(height: 10),

                    // Resend code section
                    _buildResendSection(),

                    SizedBox(height: 25),

                    // Verify Button
                    _buildVerifyButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: Get.size.height * 0.2,
          width: Get.size.width,
          decoration: BoxDecoration(
            color: AppColor.primeryBlueColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.05),
              Row(
                children: [
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      phoneAuthController.reset();
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back, color: WhiteColor),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Verify Your Phone".tr,
                    style: TextStyle(
                      color: WhiteColor,
                      fontFamily: FontFamily.gilroyMedium,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 50,
          right: 50,
          bottom: -30,
          child: Container(
            height: 60,
            width: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: Offset(0.5, 0.5),
                  blurRadius: 0.5,
                  spreadRadius: 0.5,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ),
              ],
              color: WhiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/appLogo.png",
                  height: 500,
                  width: 200,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return Container(
      alignment: Alignment.center,
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        obscureText: false,
        animationType: AnimationType.fade,
        cursorColor: AppColor.primeryBlueColor,
        cursorHeight: 18,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 45,
          fieldWidth: 45,
          inactiveColor: AppColor.primeryBlueColor,
          activeColor: AppColor.primeryBlueColor,
          selectedColor: AppColor.primeryBlueColor,
          activeFillColor: Colors.white,
          inactiveFillColor: WhiteColor,
          selectedFillColor: WhiteColor,
          borderWidth: 1,
        ),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: WhiteColor,
        enableActiveFill: true,
        controller: otpController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the OTP'.tr;
          }
          if (value.length < 6) {
            return 'Please enter complete OTP'.tr;
          }
          return null;
        },
        onCompleted: (v) {
          print("OTP Completed: $v");
        },
        onChanged: (value) {
          otpCode = value;
        },
        beforeTextPaste: (text) {
          return true;
        },
      ),
    );
  }

  Widget _buildResendSection() {
    return Obx(() => Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive code?".tr,
                style: TextStyle(
                  fontFamily: FontFamily.gilroyMedium,
                  color: greyColor,
                ),
              ),
              phoneAuthController.canResend.value
                  ? InkWell(
                      onTap: () => _resendOTP(),
                      child: Text(
                        " Resend code".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          color: AppColor.primeryBlueColor,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : Text(
                      " ${phoneAuthController.secondsRemaining.value} Seconds"
                          .tr,
                      style: TextStyle(
                        color: AppColor.primeryBlueColor,
                        fontFamily: FontFamily.gilroyBold,
                      ),
                    ),
            ],
          ),
        ));
  }

  Widget _buildVerifyButton() {
    return Obx(() {
      bool isLoading =
          phoneAuthController.isLoading.value || signupViewModel.loading.value;

      return GestButton(
        Width: Get.size.width,
        height: 50,
        buttoncolor: isLoading ? Colors.grey : AppColor.primeryBlueColor,
        margin: EdgeInsets.only(top: 15, left: 30, right: 30),
        buttontext:
            isLoading ? "Verifying...".tr : "Verify & Create Account".tr,
        style: TextStyle(
          fontFamily: FontFamily.gilroyBold,
          color: WhiteColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        onclick: isLoading ? null : () => _verifyOTP(),
      );
    });
  }

  void _verifyOTP() async {
    if (otpCode.length != 6) {
      _showToastMessage("Please enter a valid 6-digit OTP".tr);
      return;
    }

    // Verify OTP
    bool isVerified = await phoneAuthController.verifyOTP(otpCode: otpCode);

    if (isVerified) {
      // OTP verified, now create the account
      await signupViewModel.signupApi(widget.signupData);
      otpController.clear();
      phoneAuthController.reset();
    }
  }

  void _resendOTP() async {
    otpController.clear();
    otpCode = "";

    await phoneAuthController.resendOTP(
      phoneNumber: widget.phoneNumber,
      countryCode: widget.countryCode,
    );
  }
}
