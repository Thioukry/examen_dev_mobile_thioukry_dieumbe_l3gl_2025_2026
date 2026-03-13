
import 'package:flutter/material.dart';

enum TaskStatus { todo, inProgress, done }
enum TaskPriority { low, medium, high }

class Task {
  final String id;
  final String projectId;
  final String title;
  final String? description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  bool isCompleted;

  var createdAt;





  Task({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    this.status = TaskStatus.todo,
    this.priority = TaskPriority.medium,
    this.dueDate, required createdAt,
    this.isCompleted = false,
  });

  // Méthode pour copier une tâche en modifiant certains champs
  Task copyWith({
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
  }) {
    return Task(
      id: this.id,
      projectId: this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate, createdAt: null,
    );
  }

  // Sérialisation pour SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'title': title,
      'description': description,
      'status': status.index, // Stocke 0, 1 ou 2
      'priority': priority.index, // Stocke 0, 1 ou 2
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  // Désérialisation
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      projectId: map['projectId'],
      title: map['title'],
      description: map['description'],
      status: TaskStatus.values[map['status'] ?? 0],
      priority: TaskPriority.values[map['priority'] ?? 1],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      createdAt: null,
    );
  }

}