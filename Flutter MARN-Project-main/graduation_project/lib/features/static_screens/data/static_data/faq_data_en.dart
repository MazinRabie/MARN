import 'package:MARN/features/static_screens/data/models/expansion_model.dart';

final List<ExpansionModel> generalOverviewEn = const [
  ExpansionModel(
    title: "What is MARN?",
    result:
        "MARN (Modern Accommodation Rent Network) is a centralized, Egypt-wide digital platform that connects property owners with renters. It supports the entire rental lifecycle — from searching and booking to digital contracts, blockchain-anchored signatures, and online payments — all within a single, user-friendly application.",
  ),
  ExpansionModel(
    title: "Who is MARN designed for?",
    result:
        "MARN serves a wide range of users: students, young professionals, families, workers, and expatriates. It equally serves property owners who want to list and manage their rentals digitally.",
  ),
  ExpansionModel(
    title: "What types of accommodation does MARN support?",
    result:
        "MARN supports three accommodation types:"
        "• Full apartments — for families or groups seeking an entire unit\n"
        "• Private rooms — for individuals wanting a dedicated space\n"
        "• Shared beds — for students or budget-conscious renters in co-living setups\n",
  ),
  ExpansionModel(
    title:
        "What makes MARN different from other platforms like Roomster, Aqarmap, or Airbnb?",
    result:
        "MARN is the only platform that combines all of the following in one place:"
        "• Full end-to-end rental management (search → booking → contract → payment)\n"
        "• AI-powered personalized property recommendations\n"
        "• Lifestyle-based roommate matching\n"
        "• Blockchain-anchored digital contracts (unique in Egypt)\n"
        "• Integrated online payments with monthly scheduling\n"
        "• AI chatbot support in both Arabic and English\n"
        "• Nationwide coverage across all Egyptian governorates\n",
  ),
  ExpansionModel(
    title: "Is MARN available across all of Egypt?",
    result:
        "Yes. MARN covers all 27 Egyptian governorates, including cities and smaller towns often underrepresented on global platforms.",
  ),
  ExpansionModel(
    title: "What platforms can I access MARN on?",
    result:
        "MARN is available as:"
        "• A Flutter mobile application (Android and iOS)\n"
        "• A React.js web application accessible via browser\n"
        "The platform is deployed and accessible at marn.runasp.net and marn-six.vercel.app.",
  ),
  ExpansionModel(
    title: "What languages does MARN support?",
    result:
        "MARN fully supports both Arabic and English, including the AI chatbot and all user interface elements.",
  ),
];

final List<ExpansionModel> accountAndRegistrationEn = const [
  ExpansionModel(
    title: "How do I create a MARN account?",
    result:
        "You can register using your email address. After submitting your details, the system sends a confirmation link to verify your account before it is activated.",
  ),
  ExpansionModel(
    title: "Can I be both an owner and a renter on the same account?",
    result:
        "Yes. MARN allows users to select and update their roles. You can act as a renter, an owner, or both from the same account.",
  ),
  ExpansionModel(
    title: "How do I reset my password?",
    result:
        "Use the 'Forgot Password' option on the login screen. The system will send you a verification link to reset your password securely.",
  ),
  ExpansionModel(
    title: "Does MARN support two-factor authentication (2FA)?",
    result:
        "Yes. MARN supports optional two-factor authentication (2FA), which can be toggled on or off from your profile settings.",
  ),
  ExpansionModel(
    title: "Can I sign in using Google?",
    result:
        "Yes. MARN supports Google Login as an alternative to email-based registration.",
  ),
  ExpansionModel(
    title: "How do I update my profile information?",
    result:
        "Go to your Profile Settings screen, where you can edit personal information, upload a profile picture, change your password, and adjust language or notification preferences.",
  ),
];

