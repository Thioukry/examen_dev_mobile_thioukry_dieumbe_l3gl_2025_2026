
import 'package:flutter/material.dart';
import 'package:sunu_task/providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
//import '../../widgets/common/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../widgets/common/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Contrôleurs et Clé de formulaire
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // 2. Nettoyage des ressources (Obligatoire pour l'examen !)
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();

      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        if (success) {
          // Navigation vers Home et suppression de la pile
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Affichage de l'erreur
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.error ?? "Erreur de connexion"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // On écoute le provider pour l'état de chargement
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                Text(
                  "Bon retour !",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const Text("Connectez-vous pour gérer vos projets"),
                const SizedBox(height: 40),

                // Utilisation des widgets réutilisables

                 CustomTextField(
                  label: "Email",
                  controller: _emailController,
                  hint: "votre@email.com",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return "Veuillez entrer un email valide";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: "Mot de passe",
                  controller: _passwordController,
                  hint: "••••••••",
                  prefixIcon: Icons.lock_outline,
                  obscureText: true, // Active l'icône oeil dans ton CustomTextField
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Minimum 6 caractères";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                CustomButton(
                  text: "Se connecter",
                  isLoading: isLoading,
                  onPressed: _submit,
                ),

                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: const Text("Pas de compte ? S'inscrire"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
