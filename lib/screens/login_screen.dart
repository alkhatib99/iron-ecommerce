import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iron_ecommerce_app/controllers/auth_controller.dart';
import 'package:iron_ecommerce_app/screens/register_screen.dart';
import 'package:iron_ecommerce_app/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App logo or icon
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/logos/iron_logo.svg',
                      // size: 50,
                      height: 50,
                      width: 50,

                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.paddingLarge),

                // Welcome text
                Text(
                  'Welcome to Your Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppTheme.paddingLarge),

                Text(
                  'Sign in to access your profile, track orders, and manage your shopping preferences',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppTheme.paddingLarge),

                // Sign in button
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => LoginScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                SizedBox(height: 16),

                // Register button
                OutlinedButton(
                  onPressed: () {
                    Get.to(() => RegisterScreen());
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'CREATE ACCOUNT',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'OR',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                SizedBox(height: 24),

                // Google Sign In button
                OutlinedButton.icon(
                  onPressed: () async {
                    bool success = await authController.signInWithGoogle();

                    if (!success && authController.error.value!.isNotEmpty) {
                      Get.snackbar(
                        'Error',
                        authController.error.value!,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  icon: Image.asset(
                    'assets/google_logo.png',
                    height: 24,
                  ),
                  label: Text('Continue with Google'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 32),

                // Continue as guest
                TextButton(
                  onPressed: () {
                    Get.back(); // Go back to previous screen
                  },
                  child: Text('Continue as Guest'),
                ),
              ],
            ),
          ),
        ));
  }
}
