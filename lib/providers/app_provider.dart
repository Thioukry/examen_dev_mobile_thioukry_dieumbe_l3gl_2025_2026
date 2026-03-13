import 'package:flutter/material.dart' show ChangeNotifier;
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService.instance;

  bool _isOnboardingComplete = false;
  bool _isInitialized = false;
  bool _isLoading = false;

  bool get isOnboardingComplete => _isOnboardingComplete;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _isOnboardingComplete = true;
   //await _storageService.instance.setOnboardingComplete(true);
    notifyListeners();
  }

  Future<void> resetOnboarding() async {
    _isOnboardingComplete = false;
   // await _storageService.resetOnboarding();
    notifyListeners();
  }
}