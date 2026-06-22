import 'package:MARN/core/localization/language_manager.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class DateFormatter {
  // Convert Arabic-Indic digits to English digits
  static String arabicToEnglish(String input) {
    const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
    const englishNumbers = '0123456789';
    var result = input;
    for (int i = 0; i < arabicNumbers.length; i++) {
      result = result.replaceAll(arabicNumbers[i], englishNumbers[i]);
    }
    return result;
  }

  // Format a DateTime to a localized string with time.
  static String format(DateTime dateTime) {
    final now = DateTime.now();
    final localDate = dateTime.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
    );
    final difference = today.difference(messageDate).inDays;

    final locale = LanguageManager.getSavedLanguage();
    final time = DateFormat('h:mm a', locale).format(localDate);
    String result;

    if (difference < 0) {
      // Future dates
      if (now.year == localDate.year) {
        result = DateFormat('d MMMM', locale).format(localDate);
      } else {
        result = DateFormat('d MMMM yyyy', locale).format(localDate);
      }
    } else if (difference == 0) {
      result = time;
    } else if (difference == 1) {
      result = LocaleKeys.commonYesterdayTime.tr(args: [time]);
    } else if (difference < 7) {
      final dayName = DateFormat('EEEE', locale).format(localDate);
      result = '$dayName $time';
    } else if (now.year == localDate.year) {
      final date = DateFormat('d MMM', locale).format(localDate);
      result = '$date $time';
    } else {
      final fullDate = DateFormat('d MMM yyyy', locale).format(localDate);
      result = '$fullDate $time';
    }

    return arabicToEnglish(result);
  }

  // Parse a date string, format it and convert Arabic digits.
  static String formatString(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(dateString);
      // Ensure UTC handling if needed
      if (!dateTime.isUtc &&
          !dateString.contains('Z') &&
          !dateString.contains('+')) {
        dateTime = DateTime.parse('${dateString}Z');
      }
      final formatted = format(dateTime);
      return arabicToEnglish(formatted);
    } catch (_) {
      return arabicToEnglish(dateString);
    }
  }

  static String formatContract(DateTime dateTime) {
    final localDate = dateTime.toLocal();

    return arabicToEnglish(DateFormat('dd/MM/yyyy').format(localDate));
  }
}
