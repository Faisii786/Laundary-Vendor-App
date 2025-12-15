import 'package:get/get.dart';
import 'package:vendor_app/data/response/status.dart';
import 'package:vendor_app/models/home/orders.dart';
import 'package:vendor_app/res/app_url/app_url.dart';
// import '../../../models/pick_up_pickup_deliver_dropoff_orders_model/pick_up_model.dart';
import '../../../repository/pick_up_repository/pickup_repository.dart';

class ListDropoffController extends GetxController {
  final _api = PickUpRepository();
  final rxRequestStatus = Status.LOADING.obs;
  final pickupList = OrdersModel().obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  void setpickupList(OrdersModel value) => pickupList.value = value;
  List<Orders> get orders => pickupList.value.orders ?? []; // just for ui

  @override
  void onReady() {
    super.onReady();
    //print("PickUpController ready. Fetching pickup orders...");
    pickupListApi(); // ✅ API call is triggered when switching back to this tab
  }

  // void onInit() {
  //   super.onInit();
  //   print("PickUpController initialized. Fetching pickup orders...");
  //   pickupListApi();  // ✅ Now the API call happens at the correct time
  // }
  void pickupListApi() async {
    try {
      //print("Fetching pickup list from API...");
      setRxRequestStatus(Status.LOADING);
      String url = AppUrl.dropOffApi;

      final value = await _api.pickupListApi(url, 1);

      Future.delayed(Duration.zero, () {
        // ✅ Ensures state is updated AFTER build
        // print("API response received: ${value.orders?.length} orders");
        if (value.orders != null && value.orders!.isNotEmpty) {
          print(
              "1:🚚 Dropoff orders fetched successfully :: ${orders.map((e) => e).toList()}");
          setpickupList(value);
          print(
              "2:🚚 Dropoff orders fetched successfully :: ${orders.map((e) => e).toList()}");
          update();
          setRxRequestStatus(Status.COMPLETED);
        } else {
          setRxRequestStatus(Status.ERROR);
        }
      });
    } catch (error) {
      print("API error: $error");
      // print("StackTrace: $stackTrace");
      Future.delayed(Duration.zero, () {
        setRxRequestStatus(Status.ERROR);
      });
    }
  }
}
