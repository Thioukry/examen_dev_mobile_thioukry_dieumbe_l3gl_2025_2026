
import 'package:flutter/material.dart';

class ProjectsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        ListTile(
          leading: Icon(Icons.folder, color: Colors.blue),
          title: Text("Développement Mobile"),
          subtitle: Text("Flutter App - 80% terminé"),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.folder, color: Colors.orange),
          title: Text("Design UI/UX"),
          subtitle: Text("Maquettes Figma"),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ],
    );
  }
}