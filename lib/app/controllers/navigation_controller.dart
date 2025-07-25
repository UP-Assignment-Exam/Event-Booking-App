
// Create this file: lib/app/controllers/navigation_controller.dart
import 'package:event_booking_app/app/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;
  var previousIndex = 0.obs;

  // Page controller for smooth page transitions
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentIndex.value);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void changeTab(int index) {
    if (currentIndex.value != index) {
      previousIndex.value = currentIndex.value;
      currentIndex.value = index;
      
      // Smooth page transition
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }
}

