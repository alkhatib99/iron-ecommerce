import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iron_ecommerce_app/services/auth_service.dart';
import 'package:iron_ecommerce_app/services/firebase_service.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'controllers/app_controller.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(FirebaseService());
  Get.put(AuthService(firebaseService: Get.find<FirebaseService>()));
  runApp(  MyApp());
}

class MyApp extends StatelessWidget {
    MyApp({super.key});
  // final firebaseService = FirebaseService();
  // final authService = AuthService(firebaseService: firebaseService);
    final authService = Get.find<AuthService>();
  @override
  Widget build(BuildContext context) {
    // Initialize AppController
    final appController = Get.put(AppController());
    
    return Obx(() => GetMaterialApp(
      title: 'Iron E-commerce',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appController.themeMode,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.SPLASH,
      getPages: AppPages.pages,
    ));
  }
}
