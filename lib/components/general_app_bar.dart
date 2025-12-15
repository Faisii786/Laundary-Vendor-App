import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/colors/app_color.dart';
import '../res/routes/routes_name.dart';


class CustomAppBarScreen extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarScreen({super.key}); // ✅ Made Key optional

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: AppColor.primeryBlueColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30), // Adjusted for better layout
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Drawer Icon
                IconButton(
                  icon: const Icon(Icons.menu, color: AppColor.bg1Color, size: 30),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                // Notifications Button
                IconButton(
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications, size: 30, color: AppColor.bg1Color),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColor.RedColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '1',
                            style: TextStyle(
                              color: AppColor.bgcolor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    print("Notification button pressed");
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          /// **Tab Bar with "Add New" Button**
          Expanded(
            child: TabBar(
              indicatorColor: AppColor.bg1Color,
              labelColor: AppColor.bg1Color,
              unselectedLabelColor: AppColor.BlackColor,
              dividerColor: Colors.transparent,
              onTap: (index) {
                if (index == 0) {
                  Get.toNamed(RouteName.addNew);
                }
                if (index == 2) {
                  Get.toNamed(RouteName.dropOff);
                }
              },
              tabs: [
                /// **Styled "Add New" Tab (Without `+` sign)**
                Tab(
                  child: Container(
                    width: screenWidth * 0.35, // Dynamic width
                    height: 35, // Fixed height
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.blueColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Add New', // Removed the '+' icon
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                /// **Other Tabs**
                const Tab(text: 'HOME'),
                const Tab(text: 'Drop-off'),
                const Tab(text: 'Pickups'),
                const Tab(text: 'Pick & Deliver'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(130); // Adjusted height
}
