// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../../../repository/create_new_drop_off/create_new_dropoff_order_repository.dart';
// import '../../../utils/utils.dart';
// import '../user_preference/user_preference_view_model.dart';
//
// class CreateDropOffOrderViewModel extends GetxController {
//   final CreateNewDropOffOrderRepository _orderRepository = CreateNewDropOffOrderRepository();
//   final UserPreference userPreference = UserPreference();
//
//   // ✅ Store IDs
//   var customerId = ''.obs;
//   var laundromatId = ''.obs; // Retrieve laundromat ID dynamically
//
//   final orderInstructionsController = TextEditingController();
//   final orderAddressController = TextEditingController();
//   final aptNoController = TextEditingController();
//   final totalPriceController = TextEditingController();
//   final floorController = TextEditingController();
//
//   var orderType = 'pickup & delivery'.obs;
//   var orderStatus = 'pending'.obs;
//   var paymentMethod = 'cash'.obs;
//   var deliveryMethod = 'standard'.obs;
//   var deliveryType = 'same day'.obs;
//   var houseStatus = 'building'.obs;
//   var elevatorStatus = '0'.obs;
//   var deliveryStatus = 'leave at the door'.obs;
//   var deliveryTime = DateTime.now().obs;
//
//   var orderTemp = <String>[].obs;
//   var pickUpTime = <String>["17:56", "17:56"].obs;
//   var productType = <int>[4, 5].obs;
//   var variationId = <int>[1].obs;
//   var quantity = <int>[2, 180].obs;
//   var price = <double>[55, 33].obs;
//
//   RxBool loading = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // ✅ Get passed data from previous screen
//     var args = Get.arguments;
//     if (args != null && args["user_id"] != null) {
//       customerId.value = args["user_id"].toString();
//     }
//
//     // ✅ Fetch laundromat ID from SharedPreferences
//     //_getLaundromatId();
//   }
//
//   /// **Fetch laundromat ID from SharedPreferences**
//   // Future<void> _getLaundromatId() async {
//   //   int? id = await userPreference.getUserID();
//   //
//   //   if (id != null) {
//   //     laundromatId.value = id.toString();  // ✅ Convert int to String before assigning
//   //   } else {
//   //     print("🚨 ERROR: Laundromat ID not found in SharedPreferences!");
//   //   }
//   //
//   //   print("🏪 Laundromat ID set: ${laundromatId.value}");
//   // }
//
//   /// **Allow user to pick delivery date**
//   Future<void> selectDeliveryDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: deliveryTime.value,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null) {
//       deliveryTime.value = picked;
//     }
//   }
//
//   /// **Validate Required Fields Before Sending API Request**
//   bool _validateFields() {
//     if (customerId.value.isEmpty) {
//       Utils.snackBar('Error', 'Customer ID is missing. Please select a user.');
//       return false;
//     }
//     // if (laundromatId.value.isEmpty) {
//     //   Utils.snackBar('Error', 'Laundromat ID is missing.');
//     //   return false;
//     // }
//     if (orderAddressController.text.trim().isEmpty) {
//       Utils.snackBar('Error', 'Order Address is required.');
//       return false;
//     }
//     if (aptNoController.text.trim().isEmpty) {
//       Utils.snackBar('Error', 'Apartment Number is required.');
//       return false;
//     }
//     if (totalPriceController.text.trim().isEmpty) {
//       Utils.snackBar('Error', 'Total Price is required.');
//       return false;
//     }
//     return true;
//   }
//
//   /// **Create Drop-Off Order API Call**
//   Future<void> createOrder() async {
//     if (!_validateFields()) return;
//
//     loading.value = true;
//
//     // ✅ Validate IDs before proceeding
//     if (customerId.value.isEmpty) {
//       Utils.snackBar('Error', 'Customer or Laundromat ID is missing.');
//       loading.value = false;
//       return;
//     }
//
//     // ✅ Ensure valid pickup time
//     if (pickUpTime.isEmpty) {
//       pickUpTime.add(DateFormat('HH:mm').format(DateTime.now()));
//     }
//
//     Map<String, dynamic> orderData = {
//       "customer_id": int.parse(customerId.value),  // ✅ Convert to integer
//       //"laundromat_id": laundromatId.value, // ✅ Already an integer
//       "order_type": orderType.value,
//       "order_status": orderStatus.value,
//       "pickuptime": pickUpTime,
//       "product_type": productType,
//       "variation_id": variationId,
//       "quantity": quantity,
//       "price": price.map((e) => e.toDouble()).toList(), // ✅ Ensure Double format
//       "total_price": totalPriceController.text.trim(),
//       "payment": paymentMethod.value,
//       "delivery_method": deliveryMethod.value,
//       "delivery_type": deliveryType.value,
//       "order_instructions": orderInstructionsController.text.trim(),
//       "order_address": orderAddressController.text.trim(),
//       "order_temp": orderTemp,
//       "house_status": houseStatus.value,
//       "apt_no": aptNoController.text.trim(),
//       "elevator_status": int.tryParse(elevatorStatus.value) ?? 0, // ✅ Convert to int
//       "floor": int.tryParse(floorController.text.trim()) ?? 1, // ✅ Convert to int
//       "delivery_status": deliveryStatus.value,
//       "delivery_time": DateFormat('dd-MM-yyyy').format(deliveryTime.value),
//     };
//
//
//     // ✅ Print data before sending API call
//     print("📡 Order Data: ${orderData}");
//
//     try {
//       var response = await _orderRepository.createDropOffOrder(orderData);
//
//       if (response != null && response.responseCode == "200") {
//         Utils.snackBar('Success', 'Order Created Successfully!');
//         Get.back(); // Navigate back after order creation
//       } else {
//         Utils.snackBar('Error', response?.result ?? "Order creation failed!");
//       }
//     } catch (e) {
//       Utils.snackBar('Error', 'Something went wrong! Please try again.');
//       print("❌ API Call Error: $e");
//     } finally {
//       loading.value = false;
//     }
//   }
// }
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../repository/create_new_drop_off/create_new_dropoff_order_repository.dart';
import '../../../repository/create_new_drop_off/launndry_product_repository.dart';
import '../user_preference/user_preference_view_model.dart';

