import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_app/res/app_url/app_url.dart';

class AcceptOrderViewModel extends GetxController {
  // final String _endpoint = 'http://93.127.202.7:8080/laundry_api/change_status.php';
  final String _endpoint = AppUrl.orderconfirmApi;
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

  Future<Map<String, dynamic>> changeOrderStatus({
    required int orderId,
    required String orderStatus,
    required String userid,
  }) async {
    String? token = await _getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Unauthorized: No token found. pickup_repository.dart");
    }

    // Prepare request body
    final Map<String, dynamic> requestBody = {
      "order_id": orderId,
      "order_status": orderStatus,
      "user_id": userid,
    };

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          "Security-Token": token, // ✅ Include the security token
          'Content-Type': 'application/json'
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Example responseBody:
        // {
        //   "ResponseCode": "200",
        //   "Result": "true",
        //   "ResponseMsg": "Order status updated successfully!"
        // }

        if (responseBody['ResponseCode'] == "200" &&
            responseBody['Result'] == "true") {
          return {
            'success': true,
            'message': responseBody['ResponseMsg'],
          };
        } else {
          return {
            'success': false,
            'message': responseBody['ResponseMsg'] ?? 'Unknown error',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Exception: $e',
      };
    }
  }
}
