import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_app/models/home/orders.dart';
import '../../data/network/network_api_services.dart';
// import '../../models/pick_up_pickup_deliver_dropoff_orders_model/pick_up_model.dart';

class PickUpRepository {
  final _apiService = NetworkApiServices();

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");

    if (token == null || token.isEmpty) {
      print("🚨 No auth token found in SharedPreferences!");
    } else {
      print("🔑 Retrieved Token: $token");
    }
    return token;
  }

  Future<String?> _getLaundromatId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("laundromat_id");
  }

  /// **✅ Fetch Pickup Orders with Pagination**
  Future<OrdersModel> pickupListApi(String url, int page) async {
    String? token = await _getToken();
    String? laundromatId = await _getLaundromatId();

    if (token == null || token.isEmpty) {
      throw Exception("Unauthorized: No token found. pickup_repository.dart");
    }
    if (laundromatId == null || laundromatId.isEmpty) {
      throw Exception(
          "Unauthorized: Missing laundromat_id.pickup_repository.dart");
    }

    // ✅ Construct the API URL with pagination
    // String url = "${AppUrl.pickUpApi}?laundromat_id=$laundromatId&page=$page";
    // String url = AppUrl.pickUpApi;
    // String url = AppUrl.dropOffApi;

    try {
      dynamic response = await _apiService.getApi(url);

      print("📡 API Request:pickup_repository.dart $url"); // ✅ Debugging
      print("🔹 API Response:pickup_repository.dart $response");

      if (response == null) {
        throw Exception("Empty response from APIpickup_repository.dart");
      }

      return OrdersModel.fromJson(response);
    } catch (e) {
      print("❌ API Fetch Error:pickup_repository.dart $e");
      throw Exception("Failed to fetch orderspickup_repository.dart");
    }
  }
}
