import 'package:expy/common/color_extension.dart';
import 'package:flutter/material.dart';

class TextFieldl extends StatelessWidget {
  final String type;
  final TextInputType keyboardType;
  final bool obscured;
  final TextEditingController? controller;

  const TextFieldl(
      {super.key,
      required this.type,
      required this.keyboardType,
      required this.obscured,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align children to the start (left)
      children: [
        Text(
          "   $type",
          style: TextStyle(color: TColor.gray50, fontSize: 14),
        ),
        const SizedBox(
            height: 8), // Add some space between the label and the text field
        Container(
          height: 58,
          width: double.infinity,
          decoration: BoxDecoration(
            color: TColor.gray60.withValues(alpha: 0.05),
            border: Border.all(color: TColor.gray70),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(color: TColor.gray50),
            obscureText: obscured,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
