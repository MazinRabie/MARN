import 'package:flutter/material.dart';

class StaticCardModel {
  final String title;
  final String description;
  final IconData? icon;
  final double? height;
  final String? imagePath;

  const StaticCardModel({
    required this.title,
    required this.description,
    this.icon,
    this.height,
    this.imagePath,
  });
}
