
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../models/login/user_model.dart';
import '../../../repository/login_repository/login_repository.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../user_preference/user_preference_view_model.dart';

class LoginViewMOdel extends GetxController {
  final _api = LoginRepository();

  UserPreference userPreference = UserPreference();

// final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final ccodeController = TextEditingController(text: '+92').obs;
  final phoneController = TextEditingController().obs;
  final phoneFocusNode = FocusNode().obs;

  final ccodeFocusNode = FocusNode().obs;
// final emailFocusNode = FocusNode().obs;
  final passwordFocusNode = FocusNode().obs;

  RxBool loading = false.obs;
  void loginApi() async {
    loading.value = true;

    // _getLocationAndSendRequest();
    print("💀' CALLING location function.");

    Position? position = await _getCurrentLocation();
    print("💀' CALLING location function.after");
    print("💀' position $position");

    Map data = {
      //"email": emailController.value.text.trim(),
      "mobile": phoneController.value.text.trim(),
      "password": passwordController.value.text.trim(),
      "ccode": ccodeController.value.text.trim(),
    };

    // Construct the API URL with latitude and longitude
    // String apiUrl =
    //     'http://93.127.202.7/user_api/get_laundry_by_use.php'
    //     '?latitude=${position?.latitude}&longitude=${position?.longitude}';
    // String apiUrl =
    //     'http://93.127.202.7/user_api/get_laundry_by_use.php'
    //     '?latitude=24.92994926038695&longitude=67.07463296801761';

    // // Send the request to the API
    // try {
    //   final response = await http.get(Uri.parse(apiUrl));

    //   if (response.statusCode == 200) {
    //     // Handle the successful response
    //     print("DEBUG: Response Body: ${response.body}");
    //     // You can parse the response here if needed
    //   } else {
    //     // Handle the error response
    //     print(
    //         "ERROR: Failed to fetch data. Status code: ${response.statusCode}");
    //   }
    // } catch (e) {
    //   print("ERROR: An error occurred while fetching data: $e");
    // }

    _api
        .loginApi(
      phoneController.value.text.trim(),
      passwordController.value.text.trim(),
      ccodeController.value.text.trim(),
    )
        .then((value) async {
      // String apiUrl =
      //     'http://93.127.202.7/user_api/get_laundry_by_use.php'
      //     '?latitude=24.92994926038695&longitude=67.07463296801761';

      // Send the request to the API
      try {
        // final response = await http.get(Uri.parse(apiUrl));

        // if (response.statusCode == 200) {
        //   // Handle the successful response
        //   print("DEBUG: Response Body: ${response.body}");
        //   // You can parse the response here if needed
        //   final laundriesData = json.decode(response.body);

        loading.value = false;
        if (value['Result'].toString().toLowerCase() == 'true') {
          UserModel userModel = UserModel.fromJson(value);
          // (((((((((((((())))))))))))))

          // Match the laundromat name with the user's name
          // String? userName = userModel
          //     .userLogin?.name; // Assuming the UserModel has a 'name' field
          // String laundromatId = '';

          // Find the matching laundromat
          // for (var laundry in laundriesData) {
          //   if (laundry['laundromat_name'] == userName) {
          //     laundromatId =
          //         laundry['id']; // Get the ID of the matching laundromat
          //     break; // Exit the loop once a match is found
          //   }
          // }

          // Save the laundromat ID in the user model or wherever needed
          // userModel.userLogin?.id =
          //     laundromatId; // Assuming UserModel has a laundromatId field
          // ((((((((((()))))))))))
          userPreference.saveUser(userModel).then((_) {
            Get.delete<LoginViewMOdel>();
            if (userModel.userLogin?.laundryId != null &&
                userModel.userLogin!.laundryId!.isNotEmpty) {
              // If the user has a laundry ID, navigate to the home view
              Get.toNamed(RouteName.homeView);
            } else {
              // If no laundry ID, navigate to the setup view or any other appropriate view
              // Get.toNamed(RouteName.home2);
              Get.toNamed(RouteName.homeView);

              // Navigator.of(context)
              // .pushNamedAndRemoveUntil(RouteName.home2, (route) => false);
            }
            // Get.toNamed(RouteName.homeView);
          });

          Utils.snackBar(
              'Login', 'Login Successful!', Colors.green, SnackPosition.BOTTOM);
          print("DEBUG: $value");
        } else {
          Utils.snackBar('Error', value['ResponseMsg'] ?? "Login failed!",
              Colors.red, SnackPosition.BOTTOM);
        }
        // } else {
        //   // Handle the error response
        //   print(
        //       "ERROR: Failed to fetch data. Status code: ${response.statusCode}");
        // }
      } catch (e) {
        print("ERROR: An error occurred while fetching data: $e");
      }
      // loading.value = false;
      // if (value['Result'].toString().toLowerCase() == 'true') {
      //   UserModel userModel = UserModel.fromJson(value);
      //     // ((((((((((()))))))))))
      //   userPreference.saveUser(userModel).then((_) {
      //     Get.delete<LoginViewMOdel>();
      //     Get.toNamed(RouteName.homeView);
      //   });

      //   Utils.snackBar('Login', 'Login Successful!');
      //   print("DEBUG: $value");
      // } else {
      //   Utils.snackBar('Error', value['ResponseMsg'] ?? "Login failed!");
      // }
    }).onError((error, stackTrace) {
      loading.value = false;
      Utils.snackBar(
          'Error', error.toString(), Colors.red, SnackPosition.BOTTOM);
    });
  }

  Future<Position?> _getCurrentLocation() async {
    print("💀' CALLING location function inside.");
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("❌DEBBUGGGGG: Location services are disabled.");
      return null;
    }

    // Request location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("❌DEBBUGGGGG: Location permissions are denied.");

        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("❌DEBBUGGGGG: Location permissions are permanently denied.");

      return null;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(accuracy: LocationAccuracy.high));
    print(
        "✅ DEBBUGG : Latitude: ${position.latitude}, Longitude: ${position.longitude}");
    return position;
  }

// void loginApi(){
//   loading.value = true;
//   Map data = {
//     "email": emailController.value.text,
//     "password": passwordController.value.text,
//   };
//   _api.loginApi(data).then((value){
//     loading.value = false;
//     if(value['Result'].toString().toLowerCase() == 'true'){//value['error'] == 'user not found'
//       Utils.snackBar('Error', value['error']);
//     }else{
//
//       UserModel userModel = UserModel(
//
//         userLogin: UserLogin.fromJson(value['UserLogin']),
//         //userLogin: value['UserLogin'],
//         responseCode: value['ResponseCode'],
//         result: value['Result'],
//         responseMsg: value['ResponseMsg'],
//       );
//       userPreference.saveUser(userModel).then((value){
//         Get.delete<LoginViewMOdel>();
//        Get.toNamed(RouteName.homeView)!.then((value){});
//
//
//       }).onError((error, snackTrace){
//
//       });
//       Utils.snackBar('Login', 'success_login'.tr);
//     }
//
//   }).onError((error, stackTrace){
//     //print(error.toString());
//     loading.value = false;
//     Utils.snackBar('Error', error.toString());
//   });
// }
}
