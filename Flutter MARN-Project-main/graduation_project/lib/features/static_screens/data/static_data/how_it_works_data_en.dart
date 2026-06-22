import 'package:MARN/features/static_screens/data/models/how_it_works_model.dart';
import 'package:MARN/features/static_screens/data/models/static_card_model.dart';
import 'package:flutter/material.dart';

const HowItWorksData howItWorksDataEn = HowItWorksData(
  forTenants: [
    StaticCardModel(
      title: "Search & Filter",
      description:
          "thousands of listings with fitters for location, price, and roommate preferences,",
      icon: Icons.search,
      height: 230,
    ),
    StaticCardModel(
      title: "Booking Requests",
      description:
          "You will receive booking requests from tenants. Review them and accept or decline.",
      icon: Icons.calendar_today,
      height: 230,
    ),
    StaticCardModel(
      title: "Connect & Chat",
      description:
          "Message property owners and potential roommates directly. Get answers to all your questions instantly.",
      icon: Icons.chat_bubble,
      height: 230,
    ),
    StaticCardModel(
      title: "Book & Move In",
      description:
          "Complete your application online, sign the lease digitally, and pay securely. Move into your new home!",
      icon: Icons.move_to_inbox,
      height: 230,
    ),
  ],
  forOwners: [
    StaticCardModel(
      title: "List Your Property",
      description:
          "Create a detailed listing with photos, descriptions, and amenities. Set your price",
      icon: Icons.home,
      height: 230,
    ),
    StaticCardModel(
      title: "Screen Tenants",
      description:
          "Review verified tenant profiles, background checks, and references. Choose the best match for your property.",
      icon: Icons.person_search,
      height: 230,
    ),
    StaticCardModel(
      title: "Communicate",
      description:
          "Chat with interested tenants, schedule tours, and answer questions through our secure messaging platform.",
      icon: Icons.chat_bubble,
      height: 230,
    ),
    StaticCardModel(
      title: "Manage & Earn",
      description:
          "Accept payment and track your earnings all from one dashboard.",
      icon: Icons.attach_money,
      height: 230,
    ),
  ],
  whyChooseUs: [
    StaticCardModel(
      title: "Verified Listings",
      description: "All properties are verified for authenticity and accuracy.",
      icon: Icons.verified_user,
      height: 230,
    ),
    StaticCardModel(
      title: "Secure Payments",
      description: "End-to-end encrypted payment processing for your safety.",
      icon: Icons.payment,
      height: 230,
    ),
    StaticCardModel(
      title: "Compatibility Matching",
      description: "Smart algorithm matches you with compatible roommates.",
      icon: Icons.group,
      height: 230,
    ),
    StaticCardModel(
      title: "Market Insights",
      description: "Access real-time market data and pricing analytics.",
      icon: Icons.analytics,
      height: 230,
    ),
  ],
);
