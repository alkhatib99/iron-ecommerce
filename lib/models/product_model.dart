import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';

class ProductModel extends ChangeNotifier {
  final FirebaseService _firebaseService;
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;
  String? _error;

  ProductModel({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;

  // Getters
  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load products
  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      List<DocumentSnapshot> docs = await _firebaseService.getProducts();
      _products = docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load products by category
  Future<void> loadProductsByCategory(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      List<DocumentSnapshot> docs = await _firebaseService.getProductsByCategory(category);
      _products = docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
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
      _error = e.toString();
      return null;
    }
  }

  // Load categories
  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      List<DocumentSnapshot> docs = await _firebaseService.getCategories();
      _categories = docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Listen to products stream
  void listenToProducts() {
    _firebaseService.getProductsStream().listen((QuerySnapshot snapshot) {
      _products = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
      notifyListeners();
    }, onError: (error) {
      _error = error.toString();
      notifyListeners();
    });
  }

  // Listen to categories stream
  void listenToCategories() {
    _firebaseService.getCategoriesStream().listen((QuerySnapshot snapshot) {
      _categories = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
      notifyListeners();
    }, onError: (error) {
      _error = error.toString();
      notifyListeners();
    });
  }

  // Search products
  List<Map<String, dynamic>> searchProducts(String query) {
    if (query.isEmpty) return _products;
    
    query = query.toLowerCase();
    return _products.where((product) {
      return product['name'].toLowerCase().contains(query) ||
          product['description'].toLowerCase().contains(query) ||
          product['category'].toLowerCase().contains(query) ||
          product['material'].toLowerCase().contains(query) ||
          product['grade'].toLowerCase().contains(query);
    }).toList();
  }

  // Filter products by price range
  List<Map<String, dynamic>> filterByPriceRange(double minPrice, double maxPrice) {
    return _products.where((product) {
      double price = product['price'].toDouble();
      return price >= minPrice && price <= maxPrice;
    }).toList();
  }

  // Sort products
  List<Map<String, dynamic>> sortProducts(String sortBy, bool ascending) {
    List<Map<String, dynamic>> sortedProducts = List.from(_products);
    
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
