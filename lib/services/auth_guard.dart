import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iron_ecommerce_app/controllers/auth_controller.dart';
import 'package:iron_ecommerce_app/services/auth_service.dart';
import '../routes/app_routes.dart';

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    return authController.isLoggedIn
        ? null
        : const RouteSettings(name: Routes.LOGIN);
  }
}