class CreateDropOffOrderViewModel extends GetxController {
  var loading = false.obs;
  final CreateNewDropOffOrderRepository _orderRepository =
      CreateNewDropOffOrderRepository();
  final UserPreference userPreference = UserPreference();

  // ✅ Store IDs
  var customerId = ''.obs;
  var laundromatId = ''.obs;

  // 🔹 Fixed Order Type
  final orderType = "dropoff".obs;

  // 🔹 Dropdown Selections
  var paymentMethod = "cash".obs;
  var deliveryMethod = "same day".obs;
  var temperature = "Hot".obs;
  var deliveryStatus = "Hand to Hand".obs;

  // 🔹 Multi-Select Products
  var selectedProducts = <String>[].obs;
  var productVariations = <String, String>{}.obs;
  var productQuantities = <String, int>{}.obs;
  var productPrices = <String, double>{}.obs; // Store product base prices
  // 🔹 Order Instructions & Price
  var totalPriceController = TextEditingController();
  var orderInstructionsController = TextEditingController();
  var totalAmount = 0.0.obs; // Stores calculated total price

  // 🔹 Quantity Controllers for Manual Input
  var manualQuantityControllers = <String, TextEditingController>{};

  // 🔹 Delivery Date
  var deliveryTime = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();

    // ✅ Get passed data from previous screen
    var args = Get.arguments;
    if (args != null && args["user_id"] != null) {
      customerId.value = args["user_id"].toString();
    }

