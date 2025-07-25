import 'package:event_booking_app/app/controllers/navigation_controller.dart';
import 'package:get/get.dart';
// import your controllers/services

class InitialBinding extends Bindings {
  @override
  void dependencies() {
        Get.put(NavigationController());

    // Get.put(YourController());
    // Get.lazyPut(() => YourService());
  }
}
