import 'package:get/get.dart';
import '../../../data/response/status.dart';
import '../../../models/create_new_drop_off/search_by_phone_model.dart';
import '../../../repository/create_new_drop_off/search_by_phone_repository.dart';
import 'create_newdropoff_order_view_model.dart';

class SearchUserByPhoneController extends GetxController {
  final _api = SearchUserRepository();

  final rxRequestStatus = Status.COMPLETED.obs;
  final userData = SeachUserByPNModel().obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  void setUserData(SeachUserByPNModel value) => userData.value = value;

  User? get user => userData.value.user;

  /// Search user by phone number
  void searchUser(String phoneNumber) async {
    setRxRequestStatus(Status.LOADING);

    try {
      final response = await _api.searchUserByPhoneNumber(phoneNumber);
      print("🔎 API Response: ${response.toJson()}");

      if (response.user != null) {
        print(
            "✅ User Found: ${response.user!.id}, Name: ${response.user!.name}");
        setUserData(response);
        setRxRequestStatus(Status.COMPLETED);

        // ✅ Ensure ViewModel is Registered
        if (!Get.isRegistered<CreateDropOffOrderViewModel>()) {
          Get.put(CreateDropOffOrderViewModel()); // ✅ Register if missing
        }

        // ✅ Store customer_id in CreateDropOffOrderViewModel
        final orderController = Get.find<CreateDropOffOrderViewModel>();
        orderController.customerId.value = response.user!.id.toString();
        print("✅ Customer ID Set: ${response.user!.id}");
      } else {
        print("❌ User Not Found - Response: ${response.toJson()}");
        setRxRequestStatus(Status.ERROR);
      }
    } catch (error) {
      print("❌ API Error: $error");
      setRxRequestStatus(Status.ERROR);
    }
  }
}