final List<ExpansionModel> identityVerificationEn = const [
  ExpansionModel(
    title: "Why do I need to verify my identity?",
    result:
        "Verification ensures platform trust and legal compliance. Unverified users cannot create property listings or enter into rental contracts.",
  ),
  ExpansionModel(
    title: "What documents are required for verification?",
    result:
        "• Renters: A valid legal identification document (e.g., National ID)\n"
        "• Owners: National ID plus proof of property ownership documents\n",
  ),
  ExpansionModel(
    title: "How does the verification process work?",
    result:
        "1.Upload your documents from the Profile Settings or verification section\n"
        "2.The system validates the file format and stores documents securely\n"
        "3.Documents are submitted for administrative review\n"
        "4.You will be notified once your verification is approved or rejected\n"
        "5.How long does verification take?",
  ),
  ExpansionModel(
    title: "How long does verification take?",
    result:
        "Verification is reviewed by MARN administrators. You will receive a notification as soon as a decision is made.",
  ),
  ExpansionModel(
    title: "What happens if my verification is rejected?",
    result:
        "You will be notified of the rejection. You can re-upload corrected documents and resubmit for review.",
  ),
];

final List<ExpansionModel> searchingForPropertiesEn = const [
  ExpansionModel(
    title: "How can I search for a property?",
    result:
        "From the Property Search screen, you can search by:\n"
        "• Location (city or area within any of the 27 governorates)\n"
        "• Keywords\n"
        "• Property type (apartment, room, bed)\n"
        "• Price range\n"
        "• Rental duration\n"
        "• Number of occupants\n",
  ),
  ExpansionModel(
    title: "Can I view property locations on a map?",
    result:
        "Yes. MARN integrates map-based property visualization so you can see listings geographically.",
  ),
  ExpansionModel(
    title: "What information is shown on a property listing?",
    result:
        "Each listing shows photos, description, amenities, house rules, pricing, availability, owner information, location, and user ratings and reviews.",
  ),
  ExpansionModel(
    title: "Can I save or bookmark properties?",
    result:
        "Yes. Authenticated users can save or bookmark properties to revisit them later.",
  ),
  ExpansionModel(
    title: "Are all visible listings verified?",
    result:
        "Yes. Only listings that have been approved by MARN administrators appear publicly. Pending or rejected listings are not visible to renters.",
  ),
  ExpansionModel(
    title: "What if no results match my search?",
    result:
        "The system will display a 'No listings available' message. You can adjust your filters or try different search terms.",
  ),
];

final List<ExpansionModel> listingAPropertyOwnersEn = const [
  ExpansionModel(
    title: "How do I list my property on MARN?",
    result:
        "After becoming a verified owner, go to the Owner Dashboard and select 'Add Property.' Fill in your property details across the following stages:"
        "1.Stage 1: Basic details — title, type, address, city, price, and capacity"
        "2.Stage 2: Amenities — select features like Wi-Fi, parking, and AC"
        "3.Stage 3: Media — upload high-quality photos of the property",
  ),
  ExpansionModel(
    title: "What property types can I list?",
    result: "You can list an entire apartment, a room, or a shared bed.",
  ),
  ExpansionModel(
    title: "What details can I define for my listing?",
    result:
        "You can set the price, rental duration, occupancy rules, amenities, house rules, and upload images and videos.",
  ),
  ExpansionModel(
    title: "What happens after I submit a listing?",
    result:
        "Your listing is saved with a Pending status and sent for administrative review. It will only be published and made visible to renters after approval.",
  ),
  ExpansionModel(
    title: "Can I edit or remove a listing after publishing it?",
    result:
        "Yes. From the Owner Dashboard you can edit, deactivate, or delete your listings at any time.",
  ),
  ExpansionModel(
    title: "Can I temporarily make my listing unavailable without deleting it?",
    result:
        "Yes. You can deactivate a listing to hide it from search results without permanently removing it.",
  ),
];

final List<ExpansionModel> bookingAndRequestsEn = const [
  ExpansionModel(
    title: "How do I book a property?",
    result:
        "Open the property page and click 'Book Now.' A booking request will be sent to the owner, who will be notified and can accept or reject it.",
  ),
  ExpansionModel(
    title: "Can I schedule a property visit before booking?",
    result:
        "Yes. MARN allows renters to schedule property visits as part of the request workflow.",
  ),
  ExpansionModel(
    title: "What happens after my booking request is accepted?",
    result:
        "Once the owner accepts, the system moves to the digital contract stage, where both parties review and sign the agreement.",
  ),
  ExpansionModel(
    title: "Can I cancel a booking request?",
    result: "Yes. Renters can cancel a booking request before it is accepted.",
  ),
  ExpansionModel(
    title: "How are owners notified of new requests?",
    result:
        "The system sends real-time notifications to owners when a new booking request arrives.",
  ),
];

