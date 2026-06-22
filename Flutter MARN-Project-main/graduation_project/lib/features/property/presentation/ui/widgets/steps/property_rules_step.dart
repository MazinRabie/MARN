import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/custom_text_form_field.dart';
import 'package:MARN/features/property/presentation/ui/models/property_form_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PropertyRulesStep extends StatefulWidget {
  const PropertyRulesStep({
    super.key,
    required this.formKey,
    required this.property,
  });
  final PropertyFormState property;
  final GlobalKey<FormState> formKey;

  @override
  State<PropertyRulesStep> createState() => _PropertyRulesStepState();
}

class _PropertyRulesStepState extends State<PropertyRulesStep> {
  late TextEditingController ruleController;
  @override
  void initState() {
    super.initState();
    ruleController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    ruleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalRulesCount = widget.property.existingRules.length +
        widget.property.addedRules.length;

    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: CustomTextFormField(
                    controller: ruleController,
                    labelText: LocaleKeys.propertyFormRulesAddRule.tr(),
                    hintText: LocaleKeys.propertyFormRulesRuleHint.tr(),
                    type: CustomTextFormFieldType.text,
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (ruleController.text.trim().isNotEmpty) {
                        widget.property.addedRules
                            .add(ruleController.text.trim());
                        ruleController.clear();
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: totalRulesCount,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final isExisting = index < widget.property.existingRules.length;
                final ruleText = isExisting
                    ? widget.property.existingRules[index].text
                    : widget.property.addedRules[
                        index - widget.property.existingRules.length];

                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grayLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.propertyFormRulesRuleIndex.tr(namedArgs: {"index": "${index + 1}"})),
                        IconButton(
                          onPressed: () {
                            if (isExisting) {
                              widget.property.removedRuleIds.add(
                                  widget.property.existingRules[index].id);
                              widget.property.existingRules.removeAt(index);
                            } else {
                              widget.property.addedRules.removeAt(index -
                                  widget.property.existingRules.length);
                            }
                            setState(() {});
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                    subtitle: Text(ruleText),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
