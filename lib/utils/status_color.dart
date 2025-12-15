import 'package:flutter/material.dart';
import 'package:vendor_app/res/colors/app_color.dart';

Color statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
      return Colors.green;
    case 'cancelled':
      return Colors.orange;
    case 'pending':
      return Colors.red;
    default:
      return AppColor.primeryBlueColor;
  }
}
