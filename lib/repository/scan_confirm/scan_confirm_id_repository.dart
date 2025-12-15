import 'package:shared_preferences/shared_preferences.dart';
import '../../data/network/network_api_services.dart';
import '../../models/scan_confirm/scan_till_id_confirm_order_model.dart';
import '../../res/app_url/app_url.dart';

class ScanAndConfirmRepository {
  final _apiService = NetworkApiServices();

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
  Future<String?> _getLaundromatId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? laundromatId = prefs.getString("laundromat_id");

    if (laundromatId == null || laundromatId.isEmpty) {
      print("🚨 No laundromat_id found in SharedPreferences!");
      return null;
    }

    print("🏪 Laundromat ID found: $laundromatId");
    return laundromatId;
  }

  Future<UserByTillIDModel> ConfirmOrderByTillID(String orderQId) async {
    String? token = await _getToken();
    String? laundromatId = await _getLaundromatId(); // ✅ Get laundromat_id dynamically

    if (token == null || token.isEmpty) {
      throw Exception("Unauthorized: No token found.");
    }

    if (laundromatId == null || laundromatId.isEmpty) {
      throw Exception("Unauthorized: No laundromat_id found.");
    }

    String url = AppUrl.scanConfirmOrderTillID;
    Map<String, dynamic> data = {
      "order_q_id": orderQId, // ✅ Ensure it's a String
      "laundromat_id": laundromatId // ✅ Use dynamic laundromat_id
    };

    print("📡 Sending POST request to: $url");
    print("🔹 Request Data: $data");

    dynamic response = await _apiService.postApiWithToken(data, url);

    print("🔹 API Response: $response");

    return UserByTillIDModel.fromJson(response);
  }

}