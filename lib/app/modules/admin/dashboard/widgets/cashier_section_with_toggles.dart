import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../constants/app_widget_size.dart';
import '../../../../data/models/admin/dashboard_model.dart';
import '../controllers/admin_dashboard_controller.dart';

const List<Color> _gaugeColors = [
  Color(0xFFA3E635), // Lime
  Color(0xFF22C55E), // Green
  Color(0xFF86EFAC), // Mint
  Color(0xFF4ADE80), // Light Green
];


class CashierSectionWithToggles extends GetView<DashboardController> {
  final List<CashierInfo> cashiers;


  const CashierSectionWithToggles({
    super.key,
    required this.cashiers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(AppSpacing.paddingL),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: AppSpacing.paddingL),
          Obx(() => _buildContent(context)),
        ],
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Users',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppSpacing.paddingXS),
            Text(
              'Summaries of all users',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const Spacer(),
        _buildToggleGroup(context),
      ],
    );
  }

  // ================= TOGGLE GROUP =================

  Widget _buildToggleGroup(BuildContext context) {
    return Row(
      children: [
        Obx(() => _buildToggleButton(
          context,
          icon: Icons.format_list_bulleted,
          isActive: controller.cashierListView.value,
          onTap: controller.showCashierListView,
        )),
        SizedBox(width: AppSpacing.paddingXS),
        Obx(() => _buildToggleButton(
          context,
          icon: Icons.pie_chart_outline,
          isActive: controller.cashierChartView.value,
          onTap: controller.showCashierChartView,
        )),
        SizedBox(width: AppSpacing.paddingXS),
        Obx(() => _buildToggleButton(
          context,
          icon: Icons.bar_chart,
          isActive: controller.cashierBarView.value,
          onTap: controller.showCashierBarView,
        )),
      ],
    );
  }

  Widget _buildToggleButton(
      BuildContext context, {
        required IconData icon,
        required bool isActive,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(AppSpacing.paddingS),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: AppWidgetSize.iconSM,
          color: isActive
              ? AppColors.primary
              : AppColors.iconColor,
        ),
      ),
    );
  }

  // ================= CONTENT =================

  Widget _buildContent(BuildContext context) {
    if (cashiers.isEmpty) {
      return _buildNoData(context);
    }

    if (controller.cashierListView.value) {
      return _buildListView(context);
    }

    if (controller.cashierChartView.value) {
      return _buildChartView(context);
    }

    return _buildBarView(context);
  }

  // ================= LIST VIEW =================

  Widget _buildListView(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 280,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: cashiers.length,
        itemBuilder: (context, index) {
          final cashier = cashiers[index];

          return Container(
            margin: EdgeInsets.only(bottom: AppSpacing.paddingXS),
            padding: EdgeInsets.all(AppSpacing.paddingXS),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.dividerColor.withOpacity(0.6),
              ),
            ),
            child: Row(
              children: [
                /// Avatar
                CircleAvatar(
                  radius: AppWidgetSize.imageSmall / 2,
                  backgroundColor:
                  AppColors.primary.withOpacity(0.15),
                  backgroundImage: cashier.avatar.isNotEmpty
                      ? NetworkImage(
                    AppConfig.getImageUrl(cashier.avatar),
                  )
                      : null,
                  child: cashier.avatar.isEmpty
                      ? Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: AppWidgetSize.iconSM,
                  )
                      : null,
                ),

                SizedBox(width: AppSpacing.paddingM),

                /// Name + Role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cashier.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (cashier.role.isNotEmpty &&
                          cashier.role.first.role.name.isNotEmpty)
                        Text(
                          cashier.role.first.role.name,
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),

                /// Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${cashier.totalAmount.toStringAsFixed(0)} ៛',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${cashier.percentageChange}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cashier.percentageChange.startsWith('-')
                            ? AppColors.error
                            : AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }




  // ================= PIE VIEW =================

  Widget _buildChartView(BuildContext context) {
    final theme = Theme.of(context);

    final total = cashiers.fold<double>(
      0,
          (sum, c) => sum + c.totalAmount,
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, progress, _) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              /// ================= SEMI DONUT =================
              SizedBox(
                height: 160,
                width: 260,
                child: CustomPaint(
                  painter: _SemiDonutPainter(
                    values: cashiers.map((e) => e.totalAmount).toList(),
                    total: total,
                    progress: progress,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// ================= CENTER TEXT =================
              Column(
                children: [
                  Text(
                    NumberFormat('#,##0').format(total),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Total Sales',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// ================= LEGEND =================
              _buildChartLegend(context),

              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChartLegend(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: cashiers.asMap().entries.map((entry) {
        final index = entry.key;
        final cashier = entry.value;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _gaugeColors[index % _gaugeColors.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${cashier.name} (${cashier.totalAmount.toStringAsFixed(0)})',
              style: theme.textTheme.labelSmall,
            ),
          ],
        );
      }).toList(),
    );
  }



  // ================= BAR VIEW =================

  Widget _buildBarView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 200,
          child: _buildBarChart(context),
        ),
        SizedBox(height: AppSpacing.paddingM),
        _buildBarLegend(context),
      ],
    );
  }

  Widget _buildBarChart(BuildContext context) {
    final theme = Theme.of(context);

    final maxValue =
    cashiers.map((c) => c.totalAmount).fold<double>(1, max);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, progress, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: cashiers.map((cashier) {
                final barHeight =
                    (cashier.totalAmount / maxValue) * 140 * progress;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /// VALUE
                      Text(
                        cashier.totalAmount.toStringAsFixed(0),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),

                      /// BAR
                      Container(
                        width: 28,
                        height: barHeight < 6 ? 6 : barHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// NAME
                      SizedBox(
                        width: 64,
                        child: Text(
                          cashier.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBarLegend(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.6),
              ],
            ),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: AppSpacing.paddingXS),
        Text(
          'Sales Amount',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  // ================= NO DATA =================

  Widget _buildNoData(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: AppWidgetSize.iconXL,
            color: theme.disabledColor,
          ),
          SizedBox(height: AppSpacing.paddingS),
          Text(
            'គ្មានទិន្នន័យ',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }


}

class _SemiDonutPainter extends CustomPainter {
  final List<double> values;
  final double total;
  final double progress;

  _SemiDonutPainter({
    required this.values,
    required this.total,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.height * 0.9; // NOT width
    const strokeWidth = 25.0;         // thinner stroke

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = pi; // 180°

    for (int i = 0; i < values.length; i++) {
      final value = values[i];
      if (value <= 0 || total == 0) continue;

      final sweepAngle =
          (value / total) * pi * progress;

      paint.color = _gaugeColors[i % _gaugeColors.length];

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius - strokeWidth / 2,
        ),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
