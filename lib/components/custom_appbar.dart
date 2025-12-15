import 'package:flutter/material.dart';
import 'package:vendor_app/res/colors/app_color.dart';

PreferredSizeWidget myCustomAppbar(String title, {List<Widget>? actions}) {
  return AppBar(
    toolbarHeight: 70,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
    ),
    centerTitle: true,
    title: Text(title),
    backgroundColor: AppColor.primeryBlueColor,
    foregroundColor: Colors.white,
    actions: actions,
  );
}
