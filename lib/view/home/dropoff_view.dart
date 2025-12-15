import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/view/home/order_details_screen2.dart';
// import 'package:vendor_app/view/orderDetailsScreen/ordersDetailsScrenn.dart';

import '../../data/response/status.dart';
import '../../res/colors/app_color.dart';
import '../../view_models/controller/drop_off/drop_off_view_model.dart';
import '../../view_models/controller/user_preference/user_preference_view_model.dart';

class DropOffTab extends StatefulWidget {
  const DropOffTab({super.key});

  @override
  State<DropOffTab> createState() => _DropOffTabState();
}

class _DropOffTabState extends State<DropOffTab> {
  //final ListDropoffController controller = Get.put(ListDropoffController());
  final ListDropoffController controller = Get.find<ListDropoffController>();
  // late ListDropoffController controller;

  UserPreference userPreference = UserPreference();

  @override
  void initState() {
    super.initState();
    controller.pickupListApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgcolor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        color: AppColor.bgcolor,
        child: Obx(() {
          if (controller.rxRequestStatus.value == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.orders.isEmpty) {
            return const Center(child: Text("No Dropoff Orders Available"));
          }

          // Filtering only "dropoff" orders
          final dropoffOrders = controller.orders
              // .where((order) => order.orderType?.toLowerCase() == "dropoff")
              .toList();

          if (dropoffOrders.isEmpty) {
            return const Center(child: Text("No Dropoff Orders Available"));
          }

          return ListView.builder(
            itemCount: dropoffOrders.length,
            itemBuilder: (context, index) {
              final order = dropoffOrders[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                child: InkWell(
                  onTap: () {
                    // Get.to(() => OrderdetailsScreen(oid: order.id));
                    Get.to(OrderDetailsScreen2(orderData: order.toJson()));
                  },
                  child: OrderCard(
                    name: order.customer?.name ?? "Unknown Customer",
                    address: order.customer?.mobile ?? "No Address Available",
                    time: order.orderTime ?? "N/A",
                    type: order.orderType ?? "Unknown",
                    driver: order.driverName ?? "No Driver Assigned",
                    receipt:
                        (order.orderId is int) ? order.orderId as int : null,
                    // statusColor: (order.orderStatus?.toLowerCase() == "completed")
                    //     ? Colors.green
                    //     : Colors.red,
                    // statusText: order.orderStatus ?? "Pending",
                    price: order.orderPrice?.toString() ?? "0.0",
                    bags: order.totalBags?.toString() ?? "0",
                    weight: order.weight?.toString() ?? "0.0 kg",
                    productname: order.products?.isNotEmpty == true
                        ? order.products!
                            .map((p) => p.productName ?? 'No Product')
                            .join(', ')
                        : 'No Product',
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

class OrderCard extends StatelessWidget {
  final String name;
  final String address;
  final String time;
  final String type;
  final String? driver;
  final int? receipt;
  final String price;
  final String bags;
  final String weight;
  final String productname; // Placeholder for product name

  const OrderCard({super.key, 
    required this.name,
    required this.address,
    required this.time,
    required this.type,
    this.driver,
    this.receipt,
    required this.price,
    required this.bags,
    required this.weight,
    required this.productname,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // More rounded corners
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Stronger shadow
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 4), // More elevation effect
          ),
        ],
      ),
      // margin: const EdgeInsets.symmetric(
      //     vertical: 8, horizontal: 0), // More vertical spacing
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Type and Time Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_shipping,
                      color: AppColor.primeryBlueColor, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    type, // Order Type
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primeryBlueColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time,
                      color: Colors.grey.shade600, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                  ),
                ],
              ),
            ],
          ),
          const Divider(
              thickness: 1.2,
              height: 18,
              color: Colors.grey), // Thicker Divider

          // Customer Name
          Text(
            name,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColor.BlackColor,
            ),
          ),
          const SizedBox(height: 8),

          // Address
          Row(
            children: [
              const Icon(Icons.phone, color: Colors.green, size: 22),
              // Icon(Icons.location_on, color: Colors.redAccent, size: 22),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  address,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Product Name
          Row(
            children: [
              const Icon(Icons.shopping_cart,
                  color: AppColor.primeryBlueColor, size: 22),

              // Icon(Icons.location_on, color: Colors.redAccent, size: 22),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  productname,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.shopping_bag,
                  color: AppColor.primeryBlueColor, size: 22),

              // Icon(Icons.location_on, color: Colors.redAccent, size: 22),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  bags,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.scale, color: AppColor.primeryBlueColor, size: 22),

              // Icon(Icons.location_on, color: Colors.redAccent, size: 22),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  weight,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.attach_money,
                  color: AppColor.primeryBlueColor, size: 22),

              // Icon(Icons.location_on, color: Colors.redAccent, size: 22),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  price,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Optional Driver & Receipt
          if (driver != null || receipt != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (driver != null)
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.blueAccent, size: 22),
                        const SizedBox(width: 6),
                        Text(
                          "Driver: $driver",
                          style: TextStyle(
                              fontSize: 15, color: Colors.blue.shade700),
                        ),
                      ],
                    ),
                  if (receipt != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Row(
                        children: [
                          const Icon(Icons.receipt_long,
                              color: Colors.orange, size: 22),
                          const SizedBox(width: 6),
                          Text(
                            "Receipt No: $receipt",
                            style: TextStyle(
                                fontSize: 15, color: Colors.orange.shade700),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
