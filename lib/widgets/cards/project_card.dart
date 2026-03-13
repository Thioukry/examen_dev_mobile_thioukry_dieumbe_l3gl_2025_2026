
import 'package:flutter/material.dart';
import '../../models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final int taskCount;
  final VoidCallback onTap;
  final Function(String) onActionSelected;

  const ProjectCard({
    super.key,
    required this.project,
    required this.taskCount,
    required this.onTap,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Sécurité pour la couleur : si project.color est nul, on met du bleu
    final Color folderColor = project.color != null ? Color(project.color!!! as int) : Colors.blue;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: folderColor,
          child: const Icon(Icons.folder, color: Colors.white),
        ),
        title: Text(
          project.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("$taskCount tâches • ${project.description ?? 'Pas de description'}"),
        trailing: PopupMenuButton<String>(
          onSelected: onActionSelected,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Modifier'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}