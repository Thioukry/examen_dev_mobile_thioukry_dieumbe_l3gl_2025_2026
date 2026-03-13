import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AppProvider>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {

    final appProvider = Provider.of<AppProvider>(context);

    if (!appProvider.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [

          Visibility(
            visible: appProvider.isOnboardingComplete,
            child: const LoginScreen(),
          ),

          Visibility(
            visible: !appProvider.isOnboardingComplete,
            child: const OnboardingScreen(),
          ),

        ],
      ),
    );
  }
}