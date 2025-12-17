import 'package:flutter/material.dart';

import '../../../../constants/app_color.dart';

class StatisticCard extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final Color? labelColor; // ✅ nullable
  final String value;
  final String? subtitle;
  final Color iconColor;
  final Color backgroundColor;

  const StatisticCard({
    Key? key,
    this.icon,
    this.imagePath,
    required this.label,
    this.labelColor, // ✅ optional now
    required this.value,
    this.subtitle,
    this.iconColor = Colors.blue,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imagePath != null
                    ? Image.asset(
                  imagePath!,
                  width: 24,
                  height: 24,
                  color: iconColor,
                )
                    : Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const Spacer(),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: color_icon,
                    fontSize: 24,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // VALUE
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 4),

          // ✅ LABEL COLOR FALLBACK
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: labelColor ??
                  theme.textTheme.bodyMedium?.color ??
                  AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
