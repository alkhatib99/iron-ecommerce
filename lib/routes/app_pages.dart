import 'package:get/get.dart';
import 'package:iron_ecommerce_app/bindings/order_binding.dart';
import 'package:iron_ecommerce_app/bindings/product_binding.dart';
import 'package:iron_ecommerce_app/screens/account_screen.dart';
import 'package:iron_ecommerce_app/screens/cart_screen.getx.dart';
import 'package:iron_ecommerce_app/screens/checkout_screen.dart';
import 'package:iron_ecommerce_app/screens/home_screen.getx.dart';
import 'package:iron_ecommerce_app/screens/login_screen.dart';
import 'package:iron_ecommerce_app/screens/order_confirmation_screen.dart';
import 'package:iron_ecommerce_app/screens/orders_screen.dart';
import 'package:iron_ecommerce_app/screens/product_detail_screen.getx.dart';
import 'package:iron_ecommerce_app/screens/register_screen.dart';
import 'package:iron_ecommerce_app/screens/splash_screen.dart';
import 'package:iron_ecommerce_app/services/auth_guard.dart';
import '../routes/app_routes.dart';
import '../bindings/home_binding.dart';
import '../bindings/auth_binding.dart';

class AppPages {
  // should check the account route
  // if the user is logged in or not
  // if not redirect to login screen
  // if yes redirect to account screen

  // should check auth route

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
      page: () => LoginScreen(),
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
      middlewares: [
        AuthGuard(),
      ],
    ),
    GetPage(
      name: Routes.ACCOUNT,
      page: () => AccountScreen(),
      binding: HomeBinding(),
      middlewares: [
        AuthGuard(),
      ],
    ),
    GetPage(
      name: Routes.ORDER_CONFIRMATION,
      page: () => OrderConfirmationScreen(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: Routes.ORDERS,
      page: () => OrdersScreen(),
      binding: HomeBinding(),
      middlewares: [
        AuthGuard(),
      ],
    ),
    // GetPage(
    //   name: Routes.ORDER_DETAILS,
    //   page: () =>   OrderDetailsScreen(),
    //   binding: OrderBinding(),
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
