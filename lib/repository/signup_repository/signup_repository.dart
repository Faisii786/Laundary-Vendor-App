import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class SignupRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> signupApi(Map<String, Object> signupData) async {
    try {
      dynamic response =
          await _apiService.postApi(signupData, AppUrl.signupApi);

      print("🔹 signup API Response: $response");

      if (response["ResponseCode"] == "200") {
        // ✅ Save user and token
        print("🔍 Checking Token After Saving: ${response["SecurityToken"]}");
      } else {
        print("🚨 signup Failed: ${response["ResponseMsg"]}");
      }

      return response; // Return response to UI
    } catch (e) {
      print("❌ Signup Error: $e");
      return null;
    }
  }
}
