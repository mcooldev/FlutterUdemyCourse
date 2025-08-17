import 'package:flutter/material.dart';

class Category {
  Category({required this.id, required this.title, this.color = Colors.orange});

  String id, title;
  Color color;
}
