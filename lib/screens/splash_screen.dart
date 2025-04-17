import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:math' as math;
import '../controllers/splash_controller.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the splash controller
    final SplashController controller = Get.put(SplashController());
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A237E), // Dark blue
              Color(0xFF3949AB), // Medium blue
              Color(0xFF5C6BC0), // Light blue
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background particles
              Positioned.fill(
                child: Obx(() => Opacity(
                  opacity: controller.opacity.value * 0.4,
                  child: _ParticlesBackground(),
                )),
              ),
              
              // Main content
              Center(
                child: Obx(() => AnimatedOpacity(
                  opacity: controller.opacity.value,
                  duration: const Duration(milliseconds: 800),
                  child: AnimatedScale(
                    scale: controller.scale.value,
                    duration: const Duration(milliseconds: 800),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with rotation animation
                        Obx(() => TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: controller.rotationAngle.value),
                          duration: const Duration(milliseconds: 1500),
                          builder: (context, value, child) {
                            return Transform.rotate(
                              angle: value,
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Iron icon
                                      const Icon(
                                        Icons.iron,
                                        size: 80,
                                        color: Color(0xFF1A237E),
                                      ),
                                      
                                      // Circular progress indicator around the icon
                                      Obx(() => SizedBox(
                                        width: 120,
                                        height: 120,
                                        child: CircularProgressIndicator(
                                          value: controller.progressValue.value,
                                          strokeWidth: 3,
                                          valueColor: const AlwaysStoppedAnimation<Color>(
                                            Color(0xFF5C6BC0),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                        
                        const SizedBox(height: 30),
                        
                        // App name with character animation
                        _AnimatedText(
                          text: "IRON STORE",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2.0,
                          ),
                          controller: controller,
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Tagline with fade-in animation
                        Obx(() => AnimatedOpacity(
                          opacity: controller.taglineOpacity.value,
                          duration: const Duration(milliseconds: 800),
                          child: Text(
                            "Premium Quality Iron Products",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                              letterSpacing: 1.0,
                            ),
                          ),
                        )),
                        
                        const SizedBox(height: 50),
                        
                        // Loading indicator with shimmer effect
                        Container(
                          width: 200,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: Obx(() => ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.2),
                                  Colors.white,
                                  Colors.white.withOpacity(0.2),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                                begin: Alignment(-1.0 + (controller.progressValue.value * 3), 0.0),
                                end: Alignment(1.0 + (controller.progressValue.value * 3), 0.0),
                              ).createShader(bounds);
                            },
                            child: Container(
                              width: 200 * controller.progressValue.value,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white,
                              ),
                            ),
                          )),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Version text with pulse animation
                        Obx(() => AnimatedOpacity(
                          opacity: controller.versionOpacity.value,
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            "Version 1.0.0",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Animated text that reveals characters one by one
class _AnimatedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final SplashController controller;

  const _AnimatedText({
    required this.text,
    required this.style,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final visibleCharacters = (text.length * controller.textProgress.value).round();
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < text.length; i++)
            AnimatedOpacity(
              opacity: i < visibleCharacters ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                text[i],
                style: style,
              ),
            ),
        ],
      );
    });
  }
}

// Background with floating particles
class _ParticlesBackground extends StatefulWidget {
  @override
  _ParticlesBackgroundState createState() => _ParticlesBackgroundState();
}

class _ParticlesBackgroundState extends State<_ParticlesBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    
    // Create particles
    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle(
        position: Offset(
          _random.nextDouble() * Get.width,
          _random.nextDouble() * Get.height,
        ),
        size: _random.nextDouble() * 8 + 2,
        speed: _random.nextDouble() * 2 + 0.5,
        angle: _random.nextDouble() * math.pi * 2,
      ));
    }
    
    // Animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _controller.addListener(() {
      for (var particle in _particles) {
        particle.update();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlesPainter(particles: _particles),
      size: Size.infinite,
    );
  }
}

// Particle class for background animation
class _Particle {
  Offset position;
  final double size;
  final double speed;
  double angle;
  final Random _random = math.Random();

  _Particle({
    required this.position,
    required this.size,
    required this.speed,
    required this.angle,
  });

  void update() {
    // Move particle
    position = Offset(
      position.dx + math.cos(angle) * speed,
      position.dy + math.sin(angle) * speed,
    );
    
    // Slightly change angle for natural movement
    angle += (_random.nextDouble() - 0.5) * 0.1;
    
    // Wrap around screen
    if (position.dx < 0) position = Offset(Get.width, position.dy);
    if (position.dx > Get.width) position = Offset(0, position.dy);
    if (position.dy < 0) position = Offset(position.dx, Get.height);
    if (position.dy > Get.height) position = Offset(position.dx, 0);
  }
}

// Custom painter for particles
class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlesPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    for (var particle in particles) {
      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter oldDelegate) => true;
}
