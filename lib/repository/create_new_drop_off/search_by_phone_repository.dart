
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/network/network_api_services.dart';
import '../../models/create_new_drop_off/search_by_phone_model.dart';
import '../../res/app_url/app_url.dart';

class SearchUserRepository {
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
    return prefs.getString("laundromat_id");
  }

  Future<SeachUserByPNModel> searchUserByPhoneNumber(String phoneNumber) async {
    String? token = await _getToken();
    String? laundryId = await _getLaundromatId();

    if (token == null || token.isEmpty) {
      throw Exception("Unauthorized: No token found.");
    }

    if (laundryId == null || laundryId.isEmpty) {
      print("🚨 No laundry_id found!");
      throw Exception("Unauthorized: No laundry_id found.");
    }

    String url = AppUrl.serchByNumberApi;
    Map<String, dynamic> data = {
      "mobile": phoneNumber,
      "laundry_id": laundryId, // ✅ Include laundry_id for the search
    };

    print("📡 Sending POST request to: $url");
    print("🔹 Request Data: $data");

    dynamic response = await _apiService.searchPostApi(data, url);

    print("🔹 API Response: $response");

    return SeachUserByPNModel.fromJson(response);
  }

//
  // Future<SeachUserByPNModel> searchUserByPhoneNumber(String phoneNumber) async {
  //   String? token = await _getToken();
  //
  //   if (token == null || token.isEmpty) {
  //     throw Exception("Unauthorized: No token found.");
  //   }
  //
  //   String url = "${AppUrl.serchByNumberApi}?mobile=$phoneNumber";
  //
  //   dynamic response = await _apiService.getApi(url);
  //
  //   return SeachUserByPNModel.fromJson(response);
  // }
}
