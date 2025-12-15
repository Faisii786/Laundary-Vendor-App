import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/colors/app_color.dart';
import '../../view_models/controller/activity/order_activity_history_view_model.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  final ActivityOrdersHistoryViewModel _orderController =
  Get.put(ActivityOrdersHistoryViewModel());
  late ScrollController _scrollController;

  @override
  @override
  void initState() {
    super.initState();
    if (_orderController.orders.isEmpty) { // ✅ Only fetch if not already loaded
      _orderController.fetchOrders(limit: 10);
    }
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }


  /// **📌 Load More Orders when Scrolling to Bottom**
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _orderController.loadMoreOrders(limit: 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgcolor,

      /// **AppBar**
      appBar: AppBar(
        title: const Text(
          'Activity Orders',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColor.primeryBlueColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.primeryBlueColor),
          onPressed: () {
            print("🔙 Back button pressed! Previous Route: ${Get.previousRoute}");

            if (Get.previousRoute.isNotEmpty) {
              Get.back(result: Get.arguments); // ✅ Pass current tab index back
            } else {
              Get.offAllNamed('/home', arguments: 1); // ✅ Send the correct tab index
            }
          },

        ),
      ),

      /// **Main Content**
      body: Column(
        children: [
          /// **📌 Orders List**
          Expanded(
            child: Obx(() {
              if (_orderController.isLoading.value &&
                  _orderController.orders.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_orderController.orders.isEmpty) {
                return const Center(child: Text("No orders available"));
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: _orderController.orders.length +
                    (_orderController.hasMoreData.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _orderController.orders.length) {
                    final order = _orderController.orders[index];
                    return _activityCard(order);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// **📌 Order Card UI (Beautiful UI with all details)**
  Widget _activityCard(order) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// **🔹 Order ID**
              Text(
                "Order ID: ${order.orderId}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Divider(),

              /// **🔹 Customer Name & Order Time**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoRow(Icons.person, "Customer", order.customer?.name ?? "N/A",
                      AppColor.primeryBlueColor),
                  _infoRow(Icons.access_time, "Order Time", order.createdAt ?? "N/A",
                      Colors.grey),
                ],
              ),

              const SizedBox(height: 8),

              /// **🔹 Order Type & Order Price**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoRow(Icons.shopping_cart, "Order Type", order.orderType ?? "N/A",
                      AppColor.primeryBlueColor),
                  _infoRow(Icons.attach_money, "Order Price", "\$${order.orderPrice}",
                      Colors.green),
                ],
              ),

              const SizedBox(height: 8),

              /// **🔹 Order Status**
              Row(
                children: [
                  const Text(
                    "Status:",
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  _statusBadge(order.orderStatus),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// **📌 Helper: Order Info Row with Colorful Icons**
  Widget _infoRow(IconData icon, String title, String value, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 22, color: iconColor), // ✅ Colorful Icons
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  /// **📌 Helper: Status Badge**
  Widget _statusBadge(String? status) {
    Color bgColor = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status ?? "Pending",
        style:
        const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  /// **📌 Status Color Mapping**
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "pending":
        return Colors.redAccent;
      case "delivered":
        return Colors.green;
      case "delivering":
        return Colors.yellow;
      case "awaiting":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
