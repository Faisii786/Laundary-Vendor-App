import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vendor_app/res/routes/routes_name.dart';
import 'package:vendor_app/view/home/home_view_tabcontroller.dart';
import 'package:vendor_app/view/home/order_details_screen2.dart';
import 'package:vendor_app/view/home/pick_ups_view.dart';
import 'package:vendor_app/view/home/pikup_deliver_view.dart';
import 'package:vendor_app/view/home/widgets/delivery_request_card.dart';
import 'package:vendor_app/view/home/widgets/home_appbar_widget.dart';
import 'package:vendor_app/view/home/widgets/to_go_card.dart';
import 'package:vendor_app/view/home/widgets/to_go_header_view.dart';
import '../../res/assets/image_assets.dart';
import '../../res/colors/app_color.dart';
import '../../res/fonts/app_fonts.dart';
import '../../view_models/controller/home_view_model/home_completed_order_view_model.dart';
import '../../view_models/controller/home_view_model/home_pending_order_view_model.dart';
import '../../view_models/controller/user_preference/user_preference_view_model.dart';
import '../drawer/receive_delivery_view.dart';
import '../login/login_view.dart';
import '../newDropOff/add_new_dropoff_view.dart';
import 'dropoff_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  final HomeCompletedOrderController homeCompletedOrderController =
      Get.put(HomeCompletedOrderController());
  final HomePendingOrderController homePendingOrderController =
      Get.put(HomePendingOrderController());
  final UserPreference userPreference = UserPreference();
  final hometabcontroller = Get.put(HomeTabController());

  @override
  void initState() {
    super.initState();
    userPreference.getUser().then((user) {
      if (user == null ||
          user.userLogin!.laundryId == null ||
          user.userLogin!.laundryId.toString().isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(RouteName.home2, (route) => false);
        });
      }
    });
    homeCompletedOrderController.fetchCompletedOrders();
    homePendingOrderController.fetchPendingOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgcolor,
      appBar: CustomAppBarHomeScreen(
        tabController: hometabcontroller.tabController,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 130,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: AppColor.primeryBlueColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [],
                ),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // SvgPicture.asset(
                        //   ImageAssets.AppIcon,
                        //   height: 24,
                        //   width: 24,
                        // ),
                        // const SizedBox(width: 10),
                        SvgPicture.asset(
                          ImageAssets.AppName,
                          height: 60,
                          width: 60,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.qr_code_scanner,
                      color: AppColor.primeryBlueColor),
                  title: const Text(
                    "Scan & Confirm",
                    style: TextStyle(
                        fontSize: 18, fontFamily: AppFonts.gilroyMedium),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    hometabcontroller.changeTab(0);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReceiveDelivery()));
                  },
                ),
              ),
            ),
            // Activity Card
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   child: Card(
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     elevation: 4,
            //     child: ListTile(
            //       leading:
            //           Icon(Icons.history, color: AppColor.primeryBlueColor),
            //       title: Text(
            //         "Activity",
            //         style: TextStyle(
            //             fontSize: 18, fontFamily: AppFonts.gilroyMedium),
            //       ),
            //       onTap: () {
            //         Navigator.pop(context);
            //         _tabController.animateTo(2);
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => Activity()),
            //         );
            //       },
            //     ),
            //   ),
            // ),

            // Logout Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                        fontSize: 18, fontFamily: AppFonts.gilroyMedium),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    hometabcontroller.changeTab(1);

                    userPreference
                        .removeUser(); // Assuming you have this method implemented
                    // Navigate to Login Screen
                    // Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(builder: (context) => LoginView()));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const LoginView()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 8.0, top: 40, right: 8.0, bottom: 8.0),
        child: TabBarView(
          controller: hometabcontroller.tabController,
          children: [
            // Add New Tab
            const AddNewDropOff(),
            // Home Tab with two inner tabs: Completed Orders & Pending Orders
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: AppColor.primeryBlueColor,
                    unselectedLabelColor: Colors.black54,
                    indicatorColor: AppColor.primeryBlueColor,
                    tabs: [
                      Tab(text: 'Completed Orders'),
                      Tab(text: 'Pending Orders'),
                    ],
                  ),
                  Expanded(
                    child: Obx(
                      () => TabBarView(
                        children: [
                          // Completed Orders Tab
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeaderSection(
                                title: 'To GO',
                                badgeCounts: [
                                  1,
                                  homePendingOrderController
                                      .totalpendingOrders.value,
                                  homeCompletedOrderController
                                      .totalCompletedOrders.value
                                ],
                              ),
                              homeCompletedOrderController
                                      .completedOrders.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No Completed Orders',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    )
                                  : Expanded(
                                      child: ListView.builder(
                                        itemCount: homeCompletedOrderController
                                            .completedOrders.length,
                                        itemBuilder: (context, index) {
                                          final order =
                                              homeCompletedOrderController
                                                  .completedOrders[index];
                                          return InkWell(
                                            onTap: () {
                                              Get.to(OrderDetailsScreen2(
                                                  orderData: order.toJson()));
                                            },
                                            child: ToGoCard(
                                              name: order.customer?.name ??
                                                  'No Name',
                                              status: order.orderStatus ??
                                                  'Unknown',
                                              time:
                                                  order.orderTime ?? 'No Time',
                                              weight: order.weight ?? '0',
                                              bags: order.totalBags ?? '0',
                                              payment:
                                                  order.orderPrice ?? '0.00',
                                              product: order.products
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? order.products!
                                                      .map((p) =>
                                                          p.productName ??
                                                          'No Product')
                                                      .join(', ')
                                                  : 'No Product',
                                              statusColor: Colors.green,
                                              type:
                                                  order.orderType ?? 'Unknown',
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ],
                          ),
                          // Pending Orders Tab
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const HeaderSection(
                                title: 'New Delivery Request',
                              ),
                              homePendingOrderController.pendingOrders.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No Pending Orders',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    )
                                  : Expanded(
                                      child: ListView.builder(
                                        itemCount: homePendingOrderController
                                            .pendingOrders.length,
                                        itemBuilder: (context, index) {
                                          final order =
                                              homePendingOrderController
                                                  .pendingOrders[index];
                                          return InkWell(
                                            onTap: () {
                                              Get.to(OrderDetailsScreen2(
                                                  orderData: order.toJson()));
                                            },
                                            child: DeliveryRequestCard(
                                              address:
                                                  order.customer?.address ??
                                                      'No Address',
                                              name: order.customer?.name ??
                                                  'No Name',
                                              weight: order.weight ?? '0',
                                              bags: order.totalBags ?? '0',
                                              payment:
                                                  order.orderPrice ?? '0.00',
                                              product: order.products
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? order.products!
                                                      .map((p) =>
                                                          p.productName ??
                                                          'No Product')
                                                      .join(', ')
                                                  : 'No Product',
                                              time:
                                                  order.orderTime ?? 'No Time',
                                              status: order.orderStatus ??
                                                  'Unknown',
                                              statusColor: Colors.redAccent,
                                              type:
                                                  order.orderType ?? 'Unknown',
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Drop-off Tab
            const DropOffTab(),

            // Pickups Tab
            const PickUpTab(),

            // Pick & Deliver Tab
            const PickUpDeliver(),
          ],
        ),
      ),
    );
  }
}
