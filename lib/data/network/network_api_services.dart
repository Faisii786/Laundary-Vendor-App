// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../app_exceptions.dart';
// import 'base_api_services.dart';
// class NetworkApiServices extends BaseApiServices{
//   Future<String?> _getToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString("auth_token"); // Retrieve the token dynamically
//   }
//   @override
//   Future<dynamic> getApi(String url,   ) async {
//     dynamic responseJson;
//     try {
//       print("📡 Sending GET request to: $url");
//
//       final response = await http.get(
//         Uri.parse(url),
//           headers: {
//             "Security-Token": token,
//           }, // ✅ Pass headers here
//       ).timeout(const Duration(seconds: 10));
//
//       print("🔹 Response Status: ${response.statusCode}");
//       print("🔹 Response Body: ${response.body}");
//
//       responseJson = returnResponse(response);
//     } on SocketException {
//       print("🚨 No Internet Connection!");
//       throw InternetException('');
//     } on RequestTimeOut {
//       throw RequestTimeOut('');
//     }
//     return responseJson;
//   }
//   // Future<dynamic> getApi(String url, ) async{
//   //   dynamic responseJson;
//   //   try{
//   //     print("response");
//   //     final  response = await http.get(Uri.parse(url),
//   //     ).timeout(const Duration(seconds: 10));
//   //     print("response");
//   //     responseJson = returnResponse(response);
//   //   }on SocketException{
//   //     print("socket exception");
//   //     throw InternetException('');
//   //   }on RequestTimeOut{
//   //     throw RequestTimeOut('');
//   //   }
//   //   if(kDebugMode) {
//   //     print(responseJson);
//   //   }
//   //   return responseJson;
//   //
//   // }
//
//   @override
//   Future<dynamic> postApi(dynamic data, String url) async{
//
//     if (kDebugMode) {
//       print("Sending POST request to: $url");
//       //print("Data: $data");
//     }
//     print("Sending POST request to: $url");
//     //print("Data: $data");
//     dynamic responseJson;
//     try{
//
//       final  response = await http.post(Uri.parse(url),
//           headers: {
//             "Content-Type": "application/json",
//           },
//           // body: jsonEncode({
//           //   "mobile": mobile,
//           //   "password": password,
//           //   "ccode": ccode,
//           //   }),
//       body: jsonEncode(data) //if not in raw form otherwise just body: data
//       ).timeout(const Duration(seconds: 10));
//       print("Response Headers: ${response.headers}");
//       print("Response Status: ${response.statusCode}");
//       print("Response Body: ${response.body}");
//       responseJson = returnResponse(response);
//     }on SocketException{
//       throw InternetException('');
//     }on RequestTimeOut{
//       throw RequestTimeOut('');
//     }
//
//     return responseJson;
//
//   }
//   dynamic returnResponse(http.Response response){
//     switch(response.statusCode){
//       case 200:
//         dynamic responseJson = jsonDecode(response.body);
//         return responseJson;
//
//       case 400:
//         // dynamic responseJson = jsonDecode(response.body); //return reponse bcz bckn developer set 200 to errors
//         // return responseJson;// same
//         throw InvalidUrlException;
//
//       case 401:
//         throw FetchDataException("Unauthorized! Invalid email or password.");
//
//       case 500:
//         throw ServerException("Internal Server Error!");
//       default:
//         throw FetchDataException("Error occurred while communicating with server: ${response.statusCode}");
//     }
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

