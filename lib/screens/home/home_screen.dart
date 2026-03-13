import 'package:flutter/material.dart';
import 'package:sunu_task/core/constants/app_colors.dart';
import 'package:sunu_task/screens/projects/project_form_screen.dart';
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
final List<Widget> _pages = [
  DashboardTab(),
    ProjectsTab(),
    TasksTab(),
    ProfileTab(),
    ];
  void _showCreationMenu(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProjectFormScreen()),
    );
    // Logique pour ouvrir ProjectFormScreen ou TaskFormScreen
  }

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
      body: _pages[_currentIndex],
      floatingActionButton: (_currentIndex == 0 || _currentIndex == 1)
          ? FloatingActionButton(
        onPressed: () => _showCreationMenu(context),
        child: const Icon(Icons.add), backgroundColor: Colors.blue,
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Projets'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Tâches'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],),

    );
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






