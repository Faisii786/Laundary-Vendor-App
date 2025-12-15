import 'package:get/get.dart';

import '../../../repository/add_new_repository/add_new_repository.dart';

class AddNewDropOffViewModel extends GetxController {
  final  _api = AddNewRepository();
  var isLoading = false.obs;
  var responseMessage = ''.obs;

  Future<void> addNewDropOff(Map<String, dynamic> dropOffDetails) async {
    isLoading.value = true;
    try {
      var response = await _api.addNewDropOffApi(dropOffDetails);

      if (response['Result'] == 'true') {
        responseMessage.value = response['message'] ?? 'Drop-off added successfully';
        Get.snackbar("Success", responseMessage.value, snackPosition: SnackPosition.BOTTOM);
      } else {
        responseMessage.value = response['ResponseMsg'] ?? 'Failed to add drop-off';
        Get.snackbar("Error", responseMessage.value, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      responseMessage.value = "An error occurred: $e";
      Get.snackbar("Error", responseMessage.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}