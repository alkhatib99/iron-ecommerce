import 'package:get/get.dart';
import '../services/firebase_service.dart';

class CartController extends GetxController {
  final items = <String, CartItem>{}.obs;
  final isLoading = false.obs;
  final error = Rxn<String>();
  
  // Optional FirebaseService for persistence
  final FirebaseService? _firebaseService;
  
  // Constructor with optional dependency injection
  CartController({FirebaseService? firebaseService}) 
      : _firebaseService = firebaseService;
  
  // Getters
  List<CartItem> get itemsList => items.values.toList();
  bool get isEmpty => items.isEmpty;
  
  // Cart totals
  double get subtotal => items.values.fold(0, (sum, item) => sum + item.totalPrice);
  double get shippingCost => subtotal > 1000 ? 0 : 50; // Free shipping for orders over $1000
  double get tax => subtotal * 0.08; // 8% tax
  double get total => subtotal + shippingCost + tax;
  int get itemCount => items.values.fold(0, (sum, item) => sum + item.quantity);
  
  // Add item to cart
  void addItem(String productId, String name, double price, String unit, String imageUrl, int quantity) {
    if (items.containsKey(productId)) {
      // Update existing item
      final item = items[productId]!;
      item.quantity += quantity;
      items.refresh(); // Notify GetX that the map has changed
    } else {
      // Add new item
      items[productId] = CartItem(
        productId: productId,
        name: name,
        price: price,
        unit: unit,
        imageUrl: imageUrl,
        quantity: quantity,
      );
    }
  }
  
  // Update item quantity
  void updateQuantity(String productId, int quantity) {
    if (items.containsKey(productId)) {
      if (quantity <= 0) {
        removeItem(productId);
      } else {
        items[productId]!.quantity = quantity;
        items.refresh(); // Notify GetX that the map has changed
      }
    }
  }
  
  // Remove item from cart
  void removeItem(String productId) {
    items.remove(productId);
  }
  
  // Clear cart
  void clear() {
    items.clear();
  }
  
  // Load cart from Firebase
  Future<void> loadCart(String userId) async {
    if (_firebaseService == null) return;
    
    isLoading.value = true;
    error.value = null;
    
    try {
      final cartItems = await _firebaseService.getCartItems(userId);
      items.clear();
      
      for (var doc in cartItems) {
        final data = doc.data() as Map<String, dynamic>;
        final productId = data['productId'] as String;
        
        items[productId] = CartItem(
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
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Save cart to Firebase
  Future<void> saveCart(String userId) async {
    if (_firebaseService == null) return;
    
    isLoading.value = true;
    error.value = null;
    
    try {
      // Clear existing cart
      await _firebaseService.clearCart(userId);
      
      // Add all items
      for (var item in items.values) {
        await _firebaseService.addToCart(userId, {
          'productId': item.productId,
          'name': item.name,
          'price': item.price,
          'unit': item.unit,
          'imageUrl': item.imageUrl,
          'quantity': item.quantity,
        });
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Listen to cart changes from Firebase
  void listenToCart(String userId) {
    if (_firebaseService == null) return;
    
    _firebaseService.getCartItemsStream(userId).listen((snapshot) {
      items.clear();
      
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final productId = data['productId'] as String;
        
        items[productId] = CartItem(
          id: doc.id,
          productId: productId,
          name: data['name'] as String,
          price: (data['price'] as num).toDouble(),
          unit: data['unit'] as String,
          imageUrl: data['imageUrl'] as String,
          quantity: data['quantity'] as int,
        );
      }
    }, onError: (error) {
      this.error.value = error.toString();
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

  // Factory constructor to create a CartItem from a map (e.g., from Firestore)
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as String?,
      productId: map['productId'] as String,
      name: map['name'] as String,
      price: (map['price'] is num) ? (map['price'] as num).toDouble() : 0.0,
      unit: map['unit'] as String,
      imageUrl: map['imageUrl'] as String,
      quantity: map['quantity'] as int,
    );
  }
  // Convert CartItem to a map (e.g., for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'unit': unit,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }
}
