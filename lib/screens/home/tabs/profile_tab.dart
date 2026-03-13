import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/models/project.dart';
import '../../../providers/project_provider.dart';


class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          SizedBox(height: 10),
          Text("Utilisateur Sunu Task", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("dieumbe@email.com"),
          SizedBox(height: 20),
          ElevatedButton(onPressed: () {}, child: Text("Déconnexion")),
        ],
      ),
    );
  }
}