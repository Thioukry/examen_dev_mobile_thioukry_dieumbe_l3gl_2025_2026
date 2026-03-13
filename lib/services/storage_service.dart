import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/project.dart';
import '../models/task.dart';

class StorageService {
  StorageService._privateConstructor();
  static final StorageService instance = StorageService._privateConstructor();
  // Clés de stockage
  static const String _usersKey = 'users_list';
  static const String _currentUserKey = 'current_user';
  static const String _projectsKey = 'projects_list';
  static const String _tasksKey = 'tasks_list';
  static const String _onboardingKey = 'onboarding_complete';

  // ==========================================
  // GESTION DES UTILISATEURS (AUTH)
  // ==========================================

  /// Récupère tous les utilisateurs inscrits
  static Future<List<User>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_usersKey);
    if (data == null) return [];
    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((u) => User.fromMap(u)).toList();
  }

  /// Enregistre un nouvel utilisateur (Inscription)
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getAllUsers();
    users.add(user);
    await prefs.setString(_usersKey, jsonEncode(users.map((u) => u.toMap()).toList()));
  }

  /// Sauvegarde l'utilisateur actuellement connecté (Session)
  static Future<void> saveCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(user.toMap()));
  }

  /// Récupère l'utilisateur de la session active
  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_currentUserKey);
    if (data == null) return null;
    return User.fromMap(jsonDecode(data));
  }

  /// Supprime l'utilisateur de la session (Déconnexion)
  static Future<void> removeCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // ==========================================
  // GESTION DES PROJETS
  // ==========================================

  /// Récupère tous les projets
  static Future<List<Project>> getProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_projectsKey);
    if (data == null) return [];
    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((p) => Project.fromMap(p)).toList();
  }

  /// Enregistre un nouveau projet
  static Future<void> saveProject(Project project) async {
    final prefs = await SharedPreferences.getInstance();
    final projects = await getProjects();
    projects.add(project);
    await prefs.setString(_projectsKey, jsonEncode(projects.map((p) => p.toMap()).toList()));
  }

  /// Met à jour un projet existant
  static Future<void> updateProject(Project project) async {
    final prefs = await SharedPreferences.getInstance();
    final projects = await getProjects();
    int index = projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      projects[index] = project;
      await prefs.setString(_projectsKey, jsonEncode(projects.map((p) => p.toMap()).toList()));
    }
  }

  /// Supprime un projet et ses tâches associées
  static Future<void> deleteProject(String projectId) async {
    final prefs = await SharedPreferences.getInstance();
    final projects = await getProjects();
    projects.removeWhere((p) => p.id == projectId);
    await prefs.setString(_projectsKey, jsonEncode(projects.map((p) => p.toMap()).toList()));

    // Nettoyage automatique des tâches liées au projet supprimé
    await deleteTasksByProjectId(projectId);
  }

  // ==========================================
  // GESTION DES TÂCHES
  // ==========================================

  /// Récupère toutes les tâches
  static Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_tasksKey);
    if (data == null) return [];
    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((t) => Task.fromMap(t)).toList();
  }

  /// Enregistre une nouvelle tâche
  static Future<void> saveTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getTasks();
    tasks.add(task);
    await prefs.setString(_tasksKey, jsonEncode(tasks.map((t) => t.toMap()).toList()));
  }

  /// Met à jour une tâche (statut, titre, etc.)
  static Future<void> updateTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getTasks();
    int index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await prefs.setString(_tasksKey, jsonEncode(tasks.map((t) => t.toMap()).toList()));
    }
  }

  /// Supprime une tâche spécifique
  static Future<void> deleteTask(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == taskId);
    await prefs.setString(_tasksKey, jsonEncode(tasks.map((t) => t.toMap()).toList()));
  }

  /// Supprime toutes les tâches d'un projet (utilisé lors de la suppression d'un projet)
  static Future<void> deleteTasksByProjectId(String projectId) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.projectId == projectId);
    await prefs.setString(_tasksKey, jsonEncode(tasks.map((t) => t.toMap()).toList()));
  }

  // ==========================================
  // PRÉFÉRENCES APPLICATIVES
  // ==========================================

  static Future<void> setOnboardingComplete(bool bool) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }
  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingKey);
  }
}