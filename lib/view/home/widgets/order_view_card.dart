import 'package:flutter/material.dart';
import 'package:vendor_app/res/colors/app_color.dart';

class OrderCard extends StatelessWidget {
  final String name;
  final String phone;
  final String time;
  final String type;
  final String? driver;
  final String statusText;
  final Color statusColor;
  final String price;
  final String bags;
  final String weight;

  const OrderCard({
    super.key,
    required this.name,
    required this.phone,
    required this.time,
    required this.type,
    this.driver,
    required this.statusText,
    required this.statusColor,
    required this.price,
    required this.bags,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // More rounded corners
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Stronger shadow
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 4), // More elevation effect
          ),
        ],
      ),
      // margin: const EdgeInsets.symmetric(
      //     vertical: 14, horizontal: 6), // More vertical spacing
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Order Type and Time Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 400;
              final mainContent = [
                Row(
                  children: [
                    const Icon(Icons.local_shipping,
                        color: AppColor.primeryBlueColor, size: 22),
                    const SizedBox(width: 6),
                    Text(
                      type, // Order Type
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primeryBlueColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        color: Colors.grey.shade600, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade800),
                    ),
                  ],
                ),
              ];
              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mainContent[0],
                    const SizedBox(height: 6),
                    mainContent[1],
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: mainContent,
                );
              }
            },
          ),
          const Divider(
            thickness: 1.2,
            height: 18,
            color: Colors.grey,
          ), // Thicker Divider

          // /// Customer Name
          // Text(
          //   name,
          //   style: TextStyle(
          //     fontSize: 17,
          //     fontWeight: FontWeight.w700,
          //     color: AppColor.BlackColor,
          //   ),
          // ),
          const SizedBox(height: 8),

          /// Status and Order Type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon(Icons.person, color: Colors.blue, size: 22),
              /// Customer Name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColor.BlackColor,
                ),
              ),

              /// Status (Completed / Pending)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: statusColor),
                ),
              ),

              /// Order Type Below Status (Right Side)
              // Padding(
              //   padding: const EdgeInsets.only(top: 4.0),
              //   child: Text(
              //     type, // Order Type (e.g., "Pickup")
              //     style: TextStyle(
              //       color: AppColor.primeryBlueColor,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 8),

          /// phone
          Row(
            children: [
              const Icon(Icons.phone, color: Colors.green, size: 22),

              // Icon(Icons.location_on, color: Colors.redAccent, size: 22),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  phone,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.shopping_bag,
                  color: AppColor.primeryBlueColor, size: 22),

              // Icon(Icons.location_on, color: Colors.redAccent, size: 22),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  bags,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.scale,
                  color: AppColor.primeryBlueColor, size: 22),

              // Icon(Icons.location_on, color: Colors.redAccent, size: 22),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  weight,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.attach_money,
                  color: AppColor.primeryBlueColor, size: 22),

              // Icon(Icons.location_on, color: Colors.redAccent, size: 22),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  price,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// Driver (if available)
          if (driver != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.blueAccent, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    "Driver: $driver",
                    style: TextStyle(fontSize: 15, color: Colors.blue.shade700),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
