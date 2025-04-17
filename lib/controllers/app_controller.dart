import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppController extends GetxController {
  // Theme state
  final isDarkMode = false.obs;
  
  // App initialization state
  final isInitialized = false.obs;
  final isLoading = false.obs;
  final error = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    initializeApp();
  }

  // Initialize app
  Future<void> initializeApp() async {
    isLoading.value = true;
    
     try{ final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'aboodjob@gmail.com',
        password: '10203040',
      );
      print(res);
    } catch (e) {
      print(e.toString());
    } finally {
      print('done');
    }
  
    error.value = null;

    try {
      // Simulate initialization delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Check system theme
      final brightness = Get.mediaQuery.platformBrightness;
      isDarkMode.value = brightness == Brightness.dark;
      
      isInitialized.value = true;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle theme
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // Get current theme mode
  ThemeMode get themeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
}
