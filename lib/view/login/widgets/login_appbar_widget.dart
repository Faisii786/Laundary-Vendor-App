import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/colors/app_color.dart';


class CustomAppBarScreen extends StatelessWidget implements PreferredSizeWidget {
  final String titleKey;
  final String subtitleKey;

  const CustomAppBarScreen({
    super.key,
    required this.titleKey,
    required this.subtitleKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: AppColor.primeryBlueColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleKey.tr,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColor.bg1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitleKey.tr,
              style: const TextStyle(
                fontSize: 18,
                color: AppColor.lightgrey2,
              ),
            ),
            // Row(
            //   children: [
            //     SvgPicture.asset(
            //       ImageAssets.AppIcon, // Ensure the path is correct
            //       height: 40, // Adjust size as needed
            //     ),
            //     const SizedBox(width: 8),
            //     SvgPicture.asset(
            //       ImageAssets.AppName, // Ensure the path is correct
            //       height: 40, // Adjust size as needed
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(200);
}
