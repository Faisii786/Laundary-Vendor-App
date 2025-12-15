import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  final _notificationCount = 0.obs;
  final _notifications = <Map<String, dynamic>>[].obs; // List of notifications
  final _storage = GetStorage();

  int get notificationCount => _notificationCount.value;
  List<Map<String, dynamic>> get notifications => _notifications;

  @override
  void onInit() {
    super.onInit();
    _loadNotificationCount();
    _loadNotifications();
  }

  void _loadNotificationCount() {
    _notificationCount.value = _storage.read<int>('notification_count') ?? 0;
  }

  void _loadNotifications() {
    final saved = _storage.read<List>('notifications');
    if (saved != null) {
      _notifications.assignAll(saved.cast<Map<String, dynamic>>());
    }
  }

  void incrementNotificationCount({required Map<String, dynamic> data}) {
    _notificationCount.value++;
    _storage.write('notification_count', _notificationCount.value);

    _notifications.insert(0, {
      'title': data['title'] ?? 'New Notification',
      'body': data['body'] ?? '',
      'timestamp': DateTime.now().toIso8601String(),
    });
    _storage.write('notifications', _notifications);
  }

  void resetNotificationCount() {
    _notificationCount.value = 0;
    _storage.write('notification_count', 0);
  }

  void clearNotifications() {
    _notifications.clear();
    _storage.remove('notifications');
  }
}
