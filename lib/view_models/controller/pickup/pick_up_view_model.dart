import 'package:get/get.dart';
import 'package:vendor_app/data/response/status.dart';
import 'package:vendor_app/models/home/orders.dart';
import 'package:vendor_app/res/app_url/app_url.dart';
// import '../../../models/pick_up_pickup_deliver_dropoff_orders_model/pick_up_model.dart';
import '../../../repository/pick_up_repository/pickup_repository.dart';

class PickUpController extends GetxController {
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
      String url = AppUrl.onlypickupApi;

      final value = await _api.pickupListApi(url, 1);

      Future.delayed(Duration.zero, () {
        // ✅ Ensures state is updated AFTER build
        // print("API response received: ${value.orders?.length} orders");
        if (value.orders != null && value.orders!.isNotEmpty) {
          setpickupList(value);
          setRxRequestStatus(Status.COMPLETED);
        } else {
          setRxRequestStatus(Status.ERROR);
        }
      });
    } catch (error) {
      print("API error: $error");
      //  print("StackTrace: $stackTrace");
      Future.delayed(Duration.zero, () {
        setRxRequestStatus(Status.ERROR);
      });
    }
  }

// void pickupListApi() {
  //   print("Fetching pickup list from API...");
  //   setRxRequestStatus(Status.LOADING);
  //
  //   _api.pickupListApi().then((value) {
  //
  //     print("API response received: ${value.orders?.length} orders");
  //
  //     if (value.orders != null && value.orders!.isNotEmpty) {
  //       setpickupList(value);
  //       setRxRequestStatus(Status.COMPLETED);
  //     } else {
  //       print("No orders returned from API");
  //       setRxRequestStatus(Status.ERROR);
  //     }
  //   }).onError((error, stackTrace) {
  //     print("API error: $error");
  //     print("StackTrace: $stackTrace");
  //     setRxRequestStatus(Status.ERROR);
  //   });
  //
  //   //print("API call initiated...");
  // }

//   void pickupListApi() {
//     print("Fetching pickup list from API...");
//     _api.pickupListApi().then((value){
//       print("API response received: ${value.orders?.length} orders");
//       setRxRequestStatus(Status.COMPLETED);
//       setpickupList(value);
//   }).onError((error, stackTrace) {
//       print(stackTrace);
//       setRxRequestStatus(Status.ERROR);
//     });
//     print("API call initiated...");
// }
}
