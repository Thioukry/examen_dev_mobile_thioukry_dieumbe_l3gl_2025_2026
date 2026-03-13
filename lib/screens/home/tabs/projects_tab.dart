
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/models/project.dart';
import 'package:sunu_task/screens/projects/project_form_screen.dart';
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
          replacement: const Center(child: Text("Aucun projet. Cliquez sur +")),
          // Si vide
          child: ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.folder, color: Colors.blue),
                title: Text(projects[index].name),
                subtitle: Text("Description: ${projects[index].description}"),
                trailing: Row(mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit,
                          color: Colors.orange),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProjectFormScreen(project:
                                projects[index]),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.red),
                      onPressed: () {
              showDialog(
              context: context,
              builder: (context) =>
              AlertDialog(
              title: const
              Text("Supprimer ?"),
              content: const Text("Voulez-vous vraiment supprimer ce projet ?"),
              actions: [
              TextButton(onPressed: ()=>
              Navigator.pop(context),
              child: const
              Text("Non")),
              TextButton(
              onPressed:(){
              projectProvider.deleteProject(projects[index].id);
              ScaffoldMessenger.of(context).showSnackBar(
              const
              SnackBar(content: Text("Projet supprime"),backgroundColor: Colors.red),
              );
              }, child: const Text("Oui",style: TextStyle(color: Colors.red)),
              ),
              ],
              ),
              );
              },
              ),
              ],
                ),

              );
            },
          ),
        );
      },
    );
  }
}
