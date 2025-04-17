import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';

class UserController extends GetxController {
  final FirebaseService _firebaseService;

  // Observable state variables
  final userData = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;
  final error = Rxn<String>();

  // Constructor with dependency injection
  UserController({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;

  // Getters
  bool get isLoggedIn => userData.value != null;

  // Initialize user data
  Future<void> initUserData(String uid) async {
    isLoading.value = true;
    error.value = null;

    try {
      DocumentSnapshot doc = await _firebaseService.getUserDocument(uid);
      if (doc.exists) {
        userData.value = doc.data() as Map<String, dynamic>?;
      } else {
        error.value = 'User data not found';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Clear user data on logout
  void clearUserData() {
    userData.value = null;
  }

  // Update user data
  Future<void> updateUserData(Map<String, dynamic> data) async {
    isLoading.value = true;
    error.value = null;

    try {
      if (userData.value == null || userData.value!['uid'] == null) {
        throw Exception('User not initialized');
      }

      await _firebaseService.updateUserDocument(userData.value!['uid'], data);

      // Update local user data
      userData.value = {...userData.value!, ...data};
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Add address
  Future<void> addAddress(Map<String, dynamic> address) async {
    isLoading.value = true;
    error.value = null;

    try {
      if (userData.value == null || userData.value!['uid'] == null) {
        throw Exception('User not initialized');
      }

      List<dynamic> addresses = userData.value!['addresses'] ?? [];
      addresses.add(address);

      await _firebaseService.updateUserDocument(
        userData.value!['uid'],
        {'addresses': addresses},
      );

      // Update local user data
      final updatedUserData = Map<String, dynamic>.from(userData.value!);
      updatedUserData['addresses'] = addresses;
      userData.value = updatedUserData;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Update address
  Future<void> updateAddress(int index, Map<String, dynamic> address) async {
    isLoading.value = true;
    error.value = null;

    try {
      if (userData.value == null || userData.value!['uid'] == null) {
        throw Exception('User not initialized');
      }

      List<dynamic> addresses = List.from(userData.value!['addresses'] ?? []);
      if (index >= 0 && index < addresses.length) {
        addresses[index] = address;

        await _firebaseService.updateUserDocument(
          userData.value!['uid'],
          {'addresses': addresses},
        );

        // Update local user data
        final updatedUserData = Map<String, dynamic>.from(userData.value!);
        updatedUserData['addresses'] = addresses;
        userData.value = updatedUserData;
      } else {
        throw Exception('Invalid address index');
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Remove address
  Future<void> removeAddress(int index) async {
    isLoading.value = true;
    error.value = null;

    try {
      if (userData.value == null || userData.value!['uid'] == null) {
        throw Exception('User not initialized');
      }

      List<dynamic> addresses = List.from(userData.value!['addresses'] ?? []);
      if (index >= 0 && index < addresses.length) {
        addresses.removeAt(index);

        await _firebaseService.updateUserDocument(
          userData.value!['uid'],
          {'addresses': addresses},
        );

        // Update local user data
        final updatedUserData = Map<String, dynamic>.from(userData.value!);
        updatedUserData['addresses'] = addresses;
        userData.value = updatedUserData;
      } else {
        throw Exception('Invalid address index');
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Get user orders
  Future<List<DocumentSnapshot>> getUserOrders() async {
    if (userData.value == null || userData.value!['uid'] == null) {
      throw Exception('User not initialized');
    }

    return await _firebaseService.getUserOrders(userData.value!['uid']);
  }

  // Get user orders stream
  Stream<QuerySnapshot> getUserOrdersStream() {
    if (userData.value == null || userData.value!['uid'] == null) {
      throw Exception('User not initialized');
    }

    return _firebaseService.getUserOrdersStream(userData.value!['uid']);
  }

  @override
  onInit() async {
    // TODO: implement onInit
    super.onInit();
    // Example of user sign-in
    // await signInTest();
  }

  // signInTest() async {
//     try {
//       final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: 'aboodjob@gmail.com',
//         password: '10203040',
//       );
//       print(res);
//     } catch (e) {
//       print(e.toString());
//     } finally {
//       print('done');
//     }
//   }
// }
}
