import 'package:flutter/material.dart';
import 'package:sunu_task/models/task.dart';
import '../services/storage_service.dart';
import '../models/task.dart';
class TaskProvider extends ChangeNotifier {

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  Future<void> loadTasks(String projectId) async {}

  Future<void> createTask(Task task) async {
    _tasks.add(task);
    notifyListeners();

  }

  Future<void> updateTask(Task task) async {
    int i = _tasks.indexWhere((t) => t.id == task.id);
    if (i != -1) {
      _tasks[i] = task;
      notifyListeners();
    }
  }
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
    }
  Future<void> updateTaskStatus(String id ,TaskStatus status ) async {
    final i = _tasks.indexWhere((t) => t.id == id);
    if (i != -1) {
      _tasks[i] = Task(
        id:_tasks[i].id,
        title: _tasks[i].title,
        status: status,
        priority: _tasks[i].priority,
      );
      notifyListeners();
    }
  }
  }

