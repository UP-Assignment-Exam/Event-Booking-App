// Create this file: lib/app/widgets/layouts/main_layout.dart
import 'package:event_booking_app/app/controllers/navigation_controller.dart';
import 'package:event_booking_app/app/core/transitions/page_transitions.dart';
import 'package:event_booking_app/app/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainLayoutWithTransitions extends StatelessWidget {
  final List<Widget> pages;
  final NavigationController controller = Get.find<NavigationController>();

  MainLayoutWithTransitions({
    super.key,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: controller.pageController,
        onPageChanged: (index) {
          controller.previousIndex.value = controller.currentIndex.value;
          controller.currentIndex.value = index;
        },
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: controller.pageController,
            builder: (context, child) {
              double value = 1.0;
              if (controller.pageController.position.haveDimensions) {
                value = controller.pageController.page! - index;
                value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
              }

              return Transform.scale(
                scale: Curves.easeOut.transform(value),
                child: Opacity(
                  opacity: value,
                  child: pages[index],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Obx(() => CustomBottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
          )),
    );
  }
}

// Alternative: Stack-based implementation
class StackBasedMainLayout extends StatelessWidget {
  final List<Widget> pages;
  final NavigationController controller = Get.find<NavigationController>();

  StackBasedMainLayout({
    super.key,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeInOutCubic,
            switchOutCurve: Curves.easeInOutCubic,
            transitionBuilder: (child, animation) {
              // Custom transition based on navigation direction
              final isForward = controller.currentIndex.value >
                  controller.previousIndex.value;

              return SlideTransition(
                position: Tween<Offset>(
                  begin: isForward
                      ? const Offset(1.0, 0.0)
                      : const Offset(-1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  ),
                ),
                child: FadeTransition(
                  opacity: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
                    ),
                  ),
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey(controller.currentIndex.value),
              child: pages[controller.currentIndex.value],
            ),
          )),
      bottomNavigationBar: Obx(() => CustomBottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
          )),
    );
  }
}
