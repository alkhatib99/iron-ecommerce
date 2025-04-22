import 'package:get/get.dart';
import '../services/firebase_service.dart';
import '../services/order_service.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure FirebaseService is available
    if (!Get.isRegistered<FirebaseService>()) {
      Get.put(FirebaseService(), permanent: true);
    }
    
    // Register OrderService
    Get.lazyPut<OrderService>(
      () => OrderService(firebaseService: Get.find<FirebaseService>()),
      fenix: true,
    );
  }
}