final List<ExpansionModel> roommateMatchingEn = const [
  ExpansionModel(
    title: "How does the roommate matching system work?",
    result:
        "MARN uses an algorithmic compatibility model. Users fill in their lifestyle preferences, and the system matches them with compatible roommates based on those inputs.",
  ),
  ExpansionModel(
    title: "What preferences can I set for roommate matching?",
    result:
        "• Sleep schedule and daily habits\n"
        "• Smoking preferences\n"
        "• Pet ownership\n"
        "• Gender preferences\n"
        "• Educational background and field of study\n"
        "• Budget range\n",
  ),
  ExpansionModel(
    title: "Where do I set my roommate preferences?",
    result:
        "Go to Profile Settings → Roommate Preferences to define and update your lifestyle profile.",
  ),
  ExpansionModel(
    title: "How is compatibility calculated?",
    result:
        "The system computes a compatibility score based on how closely each user's preferences align with potential matches. Matches are ranked and presented with a summary of matching and non-matching traits (e.g., smoking, pets, sleep habits).",
  ),
  ExpansionModel(
    title: "Can I contact a suggested roommate?",
    result:
        "Yes. From the Roommate Matches screen, you can view a match's basic profile and initiate communication.",
  ),
];

final List<ExpansionModel> aiRecommendationsAndChatbotEn = const [
  ExpansionModel(
    title: "How does MARN recommend properties to me?",
    result:
        "The recommendation engine analyzes your activity on the platform — including searches, viewed listings, saved properties, and bookings — and uses three strategies:\n"
        "• Criteria-Based Search: When you apply filters, the engine uses FAISS vector search on 58-dimensional feature vectors to surface the most relevant listings.\n"
        "• Behavior-Based Personalization: Based on your past activity, DBSCAN geographic clustering identifies your interest zones and FAISS search retrieves tailored suggestions, with more recent interactions given greater influence.\n"
        "• Similar Listing Discovery: On any property page, you can see similar listings ranked by cosine similarity.\n",
  ),
  ExpansionModel(
    title: "Do recommendations get better over time?",
    result:
        "Yes. The more you interact with the platform (search, view, save, book), the more accurate your personalized recommendations become. Recent interactions carry more weight than older ones through a recency decay model.",
  ),
  ExpansionModel(
    title: "What is the MARN AI chatbot?",
    result:
        "The AI chatbot is a built-in assistant that helps you discover properties, understand platform features, and navigate the rental process through natural language conversation. It is available 24/7 and supports both Arabic and English.",
  ),
  ExpansionModel(
    title: "What can the chatbot help me with?",
    result:
        "• Searching and filtering properties\n"
        "• Answering questions about how MARN works\n"
        "• Guiding you through the booking and contract process\n"
        "• Providing context-aware suggestions during your session\n",
  ),
  ExpansionModel(
    title: "Is the chatbot available on both the mobile app and the website?",
    result:
        "Yes. The chatbot is available through both the Flutter mobile app and the React.js web application.",
  ),
];

