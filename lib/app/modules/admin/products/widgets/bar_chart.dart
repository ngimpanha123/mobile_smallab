import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';

class BarChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const BarChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("No chart data"));
    }

    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _bottomTitle,
                reservedSize: 36,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1000,
                getTitlesWidget: (value, meta) =>
                    Text("${value.toInt()}",
                        style: TextStyle(fontSize: AppFontSize.labelSmall)),
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: _buildBars(),
          maxY: _getMaxY(),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBars() {
    return data.map((e) {
      final index = data.indexOf(e);
      final value = (e["value"] ?? 0).toDouble();

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            width: 18,
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  double _getMaxY() {
    final maxVal =
    data.fold<double>(0, (max, e) => e["value"] > max ? e["value"] : max);
    return (maxVal + 1000).toDouble();
  }

  Widget _bottomTitle(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= data.length) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        data[index]["label"] ?? "",
        style: TextStyle(
          fontSize: AppFontSize.labelSmall,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
