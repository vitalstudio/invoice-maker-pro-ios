import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/color/color.dart';

class CommonTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatter;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  final bool? autoFocus;
  final FocusNode? focusNode;

  const CommonTextField({super.key,
    this.maxLength,
    this.maxLines,
    this.hintText,
    this.textEditingController,
    this.textInputType,
    this.textInputAction,
    this.inputFormatter,
    this.onChanged,
    this.validator,
    this.errorText,
    this.focusNode,
    this.autoFocus  = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      focusNode: focusNode,
      style: const TextStyle(
        color: grey_1,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w500
      ),
      minLines: 1,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatter,
      onChanged: onChanged,
      validator: validator,
      autofocus: autoFocus!,
      decoration: InputDecoration(
          errorText: errorText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 15
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
