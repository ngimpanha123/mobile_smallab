import 'package:flutter/material.dart';
import 'package:mobile_eshop/app/modules/admin/dashboard/widgets/statistic_card.dart';
import '../../../../data/models/admin/dashboard_model.dart';



class DetailedStatisticsWidget extends StatelessWidget {
  final Statistic statistic;

  const DetailedStatisticsWidget({
    Key? key,
    required this.statistic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
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
          const Text(
            'សង្ខេបរបស់',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // ✅ Statistics Grid (2x2 layout)
          Row(
            children: [
              Expanded(
                child: StatisticCard(
                  imagePath: 'assets/images/packageblue.png',
                  //icon: Icons.inventory_2_outlined,
                  label: 'ផលិតផល',
                  value: statistic.totalProduct.toString(),
                  iconColor: const Color(0xFF5C6BC0),
                  backgroundColor: Colors.grey[50]!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatisticCard(
                  imagePath: 'assets/images/packagegreen.png',
                  //icon: Icons.category_outlined,
                  label: 'ប្រភេទ',
                  value: statistic.totalProductType.toString(),
                  iconColor: const Color(0xFF26A69A),
                  backgroundColor: Colors.grey[50]!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatisticCard(
                  icon: Icons.people_outline,
                  label: 'អ្នកប្រើប្រាស់',
                  value: statistic.totalUser.toString(),
                  iconColor: const Color(0xFF66BB6A),
                  backgroundColor: Colors.grey[50]!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatisticCard(
                  icon: Icons.shopping_cart_outlined,
                  label: 'ការលក់',
                  value: statistic.totalOrder.toString(),
                  iconColor: const Color(0xFF42A5F5),
                  backgroundColor: Colors.grey[50]!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
