import 'package:flutter/material.dart';

class Textbox extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  const Textbox({
    super.key,
    required this.prefixIcon,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    return Container(
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // 圓角設定
          ),
          prefixIcon: Icon(prefixIcon),
          hintText: hintText,
          hintStyle: TextStyle(color: primary),
          contentPadding: EdgeInsets.symmetric(vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class sso_btn extends StatelessWidget {
  final String imgPath;
  const sso_btn({super.key, required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
      ),
      child: Image.asset(
        imgPath,
        height: 30,
      ),
    );
  }
}
