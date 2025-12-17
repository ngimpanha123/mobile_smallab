import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../constants/app_color.dart';
import '../../../../data/models/admin/dashboard_model.dart';

class SalesBarChart extends StatelessWidget {
  final SalesData salesData;

  const SalesBarChart({
    super.key,
    required this.salesData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          const SizedBox(height: 20),
          _buildBarChart(theme),
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
          'Sales Analytics',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            Text(
              'This Week',
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

  // ================= BAR CHART =================

  Widget _buildBarChart(ThemeData theme) {
    return SizedBox(
      height: 280,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxY(),
          barTouchData: _buildTouchData(theme),
          titlesData: _buildTitles(theme),
          gridData: _buildGrid(),
          borderData: FlBorderData(show: false),
          barGroups: _buildBarGroups(),
        ),
        swapAnimationDuration: const Duration(milliseconds: 900),
        swapAnimationCurve: Curves.easeOutCubic,
      ),
    );
  }

  // ================= TOUCH =================

  BarTouchData _buildTouchData(ThemeData theme) {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        tooltipPadding: const EdgeInsets.all(10),
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final formatter = NumberFormat('#,##0', 'en_US');
          return BarTooltipItem(
            '${salesData.labels[groupIndex]}\n',
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: formatter.format(rod.toY),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= TITLES =================

  FlTitlesData _buildTitles(ThemeData theme) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index >= 0 && index < salesData.labels.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _getKhmerDayAbbreviation(salesData.labels[index]),
                  style: theme.textTheme.labelSmall,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 44,
          getTitlesWidget: (value, meta) {
            if (value == 0) return const Text('0');
            final formatter = NumberFormat.compact();
            return Text(
              formatter.format(value),
              style: theme.textTheme.labelSmall,
            );
          },
        ),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  // ================= GRID =================

  FlGridData _buildGrid() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: _getMaxY() / 5,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey.withOpacity(0.25),
          strokeWidth: 1,
        );
      },
    );
  }

  // ================= BARS =================

  List<BarChartGroupData> _buildBarGroups() {
    return salesData.data.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            width: 22,
            color: _barColors[index % _barColors.length],
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      );
    }).toList();
  }

  // ================= HELPERS =================

  double _getMaxY() {
    final maxValue = salesData.data.reduce((a, b) => a > b ? a : b);
    if (maxValue == 0) return 100;
    return (maxValue / 5).ceilToDouble() * 20;
  }

  String _getKhmerDayAbbreviation(String day) {
    const map = {
      'Monday': 'M',
      'Tuesday': 'T',
      'Wednesday': 'W',
      'Thursday': 'TH',
      'Friday': 'F',
      'Saturday': 'SAT',
      'Sunday': 'S',
    };
    return map[day] ?? day.substring(0, 3);
  }
}

// ================= COLORS =================

const List<Color> _barColors = [
  Color(0xFF6366F1), // Indigo
  Color(0xFF22C55E), // Green
  Color(0xFF0EA5E9), // Sky
  Color(0xFFF59E0B), // Amber
  Color(0xFFEF4444), // Red
  Color(0xFF8B5CF6), // Purple
  Color(0xFF14B8A6), // Teal
];
