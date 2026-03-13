
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sunu_task/core/constants/app_strings.dart';
import 'package:sunu_task/core/constants/app_colors.dart';
import 'package:sunu_task/screens/home/home_screen.dart';
import 'package:sunu_task/screens/onboarding/onboarding_screen.dart';
import 'package:sunu_task/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  bool _showLogo = false;
  bool _showText = false;

  @override
  void initState() {
    super.initState();
    _startAnimations();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

// ===== Animations =====

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _showLogo = true;
        });
      }
    });


    Future.delayed(const Duration(milliseconds: 1500), () {
    if (mounted) {
    setState(() {
    _showText = true;
    });
    }
    });

  }

// ===== Timer =====

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 3), _navigateToNextScreen);
  }

// ===== Navigation =====

  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;


    final bool onboardingComplete =
    await StorageService.isOnboardingComplete();

    Navigator.pushReplacement(
    context,
    PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
    onboardingComplete
    ? const HomeScreen()
        : const OnboardingScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
    opacity: animation,
    child: child,
    );
    },
    transitionDuration: const Duration(milliseconds: 400),
    ),
    );

  }

// ===== UI =====

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            const SizedBox(height: 24),
            _buildAppName(),
            const SizedBox(height: 8),
            _buildAppSlogan(),
            const SizedBox(height: 48),
            _buildLoadingIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedOpacity(
      opacity: _showLogo ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      child: AnimatedScale(
        scale: _showLogo ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(120),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.task_alt,
            size: 60,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAppName() {
    return AnimatedOpacity(
      opacity: _showText ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      child: Text(
        AppStrings.appName,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildAppSlogan() {
    return AnimatedOpacity(
      opacity: _showText ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      child: Text(
        AppStrings.appSlogan,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedOpacity(
      opacity: _showText ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      child: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      ),
    );
  }
}
