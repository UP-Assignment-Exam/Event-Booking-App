import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/auth_controller.dart';
import '../services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize StorageService first (permanent service)
    Get.putAsync<StorageService>(() async {
      final service = StorageService();
      await service.init();
      return service;
    }, permanent: true);
    
    // Register AuthController as permanent to persist across routes
    Get.put<AuthController>(AuthController(), permanent: true);
    
    // Register NavigationController (if you have one)
    if (!Get.isRegistered<NavigationController>()) {
      Get.put<NavigationController>(NavigationController(), permanent: true);
    }
  }
}