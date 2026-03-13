
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/models/project.dart';
import '../../../providers/project_provider.dart';

class ProjectsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // On écoute le ProjectProvider
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
        final projects = projectProvider.projects;

        return Visibility(
          visible: projects.isNotEmpty,
          replacement: const Center(child: Text("Aucun projet. Cliquez sur +")), // Si vide
          child: ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(projects[index].name),
                subtitle: Text("Description: ${projects[index].description}"),
              );
            },
          ),
        );
      },
    );
  }
}