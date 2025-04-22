import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iron_ecommerce_app/routes/app_routes.dart';
import 'package:iron_ecommerce_app/services/auth_service.dart';
import 'package:iron_ecommerce_app/models/user_model.dart'; // if you have one

class AccountScreen extends StatelessWidget {
  final AuthService authService = Get.find<AuthService>();

  AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Account Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display User Info
            CircleAvatar(radius: 40, child: Text(user!.email!.toUpperCase())),
            const SizedBox(height: 16),
            Text(user.uid, style: const TextStyle(fontSize: 20)),
            Text(user.displayName ?? "user",
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            // Edit Button
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Edit Info"),
              onPressed: () {
                // Navigate to edit screen or show a dialog
              },
            ),

            const Spacer(),

            // Sign Out Button
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Sign Out"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await authService.signOut();
                Get.offAllNamed(Routes.LOGIN); // or your login route
              },
            ),
          ],
        ),
      ),
    );
  }
}
