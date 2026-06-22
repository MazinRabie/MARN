import 'package:MARN/features/static_screens/data/models/about_marn_model.dart';
import 'package:MARN/features/static_screens/data/models/static_card_model.dart';
import 'package:flutter/material.dart';

const AboutMarnData aboutMarnDataAr = AboutMarnData(
  missionText:
      "في MARN، نؤمن بأن الجميع يستحق مكانًا يمكنهم تسميته موطنًا لهم. مهمتنا هي جعل عملية الإيجار ممتعة وفعالة وشفافة لكل من أصحاب العقارات والمستأجرين. تأسسنا في عام ٢٠٢٦ كشركة ناشئة صغيرة لنصبح منصة موثوقة لاحتياجات الإيجار.",
  values: [
    StaticCardModel(
      title: "الشفافية",
      description: "تواصل صادق",
      icon: Icons.visibility,
    ),
    StaticCardModel(
      title: "الثقة",
      description: "بناء علاقات دائمة",
      icon: Icons.favorite,
    ),
    StaticCardModel(
      title: "المجتمع",
      description: "ربط الناس بالأماكن",
      icon: Icons.people,
    ),
    StaticCardModel(
      title: "الابتكار",
      description: "استخدام التكنولوجيا الحديثة",
      icon: Icons.lightbulb,
    ),
  ],
  team: [
    StaticCardModel(
      title: "أحمد مقلد",
      description: "مطور تطبيق الهاتف\n مصمم واجهة الهاتف",
      imagePath: "assets/images/team/makled.jpg",
      icon: Icons.phone_android,
      height: 300,
    ),
    StaticCardModel(
      title: "فارس الدجن",
      description: "مطور الخلفية البرمجية \n قائد الفريق",
      imagePath: "assets/images/team/fares.jpg",
      icon: Icons.storage,
      height: 300,
    ),
    StaticCardModel(
      title: "مازن ربيع",
      description: "مطور الخلفية البرمجية",
      imagePath: "assets/images/team/rabiaa.jpg",
      icon: Icons.storage,
      height: 300,
    ),
    StaticCardModel(
      title: "عبد الرحمن عيسى",
      description: "مطور ذكاء اصطناعي",
      imagePath: "assets/images/team/abdo.jpg",
      icon: Icons.smart_toy,
      height: 300,
    ),
    StaticCardModel(
      title: "كريم فودة",
      description: "مطور واجهات الويب\n مصمم واجهة الويب",
      imagePath: "assets/images/team/kareem.jpg",
      icon: Icons.code,
      height: 300,
    ),
    StaticCardModel(
      title: "محمود الشيحة",
      description: "مطور واجهات الويب",
      imagePath: "assets/images/team/sheha.jpg",
      icon: Icons.code,
      height: 300,
    ),
  ],
);
