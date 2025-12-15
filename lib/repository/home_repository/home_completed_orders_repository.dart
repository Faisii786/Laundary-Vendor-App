import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_app/models/home/orders.dart';
import '../../../data/network/network_api_services.dart';
import '../../../res/app_url/app_url.dart';

class HomeCompletedOrdersRepository {
  final _apiService = NetworkApiServices();

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");
    print(
        "🔑 Debug: Retrieved Token home_completed_orders_repository.dart = $token");
    return token;
  }

  Future<String?> _getLaundromatId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? laundromatId = prefs.getString("laundromat_id");
    print(
        "🏪 Debug: Retrieved Laundromat ID home_completed_orders_repository.dart = $laundromatId");
    return laundromatId;
  }

  /// **✅ Fetch Orders with Pagination**
  Future<OrdersModel?> fetchOrders({
    int page = 1,
    // int limit = 10,
    // String? orderType, // Optional filter
  }) async {
    String? token = await _getToken();
    String? laundromatId = await _getLaundromatId();
    // int? laundromatId =
    //     laundromatIdStr != null ? int.tryParse(laundromatIdStr) : null;

    if (token == null || laundromatId == null) {
      throw Exception(
          "Unauthorized: Missing token or laundromat ID.home_completed_orders_repository.dart");
    }

    // Construct request body
    Map<String, dynamic> requestBody = {
      "laundry_id": laundromatId,
      "page": page,
      // "limit": 5,
    };

    try {
      // Convert Map to JSON String
      String jsonBody = jsonEncode(requestBody);
      print(
          "🚀 Request Body: home_completed_orders_repository.dart: $jsonBody");

      dynamic response = await _apiService.postApiWithToken(
        requestBody, // ✅ Correct - Passing Map directly
        AppUrl.homeCompleteOdrApi,
      );

      return OrdersModel.fromJson(response);
    } catch (e) {
      print(
          "❌ Error Fetching Orders in home_completed_orders_repository.dart: $e");
      return null;
    }
  }
}
