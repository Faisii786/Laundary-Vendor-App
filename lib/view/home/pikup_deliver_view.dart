import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/data/response/status.dart';
import 'package:vendor_app/res/colors/app_color.dart';
import 'package:vendor_app/utils/status_color.dart';
import 'package:vendor_app/view/home/widgets/order_view_card.dart';
import 'package:vendor_app/view/home/order_details_screen2.dart';
import 'package:vendor_app/view_models/controller/pickup_delivery/pickup_delivery_view_model.dart';
import 'package:vendor_app/view_models/controller/user_preference/user_preference_view_model.dart';

class PickUpDeliver extends StatefulWidget {
  const PickUpDeliver({super.key});

  @override
  State<PickUpDeliver> createState() => _PickUpDeliverState();
}

class _PickUpDeliverState extends State<PickUpDeliver> {
  //final PickUpController controller = Get.put(PickUpController());
  final PickpDeliveryController controller =
      Get.put(PickpDeliveryController(), permanent: true);
  UserPreference userPreference = UserPreference();

  @override
  void deactivate() => super.deactivate();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller
          .pickupListApi(); // ✅ Ensures API call happens after the build phase
    }); // Call API here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        color: AppColor.bgcolor,
        child: Obx(() {
          if (controller.rxRequestStatus.value == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle empty state properly
          if (controller.orders.isEmpty) {
            return const Center(
                child: Text("No Pickup & Deliver Orders Available"));
          }

          //Filter only "Pickup" type orders
          final pickupOrders = controller.orders
              // .where((order) =>
              //     order.orderType?.toLowerCase() == "pickup & delivery")
              .toList();

          if (pickupOrders.isEmpty) {
            return const Center(
                child: Text("No Pickup & Deliver Orders Available"));
          }

          return ListView.builder(
            itemCount: pickupOrders.length,
            itemBuilder: (context, index) {
              final order = pickupOrders[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0), // Add vertical padding
                child: InkWell(
                  onTap: () {
                    Get.to(OrderDetailsScreen2(orderData: order.toJson()));
                  },
                  child: OrderCard(
                    name: "${order.customer?.name}", // Show order ID as Name
                    phone: order.customer?.mobile ??
                        "N/A", // Show Customer ID as Address
                    time: order.orderTime ?? "N/A",
                    type: order.orderType ?? "Unknown",
                    driver: order.driverName,
                    statusColor: statusColor(order.orderStatus ?? "Unknown"),
                    statusText: order.orderStatus ?? "Pending",
                    price: order.orderPrice?.toString() ?? "0",
                    bags: order.totalBags?.toString() ?? "0",
                    weight: order.weight?.toString() ?? "0",
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
