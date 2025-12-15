import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // ✅ Updated package
import 'package:vendor_app/components/custom_appbar.dart';
import 'oder_detail_screen.dart';

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({super.key});

  @override
  State<QrCodeScannerScreen> createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  final MobileScannerController scannerController = MobileScannerController();

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppbar("Scan QR Code"),
      // AppBar(
      //   title: const Text("Scan QR Code", style: TextStyle(color: Colors.white)),
      //   backgroundColor: AppColor.primeryBlueColor,
      //   centerTitle: true,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.white), // ✅ White back icon
      //     onPressed: () => Get.back(),
      //   ),
      // ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: scannerController,
              onDetect: (BarcodeCapture barcodeCapture) {
                final List<Barcode> barcodes = barcodeCapture.barcodes;

                if (barcodes.isNotEmpty) {
                  final String scannedData = barcodes.first.rawValue ?? '';

                  if (scannedData.isNotEmpty) {
                    print("✅ Scanned QR Code: $scannedData");

                    // ✅ Navigate to OrderDetailsScreen with scanned order_q_id
                    Get.off(() => OrderDetailsScreen(orderCode: scannedData));
                  } else {
                    Get.snackbar("Error", "Invalid QR Code! Try again.",
                        backgroundColor: Colors.red, colorText: Colors.white);
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Align QR Code within the frame",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
