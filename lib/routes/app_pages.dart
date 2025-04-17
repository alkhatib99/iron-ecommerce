import 'package:get/get.dart';
import 'package:iron_ecommerce_app/bindings/product_binding.dart';
import 'package:iron_ecommerce_app/screens/account_screen.dart';
import 'package:iron_ecommerce_app/screens/cart_screen.getx.dart';
import 'package:iron_ecommerce_app/screens/checkout_screen.dart';
import 'package:iron_ecommerce_app/screens/home_screen.getx.dart';
import 'package:iron_ecommerce_app/screens/login_screen.dart';
import 'package:iron_ecommerce_app/screens/product_detail_screen.getx.dart';
import 'package:iron_ecommerce_app/screens/register_screen.dart';
import 'package:iron_ecommerce_app/screens/splash_screen.dart';
import '../routes/app_routes.dart';
import '../bindings/home_binding.dart';
import '../bindings/auth_binding.dart';
class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.PRODUCT_DETAIL,
      page: () => const ProductDetailScreen(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.CART,
      page: () => const CartScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.CHECKOUT,
      page: () => const CheckoutScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.ACCOUNT,
      page: () => const AccountScreen(),
      binding: HomeBinding(),
    ),
    // GetPage(
    //   name: Routes.ORDER_CONFIRMATION,
    //   page: () => const OrderConfirmationScreen(),
    //   binding: HomeBinding(),
    // ),
    // GetPage(
    //   name: Routes.CALCULATOR,
    //   page: () => const CalculatorScreen(),
    //   binding: HomeBinding(),
    // ),
    // GetPage(
    //   name: Routes.PRODUCT_LIST,
    //   page: () => const ProductListScreen(),
    //   binding: ProductBinding(),
    // ),
  ];
}
