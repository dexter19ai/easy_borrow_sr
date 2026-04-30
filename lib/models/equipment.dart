import 'package:flutter/material.dart';

class Equipment {
  Equipment({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.icon,
    required this.quantityAvailable,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final IconData icon;
  int quantityAvailable;
}
