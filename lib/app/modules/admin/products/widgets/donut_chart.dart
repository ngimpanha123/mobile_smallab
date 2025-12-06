import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../constants/app_font_size.dart';

class DonutChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const DonutChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("No chart data"));
    }

    final total = data.fold<double>(0, (sum, e) => sum + (e["count"] ?? 0));

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 60,
              startDegreeOffset: -90,
              sections: _buildSections(),
            ),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "${total.toInt()} កាលონს",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppFontSize.titleLarge,
          ),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: data.map((e) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _colorForIndex(data.indexOf(e)),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text("${e["name"]} (${e["count"]})"),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    return data.map((e) {
      final index = data.indexOf(e);
      final value = (e["count"] ?? 0).toDouble();

      return PieChartSectionData(
        color: _colorForIndex(index),
        value: value,
        radius: 45,
        title: "",
      );
    }).toList();
  }

  Color _colorForIndex(int i) {
    const palette = [
      Color(0xFF4CAF50),
      Color(0xFF66BB6A),
      Color(0xFF81C784),
      Color(0xFFA5D6A7),
      Color(0xFFB2FF59),
    ];
    return palette[i % palette.length];
  }
}
