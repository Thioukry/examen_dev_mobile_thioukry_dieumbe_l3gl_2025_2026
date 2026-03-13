import 'package:flutter/material.dart';

class Project {
  final String id;
  final String userId; // ID de l'utilisateur qui a créé le projet
  final String name;
  final String? description;
  final Color color; // Couleur pour l'icône ou la carte
  final DateTime createdAt;

  //final String colorHex;


  Project({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.color,
    required this.createdAt,
  });

  // --- CONVERSION POUR LE STOCKAGE (JSON) ---

  // Convertit l'objet Project en Map pour SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'color': color.value, // On stocke la valeur numérique de la couleur
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Crée un objet Project à partir d'un Map (lecture depuis SharedPreferences)
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      description: map['description'],
      color: Color(map['color']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }


}