import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    // On récupère les données de l'utilisateur depuis l'AuthProvider
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            // Affiche le nom de l'utilisateur ou "Utilisateur" par défaut
            Text(
              user?.name ?? "Utilisateur ISIKM",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? "etudiant@isikm.sn",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Bouton de déconnexion
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  authProvider.logout();
                  // Retour à l'écran de login
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text("Se déconnecter"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}