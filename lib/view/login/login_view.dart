import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/view/Signup/signUp.dart';
import 'package:vendor_app/view/login/widgets/input_email_widget.dart';
import 'package:vendor_app/view/login/widgets/input_password_widget.dart';
import 'package:vendor_app/view/login/widgets/login_button_widget.dart';
import 'package:vendor_app/view/login/widgets/login_appbar_widget.dart';
import '../../res/colors/app_color.dart';
import '../../view_models/controller/login/login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final bool _isButtonEnabled = false;
  bool _rememberMe = false; // Added for remember me functionality

  // void _updateButtonState() {
  //   setState(() {
  //     _isButtonEnabled =
  //         _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  //   });
  // }

  Future<void> _login(BuildContext context) async {
    // final String apiUrl = "https://yourapi.com/login";
    //
    // try {
    //   final response = await http.post(
    //     Uri.parse(apiUrl),
    //     headers: {"Content-Type": "application/json"},
    //     body: json.encode({
    //      // "email": _emailController.text.trim(),
    //       //"password": _passwordController.text.trim(),
    //     }),
    //   );
    //
    //   if (response.statusCode == 200) {
    //     final Map<String, dynamic> responseBody = json.decode(response.body);
    //     if (responseBody.containsKey("token")) {
    //       // Navigator.pushReplacement(
    //       //   context,
    //       //   MaterialPageRoute(builder: (context) => HomeScreen()),
    //       // );
    //     } else {
    //       _showError(context, "Invalid login credentials.");
    //     }
    //   } else {
    //     _showError(context, "Login failed. Please try again.");
    //   }
    // } catch (e) {
    //   _showError(context, "An error occurred. Please check your connection.");
    // }
  }

  // void _showError(BuildContext context, String message) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text("Error"),
  //       content: Text(message),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text("OK"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    // You can load saved credentials here if remember me was checked previously
    // For example:
    // _rememberMe = loadRememberMeStatusFromPrefs();
    // if (_rememberMe) {
    //   _emailController.text = loadSavedEmailFromPrefs();
    //   _passwordController.text = loadSavedPasswordFromPrefs();
    // }
    //_emailController.addListener(_updateButtonState);
    //_passwordController.addListener(_updateButtonState);
  }

  final loginVM = Get.put(LoginViewMOdel());
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg1Color,
      appBar: const CustomAppBarScreen(
        titleKey: 'welcome_back',
        subtitleKey: 'sign_start',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                'sign_in'.tr,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'greeting_text'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Form(
                key: _formkey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      //InputEmailWidget(),
                      InputPhoneWidget(),
                      const SizedBox(height: 20),
                      const InputPasswordWidget(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        _rememberMe = value ?? false;
                        // Save this preference when changed
                        // saveRememberMeStatusToPrefs(_rememberMe);
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _rememberMe = !_rememberMe;
                        // saveRememberMeStatusToPrefs(_rememberMe);
                      });
                    },
                    child: Text('remember_me'.tr),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              LoginButtonWidget(formKey: _formkey),
              // Obx(() {
              //   return SizedBox(
              //     width: double.infinity,
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: AppColor.primeryBlueColor,
              //         padding: const EdgeInsets.symmetric(vertical: 14),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //       ),
              //       onPressed: loginVM.isLoading.value
              //           ? null
              //           : () async {
              //               if (_formkey.currentState!.validate()) {
              //                 await loginVM.login();
              //               }
              //             },
              //       child: loginVM.isLoading.value
              //           ? SizedBox(
              //               height: 24,
              //               width: 24,
              //               child: CircularProgressIndicator(
              //                 color: Colors.white,
              //                 strokeWidth: 2,
              //               ),
              //             )
              //           : Text(
              //               'Login',
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //     ),
              //   );
              // }),
              const SizedBox(height: 30),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const SignupScreen());
                      },
                      child: const Text(
                        'Sign up',
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
            ],
          ),
        ),
      ),
    );
  }
}
