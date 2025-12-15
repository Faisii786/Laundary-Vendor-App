import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/components/custom_appbar.dart';
import 'package:vendor_app/components/order_details_widgets/build_card.dart';
import 'package:vendor_app/components/order_details_widgets/build_row.dart';
import 'package:vendor_app/res/colors/app_color.dart';
import 'package:vendor_app/utils/Colors.dart';
import 'package:vendor_app/utils/Fontfamily.dart';
import 'package:vendor_app/utils/status_color.dart';
import 'package:vendor_app/view/home/home_view.dart';
import 'package:vendor_app/view_models/controller/acceptorder/accept_order_view_model.dart';

import '../chat/chat.dart';

class OrderDetailsScreen2 extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsScreen2({super.key, required this.orderData});

  @override
  State<OrderDetailsScreen2> createState() => _OrderDetailsScreen2State();
}

class _OrderDetailsScreen2State extends State<OrderDetailsScreen2> {
  final AcceptOrderViewModel acceptOrderViewModel =
      Get.put(AcceptOrderViewModel());
  late String orderStatus;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("Order Data: ${widget.orderData}");
    }
    orderStatus = widget.orderData['order_status'] ?? 'pending';
  }

  _confirmorder() async {
    var data = widget.orderData;
    int orderId = int.parse(data['order_id'].toString());
    String newStatus = "Order Confirmed";

    var result = await acceptOrderViewModel.changeOrderStatus(
        orderId: orderId,
        orderStatus: newStatus,
        userid: widget.orderData['customer']['user_id'].toString());

    if (result['success']) {
      if (kDebugMode) {
        print("Order status updated successfully: ${result['message']}");
      }
      setState(() {
        orderStatus = newStatus;
      });
      Get.snackbar("Success", result['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          snackPosition: SnackPosition.BOTTOM);
      // Get.back();
      Get.to(const HomeView());
    } else {
      if (kDebugMode) {
        print("Failed to update order status: ${result['message']}");
      }
      Get.snackbar("Error", result['message'],
          backgroundColor: Colors.red.withOpacity(0.5),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.orderData;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: myCustomAppbar('Order Details', actions: [
        IconButton(
            onPressed: () {
              Get.to(() => ChatWithCustomer(
                    customerId:
                        widget.orderData['customer']['user_id'].toString(),
                    customerName:
                        widget.orderData['customer']['name'].toString(),
                  ));
            },
            icon: const Icon(Icons.chat_bubble))
      ]),
      bottomNavigationBar: orderStatus.toLowerCase() != 'completed'
          ? Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: statusColor(orderStatus).withAlpha(60),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // ticketCancell(order.id ?? "");
                        Get.back();
                      },
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: RedColor,
                        ),
                        child: Text(
                          "Back".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyMedium,
                            color: WhiteColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  orderStatus.toLowerCase() == "pending"
                      ? Expanded(
                          child: InkWell(
                            onTap: () async {
                              _confirmorder();
                            },
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColor.primeryBlueColor,
                              ),
                              child: Text(
                                "Accept".tr,
                                style: TextStyle(
                                  fontFamily: FontFamily.gilroyMedium,
                                  color: WhiteColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            )
          : const SizedBox(),
      // ? Container(
      //     padding: const EdgeInsets.all(10),
      //     decoration: BoxDecoration(
      //         color: statusColor(orderStatus).withAlpha(60),
      //         borderRadius: const BorderRadius.only(
      //           topLeft: Radius.circular(20),
      //           topRight: Radius.circular(20),
      //         )),
      //     child: ElevatedButton.icon(
      //       style: ElevatedButton.styleFrom(
      //         foregroundColor: Colors.white,
      //         backgroundColor: AppColor.primeryBlueColor,
      //         padding:
      //             const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(12),
      //         ),
      //       ),
      //       icon: const Icon(Icons.edit),
      //       label: const Text('Change Status'),
      //       onPressed: () => _changeStatus(data['order_id'].toString()),
      //     ),
      //   )
      // : const SizedBox(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCard([
              Center(
                child: CircleAvatar(
                  radius: 36,
                  // backgroundColor: Colors.grey.shade200,
                  backgroundColor: statusColor(orderStatus).withAlpha(60),
                  child: const Icon(Icons.shopping_bag,
                      size: 40, color: AppColor.primeryBlueColor),
                ),
              ),
              const SizedBox(height: 20),
              buildRow('Receipt No', data['order_id'].toString()),
              buildRow('Type', data['order_type']),
              buildRow('Price', 'Rs. ${data['order_price']}'),
              buildRow('Status', orderStatus,
                  valueColor: statusColor(orderStatus)),
            ]),
            const SizedBox(height: 15),
            buildCard([
              buildRow('Weight', '${data['weight']} kg'),
              buildRow('Total Bags', '${data['total_bags']} kg'),
            ]),
            const SizedBox(height: 15),
            buildCard([
              buildRow('Customer Name', data['customer']['name'].toString()),
              buildRow('Email', data['customer']['email'].toString()),
              buildRow('Phone', data['customer']['mobile'].toString()),
              buildRow('Address', data['customer']['address'].toString()),
            ]),
            const SizedBox(height: 15),

            /// 🔹 **Products**
            const Text("Products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Column(
              children: data['products'].map<Widget>((product) {
                return buildCard([
                  buildRow("Product", product['product_name'] ?? 'N/A'),
                  buildRow("Variation", product['variation_name'] ?? 'N/A'),
                  // if (product['quantity'] != null && product['quantity']! > 0)
                  buildRow("Quantity", "${product['quantity']}"),
                  // if (product.weight != null && product.weight! > 0)
                  //   buildRow("Weight", "${product.weight} lb"),
                  buildRow("Price", "${product['price'] ?? 'N/A'}"),
                ]);
              }).toList(),
            ),

            buildCard([
              buildRow("Driver Information", data['driver_name'] ?? 'N/A'),
            ])
          ],
        ),
      ),
    );
  }
}
