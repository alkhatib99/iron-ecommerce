import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';

class UserModel extends ChangeNotifier {
  final FirebaseService _firebaseService;
  Map<String, dynamic>? _userData;
  bool _isLoading = false;
  String? _error;

  UserModel({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;

  // Getters
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _userData != null;

  // Initialize user data
  Future<void> initUserData(String uid) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      DocumentSnapshot doc = await _firebaseService.getUserDocument(uid);
      if (doc.exists) {
        _userData = doc.data() as Map<String, dynamic>?;
      } else {
        _error = 'User data not found';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear user data on logout
  void clearUserData() {
    _userData = null;
    notifyListeners();
  }

  // Update user data
  Future<void> updateUserData(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_userData == null || _userData!['uid'] == null) {
        throw Exception('User not initialized');
      }

      await _firebaseService.updateUserDocument(_userData!['uid'], data);
      
      // Update local user data
      _userData = {...?_userData, ...data};
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add address
  Future<void> addAddress(Map<String, dynamic> address) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_userData == null || _userData!['uid'] == null) {
        throw Exception('User not initialized');
      }

      List<dynamic> addresses = _userData!['addresses'] ?? [];
      addresses.add(address);

      await _firebaseService.updateUserDocument(
        _userData!['uid'],
        {'addresses': addresses},
      );

      // Update local user data
      _userData = {...?_userData, 'addresses': addresses};
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update address
  Future<void> updateAddress(int index, Map<String, dynamic> address) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_userData == null || _userData!['uid'] == null) {
        throw Exception('User not initialized');
      }

      List<dynamic> addresses = List.from(_userData!['addresses'] ?? []);
      if (index >= 0 && index < addresses.length) {
        addresses[index] = address;

        await _firebaseService.updateUserDocument(
          _userData!['uid'],
          {'addresses': addresses},
        );

        // Update local user data
        _userData = {...?_userData, 'addresses': addresses};
      } else {
        throw Exception('Invalid address index');
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Remove address
  Future<void> removeAddress(int index) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_userData == null || _userData!['uid'] == null) {
        throw Exception('User not initialized');
      }

      List<dynamic> addresses = List.from(_userData!['addresses'] ?? []);
      if (index >= 0 && index < addresses.length) {
        addresses.removeAt(index);

        await _firebaseService.updateUserDocument(
          _userData!['uid'],
          {'addresses': addresses},
        );

        // Update local user data
        _userData = {...?_userData, 'addresses': addresses};
      } else {
        throw Exception('Invalid address index');
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get user orders
  Future<List<DocumentSnapshot>> getUserOrders() async {
    if (_userData == null || _userData!['uid'] == null) {
      throw Exception('User not initialized');
    }

    return await _firebaseService.getUserOrders(_userData!['uid']);
  }

  // Get user orders stream
  Stream<QuerySnapshot> getUserOrdersStream() {
    if (_userData == null || _userData!['uid'] == null) {
      throw Exception('User not initialized');
    }

    return _firebaseService.getUserOrdersStream(_userData!['uid']);
  }
}
