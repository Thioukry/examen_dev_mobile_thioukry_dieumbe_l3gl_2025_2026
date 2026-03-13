import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/models/project.dart';
import '../../../providers/project_provider.dart';


class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
  return Consumer<ProjectProvider>(
  builder: (context, provider, child) {
  return Center(
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  const Text("Tableau de bord", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
  const SizedBox(height: 20),
  Card(
  color: Colors.blue.shade50,
  child: Padding(
  padding: const EdgeInsets.all(30),
  child: Column(
  children: [
  Text("${provider.projects.length}", style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue)),
  const Text("Projets actifs"),
  ],
  ),
  ),
  ),
  ],
  ),
  );
  },
  );
  }
  }