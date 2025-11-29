import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/services/onboarding_service.dart';
import '../../core/utils/responsive_util.dart';
import 'onboarding_page.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final onboardingService = OnboardingService();
    final hasSeenOnboarding = await onboardingService.hasSeenOnboarding();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            hasSeenOnboarding ? const HomePage() : const OnboardingPage(),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Icon
                      Container(
                        width: ResponsiveUtil.getResponsiveIconSize(
                          context,
                          baseSize: 120,
                        ),
                        height: ResponsiveUtil.getResponsiveIconSize(
                          context,
                          baseSize: 120,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.contact_phone_rounded,
                          size: ResponsiveUtil.getResponsiveIconSize(
                            context,
                            baseSize: 60,
                          ),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveUtil.getResponsiveSpacing(
                          context,
                          baseSpacing: 24,
                        ),
                      ),

                      // App Name
                      Text(
                        'Contact Saver',
                        style: TextStyle(
                          fontSize: ResponsiveUtil.getResponsiveFontSize(
                            context,
                            baseFontSize: 32,
                          ),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveUtil.getResponsiveSpacing(
                          context,
                          baseSpacing: 8,
                        ),
                      ),

                      // Tagline
                      Text(
                        'Scan. Extract. Save.',
                        style: TextStyle(
                          fontSize: ResponsiveUtil.getResponsiveFontSize(
                            context,
                            baseFontSize: 16,
                          ),
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveUtil.getResponsiveSpacing(
                          context,
                          baseSpacing: 48,
                        ),
                      ),

                      // Loading Indicator
                      SizedBox(
                        width: ResponsiveUtil.getResponsiveIconSize(
                          context,
                          baseSize: 40,
                        ),
                        height: ResponsiveUtil.getResponsiveIconSize(
                          context,
                          baseSize: 40,
                        ),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withValues(alpha: 0.7),
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
