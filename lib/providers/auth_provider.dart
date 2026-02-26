gimport 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService.instance;
  final _uuid = const Uuid();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialisation : Vérifie si un utilisateur est déjà stocké au démarrage
  Future<void> init() async {
    _isLoading = true;
    // On ne notifie pas forcément ici pour éviter des rebuilds inutiles au splash
    _currentUser = await _storageService.getCurrentuser();
    _isLoading = false;
    notifyListeners();
  }

  // LOGIQUE LOGIN
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Récupérer tous les utilisateurs
      final users = await _storageService.getAllUsers();

      // 2. Chercher la correspondance
      final user = users.firstWhere(
            (u) => u.email == email && u.password == password,
        orElse: () => throw Exception("Email ou mot de passe incorrect"),
      );

      // 3. Succès
      _currentUser = user;
      await _storageService.saveCurrentUser(user);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll("Exception: ", "");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // LOGIQUE REGISTER
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final users = await _storageService.getAllUsers();

      // Vérifier si l'email existe déjà
      if (users.any((u) => u.email == email)) {
        throw Exception("Cet email est déjà utilisé");
      }

      // Création du nouvel utilisateur avec un ID unique
      final newUser = User(
        id: _uuid.v4(),
        name: name,
        email: email,
        password: password,
        createdAt: DateTime.now(),
      );

      // Sauvegarde double : Liste globale + Session actuelle
      await _storageService.saveUser(newUser);
      await _storageService.saveCurrentUser(newUser);

      _currentUser = newUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll("Exception: ", "");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _storageService.removeCurrentUser;
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}