final List<ExpansionModel> digitalContractsAndBlockchainEn = const [
  ExpansionModel(
    title: "How does the digital contract work?",
    result:
        "Once a booking is accepted, the system automatically generates a digital rental contract. Both the renter and owner review the contract terms. When the renter approves:"
        "A PDF is generated with a cryptographic hash"
        "The contract is anchored to the Bitcoin blockchain via OpenTimestamps"
        "A tamper-proof timestamp (OTS proof file) is created"
        "The contract and payment schedules are stored securely",
  ),

  ExpansionModel(
    title: "What does blockchain anchoring mean for my contract?",
    result:
        "The contract's cryptographic fingerprint is recorded on the Bitcoin blockchain, providing an independent, permanent, and verifiable proof of the contract's content and the date it was signed. This cannot be altered or forged.",
  ),

  ExpansionModel(
    title: "Can I download my contract?",
    result:
        "Yes. Approved contracts can be downloaded by authorized users directly from the platform. You can also download your .ots proof file for independent verification.",
  ),

  ExpansionModel(
    title: "What is an OTS file?",
    result:
        "An OTS (OpenTimestamps) file is a blockchain proof receipt. It contains the data needed to independently verify that your contract existed and was signed at a specific point in time, linked to the Bitcoin network.",
  ),
  ExpansionModel(
    title: "Is MARN's digital contract legally compliant?",
    result:
        "MARN is built to comply with applicable Egyptian laws related to electronic transactions and digital contracts. Admin review ensures contracts meet platform and legal standards before activation.",
  ),
  ExpansionModel(
    title: "What happens if one party rejects the contract?",
    result:
        "If the renter rejects the contract, it is cancelled. The booking will not proceed, and no financial obligations are created.",
  ),
  ExpansionModel(
    title: "What are the possible contract statuses?",
    result:
        "A contract can be in one of the following states:"
        "Created → Pending → Signed → Verified → Cancelled / Expired",
  ),
];

final List<ExpansionModel> paymentsEn = const [
  ExpansionModel(
    title: "How do I pay rent on MARN?",
    result:
        "From the Payment screen, select 'Pay Rent.' The system creates a payment session through an integrated online payment gateway. Supported methods include credit/debit cards and mobile wallets.",
  ),

  ExpansionModel(
    title: "Does MARN support monthly payment scheduling?",
    result:
        "Yes. After a contract is activated, monthly rent installments are scheduled with defined due dates. The system tracks each installment's status and sends automated reminders for upcoming or overdue payments.",
  ),

  ExpansionModel(
    title: "Will I be notified about upcoming payments?",
    result:
        "Yes. MARN sends reminders before payment due dates and notifications for successful or failed transactions.",
  ),

  ExpansionModel(
    title: "Where can I view my payment history?",
    result:
        "Payment history is available from the Payment screen for renters and from the Owner Dashboard (earnings and payment status) for owners.",
  ),

  ExpansionModel(
    title: "How do owners receive their rental income?",
    result:
        "Owners can connect a payment account and initiate withdrawals of their balance through the Owner Dashboard.",
  ),

  ExpansionModel(
    title: "What happens if a payment fails?",
    result:
        "The system provides retry options. You will be notified of the failure and can attempt the payment again.",
  ),
];

final List<ExpansionModel> communicationAndNotificationsEn = const [
  ExpansionModel(
    title: "How can I communicate with an owner or renter?",
    result:
        "MARN has a built-in real-time chat powered by SignalR. You can message owners or renters directly within the platform. Chat access is restricted to users associated with a relevant listing or booking request.",
  ),
  ExpansionModel(
    title: "Are my messages stored?",
    result:
        "Yes. Chat messages are stored and can be retrieved later from the Chat screen.",
  ),
  ExpansionModel(
    title: "What types of notifications does MARN send?",
    result:
        "You will receive notifications for:"
        "• Booking requests and responses\n"
        "• Verification approval or rejection\n"
        "• Contract status changes\n"
        "• Payment reminders and transaction outcomes\n"
        "• Listing approval or rejection (owners)\n",
  ),
  ExpansionModel(
    title: "Are notifications real-time?",
    result:
        "Yes. MARN supports both real-time notifications (via SignalR) and asynchronous push notifications (via Firebase Cloud Messaging / FCM).",
  ),
];

final List<ExpansionModel> ratingsReviewsAndReportingEn = const [
  ExpansionModel(
    title: "Can I rate a property after renting it?",
    result:
        "Yes. After a completed rental, you can submit a star rating and a written review for the property.",
  ),
  ExpansionModel(
    title: "Where are ratings displayed?",
    result:
        "Average ratings and individual reviews appear on property detail pages, helping other renters make informed decisions.",
  ),
  ExpansionModel(
    title: "How do I report an inappropriate listing or user?",
    result:
        "Use the Report function on the listing or user profile. Submitted reports are forwarded to MARN administrators for review and moderation.",
  ),
];

