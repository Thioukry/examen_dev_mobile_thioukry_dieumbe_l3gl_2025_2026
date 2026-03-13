
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/screens/projects/project_detail_screen.dart';
import 'package:uuid/uuid.dart';
import '../../models/project.dart';
import '../../providers/project_provider.dart';
import '../../widgets/common/custom_button.dart';

class ProjectFormScreen extends StatefulWidget {
  final Project? project; // null = création, non-null = modification

  const ProjectFormScreen({Key? key, this.project}) : super(key: key);

  @override
  _ProjectFormScreenState createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Initialisation avec les données du projet si on est en mode édition
    _nameController = TextEditingController(text: widget.project?.name ?? '');
    _descriptionController = TextEditingController(text: widget.project?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  void save() {
    final provider = Provider.of<ProjectProvider>(context, listen: false);
   String message = "";
    if (widget.project == null) {
      // CRÉER
      provider.createProject(Project(
        id: const Uuid().v4(),
        name: _nameController.text,
        createdAt: DateTime.now(), userId: '', color:Colors.blue,
      ));
    } else {
      // MODIFIER
      final updatedProject = Project(
        id: widget.project!.id, // On garde le même ID !
        name: _nameController.text,
        createdAt: widget.project!.createdAt, userId: '', color:widget.project!.color,
      );
      provider.updateProject(updatedProject);
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const
          Duration(seconds: 2),
        ),
    );
    Navigator.pop(context);
  }

  Future<void> _saveProject() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessing = true);

      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);

      final projectData = Project(
        id: widget.project?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        createdAt: widget.project?.createdAt ?? DateTime.now(), userId: '', color:widget.project?.color ??Colors.blue
      );

      try {
        if (widget.project == null) {
          await projectProvider.createProject(projectData);
        } else {
          await projectProvider.updateProject(projectData);
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        // Optionnel : Afficher une snackbar en cas d'erreur
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.project != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Modifier le Projet" : "Nouveau Projet"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nom du projet *",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Le nom est obligatoire";
                  if (value.length < 3) return "3 caractères minimum";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              // Utilisation de CustomButton pour la sauvegarde
              CustomButton(
                text: isEditing ? "Mettre à jour" : "Créer le projet",
                isLoading: _isProcessing,
                onPressed: _saveProject,
              ),

              const SizedBox(height: 10),

              // EXIGENCE PROF : Utilisation du widget Visibility
              // On affiche le bouton supprimer uniquement si on est en mode édition
              Visibility(
                visible: isEditing,
                child: OutlinedButton.icon(
                  onPressed: _isProcessing ? null : () async {
                    final confirmed = await _showDeleteDialog();
                    if (confirmed == true && mounted) {
                      await Provider.of<ProjectProvider>(context, listen: false)
                          .deleteProject(widget.project!.id);
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text("Supprimer le projet", style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer ?"),
        content: const Text("Voulez-vous vraiment supprimer ce projet et toutes ses tâches ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annuler")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Supprimer", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
