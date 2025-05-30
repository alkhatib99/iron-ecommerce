import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_ecommerce_app/models/category.dart';
import 'package:iron_ecommerce_app/models/product.dart';
import '../services/firebase_service.dart';

class ProductController extends GetxController {
  final FirebaseService _firebaseService;
  
  // Observable state variables
  final products = <Product>[].obs;
  final categories = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final error = Rxn<String>();
  
  // Constructor with dependency injection
  ProductController({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;
  
  @override
  void onInit() {
    super.onInit();
    loadProducts();
    loadCategories();
  }
  
  // Load products
  Future<void> loadProducts() async {
    isLoading.value = true;
    error.value = null;
    
    try {
      List<DocumentSnapshot> docs = await _firebaseService.getProducts();
      products.value = docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Product.fromJson(data);

            }).toList();

        for (final product in products) {
    await fetchCategory(product);
  }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
    
  // Load products by category
    
  }
  Future<void> fetchCategory(Product product) async {
  if (product.categoryRef != null) {
    final doc = await product.categoryRef!.get();
    if (doc.exists) {
      product.category = Category.fromMap(doc.data() as Map<String, dynamic>);
    }
  }
}

  // Load products by category
  Future<void> loadProductsByCategory(String category) async {
    isLoading.value = true;
    error.value = null;
    
    try {
      List<DocumentSnapshot> docs = await _firebaseService.getProductsByCategory(category);
      products.value = docs.map((doc) {
       
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Product.fromJson(data);
      }).toList();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Get product by ID
  Future<Map<String, dynamic>?> getProductById(String id) async {
    try {
      DocumentSnapshot doc = await _firebaseService.getProductById(id);
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      error.value = e.toString();
      return null;
    }
  }
  
  // Load categories
  Future<void> loadCategories() async {
    isLoading.value = true;
    error.value = null;
    
    try {
      List<DocumentSnapshot> docs = await _firebaseService.getCategories();
      categories.value = docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Listen to products stream
  void listenToProducts() {
    _firebaseService.getProductsStream().listen((QuerySnapshot snapshot) {
      products.value = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Product.fromJson(data);
      }).toList();
    }, onError: (error) {
      this.error.value = error.toString();
    });
  }
  
  // Listen to categories stream
  void listenToCategories() {
    _firebaseService.getCategoriesStream().listen((QuerySnapshot snapshot) {
      categories.value = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    }, onError: (error) {
      this.error.value = error.toString();
    });
  }
  
  // Search products
  
  // Filter products by price range
  List<Product> filterByPriceRange(double minPrice, double maxPrice) {
    return    products.where((product) {
      double price = product.price ?? 0.0;
      return price >= minPrice && price <= maxPrice;
    }).toList();
  }
  
  // Sort products
  List<Map<String, dynamic>> sortProducts(String sortBy, bool ascending) {
    List<Map<String, dynamic>> sortedProducts = List.from(products);
    
    switch (sortBy) {
      case 'price':
        sortedProducts.sort((a, b) {
          double priceA = a['price'].toDouble();
          double priceB = b['price'].toDouble();
          return ascending ? priceA.compareTo(priceB) : priceB.compareTo(priceA);
        });
        break;
      case 'name':
        sortedProducts.sort((a, b) {
          String nameA = a['name'];
          String nameB = b['name'];
          return ascending ? nameA.compareTo(nameB) : nameB.compareTo(nameA);
        });
        break;
      case 'date':
        sortedProducts.sort((a, b) {
          Timestamp dateA = a['createdAt'];
          Timestamp dateB = b['createdAt'];
          return ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
        });
        break;
      default:
        // No sorting
        break;
    }
    
    return sortedProducts;
  }
}
