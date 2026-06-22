import 'package:MARN/features/static_screens/data/models/expansion_model.dart';
import 'package:flutter/material.dart';

const String privacyPolicyLastUpdatedEn = "June 13, 2026";

final List<ExpansionModel> privacyPolicyDataEn = const [
  ExpansionModel(
    icon: Icon(Icons.privacy_tip),
    title: "1. What information do we collect?",
    result:
        "We collect personal information such as your name, email address, "
        "phone number, national ID and photographs of identification documents "
        "(for legal identity verification/KYC), roommate preferences, payment "
        "details (for owners, processed securely via Stripe), chat history, "
        "and queries sent to our AI Assistant Chatbot, as well as usage data "
        "like searches, favorites, and system interactions to improve your experience.",
  ),
  ExpansionModel(
    icon: Icon(Icons.verified_user),
    title: "2. How do we protect your data?",
    result:
        "MARN uses industry-standard encryption (SSL/TLS) for data transmission. "
        "Your passwords are hashed, and we regularly audit our systems "
        "to prevent unauthorized access. Personal data is stored on secure servers, "
        "and payment details are handled entirely by Stripe, meaning we do not store "
        "your raw financial information.",
  ),
  ExpansionModel(
    icon: Icon(Icons.share),
    title: "3. Do we share your information with third parties?",
    result:
        "We only share your data with property owners when you apply for a listing, "
        "or with verified service providers who help us operate (e.g., Stripe for payments, "
        "Firebase for push notifications, and Google for analytics). When you sign a contract, "
        "a SHA-256 cryptographic hash of the document is anchored to the Bitcoin blockchain "
        "using OpenTimestamps to verify its integrity. This hash contains no readable personal data. "
        "We never sell your personal information.",
  ),
  ExpansionModel(
    icon: Icon(Icons.cookie),
    title: "4. Do we use cookies?",
    result:
        "Yes, we use cookies to remember your login status, save preferences, "
        "and analyze site traffic. You can disable cookies in your browser settings, "
        "but some features may not work properly.",
  ),
  ExpansionModel(
    icon: Icon(Icons.delete_forever),
    title: "5. How can you delete your account?",
    result:
        "Go to Settings > Edit Profile > Delete Profile within the app, or email "
        "support@marn.com. Once deleted, your personal data will be removed from our active "
        "databases within 30 days, except where we are required to retain records for legal, "
        "tax, or regulatory compliance.",
  ),
  ExpansionModel(
    icon: Icon(Icons.update),
    title: "6. How often is this policy updated?",
    result:
        "We update this policy whenever we change how we handle data. "
        "The 'Last Updated' date at the top will always reflect the latest version. "
        "We’ll notify you via email or in-app notification for significant changes.",
  ),
  ExpansionModel(
    icon: Icon(Icons.email),
    title: "7. How can you contact us about privacy?",
    result:
        "Email our Support Team at support@marn.com or write to: "
        "MARN, 123 Rental St., Suite 400, Cairo, Egypt. "
        "We respond to all privacy-related inquiries within 7 business days.",
  ),
  ExpansionModel(
    icon: Icon(Icons.location_on),
    title: "8. Do we collect location data?",
    result:
        "With your permission, we collect your device's approximate location "
        "to show nearby properties and roommate matches. You can disable this "
        "anytime in your device settings.",
  ),
  ExpansionModel(
    icon: Icon(Icons.photo_camera),
    title: "9. Do we access your camera or gallery?",
    result:
        "When you upload profile pictures, property photos, or ID documents for "
        "identity verification, we request camera/gallery access. We never access "
        "these without your action, and images are stored securely.",
  ),
  ExpansionModel(
    icon: Icon(Icons.notifications),
    title: "10. How do we use push notifications?",
    result:
        "We send notifications for new messages, booking requests, contract status changes, "
        "payment schedules, and roommate matches. You can customize or disable these in "
        "Settings > Notifications.",
  ),
  ExpansionModel(
    icon: Icon(Icons.analytics),
    title: "11. Do we use analytics tools?",
    result:
        "We use Google Analytics and Firebase Analytics to understand how "
        "users interact with MARN. This helps us improve features and fix bugs. "
        "All analytics data is anonymized.",
  ),
  ExpansionModel(
    icon: Icon(Icons.child_care),
    title: "12. What are our policies for minors under 18?",
    result:
        "MARN is strictly intended for users who are 18 years of age or older. We do not "
        "knowingly collect personal data from minors under 18. If we learn that we have "
        "collected data from a minor under 18, we will take steps to delete the information "
        "and terminate the account as soon as possible.",
  ),
  ExpansionModel(
    icon: Icon(Icons.business_center),
    title: "13. How long do we retain your data?",
    result:
        "We keep your personal data as long as your account is active. "
        "After deletion, most data is purged within 30 days. Financial and transaction "
        "records for owners and renters may be kept for up to 7 years for tax and legal compliance.",
  ),
  ExpansionModel(
    icon: Icon(Icons.security),
    title: "14. What happens in case of a data breach?",
    result:
        "We have an incident response plan. If a breach affects your personal data, "
        "we will notify you within 72 hours via email and post a notice on our platform. "
        "We will also report to relevant authorities as required by law.",
  ),
  ExpansionModel(
    icon: Icon(Icons.translate),
    title: "15. Is this policy available in other languages?",
    result:
        "Our privacy policy is available in both English and Arabic. In the event of "
        "any discrepancies or conflict between the English and Arabic versions, the "
        "English version shall prevail and be the legally binding document.",
  ),
];
