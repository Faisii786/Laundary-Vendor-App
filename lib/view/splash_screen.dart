import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../res/assets/image_assets.dart';
import '../res/colors/app_color.dart';
import '../res/fonts/app_fonts.dart';
import '../view_models/services/splash_services.dart';

// import 'auth/loginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splahScreen = SplashServices();
  @override
  void initState() {
    super.initState();
    // Navigate to Login Screen after 3 seconds
    Future.delayed(const Duration(seconds: 2), () {
      // Add delay
      splahScreen.isLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColor.bgcolor,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            SvgPicture.asset(
              ImageAssets.appLogo,
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 10),
            // Subtitle
            Text(
              'store_app'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColor.primeryBlueColor,
                fontFamily: AppFonts.gilroyHeavy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
