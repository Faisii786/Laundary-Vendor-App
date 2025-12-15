import 'package:flutter/material.dart';
import 'package:vendor_app/res/colors/app_color.dart';

class DeliveryRequestCard extends StatelessWidget {
  final String name;
  final String address;
  final String time;
  //final String type;
  final String? receipt;
  final String? status;
  final Color? statusColor;
  final bool pending;
  final bool smallFont;
  final String weight;
  final String bags;
  final String payment;
  final String product;
  final String type;

  const DeliveryRequestCard({super.key, 
    required this.name,
    required this.address,
    required this.time,
    // required this.type,
    this.receipt,
    this.status,
    this.statusColor,
    this.pending = false,
    this.smallFont = false,
    required this.weight,
    required this.bags,
    required this.payment,
    required this.product,
    required this.type,
  });

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
                if (status != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: (statusColor ?? Colors.red).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status!,
                      style: TextStyle(
                        color: statusColor ?? Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: smallFont ? 12 : 14,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            /// Address
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    address,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// Time & Type
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 400) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetail(Icons.access_time, time),
                      const SizedBox(height: 6),
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
                    _buildDetail(Icons.access_time, time),
                    _buildDetail(Icons.local_shipping, type),
                    _buildDetail(Icons.bed_sharp, product),
                    _buildDetail(Icons.line_weight, weight),
                    _buildDetail(Icons.shopping_bag, bags),
                    _buildDetail(Icons.attach_money, payment),
                  ],
                );
              },
            ),

            if (receipt != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.receipt_long, color: Colors.orange, size: 20),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      "Receipt No: $receipt",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            if (pending)
              const Padding(
                padding: EdgeInsets.only(top: 6.0),
                child: Text(
                  "Pending",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

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
