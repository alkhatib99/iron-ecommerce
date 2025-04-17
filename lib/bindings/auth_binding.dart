import 'package:get/get.dart';
import '../services/firebase_service.dart';
import '../controllers/auth_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<FirebaseService>(() => FirebaseService(), fenix: true);
    
    // Controllers
    Get.lazyPut<AuthController>(
      () => AuthController(firebaseService: Get.find<FirebaseService>()),
      fenix: true,
    );
  }
}
