import 'package:flutter/material.dart';

class TextFieldLogin extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final bool isPassword;

  const TextFieldLogin({
    Key? key,
    required this.labelText,
    required this.keyboardType,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: const Color(0x75292F36),
        labelStyle: const TextStyle(
            color: Colors.white), // Cambia el color del texto del label
        hintStyle: const TextStyle(
            color: Colors
                .white), // Cambia el color del texto de hint (cuando no hay texto)
      ),
      keyboardType: keyboardType,
      style: const TextStyle(
          color: Colors.white), // Cambia el color del texto del input
    );
  }
}
