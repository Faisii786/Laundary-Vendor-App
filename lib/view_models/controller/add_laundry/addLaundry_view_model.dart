import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/models/addlaundry/zones.dart';
import 'package:vendor_app/repository/addlaundry/addLaundry_repository.dart';
import 'package:vendor_app/res/routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../user_preference/user_preference_view_model.dart';

class AddlaundryViewModel extends GetxController {
  final _api = AddlaundryRepository();
  UserPreference userPreference = UserPreference();
  RxList zones = <Zone>[].obs;
  var zonesList = [].obs;

  RxBool loading = false.obs;
  void fetchzonesApi() async {
    loading.value = true;
    // Send the request to the API

    _api.fetchzapi().then((value) async {
      // print("DEBUG DEBUG: Fetch zones successful:: $value");
      try {
        loading.value = false;

        print("Unexpected type for zones: ${value.runtimeType}");
        print(
            "DEBUG DEBUG: Fetch zones successful:: ${value['zones'].runtimeType}");
        print(
            "DEBUG DEBUG: Fetch zones successful:: ${value['zones'][0]['coordinates'].runtimeType}");
        zonesList.value = value['zones'];
        print("DEBUG: Zones List: $zonesList");
        // if (value['zones'] is Map<String, dynamic>) {
        //   zones.value = (value['zones'] as Map<String, dynamic>)
        //       .values
        //       .map((zone) => Zone.fromJson(zone as Map<String, dynamic>))
        //       .toList();
        // } else if (value['zones'] is List) {
        //   zones.value = (value['zones'] as List<dynamic>)
        //       .map((zone) => Zone.fromJson(zone as Map<String, dynamic>))
        //       .toList();
        // } else {
        //   print("Unexpected type for zones: ${value['zones'].runtimeType}");
        // }
// ((((((((((((((((((((((((((((((((((((()))))))))))))))))))))))))))))))))))))
        // loading.value = false;
        // if (value['Result'].toString().toLowerCase() == 'true') {
        //   print("DEBUG: Fetch zones successful: $value");
        //   // Get.delete<SignupViewModel>();
        //   // Get.toNamed(RouteName.loginView);

        //   // Utils.snackBar('signup', 'signup Successful!', Colors.green,
        //   //     SnackPosition.BOTTOM);
        // } else {
        //   print("DEBUG: Fetch zones failed: $value");
        //   loading.value = false;
        //   // Utils.snackBar('Error', value['ResponseMsg'] ?? "signup failed!",
        //   //     Colors.red, SnackPosition.BOTTOM);
        // }
      } catch (e) {
        print("ERROR: An error occurred while fetching data: $e");
      }
    }).onError((error, stackTrace) {
      loading.value = false;
      Utils.snackBar(
          'Error', error.toString(), Colors.red, SnackPosition.BOTTOM);
    });
  }

  void addlaundryApi(Map<String, dynamic> data) async {
    loading.value = true;
    // Send the request to the API

    _api.addlaundapi(data).then((value) async {
      // print("DEBUG DEBUG: Fetch zones successful:: $value");
      try {
// ((((((((((((((((((((((((((((((((((((()))))))))))))))))))))))))))))))))))))
        loading.value = false;
        if (value['Result'].toString().toLowerCase() == 'true') {
          print("DEBUG: laundry add successful: $value");
          Get.delete<AddlaundryViewModel>();
          Get.toNamed(RouteName.loginView);

          Utils.snackBar('Added', 'laundry added successfully!', Colors.green,
              SnackPosition.BOTTOM);
        } else {
          print("DEBUG: laundry add failed: $value");
          loading.value = false;
          // Utils.snackBar('Error', value['ResponseMsg'] ?? "signup failed!",
          //     Colors.red, SnackPosition.BOTTOM);
        }
      } catch (e) {
        print("ERROR: An error occurred while fetching data: $e");
      }
    }).onError((error, stackTrace) {
      loading.value = false;
      Utils.snackBar(
          'Error', error.toString(), Colors.red, SnackPosition.BOTTOM);
    });
  }
}
