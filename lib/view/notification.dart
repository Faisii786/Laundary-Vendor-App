import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/view_models/controller/home/Tabs/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationController controller = Get.find<NotificationController>();

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Obx(() {
        final notifications = controller.notifications;
        if (notifications.isEmpty) {
          return const Center(child: Text("No notifications yet."));
        }
        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final item = notifications[index];
            return ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(item['title'] ?? ''),
              subtitle: Text(item['body'] ?? ''),
            );
          },
        );
      }),
    );
  }
}

class NewOrderScreen extends StatelessWidget {
  const NewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Order')),
      body: const Center(child: Text('Display new order details here')),
    );
  }
}

