import 'package:get/get.dart';

import '../../../models/create_new_drop_off/update_customer_model.dart';
import '../../../repository/create_new_drop_off/update_customer_repository.dart';


class UpdateUserController extends GetxController {
  final UpdateUserRepository _updateUserRepository = UpdateUserRepository();

  var isLoading = false.obs;
  var errorMessage = RxnString();
  var updateResponse = Rxn<UpdateCustomerModel>();

  // Method to update user details
  Future<void> updateUser(Map<String, dynamic> updateData) async {
    try {
      isLoading(true);
      errorMessage.value = null;

      UpdateCustomerModel response = await _updateUserRepository.updateUserDetails(updateData);
      updateResponse.value = response;

      print("✅ Update Successful: ${response.responseMsg}");
      Get.snackbar("Success", response.responseMsg ?? "User updated successfully!",
          snackPosition: SnackPosition.BOTTOM);
    } catch (error) {
      errorMessage.value = "❌ Update Failed: $error";
      print(errorMessage.value);
      Get.snackbar("Error", errorMessage.value!,
          snackPosition: SnackPosition.BOTTOM,);
    } finally {
      isLoading(false);
    }
  }
}
