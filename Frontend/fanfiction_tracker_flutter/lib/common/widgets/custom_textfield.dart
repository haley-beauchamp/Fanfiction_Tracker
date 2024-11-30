import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isRequired;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
      ),
      minLines: 1,
      maxLines: null,
      validator: (val) {
        if ((val == null || val.isEmpty) && isRequired) {
          return 'Enter your $hintText';
        } 
        return null;
      },
    );
  }
}
