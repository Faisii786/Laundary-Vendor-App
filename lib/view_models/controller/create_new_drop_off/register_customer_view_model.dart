import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../repository/create_new_drop_off/create_new_custmer_repository.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../user_preference/user_preference_view_model.dart';

class RegisterCustomerViewModel extends GetxController {
  final RegisterCustomerRepository _api = RegisterCustomerRepository();
  UserPreference userPreference = UserPreference();

  // Controllers for user input
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final ccodeController = TextEditingController();
  final addressController = TextEditingController();
  final cityIdController = TextEditingController();
  final stateIdController = TextEditingController();
  final countryIdController =
      TextEditingController(); // New controller for country
  final zipCodeController = TextEditingController();
  final aTypeController = TextEditingController(); // Home / Building
  final elevatorStatusController = TextEditingController(); // 1 / 0

  // Focus nodes for input fields
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final ccodeFocusNode = FocusNode();
  final addressFocusNode = FocusNode();
  final cityFocusNode = FocusNode();
  final stateFocusNode = FocusNode();
  final countryFocusNode = FocusNode(); // New focus node for country
  final zipFocusNode = FocusNode();
  final aTypeFocusNode = FocusNode();
  final elevatorFocusNode = FocusNode();

  RxBool loading = false.obs;
  RxBool isStateEnabled = false.obs;
  RxBool isCityEnabled = false.obs;

  /// ✅ **Register Customer Function**
  void registerCustomer() {
    loading.value = true;

    // Validate required fields
    if (countryIdController.text.isEmpty) {
      loading.value = false;
      Utils.snackBar('Error', 'Please select a country', Colors.yellow,
          SnackPosition.BOTTOM);
      return;
    }

    if (stateIdController.text.isEmpty) {
      loading.value = false;
      Utils.snackBar('Error', 'Please select a state', Colors.yellow,
          SnackPosition.BOTTOM);
      return;
    }

    if (cityIdController.text.isEmpty) {
      loading.value = false;
      Utils.snackBar(
          'Error', 'Please select a city', Colors.yellow, SnackPosition.BOTTOM);
      return;
    }

    _api
        .registerCustomer(
      mobile: phoneController.text.trim(),
      password: passwordController.text.trim(),
      ccode: ccodeController.text.trim(),
      name: nameController.text.trim(),
      address: addressController.text.trim(),
      aType: aTypeController.text.trim(),
      elevatorStatus: elevatorStatusController.text.trim(),
      cityId: cityIdController.text.trim(),
      stateId: stateIdController.text.trim(),
      countryId: countryIdController.text.trim(), // Added countryId
      zipCode: zipCodeController.text.trim(),
      email: emailController.text.trim(),
    )
        .then((value) {
      loading.value = false;

      if (value != null && value.responseCode == "200") {
        // ✅ Save user details
        userPreference.saveUserData(
          userID: value.userID ?? 0,
          mobile: phoneController.text.trim(),
          countryCode: ccodeController.text.trim(),
        );

        Utils.snackBar('Registration', 'User Registered Successfully!',
            Colors.green, SnackPosition.BOTTOM);

        Get.delete<RegisterCustomerViewModel>();
        Get.toNamed(RouteName.homeView);
      } else {
        Utils.snackBar('Error', value?.responseMsg ?? "Registration failed!",
            Colors.yellow, SnackPosition.BOTTOM);
      }
    }).onError((error, stackTrace) {
      loading.value = false;
      Utils.snackBar(
          'Error', error.toString(), Colors.yellow, SnackPosition.BOTTOM);
    });
  }

  // Call this when country changes to enable/disable state dropdown
  void onCountryChanged(String? countryId) {
    countryIdController.text = countryId ?? '';
    stateIdController.text = '';
    cityIdController.text = '';
    isStateEnabled.value = countryId != null;
    isCityEnabled.value = false;
  }

  // Call this when state changes to enable/disable city dropdown
  void onStateChanged(String? stateId) {
    stateIdController.text = stateId ?? '';
    cityIdController.text = '';
    isCityEnabled.value = stateId != null;
  }

  // Call this when city changes
  void onCityChanged(String? cityId) {
    cityIdController.text = cityId ?? '';
  }

  @override
  void onClose() {
    // Dispose all controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    ccodeController.dispose();
    addressController.dispose();
    cityIdController.dispose();
    stateIdController.dispose();
    countryIdController.dispose();
    zipCodeController.dispose();
    aTypeController.dispose();
    elevatorStatusController.dispose();

    // Dispose all focus nodes
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    ccodeFocusNode.dispose();
    addressFocusNode.dispose();
    cityFocusNode.dispose();
    stateFocusNode.dispose();
    countryFocusNode.dispose();
    zipFocusNode.dispose();
    aTypeFocusNode.dispose();
    elevatorFocusNode.dispose();

    super.onClose();
  }
}
