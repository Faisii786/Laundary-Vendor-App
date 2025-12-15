import 'package:shared_preferences/shared_preferences.dart';

import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';
import '../../models/login/user_model.dart';
import '../../view_models/controller/user_preference/user_preference_view_model.dart';

class LoginRepository {
  final _apiService = NetworkApiServices();
  final UserPreference userPreference =
      UserPreference(); // ✅ Initialize user preferences

  Future<dynamic> loginApi(String mobile, String password, String ccode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> requestBody = {
      "mobile": mobile,
      "password": password,
      "ccode": ccode,
      "token": prefs.getString("token")
    };

    try {
      dynamic response =
          await _apiService.postApi(requestBody, AppUrl.loginApi);

      //print("🔹 Login API Response: $response");

      if (response["ResponseCode"] == "200") {
        //  print("✅ Login Successful! Saving user data...");

        // Convert API response to UserModel
        UserModel userModel = UserModel.fromJson(response);

        // ✅ Save user and token
        await userPreference.saveUser(userModel);

        //print("🔍 Checking Token After Saving: ${await userPreference.getToken()}");
      } else {
        //print("🚨 Login Failed: ${response["ResponseMsg"]}");
      }

      return response; // Return response to UI
    } catch (e) {
      // print("❌ Login Error: $e");
      return null;
    }
  }
}

// import '../../data/network/network_api_services.dart';
// import '../../res/app_url/app_url.dart';
// class LoginRepository {
//   final _apiService = NetworkApiServices();
//
//   Future<dynamic> loginApi(String mobile, String password, String ccode) async {
//     Map<String, dynamic> requestBody = {
//       "mobile": mobile,
//       "password": password,
//       "ccode": ccode,
//     };
//
//     dynamic response = await _apiService.postApi(requestBody, AppUrl.loginApi);
//     return response;
//   }
// }
//
// // class LoginRepository {
// //   final _apiService = NetworkApiServices();
// //   Future<dynamic> loginApi( var mobile, var password, var ccode) async{
// //     dynamic response = await _apiService.postApi(data, AppUrl.loginApi);
// //     return response;
// //   }
// // }
