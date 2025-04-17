import 'package:get/get.dart';
import 'dart:async';
import 'dart:math' as math;

class SplashController extends GetxController {
  // Observable variables for animations
  final opacity = 0.0.obs;
  final scale = 0.8.obs;
  final progressValue = 0.0.obs;
  final rotationAngle = 0.0.obs;
  final textProgress = 0.0.obs;
  final taglineOpacity = 0.0.obs;
  final versionOpacity = 1.0.obs;
  
  // Timer for progress animation
  Timer? _progressTimer;
  Timer? _pulseTimer;
  
  @override
  void onInit() {
    super.onInit();
    
    // Start animations
    _startAnimations();
    
    // Start progress animation
    _startProgressAnimation();
    
    // Start text animation
    _startTextAnimation();
    
    // Start pulse animation for version text
    _startPulseAnimation();
    
    // Navigate to home screen after delay
    _setupNavigation();
  }
  
  @override
  void onClose() {
    // Cancel timers to prevent memory leaks
    _progressTimer?.cancel();
    _pulseTimer?.cancel();
    super.onClose();
  }
  
  // Start fade and scale animations
  void _startAnimations() {
    // Fade in animation
    Future.delayed(Duration(milliseconds: 200), () {
      opacity.value = 1.0;
    });
    
    // Scale animation
    Future.delayed(Duration(milliseconds: 200), () {
      scale.value = 1.0;
    });
    
    // Rotation animation
    Future.delayed(Duration(milliseconds: 500), () {
      rotationAngle.value = math.pi * 2 * 0.25; // Quarter turn
    });
    
    // Tagline fade in
    Future.delayed(Duration(milliseconds: 1200), () {
      taglineOpacity.value = 1.0;
    });
  }
  
  // Animate the progress bar
  void _startProgressAnimation() {
    const totalDuration = 2500; // Total animation time in milliseconds
    const interval = 50; // Update interval in milliseconds
    const steps = totalDuration ~/ interval;
    
    int currentStep = 0;
    
    _progressTimer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      currentStep++;
      progressValue.value = currentStep / steps;
      
      if (currentStep >= steps) {
        timer.cancel();
      }
    });
  }
  
  // Animate text character by character
  void _startTextAnimation() {
    const totalDuration = 1000; // Total animation time in milliseconds
    const interval = 50; // Update interval in milliseconds
    const steps = totalDuration ~/ interval;
    
    int currentStep = 0;
    
    Timer.periodic(Duration(milliseconds: interval), (timer) {
      currentStep++;
      textProgress.value = currentStep / steps;
      
      if (currentStep >= steps) {
        timer.cancel();
      }
    });
  }
  
  // Pulse animation for version text
  void _startPulseAnimation() {
    _pulseTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      versionOpacity.value = versionOpacity.value == 1.0 ? 0.7 : 1.0;
    });
  }
  
  // Setup navigation to home screen
  void _setupNavigation() {
    Future.delayed(Duration(milliseconds: 3500), () {
      Get.offAllNamed('/home');
    });
  }
}
