import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/create_new_drop_off/generate_receipt_model.dart';
import '../../../repository/create_new_drop_off/generate_dropoff_receipt_repository.dart';

class GenerateReceiptViewModel extends GetxController {
  final GenerateReceiptRepository _repository = GenerateReceiptRepository();

  RxBool isLoading = false.obs;
  Rx<GenerateReceiptModel?> receiptData = Rx<GenerateReceiptModel?>(null);

  Future<String?> _getLaundromatId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("laundromat_id");
  }

  /// ✅ **Fetch Receipt Data**
  Future<void> fetchReceipt(
      String orderId, String customerId, String laundromatId) async {
    String? laundromatId = await _getLaundromatId();

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    var result = await _repository.fetchOrderReceipt(
        orderId, customerId, laundromatId!);
    receiptData.value = result;
    isLoading.value = false;
  }
}
