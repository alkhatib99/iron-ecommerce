import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class CartModel extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  Map<String, CartItem> get items => _items;
  List<CartItem> get itemsList => _items.values.toList();
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmpty => _items.isEmpty;
  
  // Cart totals
  double get subtotal => _items.values.fold(0, (sum, item) => sum + item.totalPrice);
  double get shippingCost => subtotal > 1000 ? 0 : 50; // Free shipping for orders over $1000
  double get tax => subtotal * 0.08; // 8% tax
  double get total => subtotal + shippingCost + tax;
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  // Add item to cart
  void addItem(String productId, String name, double price, String unit, String imageUrl, int quantity) {
    if (_items.containsKey(productId)) {
      // Update existing item
      _items[productId]!.quantity += quantity;
    } else {
      // Add new item
      _items[productId] = CartItem(
        productId: productId,
        name: name,
        price: price,
        unit: unit,
        imageUrl: imageUrl,
        quantity: quantity,
      );
    }
    notifyListeners();
  }

  // Update item quantity
  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity <= 0) {
        removeItem(productId);
      } else {
        _items[productId]!.quantity = quantity;
        notifyListeners();
      }
    }
  }

  // Remove item from cart
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Clear cart
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Load cart from Firebase
  Future<void> loadCart(String userId, FirebaseService firebaseService) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final cartItems = await firebaseService.getCartItems(userId);
      _items.clear();
      
      for (var doc in cartItems) {
        final data = doc.data() as Map<String, dynamic>;
        final productId = data['productId'] as String;
        
        _items[productId] = CartItem(
          id: doc.id,
          productId: productId,
          name: data['name'] as String,
          price: (data['price'] as num).toDouble(),
          unit: data['unit'] as String,
          imageUrl: data['imageUrl'] as String,
          quantity: data['quantity'] as int,
        );
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save cart to Firebase
  Future<void> saveCart(String userId, FirebaseService firebaseService) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Clear existing cart
      await firebaseService.clearCart(userId);
      
      // Add all items
      for (var item in _items.values) {
        await firebaseService.addToCart(userId, {
          'productId': item.productId,
          'name': item.name,
          'price': item.price,
          'unit': item.unit,
          'imageUrl': item.imageUrl,
          'quantity': item.quantity,
        });
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Listen to cart changes from Firebase
  void listenToCart(String userId, FirebaseService firebaseService) {
    firebaseService.getCartItemsStream(userId).listen((snapshot) {
      _items.clear();
      
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final productId = data['productId'] as String;
        
        _items[productId] = CartItem(
          id: doc.id,
          productId: productId,
          name: data['name'] as String,
          price: (data['price'] as num).toDouble(),
          unit: data['unit'] as String,
          imageUrl: data['imageUrl'] as String,
          quantity: data['quantity'] as int,
        );
      }
      
      notifyListeners();
    }, onError: (error) {
      _error = error.toString();
      notifyListeners();
    });
  }
}

class CartItem {
  final String? id; // Firestore document ID
  final String productId;
  final String name;
  final double price;
  final String unit;
  final String imageUrl;
  int quantity;

  CartItem({
    this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.unit,
    required this.imageUrl,
    required this.quantity,
  });

  double get totalPrice => price * quantity;
}
