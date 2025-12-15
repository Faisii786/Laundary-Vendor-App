import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropOffController extends GetxController {
  var orders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    // Simulating API call with a delay
    await Future.delayed(const Duration(seconds: 2));
    orders.value = [
      {
        'name': "Moctar Diaby",
        'address': "1385 Webster Ave",
        'time': "2:30 pm",
        'type': "Pickup",
        'driver': "Osman",
        'statusColor': Colors.yellow,
        'statusText': "Pickup",
        'isCompleted': true,
      },
      {
        'name': "Moctar Diaby",
        'address': "1385 Webster Ave",
        'time': "2:30 pm",
        'type': "Pickup",
        'driver': "Mark Ready",
        'statusColor': Colors.green,
        'statusText': "Mark Ready",
        'isCompleted': true,
      },
      {
        'name': "Moctar Diaby",
        'address': "1385 Webster Ave",
        'time': "2:30 pm",
        'type': "Pickup",
        'driver': "Assigning Driver...",
        'statusColor': Colors.blue,
        'statusText': "Assigning Driver...",
        'isCompleted': true,
      },
      {
        'name': "Moctar Diaby",
        'address': "1385 Webster Ave",
        'time': "1:30 pm",
        'type': "Dropoff",
        'receipt': "3347",
        'statusColor': Colors.blue,
        'statusText': "Dropoff",
        'isCompleted': false,
      },
      {
        'name': "Moctar Diaby",
        'address': "1385 Webster Ave",
        'time': "1:30 pm",
        'type': "Pickup&Deliver",
        'receipt': "3347",
        'statusColor': Colors.blue,
        'statusText': "Pickup&Deliver",
        'isCompleted': false,
      },
      {
        'name': "Moctar Diaby",
        'address': "1385 Webster Ave",
        'time': "1:30 pm",
        'type': "Dropoff",
        'receipt': "3347",
        'statusColor': Colors.blue,
        'statusText': "Dropoff",
        'isCompleted': false,
      },
    ];
  }
}
