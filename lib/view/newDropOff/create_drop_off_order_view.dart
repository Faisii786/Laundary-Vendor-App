import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vendor_app/components/custom_appbar.dart';
import 'package:vendor_app/res/colors/app_color.dart';
import 'package:vendor_app/view/home/home_view.dart';
import 'package:vendor_app/view/home/home_view_tabcontroller.dart';
import '../../view_models/controller/create_new_drop_off/create_newdropoff_order_view_model.dart';
import '../../view_models/controller/create_new_drop_off/laundromat_products_view_model.dart';
import 'order_receipt_screen.dart';

class CreateOrderScreen extends StatelessWidget {
  final CreateDropOffOrderViewModel controller =
      Get.put(CreateDropOffOrderViewModel());
  final LaundromatProductsViewModel productController =
      Get.put(LaundromatProductsViewModel());
  final HomeTabController hometabcontroller = Get.put(HomeTabController());

  CreateOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: myCustomAppbar("Create Order"),
      // AppBar(
      //   title: Text("Create Order",
      //       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      //   centerTitle: true,
      //   backgroundColor: AppColor.primeryBlueColor,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back,
      //         color: Colors.white), // ✅ White back button
      //     onPressed: () => Get.back(),
      //   ),
      // ),
      body: Obx(() => controller.loading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 **Order Details**
                  buildCard([
                    buildFixedField(
                        "Order Type", "dropoff", Icons.local_shipping),
                    const SizedBox(height: 8),
                    buildDropdown("Payment Method", controller.paymentMethod,
                        ['cash', 'card', 'paypal'], Icons.payment),
                    const SizedBox(height: 8),
                    buildDropdown("Delivery Method", controller.deliveryMethod,
                        ['same day', 'next day'], Icons.delivery_dining),
                    const SizedBox(height: 8),
                    buildDropdown(
                        "Delivery Status",
                        controller.deliveryStatus,
                        ["Hand to Hand", "Leave at the Door"],
                        Icons.door_front_door),
                  ]),

                  const SizedBox(height: 20),

                  /// 🔹 **Product Selection (Multi-Select)**
                  const Text("Select Product:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        productChip(
                            "Comforter",
                            controller.selectedProducts.contains("Comforter"),
                            Icons.bed, () {
                          controller.toggleProductSelection("Comforter");
                        }),
                        const SizedBox(
                          width: 5,
                        ),
                        productChip(
                            "Clothes",
                            controller.selectedProducts.contains("Clothes"),
                            Icons.dry_cleaning, () {
                          controller.toggleProductSelection("Clothes");
                        }),
                        const SizedBox(
                          width: 5,
                        ),
                        productChip(
                            "Blanket",
                            controller.selectedProducts.contains("Blanket"),
                            Icons.bedroom_baby, () {
                          controller.toggleProductSelection("Blanket");
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// 🔹 **Product Cards (Show all selected products)**
                  ...controller.selectedProducts
                      .map((product) => buildProductCard(product)),

                  const SizedBox(height: 20),

                  /// 🔹 **Price & Instructions**
                  buildCard([
                    buildTextField(controller.totalPriceController,
                        "Total Price", Icons.attach_money,
                        isNumber: true),
                    const SizedBox(height: 8),
                    buildTextField(controller.orderInstructionsController,
                        "Order Instructions", Icons.comment),
                  ]),

                  const SizedBox(height: 20),

                  /// 🔹 **Temperature Selection**
                  buildCard([
                    buildDropdown("Temperature", controller.temperature,
                        ["Hot", "Cold", "Warm"], Icons.thermostat),
                  ]),

                  const SizedBox(height: 20),

                  /// 🔹 **Delivery Date Picker**
                  buildCard([
                    ListTile(
                      leading: const Icon(Icons.calendar_today,
                          color: AppColor.primeryBlueColor),
                      title: Text(
                        "Delivery Date: ${DateFormat('dd-MM-yyyy').format(controller.deliveryTime.value)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.edit_calendar,
                          color: AppColor.primeryBlueColor),
                      onTap: () => controller.selectDeliveryDate(context),
                    ),
                  ]),

                  const SizedBox(height: 25),

                  /// 🔹 **Create Order Button**
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (controller.selectedProducts.isEmpty) {
                          Get.snackbar(
                              "Error", "Please select at least one product.",
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                          return;
                        }

                        // ✅ Pass the showSuccessPopup function to handle navigation
                        controller.createOrder(showSuccessPopup);
                      },
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      label: const Text("Create Order",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primeryBlueColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            )),
    );
  }

  /// 🔹 **Helper Methods**

