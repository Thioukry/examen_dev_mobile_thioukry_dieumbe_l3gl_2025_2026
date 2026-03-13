import 'package:flutter/material.dart';
import 'package:sunu_task/screens/projects/project_detail_screen.dart';
import 'package:sunu_task/models/project.dart';
import '../services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';

// Pour la persistance réelle

  class ProjectProvider extends ChangeNotifier {
  // Propriétés privées
  List<Project> _projects = [];
  late Project  _selectedProject;
  bool _isLoading = false;

  // Getters publics
  List<Project> get projects => _projects;
  Project? get selectedProject => _selectedProject;
  int get projectCount => _projects.length;
  bool get isLoading => _isLoading;

  // --- MÉTHODES CRUD ---

  // 1. Charger les projets d'un utilisateur depuis SharedPreferences
  Future<void> loadProjects(String userId) async {
  _isLoading = true;
  notifyListeners(); // Affiche l'indicateur de chargement sur l'UI

  try {
  // On récupère tous les projets via le service de stockage
  final allProjects = await StorageService.getProjects();

  // On filtre pour ne garder que ceux de l'utilisateur connecté
  _projects = allProjects.where((p) => p.userId == userId).toList();
  } catch (e) {
  debugPrint("Erreur lors du chargement des projets : $e");
  } finally {
  _isLoading = false;
  notifyListeners(); // Met à jour l'UI (liste ou message "vide")
  }
  }

  // 2. Créer un nouveau projet
  Future<void> createProject(ProjectDetailScreen project) async {
  _isLoading = true;
  notifyListeners();

  try {
  await StorageService.saveProject(project as Project);
  _projects.add(project as Project); // Mise à jour locale pour la fluidité
  } catch (e) {
  debugPrint("Erreur création projet : $e");
  } finally {
  _isLoading = false;
  notifyListeners();
  }
  }

  // 3. Mettre à jour un projet existant
  Future<void> updateProject(Project project) async {
  try {
  await StorageService.updateProject(project);

  // Remplacer le projet dans la liste locale
  final index = _projects.indexWhere((p) => p.id == project.id);
  if (index != -1) {
  _projects[index] = project;
  notifyListeners();
  }
  } catch (e) {
  debugPrint("Erreur update projet : $e");
  }
  }

  // 4. Supprimer un projet
  Future<void> deleteProject(String projectId) async {
  try {
  await StorageService.deleteProject(projectId);

  // Optionnel : Selon tes bonus, supprimer aussi les tâches liées ici
  // await StorageService.deleteTasksByProjectId(projectId);

  _projects.removeWhere((p) => p.id == projectId);
  notifyListeners();
  } catch (e) {
  debugPrint("Erreur suppression projet : $e");
  }
  }

  // 5. Sélectionner un projet (pour l'affichage des détails)
  void selectProject(Project? project) {
  _selectedProject = project!;
  notifyListeners();
  }
  }

