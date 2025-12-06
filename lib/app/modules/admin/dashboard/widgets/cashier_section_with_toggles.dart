import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/admin/dashboard_model.dart';
import '../controllers/admin_dashboard_controller.dart';

class CashierSectionWithToggles extends GetView<DashboardController> {
  final List<CashierInfo> cashiers;

  const CashierSectionWithToggles({
    Key? key,
    required this.cashiers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          // Header with toggles
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
              // View toggles
              Row(
                children: [
                  Obx(() => _buildToggleButton(
                        icon: Icons.format_list_bulleted,
                        isActive: controller.cashierListView.value,
                        onTap: controller.showCashierListView,
                      )),
                  const SizedBox(width: 8),
                  Obx(() => _buildToggleButton(
                        icon: Icons.pie_chart_outline,
                        isActive: controller.cashierChartView.value,
                        onTap: controller.showCashierChartView,
                      )),
                  const SizedBox(width: 8),
                  Obx(() => _buildToggleButton(
                        icon: Icons.bar_chart,
                        isActive: controller.cashierBarView.value,
                        onTap: controller.showCashierBarView,
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Content based on selected view
          Obx(() {
            if (cashiers.isEmpty) {
              return _buildNoDataWidget();
            }

            if (controller.cashierListView.value) {
              return _buildListView();
            } else if (controller.cashierChartView.value) {
              return _buildChartView();
            } else if (controller.cashierBarView.value) {
              return _buildBarView();
            }

            return _buildListView(); // Default
          }),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF1F5F9) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? const Color(0xFF64748b) : Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: cashiers.length > 3 ? 3 : cashiers.length,
        itemBuilder: (context, index) {
          final cashier = cashiers[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: index % 2 == 0
                  ? const Color(0xFFF1F5F9)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF3B82F6),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22.5),
                    child: cashier.avatar.isNotEmpty
                        ? Image.network(
                            'http://localhost:9055/uploads/${cashier.avatar}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.person),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // Name and role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cashier.name,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF64748b),
                        ),
                      ),
                      if (cashier.role.isNotEmpty)
                        Text(
                          cashier.role[0].role.name,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94a3b8),
                          ),
                        ),
                    ],
                  ),
                ),
                // Amount and percentage
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${cashier.totalAmount.toStringAsFixed(0)} ៛',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '(${cashier.percentageChange}%)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF10b981),
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

  Widget _buildChartView() {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: _buildPieChart(),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: _buildChartLegend(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarView() {
    return SizedBox(
      height: 280,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: _buildBarChart(),
          ),
          const SizedBox(height: 16),
          _buildBarLegend(),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    final total = cashiers.fold<double>(
      0,
      (sum, cashier) => sum + cashier.totalAmount,
    );
    
    return Stack(
      alignment: Alignment.center,
      children: [
        // Placeholder for pie chart - you'll need fl_chart implementation
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[100],
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
              total.toStringAsFixed(0),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartLegend() {
    return Wrap(
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
              '${cashier.name} (${cashier.totalAmount.toStringAsFixed(0)})',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildBarChart() {
    if (cashiers.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    final maxValue = cashiers
        .map((c) => c.totalAmount)
        .reduce((a, b) => a > b ? a : b)
        .clamp(1.0, double.infinity);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight - 40;
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: cashiers.asMap().entries.map((entry) {
              final cashier = entry.value;
              final rawHeight = (cashier.totalAmount / maxValue) * availableHeight * 0.7;
              final height = rawHeight.isFinite && rawHeight > 0 ? rawHeight : 10.0;
              
              return Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: height,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3D5AFE),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 60,
                        child: Text(
                          cashier.name.length > 8
                              ? '${cashier.name.substring(0, 8)}...'
                              : cashier.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildBarLegend() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFF3D5AFE),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'ចំនួនលក់',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748b),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(int index) {
    final colors = [
      const Color(0xFFa3e635), // Lime
      const Color(0xFF16a34a), // Green
      const Color(0xFFd9f99d), // Light green
      const Color(0xFF86efac), // Mint
    ];
    return colors[index % colors.length];
  }

  Widget _buildNoDataWidget() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'គ្មានទិន្នន័យ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
