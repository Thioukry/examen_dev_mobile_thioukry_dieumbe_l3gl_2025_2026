import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/models/project.dart';
import 'package:sunu_task/models/task_status.dart';
import 'package:sunu_task/widgets/cards/task_card.dart';
import '../../providers/project_provider.dart';
import '../../providers/task_provider.dart';


class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({super.key});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les tâches dès l'ouverture de l'écran
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final project = context.read<ProjectProvider>().selectedProject;
      if (project != null) {
        context.read<TaskProvider>().loadTasks(project.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final project = context.watch<ProjectProvider>().selectedProject;
    final taskProvider = context.watch<TaskProvider>();

    if (project == null) return const Scaffold(body: Center(child: Text("Aucun projet sélectionné")));

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () => _editProject(context, project)),
          IconButton(icon: const Icon(Icons.delete), onPressed: () => _confirmDelete(context, project)),

        ],
      ),
      body: Column(
        children: [
          // En-tête avec description et stats
          _buildHeader(project, taskProvider),

          // Liste des tâches
          Expanded(
            child: taskProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : taskProvider.tasks.isEmpty
                ? const Center(child: Text("Aucune tâche pour le moment"))
                : ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  task: taskProvider.tasks[index],
                  onTap: () => Navigator.pushNamed(context, '/task-detail'), title: '', description: '',
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/task-form', arguments: project.id),
        child: const Icon(Icons.add_task),
      ),
    );
  }

  Widget _buildHeader(project, taskProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Color(int.parse(project.colorHex)).withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildStatChip("À faire", taskProvider.tasks.where((t) => t.status == TaskStatus.todo).length),
              const SizedBox(width: 8),
              _buildStatChip("En cours", taskProvider.tasks.where((t) => t.status == TaskStatus.inProgress).length),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int count) {
    return Chip(label: Text("$label : $count"));
  }

  void _confirmDelete(BuildContext context, project) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer le projet ?"),
        content: const Text("Cela supprimera aussi toutes les tâches associées."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () {
              context.read<ProjectProvider>().deleteProject(project.id);
              Navigator.pop(ctx); // Ferme le dialogue
              Navigator.pop(context); // Retourne à la liste des projets
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  void _editProject(BuildContext context, Project project) {}
}

