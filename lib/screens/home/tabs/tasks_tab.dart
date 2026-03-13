import 'package:flutter/material.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Tasks",
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}