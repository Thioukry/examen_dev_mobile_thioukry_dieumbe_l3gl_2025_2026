import 'package:flutter/material.dart';
import 'package:sunu_task/core/constants/app_colors.dart';
import 'package:sunu_task/core/constants/app_strings.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/projects_tab.dart';
import 'tabs/tasks_tab.dart';
import 'tabs/profile_tab.dart';
class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
  @override

  // Pour la liste des pages pour l'indexedStack
  final List<Widget> _tabs = [
    const DashboardTab(),
    const ProjectsTab(),
    const TasksTab(),
    const ProfileTab(),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Sunu Task"),
        actions: [
        IconButton(
        icon: const Icon(Icons.notifications_none),
         onPressed: () {},
          // Bonus : Notifications
        ),
        ],
        ),

      // Le Drawer (Menu latéral)
      //drawer: const _HomeDrawer(),

      // IndexedStack permet de garder les onglets "en vie" en mémoire
      body: IndexedStack(
      index: _currentIndex,
      children: _tabs,
      ),

      // Bouton flottant pour créer un projet ou une tâche
      floatingActionButton: _currentIndex < 2
      ? FloatingActionButton(
      onPressed: () => _showCreationMenu(context),
      child: const Icon(Icons.add),
      )
          : null,

      bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed, // Pour afficher plus de 3 items
      items: const [
      BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
      BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Projets'),
      BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Tâches'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
      ),
      );
      }

      void _showCreationMenu(context) {
      // Logique pour ouvrir ProjectFormScreen ou TaskFormScreen
      }
      }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Home"),
    ),
    body: Center(
      child: Text(
        "Hello World",
        style: TextStyle(
          fontSize: 24,
          color:AppColors.textPrimary
        ),
      ),
    ),
  );
}






