import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../models/login/user_model.dart'; // Import UserModel

class UserPreference extends GetxController {
  /// ✅ **Save only user ID, mobile & country code**
  Future<void> saveUserData(
      {required int userID,
      required String mobile,
      required String countryCode}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setInt("userID", userID);
    await prefs.setString("userID", userID.toString());
    await prefs.setString("mobile", mobile);
    await prefs.setString("countryCode", countryCode);
  }

  /// ✅ **Get User ID**
  static Future<int?> getUserID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userID");
  }

  Future<String?> getSUserID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString("userID");
    print("🔍 Retrieved User ID: $userID");
    return userID;
  }

  /// ✅ **Get Mobile Number**
  Future<String?> getUserMobile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("mobile");
  }

  /// ✅ **Get Country Code**
  Future<String?> getCountryCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("countryCode");
  }

  /// ✅ **Get Laundromat ID**
  Future<String?> getLaundromatID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? laundromatID = prefs.getString("laundromat_id");
    print("🔍 Retrieved Laundromat ID: $laundromatID");
    return laundromatID;
  }

  /// ✅ **Remove User Data**
  Future<bool> removeRegisterUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove('userID');
    await sp.remove('mobile');
    await sp.remove('countryCode');
    return true;
  }

  /// Save user details and store token
  Future<bool> saveUser(UserModel userModel) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    // Convert UserModel to JSON and save it
    String userJson = jsonEncode(userModel.toJson());
    await sp.setString('user_data', userJson);

    // Save login status
    await sp.setBool('isLogin', userModel.result?.toLowerCase() == 'true');

    // 🔹 Save authentication token
    if (userModel.userLogin != null &&
        userModel.userLogin!.securityToken != null) {
      String token = userModel.userLogin!.securityToken!;
      await sp.setString('auth_token', token);
      print("✅ Token Saved Successfully: $token");
    } else {
      print("🚨 No token found in response!");
    }

    // 🔹 Save laundromat_id
    if (userModel.userLogin != null && userModel.userLogin!.id != null) {
      // String id = userModel.userLogin!.id!;
      // String id = userModel.userLogin!.laundryId!;
      String? id = userModel.userLogin!.laundryId;
      print("✅ userModel: laundryId ${userModel.userLogin?.laundryId}");
      print("✅ userModel: id ${userModel.userLogin?.id}");
      if (userModel.userLogin!.laundryId == null ||
          userModel.userLogin!.laundryId!.isEmpty) {
        await sp.setString('laundromat_id', userModel.userLogin!.id!);
      } else {
        await sp.setString('laundromat_id', userModel.userLogin!.laundryId!);
      }

      // print("✅ Laundromat ID Saved: $id");
    } else {
      print("🚨 No laundromat_id found in response!");
    }

    // Debug: Check stored token and laundromat_id
    String? checkToken = sp.getString("auth_token");
    //print("🔍 Checking Stored Token: $checkToken");
    //print("🔍 Stored Laundromat ID: ${sp.getString("laundromat_id")}");

    return true;
  }

  /// Retrieve stored token
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");
    //print("🔑 Retrieved Token: $token");
    return token;
  }

  /// Retrieve stored user data
  Future<UserModel?> getUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? userJson = sp.getString('user_data');

    if (userJson != null) {
      // print("🔍 Stored User Data: $userJson"); // ✅ Debug stored user data
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  /// Remove user data and token
  Future<bool> removeUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove('user_data'); // Remove user data
    await sp.remove('auth_token'); // Remove token
    await sp.remove('isLogin'); // Remove login status
    await sp.remove('laundromat_id'); // Remove laundromat_id
    //print("✅ User logged out, data cleared!");
    return true;
  }
}
