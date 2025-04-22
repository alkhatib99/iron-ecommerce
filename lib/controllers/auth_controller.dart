import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/firebase_service.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // Observable state variables
  final Rxn<User> user = Rxn<User>();
  final isLoading = false.obs;
  final error = Rxn<String>();
  
  // Constructor with dependency injection
  AuthController({required FirebaseService firebaseService})
      : _firebaseService = firebaseService,
        _auth = firebaseService.auth;
  
  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    user.bindStream(_auth.authStateChanges());
  }
  
  // Get current user
  User? get currentUser => user.value;
  
  // Check if user is logged in
  bool get isLoggedIn => user.value != null;
  
  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    isLoading.value = true;
    error.value = null;
    
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Sign up with email and password
  Future<void> createUserWithEmailAndPassword(
      String email, String password, String name, String phone) async {
    isLoading.value = true;
    error.value = null;
    
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create user document in Firestore
      await _firebaseService.createUserDocument(
        userCredential.user!,
        name,
        phone,
      );
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    isLoading.value = true;
    error.value = null;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        error.value = 'Sign in aborted by user';
        isLoading.value = false;
        return false;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      // Check if this is a new user
      // if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        // Create user document in Firestore
        await _firebaseService.createUserDocument(
          userCredential.user!,
          userCredential.user?.displayName ?? 'User',
          userCredential.user?.phoneNumber ?? '',
        );
      }
    catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
    return true;
  } 
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       error.value = 'Sign in aborted by user';
  //       isLoading.value = false;
  //       return;
  //     }
      
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
      
  //     UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);
      
  //     // Check if this is a new user
  //     if (userCredential.additionalUserInfo?.isNewUser ?? false) {
  //       // Create user document in Firestore
  //       await _firebaseService.createUserDocument(
  //         userCredential.user!,
  //         userCredential.user?.displayName ?? 'User',
  //         userCredential.user?.phoneNumber ?? '',
  //       );
  //     }
  //   } catch (e) {
  //     error.value = e.toString();
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  
  // Sign out
  Future<void> signOut() async {
    isLoading.value = true;
    error.value = null;
    
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Reset password
  Future<void> resetPassword(String email) async {
    isLoading.value = true;
    error.value = null;
    
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Update user profile
  Future<void> updateUserProfile(String name, String? photoURL) async {
    isLoading.value = true;
    error.value = null;
    
    try {
      await _auth.currentUser?.updateDisplayName(name);
      if (photoURL != null) {
        await _auth.currentUser?.updatePhotoURL(photoURL);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Update user email
  Future<void> updateEmail(String email) async {
    isLoading.value = true;
    error.value = null;
    
    try {
      await _auth.currentUser?.updateEmail(email);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Update user password
  Future<void> updatePassword(String password) async {
    isLoading.value = true;
    error.value = null;
    
    try {
      await _auth.currentUser?.updatePassword(password);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Verify email
  Future<void> sendEmailVerification() async {
    isLoading.value = true;
    error.value = null;
    
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Check if email is verified
  bool isEmailVerified() {
    return _auth.currentUser?.emailVerified ?? false;
  }
}
