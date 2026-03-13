import 'package:flutter/material.dart';

class DashboardTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tableau de bord", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Row(
            children: [
              _buildStatCard("Tâches", "12", Colors.blue),
              _buildStatCard("Projets", "4", Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(title, style: TextStyle(color: Colors.white)),
              Text(count, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}