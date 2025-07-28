import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/storage_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Register StorageService if not already registered
    if (!Get.isRegistered<StorageService>()) {
      Get.putAsync<StorageService>(() async {
        final service = StorageService();
        await service.init();
        return service;
      }, permanent: true);
    }
    
    // Register AuthController
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
  
}