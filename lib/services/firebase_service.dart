import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Getters for Firebase instances
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;

  // Collection references
  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get productsCollection =>
      _firestore.collection('products');
  CollectionReference get categoriesCollection =>
      _firestore.collection('categories');
  CollectionReference get ordersCollection => _firestore.collection('orders');
  CollectionReference get cartCollection => _firestore.collection('carts');

  // User methods
  Future<void> createUserDocument(User user, String name, String phone) async {
    await usersCollection.doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'name': name,
      'phone': phone,
      'type': 'customer', // Default user type
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getUserDocument(String uid) async {
    return await usersCollection.doc(uid).get();
  }

  Future<void> updateUserDocument(String uid, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await usersCollection.doc(uid).update(data);
  }

  // Product methods
  Future<List<DocumentSnapshot>> getProducts() async {
    QuerySnapshot snapshot = await productsCollection.get();
    return snapshot.docs;
  }

  Future<List<DocumentSnapshot>> getProductsByCategory(String category) async {
    QuerySnapshot snapshot =
        await productsCollection.where('category', isEqualTo: category).get();
    return snapshot.docs;
  }

  Future<DocumentSnapshot> getProductById(String id) async {
    return await productsCollection.doc(id).get();
  }

  Stream<QuerySnapshot> getProductsStream() {
    return productsCollection.snapshots();
  }

  // Category methods
  Future<List<DocumentSnapshot>> getCategories() async {
    QuerySnapshot snapshot = await categoriesCollection.get();
    return snapshot.docs;
  }

  Stream<QuerySnapshot> getCategoriesStream() {
    return categoriesCollection.snapshots();
  }

  // Order methods
  Future<String> createOrder(Map<String, dynamic> orderData) async {
    DocumentReference docRef = await ordersCollection.add(orderData);
    return docRef.id;
  }

  Future<List<DocumentSnapshot>> getUserOrders(String uid) async {
    //Log everything

    log('Loading user orders... - firebase_service.dart');
    QuerySnapshot snapshot = await ordersCollection
        .where('userId', isEqualTo: uid)
        // .orderBy('createdAt', descending: true)
        .get();
    log('User ID: $uid - firebase_service.dart');
    log('User orders loaded: ${uid} - firebase_service.dart');
    log('User orders: ${uid} - firebase_service.dart');
    log('User orders: ${snapshot.docs.length} - firebase_service.dart');
    log('User orders: ${snapshot.docs} - firebase_service.dart');
    log('User orders: ${snapshot.docs[0].data()} - firebase_service.dart');
    log('User orders: ${snapshot.docs[0].id} - firebase_service.dart');
    return snapshot.docs;
  }

  Stream<QuerySnapshot> getUserOrdersStream(String uid) {
    return ordersCollection
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Cart methods
  Future<void> addToCart(String userId, Map<String, dynamic> item) async {
    // Check if the product already exists in the cart
    QuerySnapshot existingItems = await cartCollection
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: item['productId'])
        .get();

    if (existingItems.docs.isNotEmpty) {
      // Update existing item
      await cartCollection.doc(existingItems.docs.first.id).update({
        'quantity': item['quantity'],
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      // Add new item
      item['userId'] = userId;
      item['createdAt'] = FieldValue.serverTimestamp();
      item['updatedAt'] = FieldValue.serverTimestamp();
      await cartCollection.add(item);
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    await cartCollection.doc(cartItemId).delete();
  }

  Future<void> clearCart(String userId) async {
    QuerySnapshot cartItems =
        await cartCollection.where('userId', isEqualTo: userId).get();

    WriteBatch batch = _firestore.batch();
    for (var doc in cartItems.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<List<DocumentSnapshot>> getCartItems(String userId) async {
    QuerySnapshot snapshot =
        await cartCollection.where('userId', isEqualTo: userId).get();
    return snapshot.docs;
  }

  Stream<QuerySnapshot> getCartItemsStream(String userId) {
    return cartCollection.where('userId', isEqualTo: userId).snapshots();
  }

  // Storage methods
  Future<String> uploadImage(String path, dynamic file) async {
    Reference ref = _storage.ref().child(path);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> deleteImage(String url) async {
    Reference ref = _storage.refFromURL(url);
    await ref.delete();
  }
}
