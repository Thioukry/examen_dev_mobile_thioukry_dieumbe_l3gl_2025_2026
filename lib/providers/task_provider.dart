import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [
    Task(id: '1', title:'Finaliser le CRUD Projets', isCompleted: true, projectId: '', createdAt: null),
    Task(id: '2', title:'Tester la navigation', isCompleted: false, projectId: '', createdAt: null),
    Task(id: '1', title:'Faire le Git Push final', isCompleted: false, projectId: '', createdAt: null),
  ];

 // List<Task> get tasks => _tasks;
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;
  bool _isLoading = false;

  // --- GETTERS ---

  bool get isLoading => _isLoading;


  // Retourne les tâches filtrées et triées selon les exigences
  List<Task> get tasks {
    List<Task> filtered = _tasks.where((task) {
      final matchStatus = _statusFilter == null || task.status == _statusFilter;
      final matchPriority = _priorityFilter == null || task.priority == _priorityFilter;
      return matchStatus && matchPriority;
    }).toList();

    // Tri attendu : Statut (inProgress > todo > done) puis Priorité (high > medium > low)
    filtered.sort((a, b) {
      // Poids pour le statut
      int statusWeight(TaskStatus s) {
        switch (s) {
          case TaskStatus.inProgress: return 0;
          case TaskStatus.todo: return 1;
          case TaskStatus.done: return 2;
        }
      }

      int cmp = statusWeight(a.status).compareTo(statusWeight(b.status));
      if (cmp != 0) return cmp;

      // Si même statut, tri par priorité décroissante (High = 2, Medium = 1, Low = 0)
      return b.priority.index.compareTo(a.priority.index);
    });

    return filtered;
  }

  // Compteur par statut pour les statistiques du dashboard
  Map<TaskStatus, int> get taskCountByStatus {
    Map<TaskStatus, int> counts = {
      TaskStatus.todo: 0,
      TaskStatus.inProgress: 0,
      TaskStatus.done: 0,
    };
    for (var task in _tasks) {
      counts[task.status] = (counts[task.status] ?? 0) + 1;
    }
    return counts;
  }

  // --- MÉTHODES CRUD ---

  Future<void> loadTasks(String projectId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final allTasks = await StorageService.getTasks();
      _tasks = allTasks.where((t) => t.projectId == projectId).toList();
    } catch (e) {
      debugPrint("Erreur loadTasks: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTask(Task task) async {
    await StorageService.saveTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await StorageService.updateTask(task);
    int index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    await StorageService.deleteTask(taskId);
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    int index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      Task updatedTask = _tasks[index].copyWith(status: status);
      await updateTask(updatedTask);
    }
  }

  // --- FILTRES ---

  void setStatusFilter(TaskStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setPriorityFilter(TaskPriority? priority) {
    _priorityFilter = priority;
    notifyListeners();
  }

  void clearFilters() {
    _statusFilter = null;
    _priorityFilter = null;
    notifyListeners();
  }
  void toggleTaskStatus(String id){
    final index = _tasks.indexWhere((t)=>t.id == id);
    if(index != -1){
      _tasks[index].isCompleted = ! _tasks[index].isCompleted;
      notifyListeners();
    }
  }
}

