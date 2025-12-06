import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../data/models/admin/dashboard_model.dart';


class ProductTypeChart extends StatelessWidget {
  final ProductTypeData productTypeData;

  const ProductTypeChart({
    Key? key,
    required this.productTypeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = productTypeData.data.fold<int>(0, (sum, value) => sum + value);

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
                'ប្រភេទផលិតផល',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    'ស្ថានភាព៖',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Donut Chart
          SizedBox(
            height: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 70,
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
                      total.toString(),
                      style: const TextStyle(
                        fontSize: 28,
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
            runSpacing: 12,
            children: productTypeData.labels.asMap().entries.map((entry) {
              final index = entry.key;
              final label = entry.value;
              final value = productTypeData.data[index];
              final color = _getColor(index);
              
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
                    '$label ($value)',
                    style: const TextStyle(fontSize: 13),
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
    final total = productTypeData.data.fold<int>(0, (sum, value) => sum + value);

    if (total == 0) {
      return [
        PieChartSectionData(
          color: Colors.grey[300],
          value: 100,
          title: '100%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ];
    }

    return productTypeData.data.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;
      final percentage = (value / total) * 100;

      return PieChartSectionData(
        color: _getColor(index),
        value: value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getColor(int index) {
    final colors = [
      const Color(0xFFCDDC39), // Lime - Food-Meat
      const Color(0xFF4CAF50), // Green - Alcohol
      const Color(0xFF81C784), // Light Green - Beverage
      const Color(0xFF2196F3), // Blue
    ];
    return colors[index % colors.length];
  }
}
