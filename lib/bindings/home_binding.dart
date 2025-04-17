import 'package:get/get.dart';
import '../services/firebase_service.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<FirebaseService>(() => FirebaseService(), fenix: true);
    
    // Controllers
    Get.lazyPut<AuthController>(
      () => AuthController(firebaseService: Get.find<FirebaseService>()),
      fenix: true,
    );
    
    Get.lazyPut<UserController>(
      () => UserController(firebaseService: Get.find<FirebaseService>()),
      fenix: true,
    );
    
    Get.lazyPut<ProductController>(
      () => ProductController(firebaseService: Get.find<FirebaseService>()),
      fenix: true,
    );
    
    Get.lazyPut<CartController>(
      () => CartController(firebaseService: Get.find<FirebaseService>()),
      fenix: true,
    );
  }
}
