import 'package:MARN/features/static_screens/data/models/expansion_model.dart';
import 'package:flutter/material.dart';

const String termsOfUseLastUpdatedEn = "June 13, 2026";

final List<ExpansionModel> termsOfUseDataEn = const [
  ExpansionModel(
    icon: Icon(Icons.description),
    title: "1. Acceptance of Terms",
    result:
        "By accessing or using MARN, you agree to be bound by these Terms of Use. "
        "If you do not agree with any part of these terms, you may not use our services. "
        "Continued use constitutes acceptance of any future updates.",
  ),
  ExpansionModel(
    icon: Icon(Icons.person_outline),
    title: "2. Eligibility and Account Registration",
    result:
        "You must be at least 18 years old to use MARN. When registering, you agree to "
        "provide accurate, complete, and current information. You are solely responsible "
        "for maintaining the confidentiality of your password and account.",
  ),
  ExpansionModel(
    icon: Icon(Icons.home_work),
    title: "3. Listing Properties (For Owners)",
    result:
        "Property owners agree to provide accurate descriptions, honest pricing, "
        "and up-to-date availability. MARN reserves the right to remove any listing "
        "that violates our policies. A service fee may apply per successful rental.",
  ),
  ExpansionModel(
    icon: Icon(Icons.search),
    title: "4. Searching and Applying (For Tenants)",
    result:
        "Tenants may browse listings for free. When you apply for a property, "
        "you authorize MARN to share your application details with the property owner. "
        "MARN does not guarantee approval or lease agreement outcomes.",
  ),
  ExpansionModel(
    icon: Icon(Icons.gavel),
    title: "5. Prohibited Activities",
    result:
        "You may not: post false listings, harass other users, scrape data, "
        "use bots, attempt to hack our systems, or list properties you don't own. "
        "Violations may result in immediate account termination and legal action.",
  ),
  ExpansionModel(
    icon: Icon(Icons.payment),
    title: "6. Payments and Fees",
    result:
        "All rental transactions and payouts are processed securely via our third-party "
        "payment processor, Stripe. Tenants must pay rent schedules online through the "
        "platform. Property owners must onboard via Stripe Connect to receive and withdraw "
        "their earnings. MARN does not store raw credit card or banking details. Platform "
        "service fees or success fees may apply and are clearly displayed before any transaction.",
  ),
  ExpansionModel(
    icon: Icon(Icons.message),
    title: "7. User Communications",
    result:
        "Messages sent through MARN's platform are monitored for safety and fraud prevention. "
        "We recommend keeping all communications within the app. Exchanging personal contact "
        "information before a legitimate lease is signed is discouraged.",
  ),
  ExpansionModel(
    icon: Icon(Icons.star),
    title: "8. Reviews and Ratings",
    result:
        "Users may leave honest reviews about landlords or tenants. Fake reviews, "
        "retaliatory ratings, or review manipulation is strictly prohibited. "
        "MARN may remove reviews that violate our content guidelines.",
  ),
  ExpansionModel(
    icon: Icon(Icons.photo_library),
    title: "9. Content Ownership and License",
    result:
        "You retain ownership of photos, descriptions, and messages you post. "
        "By posting, you grant MARN a worldwide, royalty-free license to display, "
        "store, and promote your content within the app. Do not post copyrighted "
        "material you don't own.",
  ),
  ExpansionModel(
    icon: Icon(Icons.block),
    title: "10. Account Suspension and Termination",
    result:
        "MARN may suspend or terminate your account for violations of these terms, "
        "fraudulent activity, or at our discretion. You may delete your account anytime. "
        "Upon termination, you lose access to all data associated with your account.",
  ),
  ExpansionModel(
    icon: Icon(Icons.warning_amber),
    title: "11. Disclaimer of Warranties",
    result:
        "MARN is provided 'as is' without warranties of any kind. We do not guarantee "
        "that listings are accurate, that you will find a tenant/roommate, or that the "
        "service will be uninterrupted or error-free. Verify all information independently.",
  ),
  ExpansionModel(
    icon: Icon(Icons.shield),
    title: "12. Limitation of Liability",
    result:
        "To the maximum extent permitted by law, MARN is not liable for any indirect, "
        "incidental, or consequential damages arising from your use of the service. "
        "Our total liability shall not exceed the fees you paid to us in the past 6 months.",
  ),
  ExpansionModel(
    icon: Icon(Icons.mediation),
    title: "13. Dispute Resolution and Arbitration",
    result:
        "Any disputes arising from these terms shall first be attempted to resolve informally. "
        "If unresolved, disputes shall be settled through binding arbitration in Cairo, Egypt, "
        "rather than court. Class action waivers apply.",
  ),
  ExpansionModel(
    icon: Icon(Icons.gavel_outlined),
    title: "14. Governing Law",
    result:
        "These Terms are governed by the laws of the Arab Republic of Egypt. "
        "Any legal proceedings must be filed in the courts of Cairo. "
        "International users agree to comply with all local laws.",
  ),
  ExpansionModel(
    icon: Icon(Icons.fingerprint),
    title: "15. Digital Contracts and Blockchain Verification",
    result:
        "Lease contracts generated on MARN are legally binding electronic agreements. "
        "Upon signing by both parties, MARN compiles the final bilingual contract PDF, "
        "generates a SHA-256 cryptographic hash of the document, and anchors this hash "
        "to the Bitcoin blockchain using the OpenTimestamps protocol. This provides an "
        "immutable, publicly auditable proof of the contract's existence and content at the "
        "moment of signing, enabling both parties to independently verify the file's integrity.",
  ),
  ExpansionModel(
    icon: Icon(Icons.change_circle),
    title: "16. Changes to These Terms",
    result:
        "We may update these Terms of Use periodically. We will notify you via email "
        "or in-app notification of significant changes. Continuing to use MARN after "
        "changes means you accept the revised terms. The 'Last Updated' date is at the top.",
  ),
];
