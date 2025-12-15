import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../res/assets/image_assets.dart';
import '../../../res/colors/app_color.dart';
import '../../../res/routes/routes_name.dart';
import '../../../view_models/controller/home/Tabs/notification_controller.dart';

class CustomAppBarHomeScreen extends StatelessWidget
    implements PreferredSizeWidget {
  final TabController tabController;
  final NotificationController notificationController =
      Get.find<NotificationController>();

  CustomAppBarHomeScreen({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// **Main AppBar Container**
        Container(
          height: preferredSize.height,
          decoration: const BoxDecoration(
            color: AppColor.primeryBlueColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              /// **Top Row: Menu & Notification Icons**
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu,
                          color: AppColor.bg1Color, size: 30),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    const Spacer(),
                    // Updated Notification Icon with proper navigation
                    Obx(() => IconButton(
                          icon: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(Icons.notifications,
                                  size: 30, color: AppColor.bg1Color),
                              if (notificationController.notificationCount > 0)
                                Positioned(
                                  top: -4,
                                  right: -4,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: AppColor.RedColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColor.primeryBlueColor,
                                        width: 1.5,
                                      ),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      notificationController.notificationCount >
                                              9
                                          ? '9+'
                                          : notificationController
                                              .notificationCount
                                              .toString(),
                                      style: const TextStyle(
                                        color: AppColor.bgcolor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onPressed: () async {
                            // Reset count before navigation
                            notificationController.resetNotificationCount();

                            // Navigate to notification screen using correct route name
                            await Get.toNamed(RouteName.notificationScreen);

                            // Optional: Update UI if needed
                            notificationController.update();
                          },
                        )),
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: IconButton(
                    //     icon: const Icon(Icons.chat_bubble_rounded,
                    //         color: AppColor.bg1Color, size: 28),
                    //     onPressed: () {
                    //       // Add your settings navigation or logic here
                    //     },
                    //   ),
                    // ),
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: IconButton(
                    //     icon: const Icon(Icons.settings,
                    //         color: AppColor.bg1Color, size: 28),
                    //     onPressed: () {
                    //       // Add your settings navigation or logic here
                    //       Get.toNamed(RouteName.home2);
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 0),
              Flexible(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return TabBar(
                      controller: tabController,
                      isScrollable: constraints.maxWidth < 600,
                      indicatorColor: AppColor.bg1Color,
                      labelColor: AppColor.bg1Color,
                      unselectedLabelColor: AppColor.bgcolor,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_circle,
                                  size: 20, color: Colors.white),
                              SizedBox(height: 4),
                              Text(
                                'Add New',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.home, size: 20, color: Colors.white),
                              SizedBox(height: 4),
                              Text('HOME'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.local_shipping,
                                  size: 20, color: Colors.white),
                              SizedBox(height: 4),
                              Text('Drop-off'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.shopping_cart,
                                  size: 20, color: Colors.white),
                              SizedBox(height: 4),
                              Text('Pickups'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delivery_dining,
                                  size: 20, color: Colors.white),
                              SizedBox(height: 4),
                              Text('Pick & Deliver'),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        /// **Fast Laundry Icon & Name (Half Inside, Half Outside)**
        Positioned(
          bottom: -15,
          left: screenWidth * 0.15,
          right: screenWidth * 0.15,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    height: 24,
                    width: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(130);
}