final List<ExpansionModel> adminAndPlatformGovernanceEn = const [
  ExpansionModel(
    title: "What does the MARN admin team do?",
    result:
        "Administrators manage the health and integrity of the platform through a comprehensive Admin Dashboard. Their responsibilities include:"
        "• Reviewing and approving user identity documents\n"
        "• Approving or rejecting property listings\n"
        "• Reviewing and verifying digital contracts\n"
        "• Managing users (including suspension or banning)\n"
        "• Handling reports and moderation actions\n"
        "• Generating analytics reports\n",
  ),
  ExpansionModel(
    title: "Are listings reviewed before going live?",
    result:
        "Yes. Every newly submitted listing is reviewed by an administrator before it becomes publicly visible. This ensures accuracy, compliance, and quality.",
  ),
  ExpansionModel(
    title: "How is user trust maintained on the platform?",
    result:
        "Through a combination of identity verification, document review, admin-approved listings, user ratings, a reporting system, and audit logging of all critical operations.",
  ),
];

final List<ExpansionModel> technicalStackAndArchitectureEn = const [
  ExpansionModel(
    title: "What technologies power MARN?",
    result:
        "Backend API	ASP.NET Core Web API"
        "AI Microservice	FastAPI (Python)"
        "Mobile App	Flutter (Android & iOS)"
        "Web App	React.js"
        "Database	Microsoft SQL Server + Entity Framework Core"
        "Real-Time Communication	SignalR"
        "AI Recommendation Engine	FAISS, KNN (Ball-Tree), DBSCAN, TF-IDF"
        "AI Chatbot	LangGraph ReAct + Qwen LLM"
        "Blockchain Timestamping	OpenTimestamps (Bitcoin network)"
        "Push Notifications	Firebase Cloud Messaging (FCM)",
  ),
  ExpansionModel(
    title: "How does the recommendation engine work at a technical level?",
    result:
        "Each property is represented as a 58-dimensional feature vector combining 8 weighted numeric features (price, area, bedrooms, bathrooms, beds, max occupants, latitude, longitude) and a 50-dimensional TF-IDF title encoding. These are indexed in a FAISS index (cosine similarity via L2-normalized inner product). Behavior-based personalization uses DBSCAN geographic clustering to identify user interest zones, then performs FAISS search per cluster with weighted interaction scores and recency decay.",
  ),
  ExpansionModel(
    title: "What is the chatbot's architecture?",
    result:
        "The chatbot uses a LangGraph ReAct (Reasoning + Acting) agent architecture with a local Qwen3.5-4B large language model served via LM Studio. It maintains conversation history in the database (AssistantSessions / AssistantMessages tables) for chat persistence across sessions.",
  ),
  ExpansionModel(
    title: "How is data secured on MARN?",
    result:
        "• Role-based access control (renter, owner, admin)\n"
        "• JWT-based authentication with 2FA support\n"
        "• Encrypted storage for legal documents and contracts\n"
        "• HTTPS for all client-server communication\n"
        "• Audit logs for critical system operations\n",
  ),
  ExpansionModel(
    title: "What development methodology was used?",
    result:
        "MARN was developed using the Agile methodology, with iterative sprints covering requirements analysis, architecture design, UI/UX prototyping, backend development, frontend integration, and testing & refinement.",
  ),
];

final List<ExpansionModel> futureImprovementsEn = const [
  ExpansionModel(
    title: "What features are planned for future versions of MARN?",
    result:
        "• AI-Assisted Verification: Automated review of identity and ownership documents to speed up the verification process and detect inconsistencies\n"
        "• AI-Based Price Estimation: A pricing model to help owners set fair rental prices and help renters evaluate offers based on market data\n"
        "• Geographical Expansion: Extending the platform beyond Egypt to support other countries, currencies, and languages\n"
        "• Handwritten Digital Signature Support: Allowing users to sign contracts with a handwritten-style signature for a more natural experience\n"
        "• Voice-Enabled Assistant: Adding voice interaction to the chatbot for improved accessibility\n"
        "• AI-Assisted Reporting & Violation Detection: Using AI to help detect abusive messages, misleading listings, and repeated policy violations\n"
        "• Property Sales Support: Expanding MARN beyond rentals to support full property purchases\n",
  ),
];
