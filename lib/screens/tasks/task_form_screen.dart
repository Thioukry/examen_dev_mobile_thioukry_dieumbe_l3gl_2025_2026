import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task; // null si création, sinon modification
  final String projectId;

  const TaskFormScreen({super.key, this.task, required this.projectId});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;

  TaskStatus _selectedStatus = TaskStatus.todo;
  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    // Pré-remplissage si modification
    _titleController = TextEditingController(text: widget.task?.title ?? "");
    _descController = TextEditingController(text: widget.task?.description ?? "");
    if (widget.task != null) {
      _selectedStatus = widget.task!.status;
      _selectedPriority = widget.task!.priority;
      _dueDate = widget.task!.dueDate;
    }
  }

  // Sélecteur de date (showDatePicker)
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = context.read<TaskProvider>();

      final newTask = Task(
        id: widget.task?.id ?? const Uuid().v4(),
        projectId: widget.projectId,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        status: _selectedStatus,
        priority: _selectedPriority,
        dueDate: _dueDate,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
      );

      if (widget.task == null) {
        taskProvider.createTask(newTask);
      } else {
        taskProvider.updateTask(newTask);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? "Nouvelle Tâche" : "Modifier Tâche")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: "Titre",
                controller: _titleController,
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 20),

              const Text("Priorité", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildPrioritySelector(),

              const SizedBox(height: 20),
              ListTile(
                title: Text(_dueDate == null ? "Ajouter une date d'échéance" : "Échéance : ${_dueDate.toString().split(' ')[0]}"),
                leading: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
                tileColor: Colors.grey[100],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),

              const SizedBox(height: 30),
              CustomButton(
                text: widget.task == null ? "Créer la tâche" : "Enregistrer",
                onPressed: _saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget personnalisé pour la sélection de priorité
  Widget _buildPrioritySelector() {
    return Row(
      children: TaskPriority.values.map((p) {
        bool isSelected = _selectedPriority == p;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedPriority = p),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? _getPriorityColor(p) : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  p.name.toUpperCase(),
                  style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getPriorityColor(TaskPriority p) {
    switch (p) {
      case TaskPriority.high: return Colors.red;
      case TaskPriority.medium: return Colors.orange;
      case TaskPriority.low: return Colors.green;
    }
  }
}