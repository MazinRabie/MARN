import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/widgets/custom_text_form_field.dart';
import 'package:MARN/core/widgets/enum_select_field.dart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:MARN/features/property/presentation/ui/models/property_form_state.dart';

class PropertyPricingStep extends StatefulWidget {
  const PropertyPricingStep({
    super.key,
    required this.formKey,
    required this.property,
  });
  final PropertyFormState property;
  final GlobalKey<FormState> formKey;

  @override
  State<PropertyPricingStep> createState() => _PropertyPricingStepState();
}

class _PropertyPricingStepState extends State<PropertyPricingStep> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            EnumSelectField(
              enumType: EnumType.rentalUnits,
              initialValue: widget.property.rentalUnit,
              labelText: LocaleKeys.propertyFormPricingBillingCycle.tr(),
              onChanged: (value) {
                if (value != null) {
                  widget.property.rentalUnit = value;
                  setState(() {});
                }
              },
            ),

            const SizedBox(height: 12),

            CustomTextFormField(
              labelText: LocaleKeys.propertyFormPricingPriceLabel.tr(),
              hintText: LocaleKeys.propertyFormPricingPriceHint.tr(),
              type: CustomTextFormFieldType.number,
              initialValue: widget.property.price?.toString(),
              validator: (value) {
                if (value == null || value.isEmpty) return LocaleKeys.propertyFormPricingPriceRequired.tr();
                if (double.tryParse(value) == null) {
                  return LocaleKeys.propertyFormPricingPriceInvalid.tr();
                }
                return null;
              },
              onChanged: (value) {
                widget.property.price = double.tryParse(value);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
