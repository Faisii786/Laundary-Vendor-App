import 'package:get/get.dart';
import 'package:vendor_app/data/network/network_api_services.dart';
import 'package:vendor_app/res/app_url/app_url.dart';

import '../../models/create_new_drop_off/generate_receipt_model.dart';

class GenerateReceiptRepository {
  final NetworkApiServices _apiService = NetworkApiServices();

  /// ✅ **Fetch Order Receipt**
  Future<GenerateReceiptModel?> fetchOrderReceipt(String orderId, String customerId, String laundromatId) async {
    try {
      Map<String, dynamic> requestBody = {
        "order_id": orderId,
        "customer_id": customerId,
        "laundromat_id": laundromatId
      };

      print("📡 DEBUG: Fetching Receipt with Body: $requestBody");

      dynamic response = await _apiService.postApiWithToken(requestBody, AppUrl.dropoffReceiptApi);

      print("🔹 DEBUG: Response Status: ${response['ResponseCode']}");
      print("🔹 DEBUG: Response Body: $response");

      if (response["ResponseCode"] == "200") {
        return GenerateReceiptModel.fromJson(response);
      } else {
        Get.snackbar("Error", response["ResponseMsg"] ?? "Failed to fetch receipt");
        return null;
      }
    } catch (e) {
      print("❌ API Call Error: $e");
      Get.snackbar("Error", "Something went wrong! Please try again.");
      return null;
    }
  }

}
