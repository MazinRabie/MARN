import 'package:MARN/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OtpFields extends StatefulWidget {
  const OtpFields({super.key, required this.onCodeChanged});

  final Function(String) onCodeChanged;

  @override
  State<OtpFields> createState() => _OtpFieldsState();
}

class _OtpFieldsState extends State<OtpFields> {
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> code = ["", "", "", "", "", ""];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        6,
        (index) => SizedBox(
          width: 40,
          height: 70,
          child: TextField(
            focusNode: focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(context).requestFocus(focusNodes[index + 1]);
              }
              code[index] = value;
              widget.onCodeChanged(code.join());
            },
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: AppColors.primary.withAlpha(30),
              border: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
