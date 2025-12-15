import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/components/custom_appbar.dart';
import 'package:vendor_app/components/order_details_widgets/build_card.dart';
import 'package:vendor_app/components/order_details_widgets/build_row.dart';
import 'package:vendor_app/res/colors/app_color.dart';
import '../../../models/scan_confirm/scan_till_id_confirm_order_model.dart';
import '../../view_models/controller/scan_confirm/update_tillId_order_view_model.dart';

class UpdateOrderScreen extends StatefulWidget {
  final OrderDetails orderDetails;

  const UpdateOrderScreen({super.key, required this.orderDetails});

  @override
  _UpdateOrderScreenState createState() => _UpdateOrderScreenState();
}

class _UpdateOrderScreenState extends State<UpdateOrderScreen> {
  final UpdateTillIDOrderController updateController =
      Get.put(UpdateTillIDOrderController());

  late String orderId;
  late String customerId;
  late String customerName;
  late String customerPhone;
  late String customerAddress;
  late TextEditingController bagsController;
  late TextEditingController weightController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    orderId = widget.orderDetails.orderId.toString();
    customerId = widget.orderDetails.customer?.userId.toString() ?? 'N/A';
    customerName = widget.orderDetails.customer?.name ?? 'Unknown';
    customerPhone = widget.orderDetails.customer?.mobile ?? 'No Phone';
    customerAddress =
        widget.orderDetails.customerAddress?.address ?? 'No Address';

    bagsController = TextEditingController(
        text: widget.orderDetails.totalBags?.toString() ?? '');
    weightController = TextEditingController(
        text: widget.orderDetails.weight?.toString() ?? '');
    priceController = TextEditingController(
        text: widget.orderDetails.orderPrice?.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: myCustomAppbar("Update Details"),
        // AppBar(
        //   title: Text("Update Detail", style: TextStyle(color: AppColor.bgcolor)),
        //   backgroundColor: AppColor.primeryBlueColor, // Primary Blue Background
        //   iconTheme: IconThemeData(color: AppColor.bgcolor), // White Back Button
        // ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Order Details (Non-Editable)
                buildSectionTitle("Order Details"),
                buildCard([
                  buildRow("Order ID", orderId),
                  buildRow(
                      "Order Type", widget.orderDetails.orderType ?? 'N/A'),
                  buildRow(
                      "Order Status", widget.orderDetails.orderStatus ?? 'N/A'),
                ]),
                const SizedBox(height: 15),

                /// 🔹 Editable Fields
                buildSectionTitle("Update Order"),
                buildCard([
                  buildTextField("No. of Bags", bagsController),
                  buildTextField("Weight (lb)", weightController),
                  buildTextField("Total Price", priceController),
                ]),
                const SizedBox(height: 20),

                /// 🔹 Submit Button

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColor.primeryBlueColor, // Primary Blue
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                    ),
                    onPressed: () {
                      updateController.updateOrderByTillID(
                        orderId,
                        customerId,
                        bagsController.text.trim(),
                        weightController.text.trim(),
                        priceController.text.trim(),
                      );
                    },
                    child: updateController.isLoading.value
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text("Submit Update",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
