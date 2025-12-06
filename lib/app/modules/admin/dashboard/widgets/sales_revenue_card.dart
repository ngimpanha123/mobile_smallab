import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesRevenueCard extends StatelessWidget {
  final double total;
  final double percentageChange;
  final String saleIncreasePreviousDay;

  const SalesRevenueCard({
    Key? key,
    required this.total,
    required this.percentageChange,
    required this.saleIncreasePreviousDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPositive = percentageChange >= 0;
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
              Text(
                'កាលប៉ង់',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              Icon(
                Icons.calendar_today,
                size: 20,
                color: Colors.grey[600],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${formatter.format(total)} \$',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'លើកទីមុន៖ ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '${percentageChange.toStringAsFixed(2)} %',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '( ${formatter.format(double.tryParse(saleIncreasePreviousDay) ?? 0)} )',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'ប្រៀបធៀបថ្ងៃមុន',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
