
import 'package:flutter/material.dart';

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