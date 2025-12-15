import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/repository/signup_repository/signup_repository.dart';
import 'package:vendor_app/view/addLaundry/addLaundry.dart';
import 'package:vendor_app/view_models/controller/add_laundry/addLaundry_view_model.dart';
import 'package:vendor_app/view_models/controller/firebase_phone_auth_controller.dart';
import '../../../utils/utils.dart';

class SignupViewModel extends GetxController {
  final _api = SignupRepository();
  // final _api1 = LoginRepository();
  // UserPreference userPreference = UserPreference();
  final AddlaundryViewModel addlaundryviewmodel =
      Get.put(AddlaundryViewModel());

  // Firebase Phone Auth Controller
  final FirebasePhoneAuthController phoneAuthController =
      Get.put(FirebasePhoneAuthController());

  // Store country code for later use
  String storedCountryCode = "";

  RxBool loading = false.obs;

  /// Send OTP using Firebase Phone Auth
  /// This is the first step in the signup process
  Future<bool> sendSignupOTP({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      storedCountryCode = countryCode;
      print(
          "📱 SignupViewModel: Sending OTP to $phoneNumber with code $countryCode");

      bool result = await phoneAuthController.sendOTP(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      );

      print("📱 SignupViewModel: OTP send result = $result");
      return result;
    } catch (e) {
      print("❌ SignupViewModel: Error sending OTP: $e");
      return false;
    }
  }

  Future<void> signupApi(Map<String, Object> signupData) async {
    loading.value = true;
    // Send the request to the API

    _api.signupApi(signupData).then((value) async {
      try {
        loading.value = false;
        if (value['Result'].toString().toLowerCase() == 'true' &&
            value['ResponseCode'].toString().toLowerCase() == '200') {
          final id = value['LaundryUserID'].toString();
          final userdata = signupData;
          addlaundryviewmodel.fetchzonesApi();
          Get.to(() => AddLaundryPage(signupdata: userdata, laundryUserId: id));
          // _api1
          //     .loginApi(
          //   signupData['mobile'].toString(),
          //   signupData['password'].toString(),
          //   signupData['ccode'].toString(),
          // )
          //     .then((value) async {
          //   // Send the request to the API
          //   try {
          //     loading.value = false;
          //     if (value['Result'].toString().toLowerCase() == 'true') {
          //       UserModel userModel = UserModel.fromJson(value);
          //       userPreference.saveUser(userModel).then((_) {
          //         Get.to(() => AddLaundryPage());
          //       });
          //       Utils.snackBar('signup', 'User created now add laundry',
          //           Colors.green, SnackPosition.BOTTOM);
          //       print("DEBUG: $value");
          //     } else {
          //       Utils.snackBar(
          //           'Error',
          //           value['ResponseMsg'] ?? "signup failed!",
          //           Colors.red,
          //           SnackPosition.BOTTOM);
          //     }
          //   } catch (e) {
          //     print("ERROR: An error occurred while fetching data: $e");
          //   }
          // }).onError((error, stackTrace) {
          //   loading.value = false;
          //   Utils.snackBar(
          //       'Error', error.toString(), Colors.red, SnackPosition.BOTTOM);
          // });
          // Get.delete<SignupViewModel>();
          // Get.toNamed(RouteName.loginView);

          Utils.snackBar('signup', 'signup Successful!', Colors.green,
              SnackPosition.BOTTOM);
          print("DEBUG: $value");
        } else {
          Utils.snackBar('Error', value['ResponseMsg'] ?? "signup failed!",
              Colors.red, SnackPosition.BOTTOM);
        }
      } catch (e) {
        print("ERROR: An error occurred while fetching data: $e");
      }
    }).onError((error, stackTrace) {
      loading.value = false;
      Utils.snackBar(
          'Error', error.toString(), Colors.red, SnackPosition.BOTTOM);
    });
  }
}
