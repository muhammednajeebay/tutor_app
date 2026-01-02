import 'package:flutter/material.dart';
import 'package:tutor_app/utils/const/app_colors.dart';
import 'package:tutor_app/utils/const/app_textstyles.dart';

class TextButtonCustom extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final TextStyle? textStyle;

  const TextButtonCustom({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        text,
        style:
            textStyle ??
            AppTextStyles.button.copyWith(
              color: textColor ?? AppColors.primary,
            ),
      ),
    );
  }
}
