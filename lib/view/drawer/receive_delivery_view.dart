import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/components/custom_appbar.dart';
import 'package:vendor_app/view/drawer/qr_code_view.dart';

import '../../components/round_button.dart';
import '../../res/assets/image_assets.dart';
import '../../res/colors/app_color.dart';
import 'code_input_fields.dart';

class ReceiveDelivery extends StatefulWidget {
  const ReceiveDelivery({super.key});

  @override
  State<ReceiveDelivery> createState() => _ReceiveDeliveryState();
}

class _ReceiveDeliveryState extends State<ReceiveDelivery> {
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _openQRScanner() async {
    Get.to(() => const QrCodeScannerScreen());
  }

  void _navigateToEnterCode() async {
    final enteredCode = await Get.to(() => const EnterCodeScreen());

    if (enteredCode != null) {
      print("Entered Code: $enteredCode"); // Handle entered code here
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: myCustomAppbar("Receive Delivery"),
      // AppBar(
      //   backgroundColor: AppColor.bgcolor,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: AppColor.primeryBlueColor),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        decoration: const BoxDecoration(color: AppColor.bgcolor),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Align(
              //   alignment: Alignment.center,
              //   child: Container(
              //     padding: EdgeInsets.symmetric(
              //       vertical: size.height * 0.02,
              //       horizontal: size.width * 0.05,
              //     ),
              //     decoration: BoxDecoration(
              //       border: Border.all(color: AppColor.primeryBlueColor),
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     child: const Text(
              //       'Receive Delivery',
              //       style: TextStyle(
              //         color: Colors.black,
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: size.width * 0.3,
                  height: size.width * 0.3,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(ImageAssets.QrImage),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColor.BlackColor,
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: size.width * 0.65,
                height: 50,
                child: RoundButton(
                  title: 'Scan Receipt',
                  onPress: _openQRScanner,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "OR",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: size.width * 0.65,
                height: 50,
                child: RoundButton(
                  title: 'Type Code',
                  onPress: _navigateToEnterCode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
