import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeriodSummaryWidget extends StatelessWidget {
  final double todayTotal;
  final double weekTotal;
  final double monthTotal;
  final double sixMonthsTotal;
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const PeriodSummaryWidget({
    Key? key,
    required this.todayTotal,
    required this.weekTotal,
    required this.monthTotal,
    required this.sixMonthsTotal,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              'Sales Summary by Period',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Period cards grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildPeriodCard(
                title: 'Today',
                amount: todayTotal,
                icon: Icons.today,
                color: const Color(0xFF4CAF50),
                period: 'today',
              ),
              _buildPeriodCard(
                title: 'This Week',
                amount: weekTotal,
                icon: Icons.calendar_view_week,
                color: const Color(0xFF2196F3),
                period: 'week',
              ),
              _buildPeriodCard(
                title: 'This Month',
                amount: monthTotal,
                icon: Icons.calendar_month,
                color: const Color(0xFFFF9800),
                period: 'month',
              ),
              _buildPeriodCard(
                title: '6 Months',
                amount: sixMonthsTotal,
                icon: Icons.date_range,
                color: const Color(0xFF9C27B0),
                period: '6months',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
    required String period,
  }) {
    final formatter = NumberFormat('#,##0', 'en_US');
    final isSelected = selectedPeriod == period;

    return InkWell(
      onTap: () => onPeriodChanged(period),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.15),
              spreadRadius: isSelected ? 2 : 1,
              blurRadius: isSelected ? 10 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header with icon and title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${formatter.format(amount)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Selected',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
