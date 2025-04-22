import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'app_title': 'Iron E-commerce App',
          'products': 'Products',
          'categories': 'Categories',
          'cart': 'Cart',
          'orders': 'Orders',
          'add_product': 'Add Product',
        },
        'ar': {
          'app_title': 'تطبيق تجارة الحديد',
          'products': 'المنتجات',
          'categories': 'الفئات',
          'cart': 'السلة',
          'orders': 'الطلبات',
          'add_product': 'إضافة منتج',
        }
      };
}
