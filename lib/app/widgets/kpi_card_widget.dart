import 'package:flutter/material.dart';
import '../constants/app_color.dart';

enum KpiIconLayout { column, row }

class KpiItem {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final KpiIconLayout layout;

  KpiItem({
    required this.icon,
    required this.value,
    required this.label,
    this.color = AppColors.primary,
    this.layout = KpiIconLayout.column,
  });
}

class KpiCardWidget extends StatelessWidget {
  final List<List<KpiItem>> rows;
  final double spacing;
  final double iconSize;

  const KpiCardWidget({
    super.key,
    required this.rows,
    this.spacing = 24.0,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(
            rows.length, (rowIndex) {
              final rowItems = rows[rowIndex];
              return Padding(
                padding: EdgeInsets.only(bottom: rowIndex == rows.length - 1 ? 0 : spacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: rowItems.map((item) {
                      if (item.layout == KpiIconLayout.row) {
                        // Icon on left (row layout)
                        return Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 24.0,
                                backgroundColor: item.color.withOpacity(0.2),
                                child: Icon(item.icon, size: iconSize, color: item.color),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.value,
                                      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.label,
                                      style: textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).textTheme.bodySmall?.color),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Icon on top (column layout, default)
                        return Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 24.0,
                                backgroundColor: item.color.withOpacity(0.2),
                                child: Icon(item.icon, size: iconSize, color: item.color),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                item.value,
                                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                item.label,
                                style: textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).textTheme.bodySmall?.color),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ).toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}