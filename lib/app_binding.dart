// lib/app_bindings.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'data/network/api_client.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => http.Client());
    Get.lazyPut(() => ApiClient(
      baseUrl: 'YOUR_API_BASE_URL',
      client: Get.find(),
    ));
  }
}