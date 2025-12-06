import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OverallSalesSummaryWidget extends StatelessWidget {
  final double total;
  final double percentageChange;
  final String saleIncreasePreviousDay;
  final VoidCallback onDatePickerTap;

  const OverallSalesSummaryWidget({
    Key? key,
    required this.total,
    required this.percentageChange,
    required this.saleIncreasePreviousDay,
    required this.onDatePickerTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPositive = percentageChange >= 0;
    final formatter = NumberFormat('#,##0', 'en_US');
    final changeAmount = double.tryParse(saleIncreasePreviousDay) ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and date picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Sell',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              InkWell(
                onTap: onDatePickerTap,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Color(0xFF5C6BC0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),

          // Total amount
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${formatter.format(total)} \$',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          ),


          const SizedBox(height: 50),

          // Percentage change indicator
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Last time Sale Increase៖ ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                TextSpan(
                  text: '${percentageChange.toStringAsFixed(2)} %',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
                TextSpan(
                  text: ' ( ${formatter.format(changeAmount)} )',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
                TextSpan(
                  text: ' Compare the previous day',
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
