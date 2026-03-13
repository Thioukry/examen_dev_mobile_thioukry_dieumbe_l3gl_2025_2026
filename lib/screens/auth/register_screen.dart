import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Les mots de passe ne correspondent pas")),
        );
        return;
      }

      final authProv = Provider.of<AuthProvider>(context, listen: false);
      await authProv.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (authProv.isAuthenticated) {
        // Redirection vers le Home après inscription réussie
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProv.error ?? "Erreur d'inscription")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un compte")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: "Nom complet",
                controller: _nameController,
                prefixIcon: Icons.person,
                validator: (v) => v!.length < 2 ? "Nom trop court" : null,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                label: "Email",
                controller: _emailController,
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.contains('@') ? null : "Email invalide",
              ),
              const SizedBox(height: 15),
              CustomTextField(
                label: "Mot de passe",
                controller: _passwordController,
                prefixIcon: Icons.lock,
                obscureText: true,
                validator: (v) => v!.length < 6 ? "Minimum 6 caractères" : null,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                label: "Confirmer le mot de passe",
                controller: _confirmPasswordController,
                prefixIcon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              Consumer<AuthProvider>(
                builder: (context, auth, _) => CustomButton(
                  text: "S'inscrire",
                  isLoading: auth.isLoading,
                  onPressed: _handleRegister,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}