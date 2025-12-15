import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';
import '../../view_models/controller/user_preference/user_preference_view_model.dart';

class AddNewRepository {
  final _apiService = NetworkApiServices();
  final UserPreference userPreference = UserPreference();
  Future<dynamic> addNewDropOffApi(Map<String, dynamic> dropOffData) async {
    try {
      //print("🚀 Calling addNewDropOffApi...");
     // print("📤 Request Data: $dropOffData");

      dynamic response = await _apiService.postApi(dropOffData, AppUrl.addNewApi);

      //print("✅ API Response: $response");

      return response;
    } catch (error) {
      //print("❌ API Call Failed: $error");
     // print("📌 StackTrace: $stackTrace");
      return {'Result': 'false', 'ResponseMsg': 'API call failed'};
    }
  }
}