import 'package:flutter/material.dart';
import 'package:MARN/features/static_screens/data/models/expansion_model.dart';

class FAQSearchController {
  static void searchFAQ({
    required String query,
    required Map<String, GlobalKey> itemKeys,
    required List<ExpansionModel> allItems,
  }) {
    final lowerQuery = query.toLowerCase();

    for (var item in allItems) {
      if (item.title.toLowerCase().contains(lowerQuery)) {
        final key = itemKeys[item.title];

        if (key?.currentContext != null) {
          Scrollable.ensureVisible(
            key!.currentContext!,
            duration: const Duration(milliseconds: 500),
          );
        }
        break;
      }
    }
  }
}
