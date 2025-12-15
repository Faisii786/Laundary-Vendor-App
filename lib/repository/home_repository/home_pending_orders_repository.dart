import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_app/models/home/orders.dart';
import '../../../data/network/network_api_services.dart';
import '../../../res/app_url/app_url.dart';

class HomePendingOrdersRepository {
  final _apiService = NetworkApiServices();

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  Future<String?> _getLaundromatId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("laundromat_id");
  }

  /// Fetch Orders with Pagination
  Future<OrdersModel?> fetchOrders({int page = 1}) async {
    String? token = await _getToken();
    String? laundromatId = await _getLaundromatId();
    // int? laundromatId =
    //     laundromatIdStr != null ? int.tryParse(laundromatIdStr) : null;

    if (token == null || laundromatId == null) {
      print(
          "❌ Missing token or laundromat ID home_pending_orders_repository.dart");
      throw Exception(
          "Unauthorized: Missing token or laundromat ID.home_pending_orders_repository.dart");
    }

    Map<String, dynamic> requestBody = {
      "laundry_id": int.tryParse(laundromatId) ?? laundromatId,
      "page": page,
    };

    print(
        "🔍 Request Body home_pending_orders_repository.dart: $requestBody"); // ✅ Debugging Print

    try {
      dynamic response = await _apiService.postApiWithToken(
        requestBody,
        AppUrl.homePendingOdrApi,
      );

      print(
          "🔍 Full API Response home_pending_orders_repository.dart: $response"); // ✅ Debugging Print

      if (response == null) {
        print(
            "⚠️ API returned null response home_pending_orders_repository.dart");
        return null;
      }

      return OrdersModel.fromJson(response);
    } catch (e) {
      print("❌ Error Fetching Orders home_pending_orders_repository.dart: $e");
      return null;
    }
  }
}
