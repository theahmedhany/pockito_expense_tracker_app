import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: AppColors.kFontColor,
      style: TextStyle(
        color: AppColors.kFontColor,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: 24,
          top: 16,
          bottom: 16,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.kBlueColor,
          fontSize: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 2,
            color: AppColors.kBlueColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 2,
            color: AppColors.kBlueColor,
          ),
        ),
      ),
    );
  }
}
