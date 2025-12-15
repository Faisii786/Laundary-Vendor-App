import 'package:flutter/material.dart';
import 'package:vendor_app/res/colors/app_color.dart';

class ToGoCard extends StatelessWidget {
  final String name;
  final String status;
  final String time;
  final String weight;
  final String bags;
  final String payment;
  final Color statusColor;
  final String product;
  final String type;

  const ToGoCard(
      {super.key, required this.name,
      required this.status,
      required this.time,
      required this.weight,
      required this.bags,
      required this.payment,
      required this.statusColor,
      required this.product,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// Time
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.access_time, color: Colors.grey.shade600, size: 18),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    time,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Expanded(
                //   child: Text(
                //     textAlign: TextAlign.end,
                //     type,
                //     style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 8),

            /// Details (Weight, Bags, Payment)
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 400) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetail(Icons.local_shipping, type),
                      const SizedBox(height: 6),
                      _buildDetail(Icons.shopping_cart, product),
                      const SizedBox(height: 6),
                      _buildDetail(Icons.scale, weight),
                      const SizedBox(height: 6),
                      _buildDetail(Icons.shopping_bag, bags),
                      const SizedBox(height: 6),
                      _buildDetail(Icons.attach_money, payment),
                    ],
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetail(Icons.local_shipping, type),
                    _buildDetail(Icons.bed_sharp, product),
                    _buildDetail(Icons.line_weight, weight),
                    _buildDetail(Icons.shopping_bag, bags),
                    _buildDetail(Icons.attach_money, payment),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to create Detail Rows with Icons
  Widget _buildDetail(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColor.primeryBlueColor, size: 18),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
