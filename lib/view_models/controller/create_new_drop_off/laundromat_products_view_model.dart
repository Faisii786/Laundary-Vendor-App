import 'package:get/get.dart';
import '../../../models/create_new_drop_off/laundry_product_model.dart';
import '../../../repository/create_new_drop_off/launndry_product_repository.dart';

class LaundromatProductsViewModel extends GetxController {
  final _api = LaunndryProductRepository();
  var loading = true.obs;
  var productList = <Products>[].obs;
  var productPrices = <String, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLaundromatProducts(); // Fetch products when ViewModel is initialized
  }

  /// **Fetch product list from API**
  Future<void> fetchLaundromatProducts() async {
    try {
      loading.value = true;
      var response = await _api.LaundromatProductApi();

      if (response.products != null && response.products!.isNotEmpty) {
        productList.value = response.products!;

        // ✅ Extract and store base prices
        for (var product in response.products!) {
          double basePrice = double.tryParse(product.basePrice ?? "0") ?? 0.0;
          productPrices[product.productName ?? ""] = basePrice;
        }

        print("📦 Product Prices Loaded: $productPrices");
      }
    } catch (e) {
      print("❌ Error fetching products: $e");
    } finally {
      loading.value = false;
    }
  }
}
