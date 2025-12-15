import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickupController extends GetxController {
  var orders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPickupOrders();
  }

  Future<void> fetchPickupOrders() async {
    // Simulating API call with a delay
    await Future.delayed(const Duration(seconds: 2));

    orders.value = [
      {
        'name': "John Doe",
        'address': "123 Main St",
        'time': "2:30 pm",
        'type': "Pickup",
        'driver': "Osman",
        'statusColor': Colors.yellow,
        'statusText': "Pickup",
        'isCompleted': true,
      },
      {
        'name': "Jane Smith",
        'address': "456 Elm St",
        'time': "3:00 pm",
        'type': "Pickup",
        'driver': "Mark Ready",
        'statusColor': Colors.green,
        'statusText': "Mark Ready",
        'isCompleted': true,
      },
      {
        'name': "David Johnson",
        'address': "789 Oak St",
        'time': "3:30 pm",
        'type': "Pickup",
        'driver': "Assigning Driver...",
        'statusColor': Colors.blue,
        'statusText': "Assigning Driver...",
        'isCompleted': true,
      },
      {
        'name': "Michael Brown",
        'address': "101 Pine St",
        'time': "4:00 pm",
        'type': "Pickup",
        'driver': "Alex",
        'statusColor': Colors.red,
        'statusText': "Delayed",
        'isCompleted': false,
      },
      {
        'name': "Sarah Wilson",
        'address': "246 Maple Ave",
        'time': "4:30 pm",
        'type': "Pickup",
        'driver': "Unavailable",
        'statusColor': Colors.orange,
        'statusText': "Waiting for Assignment",
        'isCompleted': false,
      },
    ];
  }
}
