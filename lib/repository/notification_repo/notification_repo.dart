
import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class NotificationRepo {
  static final _apiService = NetworkApiServices();

  static Future<dynamic> sendNotification(
      {String? channelName,
      required String targetid,
      required String role,
      required String uid,
      required String touserType,
      String? body}) async {
    try {
      dynamic response = await _apiService.sendnotification(
          "${AppUrl.baseUrl}token.php?channelName=$channelName&target_id=$targetid&user_type=$role&uid=$uid&body=$body&touserType=$touserType");

      //print("🔹 Login API Response: $response");

      // if (response["ResponseCode"] == "200") {
      //   print(response);
      //   return response
      //   //  print("✅ Login Successful! Saving user data...");

      //   //print("🔍 Checking Token After Saving: ${await userPreference.getToken()}");
      // } else {
      //   //print("🚨 Login Failed: ${response["ResponseMsg"]}");
      // }
      return response;

      return response; // Return response to UI
    } catch (e) {
      // print("❌ Login Error: $e");
      return null;
    }
  }
}
