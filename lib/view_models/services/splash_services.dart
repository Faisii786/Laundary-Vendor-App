import 'dart:async';
import 'package:get/get.dart';

import '../../res/routes/routes_name.dart';
import '../controller/user_preference/user_preference_view_model.dart';

// import '../controller/user_preference/user_preference_view_model.dart';
class SplashServices {
  UserPreference userPreference = UserPreference();

  void isLogin() {
    userPreference.getUser().then((value) {
      Future.delayed(const Duration(seconds: 2), () {
        try {
          if (value == null || value.result?.toLowerCase() != 'true') {
            Get.offAllNamed(RouteName.loginView);
          } else {
            if (value.userLogin?.laundryId == null ||
                value.userLogin!.laundryId!.isEmpty) {
              Get.offAllNamed(RouteName.home2);
            } else {
              print("Loggin: ${value.userLogin}");

              Get.offAllNamed(RouteName.homeView);
            }
            print("Loggin: ${value.userLogin}");

            Get.offAllNamed(RouteName.homeView);
          }
        } catch (e) {
          print("Navigation failed: $e");
          Get.offAllNamed(RouteName.loginView); // Fallback
        }
      });
    }).catchError((error) {
      Get.offAllNamed(RouteName.loginView);
    });
  }
}

// class SplashServices{
//   UserPreference userPreference = UserPreference();
//   void isLogin(){
//     userPreference.getUser().then((value){
//       print(value.token);
//       print(value.isLogin);
//
//       if(value.isLogin == false || value.isLogin.toString() == 'null'){
//         Timer(const Duration(seconds: 3),
//                 ()=> Get.toNamed(RouteName.loginView));
//       }else{
//         Timer(const Duration(seconds: 3),
//                 ()=> Get.toNamed(RouteName.homeView));
//       }
//
//
//     });
//   }
// }//
