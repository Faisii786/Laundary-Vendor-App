import 'package:shared_preferences/shared_preferences.dart';
import '../../data/network/network_api_services.dart';
import '../../models/create_new_drop_off/update_customer_model.dart';
import '../../res/app_url/app_url.dart';

class UpdateUserRepository {
  final _apiService = NetworkApiServices();

  // Fetch authentication token from SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");

    if (token == null || token.isEmpty) {
      print("🚨 No auth token found!");
    } else {
      print("🔑 Token found: $token");
    }
    return token;
  }

  // Update user details using PUT method (userId in body, NOT in URL)
  Future<UpdateCustomerModel> updateUserDetails(Map<String, dynamic> updateData) async {
    String? token = await _getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Unauthorized: No token found.");
    }

    String url = AppUrl.updateCustomerApi; // ✅ No userId in URL

    print("📡 Sending PUT request to: $url");
    print("🔹 Request Data: $updateData");

    dynamic response = await _apiService.putApi(updateData, url); // ✅ Using putApi()

    print("🔹 API Response: $response");

    return UpdateCustomerModel.fromJson(response);
  }
}
