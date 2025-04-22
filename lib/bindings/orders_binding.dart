import 'package:get/get.dart';
import '../services/firebase_service.dart';
import '../services/order_service.dart';
import '../controllers/orders_controller.dart';
import '../controllers/auth_controller.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure FirebaseService is available
    if (!Get.isRegistered<FirebaseService>()) {
      Get.put(FirebaseService(), permanent: true);
    }
    
    // Ensure OrderService is available
    if (!Get.isRegistered<OrderService>()) {
      Get.lazyPut<OrderService>(
        () => OrderService(firebaseService: Get.find<FirebaseService>()),
        fenix: true,
      );
    }
    
    // Register OrdersController
    Get.lazyPut<OrdersController>(
      () => OrdersController(
        orderService: Get.find<OrderService>(),
        authController: Get.find<AuthController>(),
      ),
    );
                // Get.lazyPut<OrdersController>(
                //    () => OrdersController(
                //     orderService: Get.find<OrderService>(),
                //      authController: Get.find<AuthController>()
                //      ), fenix: true);

  }
}
