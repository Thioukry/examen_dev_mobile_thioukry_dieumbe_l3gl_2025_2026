import 'package:flutter/material.dart';
import '../../models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final int taskCount;
  final VoidCallback onTap;
  final Function(String) onActionSelected; // Pour modifier/supprimer

  const ProjectCard({
    super.key,
    required this.project,
    required this.taskCount,
    required this.onTap,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          // Utilisation de la couleur stockée dans le projet
          backgroundColor: Color(int.parse(project.colorHex)),
          child: const Icon(Icons.folder, color: Colors.white),
        ),
        title: Text(
          project.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("$taskCount tâches • ${project.description}"),
        trailing: PopupMenuButton<String>(
          onSelected: onActionSelected,
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Modifier')),
            const PopupMenuItem(
                value: 'delete',
                child: Text('Supprimer', style: TextStyle(color: Colors.red))
            ),
          ],
        ),
      ),
    );
  }
}