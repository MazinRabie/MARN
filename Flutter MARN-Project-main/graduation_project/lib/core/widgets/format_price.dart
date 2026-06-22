import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

String formatPrice(int value) {
  if (value >= 1000000) {
    return LocaleKeys.commonPriceMillion.tr(args: [(value / 1000000).toStringAsFixed(1)]);
  } else if (value >= 1000) {
    return LocaleKeys.commonPriceThousand.tr(args: [(value / 1000).toStringAsFixed(0)]);
  }
  return value.toString();
}