import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iron_ecommerce_app/controllers/auth_controller.dart';
import 'package:iron_ecommerce_app/models/product.dart';
import 'package:iron_ecommerce_app/screens/account_screen.dart';
import 'package:iron_ecommerce_app/screens/cart_screen.getx.dart';
import 'package:iron_ecommerce_app/screens/login_screen.dart';
import 'package:iron_ecommerce_app/services/auth_service.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/user_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/responsive_widgets.dart';
import '../../widgets/product_widgets.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<String> _categories = [
    'Structural',
    'Sheets',
    'Pipes',
    'Reinforcement',
    'Angles'
  ];
  final List<IconData> _categoryIcons = [
    Icons.view_in_ar,
    Icons.layers,
    Icons.circle,
    Icons.linear_scale,
    Icons.change_history
  ];

  // GetX Controllers
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    // Load products and categories
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.loadProducts();
      productController.loadCategories();

      // Listen to real-time updates
      productController.listenToProducts();
      productController.listenToCategories();

      // Load cart items for current user
      if (userController.isLoggedIn) {
        cartController.loadCart(userController.userData.value!['uid']);
        cartController.listenToCart(userController.userData.value!['uid']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screens = [
      _buildHomeTab(),
      _buildCategoriesTab(),
      _buildCartTab(),
      _buildAccountTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Iron E-commerce'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          Obx(() {
            return IconButton(
              icon: Badge(
                label: Text(cartController.itemCount.toString()),
                isLabelVisible: cartController.itemCount > 0,
                child: const Icon(Icons.shopping_cart),
              ),
              onPressed: () {
                Get.toNamed(Routes.CART);
              },
            );
          }),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            // title: const Text('My Orders'),
            onPressed: () => Get.toNamed(Routes.ORDERS),
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return Obx(() {
      if (productController.isLoading.value) {
        return const CustomLoadingIndicator();
      }

      if (productController.error.value != null) {
        return CustomErrorWidget(
          message: productController.error.value!,
          onRetry: () {
            productController.loadProducts();
            productController.loadCategories();
          },
        );
      }

      if (productController.products.isEmpty) {
        return const CustomEmptyState(
          title: 'No Products Found',
          message: 'There are no products available at the moment.',
          icon: Icons.inventory_2_outlined,
        );
      }

      return SingleChildScrollView(
        child: ResponsiveContainer(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Promotion banner
              PromotionBanner(
                title: 'Special Offer',
                description:
                    'Get 10% off on all structural steel products. Limited time offer!',
                buttonText: 'Shop Now',
                onButtonPressed: () {
                  // Navigate to structural category
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: AppTheme.paddingXLarge),

              // Categories section
              Text(
                'Categories',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: AppTheme.paddingLarge),

              // Category grid
              SizedBox(
                height: 145,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(right: AppTheme.paddingMedium),
                      child: SizedBox(
                        width: 135,
                        child: CategoryCard(
                          category: _categories[index],
                          icon: _categoryIcons[index],
                          onTap: () {
                            // Load products by category
                            productController
                                .loadProductsByCategory(_categories[index]);
                            // Navigate to categories tab
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppTheme.paddingXLarge),

              // Featured products section
              Text(
                'Featured Products',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: AppTheme.paddingLarge),

              // Featured products grid
              ResponsiveGridView(
                children: productController.products.take(4).map((product) {
                  log('Product :  $product');
                  return ProductCard(
                    product: product,
                    onTap: () {
                      Get.toNamed(
                        Routes.PRODUCT_DETAIL,
                        arguments: {'productId': product.id ?? ''},
                      );
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: AppTheme.paddingXLarge),

              // Industry tools section
              Text(
                'Industry Tools',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: AppTheme.paddingLarge),

              // Tools list
              Column(
                children: [
                  FeatureCard(
                    title: 'Steel Weight Calculator',
                    description:
                        'Calculate the weight of different steel products based on dimensions.',
                    icon: Icons.calculate,
                    onTap: () {
                      Get.toNamed(Routes.CALCULATOR);
                    },
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                  FeatureCard(
                    title: 'Material Requirement Estimator',
                    description:
                        'Estimate material requirements for your construction project.',
                    icon: Icons.architecture,
                    onTap: () {
                      // TODO: Navigate to material estimator screen
                    },
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                  FeatureCard(
                    title: 'Technical Specifications',
                    description:
                        'View detailed technical specifications for all products.',
                    icon: Icons.description,
                    onTap: () {
                      // TODO: Navigate to specifications screen
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.paddingXLarge),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCategoriesTab() {
    return Obx(() {
      if (productController.isLoading.value) {
        return const CustomLoadingIndicator();
      }

      if (productController.error.value != null) {
        return CustomErrorWidget(
          message: productController.error.value!,
          onRetry: () {
            productController.loadProducts();
          },
        );
      }

      return SingleChildScrollView(
        child: ResponsiveContainer(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category filter chips
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(right: AppTheme.paddingSmall),
                      child: CustomChip(
                        label: _categories[index],
                        onTap: () {
                          productController
                              .loadProductsByCategory(_categories[index]);
                        },
                        icon: _categoryIcons[index],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppTheme.paddingLarge),

              // Products grid
              if (productController.products.isEmpty)
                const CustomEmptyState(
                  title: 'No Products Found',
                  message: 'There are no products available in this category.',
                  icon: Icons.inventory_2_outlined,
                )
              else
                ResponsiveGridView(
                  children: productController.products.map((product) {
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Get.toNamed(
                          Routes.PRODUCT_DETAIL,
                          arguments: {'productId': product.id ?? ''},
                        );
                      },
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCartTab() {
    return GetRouterOutlet.builder(
      routerDelegate: GetDelegate(
        notFoundRoute: GetPage(
          name: Routes.CART,
          page: () => const CartScreen(),
        ),
      ),
      builder: (context, delegate, currentRoute) {
        return const CartScreen();
      },
    );
  }

  Widget _buildAccountTab() {
    return GetRouterOutlet.builder(
        routerDelegate: GetDelegate(
          notFoundRoute: GetPage(
            name: Routes.ACCOUNT,
            page: () => AccountScreen(),
          ),
        ),
        builder: (context, delegate, currentRoute) {
          // final authService = Get.find<AuthService>();
          // final auth = Get.arguments; // Get the auth argument from the route
          return AccountScreen();
          // currentRoute.currentPage.name
        }
        // If user is not logged in, sho
        );
  }
}