  /// **Chip Button for Selecting Products**
  Widget productChip(
      String label, bool selected, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Row(
          children: [
            Icon(icon,
                size: 18,
                color: selected ? Colors.white : AppColor.primeryBlueColor),
            const SizedBox(width: 6),
            Text(label,
                style:
                    TextStyle(color: selected ? Colors.white : Colors.black)),
          ],
        ),
        backgroundColor: selected ? AppColor.primeryBlueColor : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColor.primeryBlueColor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

//   /// **Product Details Card**
//   Widget buildProductCard(String product) {
//     double basePrice = productController.productPrices[product] ?? 0.0; // Get base price from API
//     int quantity = controller.getQuantity(product);
//     double totalProductPrice = basePrice * quantity; // Calculate total for this product
//
//     return buildCard([
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text("$product Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           Icon(Icons.local_laundry_service, color: AppColor.primeryBlueColor, size: 28),
//         ],
//       ),
//       SizedBox(height: 10),
// // 🔹 Show Base Price
//       Text("Base Price: \$${basePrice.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, color: Colors.black)),
//
//       // 🔹 Show Total Price for This Product
//       Text("Total: \$${totalProductPrice.toStringAsFixed(2)}",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
//       if (product == "Comforter" || product == "Blanket")
//         buildDropdown("Variation", controller.getVariation(product), ["Single", "Double"], Icons.layers),
//
//       product == "Clothes"
//           ? buildTextField(controller.getQuantityController(product), "Weight", Icons.format_list_numbered, isNumber: true)
//           : Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           IconButton(icon: Icon(Icons.remove_circle, color: Colors.red), onPressed: () {
//             controller.decreaseQuantity(product);
//             controller.calculateTotalPrice(); // Update total price
//           }),
//           Obx(() => Text("${controller.getQuantity(product)}", style: TextStyle(fontSize: 18))),
//           IconButton(icon: Icon(Icons.add_circle, color: Colors.green), onPressed: () {
//     controller.increaseQuantity(product);
//     controller.calculateTotalPrice();
//     }),
//
//         ],
//       ),
//     ]);
//   }
  Widget buildProductCard(String product) {
    double basePrice =
        controller.productPrices[product.trim()] ?? 0.0; // ✅ Trim spaces
    int quantity = controller.getQuantity(product);

    double totalProductPrice = 0.0;

    if (product == "Clothes") {
      int weight =
          int.tryParse(controller.getQuantityController(product).text) ?? 1;
      totalProductPrice = weight * basePrice; // ✅ Use weight as quantity
    } else {
      totalProductPrice = quantity * basePrice; // ✅ Use quantity for others
    }

    return buildCard([
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$product Details",
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Icon(Icons.local_laundry_service,
              color: AppColor.primeryBlueColor, size: 28),
        ],
      ),
      const SizedBox(height: 10),

      // ✅ Fix Base Price Display
      Text("Base Price: \$${basePrice.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 16, color: Colors.black)),

      // ✅ Fix Total Price Display
      Text("Total: \$${totalProductPrice.toStringAsFixed(2)}",
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),

      if (product == "Comforter" || product == "Blanket")
        buildDropdown("Variation", controller.getVariation(product),
            ["Single", "Double"], Icons.layers),

      if (product == "Clothes")
        buildTextField(controller.getQuantityController(product), "Weight (KG)",
            Icons.scale,
            isNumber: true)
      else
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  controller.decreaseQuantity(product);
                  controller.calculateTotalPrice();
                }),
            Obx(() => Text("${controller.getQuantity(product)}",
                style: const TextStyle(fontSize: 18))),
            IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.green),
                onPressed: () {
                  controller.increaseQuantity(product);
                  controller.calculateTotalPrice();
                }),
          ],
        ),
    ]);
  }

  /// **Reusable Card Widget**
  Widget buildCard(List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(children: children),
      ),
    );
  }

  /// **Fixed Field for Read-Only Data**
  Widget buildFixedField(String label, String value, IconData icon) {
    return TextField(
      controller: TextEditingController(text: value),
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColor.primeryBlueColor),
        border: const OutlineInputBorder(),
      ),
    );
  }

  /// **Dropdown with Icons**
  Widget buildDropdown(String label, RxString selectedValue,
      List<String> options, IconData icon) {
    return DropdownButtonFormField<String>(
      initialValue: selectedValue.value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColor.primeryBlueColor),
        border: const OutlineInputBorder(),
      ),
      items: options
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) => selectedValue.value = value!,
    );
  }

  /// **TextField with Icon**
  Widget buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColor.primeryBlueColor),
        border: const OutlineInputBorder(),
      ),
    );
  }

  void showSuccessPopup(String orderId, String customerId) {
    Get.snackbar(
      "Success",
      "Order Created Successfully!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );

    Get.dialog(
      AlertDialog(
        title: const Text("Order Created Successfully!"),
        content: const Text("Would you like to view order details?"),
        actions: [
          TextButton(
            // onPressed: () => Get.back(),
            onPressed: () {
              // hometabcontroller.changeTab(0);
              Get.offAll(const HomeView());
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              // Get.back(); // Close dialog
              // hometabcontroller.changeTab(0);

              Get.offAll(const HomeView());

              Get.to(() => OrderReceiptScreen(
                    orderId: orderId,
                    customerId: customerId,
                    laundromatId: " ", // Replace with actual laundromat ID
                  ));
            },
            child: const Text("View Order",
                style: TextStyle(color: AppColor.primeryBlueColor)),
          ),
        ],
      ),
    );
  }
}
