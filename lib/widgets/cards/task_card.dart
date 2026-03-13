import 'package:flutter/material.dart';
import 'package:sunu_task/models/task.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;

  const TaskCard({super.key, required this.title, required this.description, required Future<Object?> Function() onTap, required Task task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}