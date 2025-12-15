import '../../data/network/network_api_services.dart';
import '../../models/create_new_drop_off/create_customer_model.dart';
import '../../res/app_url/app_url.dart';
import '../../view_models/controller/user_preference/user_preference_view_model.dart';

class RegisterCustomerRepository {
  final _apiService = NetworkApiServices();
  final UserPreference userPreference = UserPreference(); // ✅ Initialize user preferences

  /// ✅ **Fix: Use Named Parameters in Function Signature**
  Future<RegisterCustomerModel?> registerCustomer({
    required String mobile,
    required String password,
    required String ccode,
    required String name,
    required String address,
    required String aType,
    required String elevatorStatus,
    required String countryId,
    required String cityId,
    required String stateId,
    required String zipCode,
    required String email,
  }) async {
    Map<String, dynamic> requestBody = {
      "email": email,
      "mobile": mobile,
      "ccode": ccode,
      "name": name,
      "address": address,
      "a_type": aType,
      "elevator_status": elevatorStatus,
      "city_id": countryId,
      "city_id": cityId,
      "state_id": stateId,
      "zip_code": zipCode,
      "password": password,
    };

    /// 🔹 **PRINT THE REQUEST DATA BEFORE SENDING TO API**
    print("📡 Sending POST Request with Data: $requestBody");

    try {
      dynamic response = await _apiService.postApi(requestBody, AppUrl.registerCustomerApi);

      /// 🔹 **PRINT THE API RESPONSE**
      print("🔹 API Response: $response");

      if (response["ResponseCode"] == "200") {
        RegisterCustomerModel registerCustomerModel = RegisterCustomerModel.fromJson(response);
        await userPreference.saveUserData(
          userID: registerCustomerModel.userID ?? 0,
          mobile: mobile,
          countryCode: ccode,
        );
        return registerCustomerModel;
      } else {
        return RegisterCustomerModel.fromJson(response);
      }
    } catch (e) {
      print("❌ Error: $e");
      return null;
    }
  }

}
