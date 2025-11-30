import 'package:flutter/material.dart';
import '../constants/app_color.dart';

class TitleTextWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  const TitleTextWidget({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      style: theme.titleMedium?.copyWith(
        color: color ?? AppColors.primary,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w600,
      ),
    );
  }
}