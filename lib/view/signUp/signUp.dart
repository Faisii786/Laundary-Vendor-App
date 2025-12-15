import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vendor_app/res/colors/app_color.dart';
import 'package:vendor_app/view/login/login_view.dart';
import 'package:vendor_app/view/login/widgets/login_appbar_widget.dart';
import 'package:vendor_app/view/signUp/widgets/signupWidgets.dart';
import 'package:vendor_app/view/signUp/firebase_otp_screen.dart';
import 'package:vendor_app/view_models/controller/add_laundry/addLaundry_view_model.dart';
import 'package:vendor_app/view_models/controller/signup/signup_view_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SignupViewModel signupViewModel = Get.put(SignupViewModel());
  final AddlaundryViewModel addlaundryviewmodel =
      Get.put(AddlaundryViewModel());

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ccodeController = TextEditingController(text: '+92');
  final _mobileController = TextEditingController();
  final _parentCodeController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ccodeController.dispose();
    _mobileController.dispose();
    _parentCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignup() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Get FCM token for push notifications
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
        print("📱 FCM Token: $fcmToken");
      } catch (e) {
        print("⚠️ Could not get FCM token: $e");
      }

      // Here you can use the model data
      final signupData = {
        "name": _nameController.text,
        "email": _emailController.text,
        "ccode": _ccodeController.text,
        "mobile": _mobileController.text,
        "parentcode": _parentCodeController.text,
        "password": _passwordController.text,
        "status": 1,
        "token": fcmToken ?? "",
      };

      // Send OTP first
      bool otpSent = await signupViewModel.sendSignupOTP(
        phoneNumber: _mobileController.text,
        countryCode: _ccodeController.text,
      );

      if (otpSent) {
        // Navigate to OTP verification screen
        Get.to(() => FirebaseOtpScreen(
              countryCode: _ccodeController.text,
              phoneNumber: _mobileController.text,
              signupData: signupData,
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg1Color,
      appBar: const CustomAppBarScreen(
        titleKey: 'Welcome',
        subtitleKey: 'sign_start',
      ),
      body: Obx(
        () => Stack(children: [
          AbsorbPointer(
            absorbing: signupViewModel.loading.value,
            child: Opacity(
              opacity: signupViewModel.loading.value
                  ? 0.5
                  : 1.0, // Optional fade effect
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          'Sign up'.tr,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your account to get started'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              InputNameWidget(controller: _nameController),
                              const SizedBox(height: 20),
                              InputEmailWidget(controller: _emailController),
                              const SizedBox(height: 20),
                              // IntlPhoneField(
                              //   initialCountryCode: "PK",
                              //   keyboardType: TextInputType.number,
                              //   cursorColor: BlackColor,
                              //   inputFormatters: [
                              //     FilteringTextInputFormatter.digitsOnly
                              //   ],
                              //   // controller: _mobileController,
                              //   autovalidateMode: AutovalidateMode.onUserInteraction,
                              //   disableLengthCheck: true,
                              //   dropdownIcon: Icon(
                              //     Icons.arrow_drop_down,
                              //     color: Colors.grey.shade600,
                              //   ),
                              //   dropdownTextStyle: TextStyle(
                              //     color: Colors.grey.shade600,
                              //   ),
                              //   style: TextStyle(
                              //     fontFamily: FontFamily.gilroyMedium,
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.w600,
                              //     color: BlackColor,
                              //   ),
                              //   onCountryChanged: (value) {
                              //     _mobileController.text = '';
                              //     _passwordController.text = '';
                              //   },
                              //   onChanged: (value) {
                              //     _ccodeController.text = value.countryCode;
                              //     _mobileController.text = value.number;
                              //   },

                              //   validator: (value) {
                              //     if (value == null || value.number.trim().isEmpty) {
                              //       return "Please enter your mobile number".tr;
                              //     }
                              //     if (value.number.length < 10 ||
                              //         value.number.length > 10) {
                              //       return "Mobile number is invalid".tr;
                              //     }
                              //     // Add more validation if needed
                              //     return null;
                              //   },
                              //   decoration: InputDecoration(
                              //     filled: true,
                              //     fillColor: Colors.white,
                              //     hintText: "Mobile Number".tr,
                              //     hintStyle: TextStyle(
                              //       color: Colors.grey.shade600,
                              //     ),
                              //     focusedBorder: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(15),
                              //       borderSide: BorderSide(
                              //         color: Colors.grey.shade300,
                              //       ),
                              //     ),
                              //     enabledBorder: OutlineInputBorder(
                              //       borderSide: BorderSide(
                              //         color: Colors.grey.shade300,
                              //       ),
                              //       borderRadius: BorderRadius.circular(15),
                              //     ),
                              //     border: OutlineInputBorder(
                              //       borderSide: BorderSide(
                              //         color: Colors.grey.shade300,
                              //       ),
                              //       borderRadius: BorderRadius.circular(15),
                              //     ),
                              //   ),
                              //   invalidNumberMessage:
                              //       "Please enter your mobile number".tr,
                              // ),
                              InputPhoneWidget(
                                ccodeController: _ccodeController,
                                mobileController: _mobileController,
                              ),
                              const SizedBox(height: 20),
                              InputParentCodeWidget(
                                  controller: _parentCodeController),
                              const SizedBox(height: 20),
                              InputPasswordWidget(
                                  controller: _passwordController),
                            ],
                          ),
                        ),
                        // SizedBox(height: 20),
                        // Row(
                        //   children: [
                        //     Checkbox(
                        //       value: _rememberMe,
                        //       onChanged: (bool? value) {
                        //         setState(() {
                        //           _rememberMe = value ?? false;
                        //         });
                        //       },
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {
                        //         setState(() {
                        //           _rememberMe = !_rememberMe;
                        //         });
                        //       },
                        //       child: Text('remember_me'.tr),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(height: 30),
                        Obx(() => ElevatedButton(
                              onPressed: signupViewModel
                                      .phoneAuthController.isLoading.value
                                  ? null
                                  : _onSignup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: signupViewModel
                                        .phoneAuthController.isLoading.value
                                    ? Colors.grey
                                    : AppColor.primeryBlueColor,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                signupViewModel
                                        .phoneAuthController.isLoading.value
                                    ? "Sending OTP...".tr
                                    : "Sign Up".tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                        const SizedBox(height: 30),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => const LoginView());
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: AppColor.primeryBlueColor,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(height: 30),
                        // TextButton(
                        //   onPressed: () {
                        //     addlaundryviewmodel.fetchzonesApi();
                        //     final signupData = {
                        //       "name": "John Doe",
                        //       "email": "johndoe@example.com",
                        //       "ccode": "+92",
                        //       "mobile": "1234567890",
                        //       "parentcode": "123",
                        //       "password": "1234",
                        //       "status": "1",
                        //     };
                        //     // signupViewModel.loading.value = true;
                        //     Get.to(() => AddLaundryPage(
                        //         signupdata: signupData, laundryUserId: '1'));
                        //   },
                        //   child: Text('Just Text Button'),
                        // ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Loading overlay
          if (signupViewModel.loading.value)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ]),
      ),
    );
  }
}
