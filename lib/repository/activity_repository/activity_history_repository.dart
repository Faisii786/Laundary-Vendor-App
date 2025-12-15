import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/network/network_api_services.dart';
import '../../../res/app_url/app_url.dart';
import '../../models/activity/activity_history_model.dart';


class ActivityOrdersHistoryRepository {
  final _apiService = NetworkApiServices();

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");
    print("🔑 Debug: Retrieved Token = $token");
    return token;
  }
  Future<String?> _getLaundromatId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? laundromatId = prefs.getString("laundromat_id");
    print("🏪 Debug: Retrieved Laundromat ID = $laundromatId");
    return laundromatId;
  }

  /// **✅ Fetch Orders with Pagination**
  Future<ActivityOrdersHistoryModel?> fetchOrders({
    int page = 1,
    int limit = 10,
    String? orderType, // Optional filter
  }) async {
    String? token = await _getToken();
    String? laundromatId = await _getLaundromatId();

    if (token == null || laundromatId == null) {
      throw Exception("Unauthorized: Missing token or laundromat ID.");
    }

    // Construct request body
    Map<String, dynamic> requestBody = {
      "laundry_id": laundromatId,
      "page": page,
      "limit": limit,
    };

    // Add optional filters
    if (orderType != null && orderType.isNotEmpty) {
      requestBody["order_type"] = orderType;
    }

    print("📡 Fetching Orders - Page: $page, Limit: $limit, Laundry ID: $laundromatId");

    try {
      // Convert Map to JSON String
      String jsonBody = jsonEncode(requestBody);

      dynamic response = await _apiService.postApiWithToken(
        requestBody, // ✅ Correct - Passing Map directly
        AppUrl.activityApi,
      );


      return ActivityOrdersHistoryModel.fromJson(response);
    } catch (e) {
      print("❌ Error Fetching Orders: $e");
      return null;
    }
  }
}
