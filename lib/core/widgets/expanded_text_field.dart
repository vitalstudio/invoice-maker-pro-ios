import 'package:flutter/material.dart';
import '../../core/constants/color/color.dart';

class ExpandedTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final int? minLines;
  final int? maxLength;

  const ExpandedTextField({super.key,
    this.maxLength,
    this.hintText,
    this.textEditingController,
    this.textInputType,
    this.minLines,
    this.textInputAction});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      style: const TextStyle(
        color: grey_1,
      ),

      minLines: minLines,
      maxLines: null,
      maxLength: maxLength,
      expands: true,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        hintText: hintText,
        hintStyle: const TextStyle(
            fontStyle: FontStyle.normal
        ),
        filled: true,
        fillColor: textFieldColor,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
        ),

      ),
    );
  }
}
