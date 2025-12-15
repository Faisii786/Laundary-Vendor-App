import 'package:flutter/material.dart';
//import 'package:qr_flutter/qr_flutter.dart';

import '../../res/colors/app_color.dart';

class BillScreen extends StatelessWidget {
  final Map<String, String> details;

  const BillScreen({required this.details, super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bill Details",
          style: TextStyle(color: AppColor.primeryBlueColor),
        ),
        iconTheme: const IconThemeData(
          color: AppColor.primeryBlueColor, // Change the back icon color here
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bill Header
              const Center(
                child: Text(
                  "Delivery Receipt",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Divider Line
              const Divider(thickness: 2),

              // Details Section
              Wrap(
                spacing: 16.0, // Space between items
                runSpacing: 12.0, // Space between lines
                children: [
                  _buildDetailRow("Customer Name:", details['name']),
                  _buildDetailRow("Phone Number:", details['phone']),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Address:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${details['streetAddress']}, ${details['apt']}, ${details['city']}, ${details['state']}, ${details['zipCode']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Divider Line
              const Divider(thickness: 2),

              // Order Details
              const Text(
                "Order Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16.0,
                runSpacing: 12.0,
                children: [
                  _buildDetailRow("Total Weight (Lb):", details['totalLb']),
                  _buildDetailRow("No of Bags:", details['noOfBags']),
                  _buildDetailRow("Price:", details['price']),
                  _buildDetailRow("Delivery Time:", details['deliveryTime']),
                ],
              ),
              const SizedBox(height: 16),

              // Divider Line
              const Divider(thickness: 2),

              // QR Code Section
              const Center(
                child: Column(
                  children: [
                    Text(
                      "Scan the QR Code for Order Details",
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: 12),
                    // QrImage(
                    //   data: details.entries
                    //       .map((e) => '${e.key}: ${e.value}')
                    //       .join(', '),
                    //   version: QrVersions.auto,
                    //   size: screenWidth * 0.6, // Make QR code responsive
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          child: Text(
            value ?? 'N/A',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
