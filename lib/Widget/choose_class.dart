import 'package:flutter/material.dart';

class ChooseClass extends StatelessWidget {
  final String? selectedClass;
  final Function(String?)? onChange;
  final double? width;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final String? hintText;
  final Widget? prefixIcon;
  final Color? fillColor;
  final Color? focusBorderColor;
  final bool hidePassword;
  final Widget? suffixIcon;
  final Color? errorBorderColor;
  final Color? suffixIconColor;
  final TextInputType? keyboardType;
  final String? labelText;
  final Color? labelColor;
  final Color? dropdownTextColor;
  final Color? dropdownBackgroundColor; // Background color for dropdown

  const ChooseClass({
    super.key,
    required this.selectedClass,
    required this.onChange,
    this.width,
    this.controller,
    this.validate,
    this.hintText,
    this.prefixIcon,
    this.fillColor,
    this.focusBorderColor,
    this.hidePassword = false,
    this.suffixIcon,
    this.errorBorderColor,
    this.suffixIconColor,
    this.keyboardType,
    this.labelText,
    this.labelColor,
    this.dropdownTextColor,
    this.dropdownBackgroundColor, // Field for dropdown background
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          labelStyle: TextStyle(color: labelColor),
          hintText: hintText,
          filled: true,
          fillColor: fillColor,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              borderSide: BorderSide(
                width: 2.0,
                style: BorderStyle.solid,
                strokeAlign: BorderSide.strokeAlignOutside,
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
            borderSide: BorderSide(
              color: focusBorderColor ?? Colors.blue,
              width: 2.0,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
            borderSide: BorderSide(
              color: errorBorderColor ?? Colors.red,
              width: 2.0,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          labelText: labelText ?? 'Class',
        ),
        value: selectedClass,
        dropdownColor: dropdownBackgroundColor ?? Colors.white, // Dropdown background color
        items: ['3', '4', '5', '6', '7', '8', '9', '10', '11', '12']
            .map((classValue) => DropdownMenuItem(
                  value: classValue,
                  child: Text(
                    classValue,
                    style: TextStyle(color: dropdownTextColor), // Dropdown text color
                  ),
                ))
            .toList(),
        onChanged: onChange,
        validator: (value) =>
            value == null ? 'Please select a class' : null,
      ),
    );
  }
}