import '../app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token"); // Retrieve the token dynamically
  }

  Future<String?> _getLaundromatId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("laundromat_id"); // ✅ Retrieve laundromat_id
  }

  Future<void> saveLaundromatID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("laundromat_id", id); // ✅ Store laundromat_id
    print("✅ Laundromat ID Saved: $id");
  }

  @override
  Future<dynamic> getApi(String url) async {
    dynamic responseJson;
    try {
      print("📡 Sending GET (POST) request to: $url");

      // Fetch stored token & laundromat ID
      String? token = await _getToken();
      String? laundromatId = await _getLaundromatId();

      if (token == null || token.isEmpty) {
        print("🚨 No token found! User must log in.");
        throw Exception("Unauthorized: No token found.");
      }

      if (laundromatId == null || laundromatId.isEmpty) {
        print("🚨 No laundromat_id found! API requires it.");
        throw Exception("Unauthorized: Missing laundromat_id.");
      }

      // ✅ Convert `laundromat_id` into a JSON body
      Map<String, dynamic> body = {
        "laundromat_id": laundromatId, // 🔹 Send in request body
        // "page": 1,
        // "limit": 200
      };

      print("📡 Sending Request Body: ${jsonEncode(body)}");

      final response = await http
          .post(
            // ✅ Use `POST` instead of `GET`
            Uri.parse(url),
            headers: {
              "Security-Token": token, // ✅ Include the security token
              "Content-Type": "application/json",
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      print("🔹 Response Status: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      responseJson = returnResponse(response);
    } on SocketException {
      print("🚨 No Internet Connection!");
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    return responseJson;
  }

  /// ✅ **Handle API Response**

  @override
  Future<dynamic> postApi(dynamic data, String url) async {
    dynamic responseJson;
    try {
      print("📡 Sending POST request to: $url");
      // ✅ Fetch stored token
      // String? token = await _getToken();
      // if (token == null || token.isEmpty) {
      //   print("🚨 No token found! User must log in.");
      //   throw Exception("Unauthorized: No token found.");
      // }
      // print("🔑 Using Token: $token");

      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              //"Security-Token": token,
              "Content-Type": "application/json",
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      print("🔹 Response Headers: ${response.headers}");
      print("🔹 Response Status: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    return responseJson;
  }

  // @override
  Future<dynamic> postApiWithToken(dynamic data, String? url) async {
    dynamic responseJson;

    try {
      print("📡 DEBUG: Preparing to send POST request...");

      // ✅ Validate URL
      if (url == null || url.isEmpty) {
        print("🚨 ERROR: API URL is missing!");
        throw Exception("API URL is null or empty.");
      }

      print("📡 DEBUG: API URL: $url");

      // ✅ Fetch Security Token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");
      String? laundromatId = prefs.getString("laundromat_id");
      // int? laundromatId = prefs.getInt("laundromat_id");

      if (token == null || token.isEmpty) {
        print("🚨 ERROR: No auth token found! User must log in.");
        throw Exception("Unauthorized: No Security Token found.");
      }
      if (laundromatId == null || laundromatId == 0) {
        print("🚨 ERROR: No laundromat_id found! API requires it.");
        throw Exception("Unauthorized: Missing laundromat_id.");
      }

      print("🔑 DEBUG: Using Token: $token");
      print("🏪 DEBUG: Laundromat ID: $laundromatId");

      // ✅ Add laundromat_id to request body
      // data["laundromat_id"] = laundromatId;

      print("📡 DEBUG: Sending Request Data: ${jsonEncode(data)}");

      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              "Security-Token": token, // ✅ Automatically set the Security-Token
              "Content-Type": "application/json",
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30)); // ⏳ Increased Timeout

      // ✅ Print API Response
      print("🔹 DEBUG: Response Headers: ${response.headers}");
      print("🔹 DEBUG: Response Status: ${response.statusCode}");
      print("🔹 DEBUG: Response Body: ${response.body}");

      // ✅ Check response format
      responseJson = returnResponse(response);
    } catch (e) {
      print("❌ ERROR: API Call Exception in network_api_services.dart: $e");
      throw Exception("API call failed: $e");
    }

    return responseJson;
  }

  // @override
  Future<dynamic> putApi(dynamic data, String url) async {
    dynamic responseJson;
    try {
      print("📡 Sending PUT request to: $url");

      // ✅ Fetch stored token
      String? token = await _getToken();
      if (token == null || token.isEmpty) {
        print("🚨 No token found! User must log in.");
        throw Exception("Unauthorized: No token found.");
      }
      print("🔑 Using Token: $token");

      final response = await http
          .put(
            Uri.parse(url),
            headers: {
              "Security-Token": token, // ✅ Include authentication token
              "Content-Type": "application/json",
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      print("🔹 Response Headers: ${response.headers}");
      print("🔹 Response Status: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    return responseJson;
  }

  Future<dynamic> sendnotification(String url) async {
    dynamic responseJson;
    try {
      print("📡 Sending POST request to: $url");

      final response = await http
          .get(
            Uri.parse(url),
          )
          .timeout(const Duration(seconds: 10));

      print("🔹 Response Headers: ${response.headers}");
      print("🔹 Response Status: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    return responseJson;
  }

  Future<dynamic> searchPostApi(dynamic data, String url) async {
    dynamic responseJson;
    try {
      print("📡 Sending POST request to: $url");
      // ✅ Fetch stored token
      String? token = await _getToken();
      if (token == null || token.isEmpty) {
        print("🚨 No token found! User must log in.");
        throw Exception("Unauthorized: No token found.");
      }
      print("🔑 Using Token: $token");

      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              "Security-Token": token,
              "Content-Type": "application/json",
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      print("🔹 Response Headers: ${response.headers}");
      print("🔹 Response Status: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    return responseJson;
  }

  // @override
  Future<dynamic> getApiWithPagination(String url,
      {int page = 1, int limit = 10, Map<String, dynamic>? filters}) async {
    dynamic responseJson;
    try {
      print("📡 Sending GET request with pagination to: $url");

      // ✅ Fetch stored token & laundromat ID
      String? token = await _getToken();
      String? laundromatId = await _getLaundromatId();

      if (token == null || token.isEmpty) {
        print("🚨 No token found! User must log in.networkApiServices.dart");
        throw Exception("Unauthorized: No token found.");
      }

      if (laundromatId == null || laundromatId.isEmpty) {
        print(
            "🚨 No laundromat_id found! API requires it.networkApiServices.dart");
        throw Exception("Unauthorized: Missing laundromat_id.");
      }

      // ✅ Construct Request Body with pagination & filters
      Map<String, dynamic> requestBody = {
        "laundromat_id": laundromatId,
        "page": page,
        "limit": limit,
        "filters":
            filters ?? {} // Send filters if provided, else send empty object
      };

      final response = await http
          .post(
            // ✅ Use POST to send body data
            Uri.parse(url),
            headers: {
              "Security-Token": token,
              "Content-Type": "application/json",
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 10));

      print(
          "🔹 Response Status:networkApiServices.dart ${response.statusCode}");
      print("🔹 Response Body:networkApiServices.dart ${response.body}");

      responseJson = returnResponse(response);
    } on SocketException {
      print("🚨 No Internet Connection!networkApiServices.dart");
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw InvalidUrlException;
      case 401:
        throw FetchDataException(
            "🚨 Unauthorized! Invalid or expired token.networkApiServices.dart");
      case 500:
        throw ServerException(
            "❌ Internal Server Error!networkApiServices.dart");
      default:
        throw FetchDataException(
            "Error occurred while communicating with server: networkApiServices.dart: ${response.statusCode}");
    }
  }
}
