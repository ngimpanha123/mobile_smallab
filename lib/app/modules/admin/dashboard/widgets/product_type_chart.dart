import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../constants/app_color.dart';
import '../../../../data/models/admin/dashboard_model.dart';

class ProductTypeChart extends StatelessWidget {
  final ProductTypeData productTypeData;

  const ProductTypeChart({
    super.key,
    required this.productTypeData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = productTypeData.data.fold<int>(0, (s, v) => s + v);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 16),

          /// ✅ SCROLLABLE CONTENT (CHART + LEGEND)
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildChart(theme, total),
                const SizedBox(height: 20),
                _buildLegend(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Product Types',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            Text(
              'This Month',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.calendar_today,
              size: 16,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ],
    );
  }

  // ================= CHART =================

  Widget _buildChart(ThemeData theme, int total) {
    return SizedBox(
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 80,
              startDegreeOffset: -90,
              sections: _buildSections(theme, total),
            ),
            swapAnimationDuration: const Duration(milliseconds: 900),
            swapAnimationCurve: Curves.easeOutCubic,
          ),

          /// CENTER TEXT
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                total.toString(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(
      ThemeData theme,
      int total,
      ) {
    if (total == 0) {
      return [
        PieChartSectionData(
          color: theme.dividerColor,
          value: 1,
          title: '0%',
          radius: 56,
          titleStyle: theme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ];
    }

    return productTypeData.data.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;
      final percentage = (value / total) * 100;

      return PieChartSectionData(
        color: _chartColors[index % _chartColors.length],
        value: value.toDouble(),
        radius: 56,
        title: '${percentage.toStringAsFixed(0)}%',
        titleStyle: theme.textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
  }

  // ================= LEGEND =================

  Widget _buildLegend(ThemeData theme) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: productTypeData.labels.asMap().entries.map((entry) {
        final index = entry.key;
        final label = entry.value;
        final value = productTypeData.data[index];

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _chartColors[index % _chartColors.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$label ($value)',
              style: theme.textTheme.bodySmall,
            ),
          ],
        );
      }).toList(),
    );
  }
}

// ================= COLORS =================

const List<Color> _chartColors = [
  Color(0xFF6C4DE6), // Purple
  Color(0xFF5B8DEF), // Blue
  Color(0xFFFFB020), // Orange
  Color(0xFF10B981), // Green
  Color(0xFFEF4444), // Red
  Color(0xFF9C27B0), // Violet
  Color(0xFF03A9F4), // Light Blue
  Color(0xFF795548), // Brown
];
