
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/models/task.dart';
import '../../../providers/task_provider.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = taskProvider.tasks;

        return Visibility(
          visible: tasks.isNotEmpty,
          replacement: const Center(
            child: Text("Aucune tâche pour le moment."),
          ),
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return CheckboxListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    // Barre le texte si la tâche est terminée
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                value: task.isCompleted,
                onChanged: (bool? value) {
                  // Appelle une fonction dans ton provider pour changer l'état
                  taskProvider.toggleTaskStatus(task.id);
                },
                secondary: const Icon(Icons.assignment_turned_in, color: Colors.blue),
              );
            },
          ),
        );
      },
    );
  }
}



