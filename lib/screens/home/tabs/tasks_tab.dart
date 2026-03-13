
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/models/project.dart';
import '../../../providers/project_provider.dart';


class TasksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text("Tâche numéro ${index + 1}"),
          value: index % 2 == 0, // Juste pour l'exemple
          onChanged: (val) {},
        );
      },
    );
  }
}