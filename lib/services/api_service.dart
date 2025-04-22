// This file contains the implementation of the services that handle API communication
// and business logic for the Iron E-commerce App.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iron_ecommerce_app/models/category.dart';
import 'package:iron_ecommerce_app/models/product.dart';
import 'package:iron_ecommerce_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/cart_model.dart';

class ApiService {
  // Base URL for the API
  final String baseUrl = 'https://api.ironcompany.com';

  // API endpoints
  final String _loginEndpoint = '/auth/login';
  final String _registerEndpoint = '/auth/register';
  final String _productsEndpoint = '/products';
  final String _ordersEndpoint = '/orders';

  // Headers for API requests
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  // Token for authentication
  String? _token;

  // Singleton instance
  static final ApiService _instance = ApiService._internal();

  // Factory constructor
  factory ApiService() {
    return _instance;
  }

  // Internal constructor
  ApiService._internal();

  // Initialize the service
  Future<void> initialize() async {
    await _loadToken();
  }

  // Load token from shared preferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    if (_token != null) {
      _headers['Authorization'] = 'Bearer $_token';
    }
  }

  // Save token to shared preferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _token = token;
    _headers['Authorization'] = 'Bearer $_token';
  }

  // Clear token from shared preferences
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _token = null;
    _headers.remove('Authorization');
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _token != null;
  }

  // Login user
  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl$_loginEndpoint'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data['token']);
      return User.fromJson(data['user']);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Register user
  Future<User> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl$_registerEndpoint'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _saveToken(data['token']);
      return User.fromJson(data['user']);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  // Logout user
  Future<void> logout() async {
    await clearToken();
  }

  // Get all products
  Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl$_productsEndpoint'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products: ${response.body}');
    }
  }

  // Get product by ID
  Future<Product> getProductById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl$_productsEndpoint/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load product: ${response.body}');
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl$_productsEndpoint?category=$category'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products: ${response.body}');
    }
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl$_productsEndpoint?search=$query'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search products: ${response.body}');
    }
  }

  // Create order
  Future<Map<String, dynamic>> createOrder(
      CartModel cart, String shippingAddress, String paymentMethod) async {
    if (!isAuthenticated()) {
      throw Exception('User not authenticated');
    }

    final items = cart.items.map((itemNo, item) => MapEntry(itemNo, {
          'product_id': item.productId,
          'quantity': item.quantity,
          'unit': item.unit,
        }));

    final response = await http.post(
      Uri.parse('$baseUrl$_ordersEndpoint'),
      headers: _headers,
      body: jsonEncode({
        'items': items,
        'shipping_address': shippingAddress,
        'payment_method': paymentMethod,
        'subtotal': cart.subtotal,
        'shipping_cost': cart.shippingCost,
        'tax': cart.tax,
        'total': cart.total,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  // Get user orders
  Future<List<Map<String, dynamic>>> getUserOrders() async {
    if (!isAuthenticated()) {
      throw Exception('User not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl$_ordersEndpoint'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load orders: ${response.body}');
    }
  }

  // Get order by ID
  Future<Map<String, dynamic>> getOrderById(String id) async {
    if (!isAuthenticated()) {
      throw Exception('User not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl$_ordersEndpoint/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load order: ${response.body}');
    }
  }

  // Request custom quote
  Future<void> requestCustomQuote(
      String productId, double quantity, String unit, String notes) async {
    if (!isAuthenticated()) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/quotes'),
      headers: _headers,
      body: jsonEncode({
        'product_id': productId,
        'quantity': quantity,
        'unit': unit,
        'notes': notes,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to request quote: ${response.body}');
    }
  }

  // Get technical specifications
  Future<Map<String, dynamic>> getTechnicalSpecs(String productId) async {
    final response = await http.get(
      Uri.parse('$baseUrl$_productsEndpoint/$productId/specs'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load specifications: ${response.body}');
    }
  }

  // Get certifications
  Future<List<String>> getCertifications(String productId) async {
    final response = await http.get(
      Uri.parse('$baseUrl$_productsEndpoint/$productId/certifications'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.cast<String>();
    } else {
      throw Exception('Failed to load certifications: ${response.body}');
    }
  }
}

// Mock implementation for development
class MockApiService {
  // Get mock products
  List<Product> getMockProducts() {
    return [
      Product(
        id: '1',
        name: 'Structural I-Beam',
        description: 'Standard structural I-beam for construction projects',
        price: 850.0,
        unit: 'ton',
        category: Category(id: '1', name: 'Beams', description: 'Steel Beams'),
        grade: 'A36',
        material: 'Carbon Steel',
        // dimensions: {
        //   'width': 8,
        //   'height': 8,
        //   'length': 20,
        // },
        imageUrl: 'assets/images/i_beam.jpg',
        inStock: true,
        createdAt: DateTime.now().toString(),
        // updatedAt: DateTime.now(),
      ),
      Product(
        id: '2',
        name: 'Steel Sheet',
        description: 'Hot-rolled steel sheet for various applications',
        price: 950.0,
        unit: 'ton',
        category:
            Category(id: '2', name: 'Sheets', description: 'Steel Sheets'),
        grade: 'A572',
        material: 'Carbon Steel',
        // dimensions: {
        //   'width': 48,
        //   'length': 96,
        //   'thickness': 0.25,
        // },
        imageUrl: 'assets/images/steel_sheet.jpg',
        inStock: true,
        createdAt: DateTime.now().toString(),
      ),
      Product(
        id: '3',
        name: 'Steel Pipe',
        description:
            'Seamless steel pipe for structural and fluid applications',
        price: 1200.0,
        unit: 'ton',
        category: Category(id: '3', name: 'Pipes', description: 'Steel Pipes'),
        grade: 'A53',
        material: 'Carbon Steel',
        // dimensions: {
        //   'diameter': 6,
        //   'wall_thickness': 0.28,
        //   'length': 20,
        // },
        imageUrl: 'assets/images/steel_pipe.jpg',
        inStock: true,
        createdAt: DateTime.now().toString(),
      ),
      Product(
        id: '4',
        name: 'Reinforcement Bar',
        description: 'Deformed steel bar for concrete reinforcement',
        price: 780.0,
        unit: 'ton',
        category: Category(
            id: '4',
            name: 'Reinforcement',
            description: 'Steel Reinforcement Bars'),
        grade: 'A615',
        material: 'Carbon Steel',
        // dimensions: {
        //   'diameter': 0.75,
        //   'length': 20,
        // },
        imageUrl: 'assets/images/rebar.jpg',
        inStock: true,
        createdAt: DateTime.now().toString(),
      ),
      Product(
        id: '5',
        name: 'Steel Angle',
        description: 'L-shaped structural steel for framing and supports',
        price: 820.0,
        unit: 'ton',
        category:
            Category(id: '5', name: 'Angles', description: 'Steel Angles'),

        grade: 'A36',
        material: 'Carbon Steel',
        // dimensions: {
        //   'width': 4,
        //   'height': 4,
        //   'thickness': 0.375,
        //   'length': 20,
        // },
        imageUrl: 'assets/images/steel_angle.jpg',
        inStock: true,
        createdAt: DateTime.now().toString(),
      ),
    ];
  }

  // Get mock user
  User getMockUser() {
    return User(
      uid: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '555-123-4567',
      type: 'business',
      addresses: [
        Address(
          // id: '1',
          name: 'Office',
          street: '123 Main St',
          city: 'Anytown',
          state: 'CA',
          zipCode: '12345',
          country: 'USA',
        ),
        Address(
          // id: '2',
          name: 'Warehouse',
          street: '456 Industrial Blvd',
          city: 'Anytown',
          state: 'CA',
          zipCode: '12345',
          country: 'USA',
        ),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Get mock certifications
  List<String> getMockCertifications() {
    return [
      'ASTM A36',
      'ASTM A53',
      'ASTM A615',
      'ISO 9001',
    ];
  }
}
