import 'package:MARN/features/static_screens/data/models/how_it_works_model.dart';
import 'package:MARN/features/static_screens/data/models/static_card_model.dart';
import 'package:flutter/material.dart';

const HowItWorksData howItWorksDataAr = HowItWorksData(
  forTenants: [
    StaticCardModel(
      title: "البحث والتصفية",
      description:
          "آلاف الإعلانات مع أدوات تصفية للموقع والسعر وتفضيلات شريك السكن.",
      icon: Icons.search,
      height: 230,
    ),
    StaticCardModel(
      title: "طلبات الحجز",
      description:
          "ستتلقى طلبات حجز من المستأجرين. قم بمراجعتها وقبولها أو رفضها.",
      icon: Icons.calendar_today,
      height: 230,
    ),
    StaticCardModel(
      title: "التواصل والدردشة",
      description:
          "راسل أصحاب العقارات وشركاء السكن المحتملين مباشرة. احصل على إجابات لجميع أسئلتك على الفور.",
      icon: Icons.chat_bubble,
      height: 230,
    ),
    StaticCardModel(
      title: "الحجز والانتقال",
      description:
          "أكمل طلبك عبر الإنترنت، ووقع عقد الإيجار رقميًا، وادفع بأمان. انتقل إلى منزلك الجديد!",
      icon: Icons.move_to_inbox,
      height: 230,
    ),
  ],
  forOwners: [
    StaticCardModel(
      title: "إدراج عقارك",
      description:
          "أنشئ إعلانًا تفصيليًا بالصور والأوصاف والميزات المتاحة. حدد السعر الخاص بك.",
      icon: Icons.home,
      height: 230,
    ),
    StaticCardModel(
      title: "فحص المستأجرين",
      description:
          "راجع الملفات الشخصية الموثقة للمستأجرين، وفحوصات الخلفية، والمراجع. اختر المطابقة الأفضل لعقارك.",
      icon: Icons.person_search,
      height: 230,
    ),
    StaticCardModel(
      title: "التواصل",
      description:
          "دردش مع المستأجرين المهتمين، وجدول الجولات، وأجب عن أسئلتهم من خلال منصة المراسلة الآمنة لدينا.",
      icon: Icons.chat_bubble,
      height: 230,
    ),
    StaticCardModel(
      title: "الإدارة والربح",
      description: "اقبل المدفوعات، وتتبع أرباحك كلها من لوحة تحكم واحدة.",
      icon: Icons.attach_money,
      height: 230,
    ),
  ],
  whyChooseUs: [
    StaticCardModel(
      title: "إعلانات موثقة",
      description: "يتم التحقق من جميع العقارات لضمان أصالتها ودقتها.",
      icon: Icons.verified_user,
      height: 230,
    ),
    StaticCardModel(
      title: "مدفوعات آمنة",
      description: "معالجة دفع مشفرة من الطرفين لسلامتك.",
      icon: Icons.payment,
      height: 230,
    ),
    StaticCardModel(
      title: "مطابقة التوافق",
      description: "خوارزمية ذكية تطابقك مع شركاء السكن المتوافقين.",
      icon: Icons.group,
      height: 230,
    ),
    StaticCardModel(
      title: "رؤى السوق",
      description: "الوصول إلى بيانات السوق في الوقت الفعلي وتحليلات الأسعار.",
      icon: Icons.analytics,
      height: 230,
    ),
  ],
);
