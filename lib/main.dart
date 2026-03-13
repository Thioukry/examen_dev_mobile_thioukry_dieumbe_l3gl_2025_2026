
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/providers/auth_provider.dart';
import 'package:sunu_task/providers/project_provider.dart' hide Project;
import 'package:sunu_task/providers/task_provider.dart';
import 'package:sunu_task/providers/app_provider.dart';
import 'package:sunu_task/models/project.dart';
import 'package:sunu_task/screens/projects/project_detail_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart' hide Center;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SunuTask',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,

      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );


   // home:
    //const TestDataScreen();



  }
}

class TestDataScreen extends StatelessWidget {
  const TestDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProv = Provider.of<ProjectProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Test SunuTask Storage")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Projets stockés : ${projectProv.projectCount}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Création d'un projet de test
                final newProject = Project(
                  id: DateTime.now().toString(),
                  userId: "user_123",
                  name: "Projet Test ${projectProv.projectCount + 1}",
                  color: Colors.blue,
                  createdAt: DateTime.now(),
                );
                await projectProv.createProject(newProject as ProjectDetailScreen);
              },
              child: const Text("Ajouter un projet de test"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => projectProv.loadProjects("user_123"),
              child: const Text("Rafraîchir / Charger"),
            ),
          ],
        ),
      ),
    );
  }
}