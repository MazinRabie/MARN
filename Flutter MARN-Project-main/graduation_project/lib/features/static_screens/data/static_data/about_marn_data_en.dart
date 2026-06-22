import 'package:MARN/features/static_screens/data/models/about_marn_model.dart';
import 'package:MARN/features/static_screens/data/models/static_card_model.dart';
import 'package:flutter/material.dart';

const AboutMarnData aboutMarnDataEn = AboutMarnData(
  missionText:
      "At MARN, we believe everyone deserves a place they can call home. Our mission is to make the rental process enjoyable, efficient, and transparent for both property owners and tenants. Founded in 2026 as a small startup, becoming a trusted platform for rental needs.",
  values: [
    StaticCardModel(
      title: "Transparency",
      description: "Honest communication",
      icon: Icons.visibility,
    ),
    StaticCardModel(
      title: "Trust",
      description: "Building lasting relationships",
      icon: Icons.favorite,
    ),
    StaticCardModel(
      title: "Community",
      description: "Connecting people with places",
      icon: Icons.people,
    ),
    StaticCardModel(
      title: "Innovation",
      description: "Using modern technology",
      icon: Icons.lightbulb,
    ),
  ],
  team: [
    StaticCardModel(
      title: "Ahmed Makled",
      description: "Mobile Developer \n Mobile UI/UX Designer",
      imagePath: "assets/images/team/makled.jpg",
      icon: Icons.phone_android,
      height: 300,
    ),
    StaticCardModel(
      title: "Fares Eldagen",
      description: "Back-End Developer\n Team Lead",
      imagePath: "assets/images/team/fares.jpg",
      icon: Icons.storage,
      height: 300,
    ),
    StaticCardModel(
      title: "Mazin Rabie",
      description: "Back-End Developer",
      imagePath: "assets/images/team/rabiaa.jpg",
      icon: Icons.storage,
      height: 300,
    ),
    StaticCardModel(
      title: "Abdalrahman Eissa",
      description: "AI Developer",
      imagePath: "assets/images/team/abdo.jpg",
      icon: Icons.smart_toy,
      height: 300,
    ),
    StaticCardModel(
      title: "Kareem Foda",
      description: "Web Developer\n Web UI/UX Designer",
      imagePath: "assets/images/team/kareem.jpg",
      icon: Icons.code,
      height: 300,
    ),
    StaticCardModel(
      title: "Mahmoud Elshiha",
      description: "Web Developer",
      imagePath: "assets/images/team/sheha.jpg",
      icon: Icons.code,
      height: 300,
    ),
  ],
);
