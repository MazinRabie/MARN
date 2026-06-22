import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/enums/utils/enum_helper.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class EnumSelectField extends StatefulWidget {
  final String? labelText;
  final EnumType enumType;
  final EnumItem? initialValue;
  final bool Function(EnumItem)? filter;
  final Function(EnumItem?) onChanged;

  const EnumSelectField({
    super.key,
    this.labelText,
    required this.enumType,
    required this.onChanged,
    this.filter,
    this.initialValue,
  });

  @override
  State<EnumSelectField> createState() => _EnumSelectFieldState();
}

class _EnumSelectFieldState extends State<EnumSelectField> {
  EnumItem? selectedValue;
  late List<EnumItem> items;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadItemsAndMatchSelected();
  }

  @override
  void didUpdateWidget(covariant EnumSelectField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enumType != oldWidget.enumType) {
      _loadItemsAndMatchSelected();
    }

    if (widget.initialValue != null) {
      selectedValue = items.firstWhere(
        (e) => e.id == widget.initialValue!.id,
        orElse: () => widget.initialValue!,
      );
    } else {
      selectedValue = null;
    }
  }

  void _loadItemsAndMatchSelected() {
    items = EnumHelper.getEnum(context, widget.enumType) ?? [];
    if (widget.filter != null) {
      items = items.where(widget.filter!).toList();
    }

    // Ensure selectedValue matches the exact reference in the list for DropdownButton
    if (selectedValue != null) {
      try {
        selectedValue = items.firstWhere((e) => e.id == selectedValue!.id);
      } catch (e) {
        // Not found in the list, fallback
      }
    } else {
      selectedValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(widget.labelText!, style: AppTextStyles.bodyLarge),
          const SizedBox(height: 8),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<EnumItem>(
              value: selectedValue,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              hint: Text(
                LocaleKeys.commonSelect.tr(),
                style: AppTextStyles.bodyHint,
              ),
              items: items.map((item) {
                final isSelected = item.id == selectedValue?.id;

                return DropdownMenuItem<EnumItem>(
                  value: item,
                  child: Text(
                    item.displayName.isNotEmpty ? item.displayName : item.name,
                    style: isSelected
                        ? AppTextStyles.bodyLarge
                        : AppTextStyles.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedValue = value);
                widget.onChanged(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
