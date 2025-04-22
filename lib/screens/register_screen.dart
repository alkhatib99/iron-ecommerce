import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Get the AuthController using GetX
  final AuthController _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    await _authController.createUserWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text,
      _nameController.text.trim(),
      _phoneController.text.trim(),
    );

    // If registration was successful, navigate to home
    if (_authController.error.value == null && _authController.isLoggedIn) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.paddingXLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Error message
                Obx(() {
                  if (_authController.error.value != null) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppTheme.paddingMedium),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                                AppTheme.borderRadiusMedium),
                          ),
                          child: Text(
                            _authController.error.value!,
                            style: TextStyle(color: theme.colorScheme.error),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: AppTheme.paddingLarge),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Registration form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Name field
                      CustomTextField(
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        controller: _nameController,
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.paddingLarge),

                      // Email field
                      CustomTextField(
                        label: 'Email',
                        hint: 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.paddingLarge),

                      // Phone field
                      CustomTextField(
                        label: 'Phone Number',
                        hint: 'Enter your phone number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (!GetUtils.isPhoneNumber(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.paddingLarge),

                      // Password field
                      CustomTextField(
                        label: 'Password',
                        hint: 'Enter your password',
                        controller: _passwordController,
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.paddingLarge),

                      // Confirm password field
                      CustomTextField(
                        label: 'Confirm Password',
                        hint: 'Confirm your password',
                        controller: _confirmPasswordController,
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_outline),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.paddingXLarge),

                      // Register button
                      Obx(() => CustomButton(
                            text: 'Create Account',
                            onPressed: _register,
                            isLoading: _authController.isLoading.value,
                            height: 50,
                          )),
                      const SizedBox(height: AppTheme.paddingLarge),

                      // Google Sign In Button
                      CustomButton(
                        text: 'Sign Up with Google',
                        onPressed: () async {
                          await _authController.signInWithGoogle();
                          if (_authController.error.value == null &&
                              _authController.isLoggedIn) {
                            Get.offAllNamed(Routes.HOME);
                          }
                        },
                        image: Image.asset('assets/images/google_logo.png'),

                        backgroundColor: Colors.white,
                        textColor: Colors.black87,
                        // borderColor: Colors.grey.shade300,
                        height: 50,
                      ),
                      const SizedBox(height: AppTheme.paddingLarge),

                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: theme.textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.LOGIN);
                            },
                            child: const Text('Sign In'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
