import '../../data/network/network_api_services.dart';
import '../../models/create_new_drop_off/create_dropoff_model.dart';
import '../../res/app_url/app_url.dart';
import '../../view_models/controller/user_preference/user_preference_view_model.dart';

class CreateNewDropOffOrderRepository {
  final NetworkApiServices _apiService = NetworkApiServices();
  final UserPreference userPreference = UserPreference();

  /// ✅ **Create Drop-Off Order API Call with Security Token**
  Future<CreateDropOffOrderModel?> createDropOffOrder(
      Map<String, dynamic> orderData) async {
    try {
      // 🔹 Fetch Security Token
      String? token = await userPreference.getToken();
      if (token == null || token.isEmpty) {
        print("🚨 Error: Security token is missing!");
        return null;
      }

      // ✅ Ensure correct headers
      Map<String, String> headers = {
        "Security-Token": token,
        "Content-Type": "application/json"
      };

      // 🔹 Print the API request details
      print("📡 DEBUG: Sending Order Request");
      print("📡 API URL: ${AppUrl.createDropOffOrderApi}");
      print("📡 Request Headers: $headers");
      //print("📡 Request Data: ${jsonEncode(orderData)}");

      print("Danger order data: $orderData");

      // ✅ Call the API
      dynamic response = await _apiService.postApiWithToken(
          orderData, AppUrl.createDropOffOrderApi);

      // 🔹 Print API response
      print("🔹 Response Status: ${response['ResponseCode']}");
      print("🔹 Full Response Body: $response");

      if (response["ResponseCode"] == "200") {
        print(
            "✅ Order Created Successfully! Order ID: ${response['order_id']}");
        return CreateDropOffOrderModel.fromJson(response);
      } else {
        print("❌ API Error: ${response['ResponseMsg']}");
        print("Token: $token");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }
}
