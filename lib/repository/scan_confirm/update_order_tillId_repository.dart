import 'package:shared_preferences/shared_preferences.dart';
import '../../data/network/network_api_services.dart';
import '../../models/scan_confirm/update_order_by_till_id.dart';
import '../../res/app_url/app_url.dart';

class UpdateTillIdOrderRepository {
  final _apiService = NetworkApiServices();

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  Future<String?> _getLaundromatId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("laundromat_id");
  }

  /// 🔹 **Update Order**
  Future<UpadateTillIdOderModel> updateOrderByTillID(
      String orderId,
      String customerId,
      String totalBags,
      String weight,
      String totalPrice,
      ) async {
    String? token = await _getToken();
    String? laundromatId = await _getLaundromatId();

    if (token == null || token.isEmpty) throw Exception("Unauthorized: No token found.");
    if (laundromatId == null || laundromatId.isEmpty) throw Exception("Unauthorized: No laundromat_id found.");

    String url = AppUrl.updateOrderTillID;

    // ✅ Construct API request payload
    Map<String, dynamic> data = {
      "order_id": orderId,
      "laundromat_id": laundromatId,
      "customer_id": customerId,
      "total_bags": totalBags,
      "weight": weight,
      "total_price": totalPrice,
    };

    // 🚀 Debugging: Print the request payload before sending
    print("📡 DEBUG: Sending PUT request to: $url");
    print("🔑 Using Token: $token");
    print("📦 Request Payload: $data");

    dynamic response = await _apiService.putApi(data, url);

    print("🔹 API Response: $response"); // Debug API response
    return UpadateTillIdOderModel.fromJson(response);
  }

}
