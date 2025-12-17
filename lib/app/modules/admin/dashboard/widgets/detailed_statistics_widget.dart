import 'package:flutter/material.dart';
import 'package:mobile_eshop/app/constants/app_color.dart';
import 'package:mobile_eshop/app/modules/admin/dashboard/widgets/statistic_card.dart';
import '../../../../data/models/admin/dashboard_model.dart';

// statistic card sale ** 2  **

class DetailedStatisticsWidget extends StatelessWidget {
  final Statistic statistic;

  const DetailedStatisticsWidget({
    super.key,
    required this.statistic,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SingleChildScrollView( // ✅ FIX
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ================= HEADER =================
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded( // ✅ Prevent horizontal overflow
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Information Summary',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Overview of system statistics',
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ================= GRID =================
            _buildStatisticGrid(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticGrid(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: StatisticCard(
                imagePath: 'assets/images/packageblue.png',
                label: 'Product',
                labelColor: AppColors.error,
                value: statistic.totalProduct.toString(),
                iconColor: const Color(0xFF5C6BC0),
                backgroundColor: theme.colorScheme.surface,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: StatisticCard(
                imagePath: 'assets/images/packagegreen.png',
                label: 'Type',
                labelColor: AppColors.primary,
                value: statistic.totalProductType.toString(),
                iconColor: const Color(0xFF26A69A),
                backgroundColor: theme.colorScheme.surface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: StatisticCard(
                icon: Icons.people_outline,
                label: 'User',
                labelColor: AppColors.warningColor,
                value: statistic.totalUser.toString(),
                iconColor: const Color(0xFF66BB6A),
                backgroundColor: theme.colorScheme.surface,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: StatisticCard(
                icon: Icons.shopping_cart_outlined,
                label: 'Sale',
                labelColor: AppColors.accentColor,
                value: statistic.totalOrder.toString(),
                iconColor: const Color(0xFF42A5F5),
                backgroundColor: theme.colorScheme.surface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
