import 'package:shared_preferences/shared_preferences.dart';
import '../../data/network/network_api_services.dart';
import '../../models/create_new_drop_off/laundry_product_model.dart';
import '../../res/app_url/app_url.dart';

class LaunndryProductRepository {
  final _apiService = NetworkApiServices();
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Debug: Print all stored keys
    Set<String> keys = prefs.getKeys();
    // print("📂 SharedPreferences Keys: $keys");

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
    return prefs.getString("laundromat_id"); // Retrieve stored laundromat_id
  }
  Future<LaundroyProductModel>  LaundromatProductApi() async{
    String? token = await _getToken();
    String? laundromatId = await _getLaundromatId();


    if (token == null || token.isEmpty) {
      //print(" No token found! User must log in.");
      throw Exception("Unauthorized: No token found.");
    }
    if (laundromatId == null || laundromatId.isEmpty) {
      //print("🚨 No laundromat_id found! API requires it.");
      throw Exception("Unauthorized: Missing laundromat_id.");
    }
    //String url = "${AppUrl.pickUpApi}?laundromat_id=$laundromatId";
    dynamic response = await _apiService.getApi(AppUrl.laundryProductApi);
    //print('response');
    return LaundroyProductModel.fromJson(response);
  }


// all home apis here
}