    // ✅ Fetch laundromat ID from SharedPreferences
    _getLaundromatId();
    fetchAllProductPrices(); // ✅ Fetch product prices from API
  }

  /// **Fetch laundromat ID from SharedPreferences**
  Future<void> _getLaundromatId() async {
    String? id = await userPreference.getLaundromatID(); // <-- Correct method
    if (id != null && id.isNotEmpty) {
      laundromatId.value = id;
      print("🏪 Laundromat ID: $id");
    } else {
      print("🚨 ERROR: Laundromat ID not found!");
    }
  }

  /// **Fetch all product base prices from API**
  Future<void> fetchAllProductPrices() async {
    try {
      var productList =
          await LaunndryProductRepository().LaundromatProductApi();

      if (productList.products != null) {
        for (var product in productList.products!) {
          String productName =
              product.productName?.trim() ?? ""; // ✅ Remove extra spaces
          double basePrice = double.tryParse(product.basePrice ?? "0") ?? 0.0;
          productPrices[productName] = basePrice;
        }
      }

      print("📦 Loaded Product Prices: $productPrices"); // ✅ Debugging
    } catch (e) {
      print("❌ Error fetching product prices: $e");
    }
  }

  void toggleProductSelection(String product) {
    if (selectedProducts.contains(product)) {
      selectedProducts.remove(product);
      productVariations.remove(product);
      productQuantities.remove(product);
      manualQuantityControllers.remove(product);
    } else {
      selectedProducts.add(product);
      productQuantities[product] = 1;
      if (product == "Comforter" || product == "Blanket") {
        productVariations[product] = "Single";
      }
      if (product == "Clothes") {
        manualQuantityControllers[product] = TextEditingController(text: "1");

        // ✅ Call calculateTotalPrice when weight changes
        manualQuantityControllers[product]!.addListener(() {
          calculateTotalPrice();
        });
      }
    }

    calculateTotalPrice(); // ✅ Update total price when a product is selected/deselected
  }

  // /// **Toggle Product Selection**
  // void toggleProductSelection(String product) {
  //   if (selectedProducts.contains(product)) {
  //     selectedProducts.remove(product);
  //     productVariations.remove(product);
  //     productQuantities.remove(product);
  //     manualQuantityControllers.remove(product);
  //   } else {
  //     selectedProducts.add(product);
  //     productQuantities[product] = 1;
  //     if (product == "Comforter" || product == "Blanket") {
  //       productVariations[product] = "Single";
  //     }
  //     if (product == "Clothes") {
  //       manualQuantityControllers[product] = TextEditingController(text: "1");
  //     }
  //   }
  //   calculateTotalPrice();
  // }

  /// **Update Variation for a Product**
  void updateVariation(String product, String variation) {
    if (productVariations.containsKey(product)) {
      productVariations[product] = variation;
    }
  }

  /// **Get Variation for a Product**
  RxString getVariation(String product) {
    return productVariations.containsKey(product)
        ? productVariations[product]!.obs
        : "".obs;
  }

  /// **Increase Quantity for a Product**
  void increaseQuantity(String product) {
    if (productQuantities.containsKey(product)) {
      productQuantities[product] = productQuantities[product]! + 1;
      calculateTotalPrice();
    }
  }

  /// **Decrease Quantity for a Product**
  void decreaseQuantity(String product) {
    if (productQuantities.containsKey(product) &&
        productQuantities[product]! > 1) {
      productQuantities[product] = productQuantities[product]! - 1;
      calculateTotalPrice();
    }
  }

  void calculateTotalPrice() {
    double total = 0.0;

    for (String product in selectedProducts) {
      double basePrice = productPrices[product.trim()] ?? 0.0; // ✅ Trim spaces

      if (product == "Clothes") {
        int weight = int.tryParse(getQuantityController(product).text) ?? 1;
        total += weight * basePrice; // ✅ Use weight for Clothes
      } else {
        int quantity = getQuantity(product);
        total += quantity * basePrice; // ✅ Use quantity for others
      }
    }

    totalAmount.value = total;
    totalPriceController.text = total.toStringAsFixed(2);
  }

  // /// **Calculate Total Price**
  // void calculateTotalPrice() {
  //   double total = 0.0;
  //   for (String product in selectedProducts) {
  //     int quantity = productQuantities[product] ?? 1;
  //     double basePrice = productPrices[product] ?? 0.0;
  //     total += quantity * basePrice;
  //   }
  //   totalAmount.value = total;
  //
  //   // ✅ Update the total price field
  //   totalPriceController.text = total.toStringAsFixed(2);
  // }

  /// **Get Quantity for a Product**
  int getQuantity(String product) {
    return productQuantities.containsKey(product)
        ? productQuantities[product]!
        : 1;
  }

  /// **Get TextEditingController for Manual Quantity Input (Only for Clothes)**
  // TextEditingController getQuantityController(String product) {
  //   if (!manualQuantityControllers.containsKey(product)) {
  //     manualQuantityControllers[product] = TextEditingController(text: "1");
  //   }
  //   return manualQuantityControllers[product]!;
  // }

  TextEditingController getQuantityController(String product) {
    if (!manualQuantityControllers.containsKey(product)) {
      manualQuantityControllers[product] = TextEditingController(text: "1");

      // ✅ Update total price when weight changes
      manualQuantityControllers[product]!.addListener(() {
        calculateTotalPrice();
      });
    }
    return manualQuantityControllers[product]!;
  }

  /// **Select Delivery Date**
  Future<void> selectDeliveryDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: deliveryTime.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (pickedDate != null) {
      deliveryTime.value = pickedDate;
    }
  }

  // /// **Create Order API Call**
  // Future<void> createOrder(Function(String, String) onSuccess) async {
  //   loading.value = true;
  //   if (customerId.value.isEmpty) {
  //     Get.snackbar("Error", "Customer ID is missing. Please select a customer.",
  //         backgroundColor: Colors.red, colorText: Colors.white);
  //     loading.value = false;
  //     return;
  //   }
  //   if (selectedProducts.isEmpty) {
  //     Get.snackbar("Error", "Please select at least one product.",
  //         backgroundColor: Colors.transparent, colorText: Colors.white);
  //     loading.value = false;
  //     return;
  //   }
  //
  //   if (totalPriceController.text.trim().isEmpty) {
  //     Get.snackbar("Error", "Total price cannot be empty.",
  //         backgroundColor: Colors.red, colorText: Colors.white);
  //     loading.value = false;
  //     return;
  //   }
  //
  //   List<int> productTypes = [];
  //   List<int> variationIds = [];
  //   List<int> quantities = [];
  //   List<double> prices = [];
  //
  //   for (String product in selectedProducts) {
  //     if (product == "Comforter") {
  //       productTypes.add(4);
  //       variationIds.add(productVariations[product] == "Single" ? 1 : 2);
  //     } else if (product == "Blanket") {
  //       productTypes.add(1);
  //       variationIds.add(productVariations[product] == "Single" ? 1 : 2);
  //     } else if (product == "Clothes") {
  //       productTypes.add(5);
  //       variationIds.add(0);
  //     }
  //     quantities.add(getQuantity(product));
  //     prices.add(productPrices[product] ?? 0.0);
  //   }
  //
  //   Map<String, dynamic> orderData = {
  //     "customer_id": customerId.value,
  //     "laundromat_id": laundromatId.value,
  //     "order_type": orderType.value,
  //     "payment_method": paymentMethod.value,
  //     "delivery_method": deliveryMethod.value,
  //     "product_type": productTypes,
  //     "variation_id": variationIds,
  //     "quantity": quantities,
  //     "price": prices, // ✅ Include product prices
  //     "temperature": temperature.value,
  //     "delivery_status": deliveryStatus.value,
  //     "order_instructions": orderInstructionsController.text.trim(),
  //     "total_price": totalPriceController.text.trim(),
  //     "delivery_time": DateFormat('yyyy-MM-dd').format(deliveryTime.value),
  //   };
  //
  //   print("📡 Sending Order Data: $orderData");
  //
  //   try {
  //     var response = await _orderRepository.createDropOffOrder(orderData);
  //
  //     if (response != null && response.responseCode == "200") {
  //       String orderId = response.orderId.toString();
  //       print("✅ Order Created Successfully! Order ID: $orderId, Customer ID: ${customerId.value}");
  //
  //       onSuccess(orderId, customerId.value);
  //     } else {
  //       print("❌ Order Creation Failed: ${response?.result}");
  //       Get.snackbar("Error", response?.result ?? "Order creation failed!",
  //           backgroundColor: Colors.red, colorText: Colors.white);
  //     }
  //   } catch (e) {
  //     print("❌ API Call Error: $e");
  //     Get.snackbar("Error", "Something went wrong! Please try again.",
  //         backgroundColor: Colors.red, colorText: Colors.white);
  //   } finally {
  //     loading.value = false;
  //   }
  // }
  Future<void> createOrder(Function(String, String) onSuccess) async {
    loading.value = true;

    if (customerId.value.isEmpty) {
      Get.snackbar("Error", "Customer ID is missing. Please select a customer.",
          backgroundColor: Colors.red, colorText: Colors.white);
      loading.value = false;
      return;
    }

    if (selectedProducts.isEmpty) {
      Get.snackbar("Error", "Please select at least one product.",
          backgroundColor: Colors.red, colorText: Colors.white);
      loading.value = false;
      return;
    }

    if (totalPriceController.text.trim().isEmpty) {
      Get.snackbar("Error", "Total price cannot be empty.",
          backgroundColor: Colors.red, colorText: Colors.white);
      loading.value = false;
      return;
    }

    List<int> productTypes = [];
    List<int> variationIds = [];
    List<int> quantities = [];
    List<double> prices = [];

    for (String product in selectedProducts) {
      double basePrice = productPrices[product] ?? 0.0;

      if (product == "Comforter") {
        productTypes.add(4);
        variationIds.add(productVariations[product] == "Single" ? 1 : 2);
        quantities.add(productQuantities[product]!); // Normal quantity
      } else if (product == "Blanket") {
        productTypes.add(1);
        variationIds.add(productVariations[product] == "Single" ? 1 : 2);
        quantities.add(productQuantities[product]!); // Normal quantity
      } else if (product == "Clothes") {
        productTypes.add(5);
        variationIds.add(0); // No variation for clothes
        int weight =
            int.tryParse(manualQuantityControllers[product]?.text ?? "1") ?? 1;
        quantities.add(weight); // ✅ Use weight as quantity
      }

      prices.add(basePrice);
    }

    Map<String, dynamic> orderData = {
      "customer_id": customerId.value,
      "laundromat_id": laundromatId.value,
      "order_type": orderType.value,
      "order_status": "in process",
      "pickuptime": ["17:56", "17:56"],
      "product_type": productTypes,
      "variation_id": variationIds,
      "quantity": quantities, // ✅ Clothes weight is included in this
      "price": prices,
      "total_price": totalPriceController.text.trim(),
      "payment": paymentMethod.value,
      "delivery_method": deliveryMethod.value,
      "delivery_type": deliveryMethod.value,
      "order_instructions": orderInstructionsController.text.trim(),
      // "order_address": orderAddressController.text.trim(),
      "order_temp": ["Hot", "Cold", "Warm"],
      "house_status": "building",
      "apt_no": "new apartment",
      "elevator_status": 0,
      "floor": 1,
      "delivery_status": "leave at the door",
      "delivery_time": DateFormat('dd-MM-yyyy').format(deliveryTime.value),
    };

    print("📡 Sending Order Data: $orderData");

    try {
      var response = await _orderRepository.createDropOffOrder(orderData);

      if (response != null && response.responseCode == "200") {
        onSuccess(response.orderId.toString(), customerId.value);
      } else {
        Get.snackbar("Error", response?.result ?? "Order creation failed!",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong! Please try again.",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      loading.value = false;
    }
  }
}
