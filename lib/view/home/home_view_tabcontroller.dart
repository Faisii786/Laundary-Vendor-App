import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 5, vsync: this, initialIndex: 1);
  }

  void changeTab(int index) {
    tabController.animateTo(index);
    update();
  }

  int get currentIndex => tabController.index;

  @override
  void onClose() {
    // tabController.dispose();
    super.onClose();
  }
}
