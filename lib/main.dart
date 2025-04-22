import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iron_ecommerce_app/bindings/home_binding.dart';
import 'package:iron_ecommerce_app/bindings/order_binding.dart';
import 'package:iron_ecommerce_app/bindings/orders_binding.dart';
import 'package:iron_ecommerce_app/services/auth_service.dart';
import 'package:iron_ecommerce_app/services/firebase_service.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'controllers/app_controller.dart';
import 'theme/app_theme.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  OrderBinding().dependencies();
  OrdersBinding().dependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // final authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    // Initialize AppController
    final appController = Get.put(AppController());
    // final firebaseService =  Get.put(FirebaseService());
    //   Get.put(AuthService(firebaseService: Get.find<FirebaseService>()));
    return Obx(() => GetMaterialApp(
          title: 'Iron E-commerce',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appController.themeMode,
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.SPLASH,
          getPages: AppPages.pages,
          initialBinding: HomeBinding(), // Initialize bindings
        ));
  }
}
