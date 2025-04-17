import 'package:get/get.dart';
import '../services/firebase_service.dart';
import '../controllers/product_controller.dart';

class ProductBinding implements Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<FirebaseService>(() => FirebaseService(), fenix: true);
    
    // Controllers
    Get.lazyPut<ProductController>(
      () => ProductController(firebaseService: Get.find<FirebaseService>()),
      fenix: true,
    );
  }
}
