import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/admin/dashboard_model.dart';

class CashierPerformanceChart extends StatelessWidget {
  final List<CashierInfo> cashiers;

  const CashierPerformanceChart({
    Key? key,
    required this.cashiers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = cashiers.fold<double>(
      0,
      (sum, cashier) => sum + cashier.totalAmount,
    );
    
    final formatter = NumberFormat('#,##0', 'en_US');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'អ្នកគិតប្រាក់',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.more_horiz, color: Colors.grey[600]),
            ],
          ),
          const SizedBox(height: 24),
          // Gauge Chart
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: 180,
                    sectionsSpace: 2,
                    centerSpaceRadius: 80,
                    sections: _buildPieChartSections(),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatter.format(total),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: cashiers.asMap().entries.map((entry) {
              final cashier = entry.value;
              final color = _getColor(entry.key);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${cashier.name} (${formatter.format(cashier.totalAmount)})',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final total = cashiers.fold<double>(
      0,
      (sum, cashier) => sum + cashier.totalAmount,
    );

    if (total == 0) {
      return [
        PieChartSectionData(
          color: Colors.grey[300],
          value: 100,
          title: '100%',
          radius: 40,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ];
    }

    return cashiers.asMap().entries.map((entry) {
      final index = entry.key;
      final cashier = entry.value;
      final percentage = (cashier.totalAmount / total) * 100;

      return PieChartSectionData(
        color: _getColor(index),
        value: cashier.totalAmount,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 40,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getColor(int index) {
    final colors = [
      const Color(0xFFa3e635), // Lime
      const Color(0xFF16a34a), // Green
      const Color(0xFFd9f99d), // Grey
      const Color(0xFF86efac), // Blue
    ];
    return colors[index % colors.length];
  }
}
