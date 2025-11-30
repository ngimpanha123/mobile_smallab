import 'package:flutter/material.dart';
import '../constants/app_widget_size.dart';

class ItemCardWidget extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showArrow;

  const ItemCardWidget({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 22, color: theme.colorScheme.primary),
                ),

              if (icon != null) const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              trailing ??
                  (showArrow
                      ? Icon(Icons.arrow_circle_right_outlined,
                      color: theme.colorScheme.onSurfaceVariant, size: AppWidgetSize.iconXS)
                      : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}