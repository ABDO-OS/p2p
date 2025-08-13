import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  const Textfield({
    super.key,
    required this.controller,
    required this.hinttext,
    this.ispassword = false,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String hinttext;
  final bool ispassword;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        controller: controller,
        obscureText: ispassword,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 229, 229, 229),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 229, 229, 229),
              width: 1.5,
            ),
          ),
          suffixIcon: ispassword ? PasswordEye() : null,
        ),
      ),
    );
  }
}

class PasswordEye extends StatefulWidget {
  const PasswordEye({super.key});

  @override
  State<PasswordEye> createState() => _PasswordEyeState();
}

class _PasswordEyeState extends State<PasswordEye> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }
}
