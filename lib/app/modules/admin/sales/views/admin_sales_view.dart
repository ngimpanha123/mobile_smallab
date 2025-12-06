import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../controllers/admin_sales_controller.dart';

class AdminSalesView extends GetView<AdminSalesController> {
  const AdminSalesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshData(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: AppColors.errorColor),
                const SizedBox(height: 16),
                Text(controller.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchSales(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          child: Column(
            children: [
              _buildFilterChips(),
              _buildSalesStats(),
              Expanded(child: _buildSalesList()),
              _buildPagination(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFilterChips() {
    return Obx(() {
      final hasFilters = controller.selectedStartDate.value != null ||
          controller.selectedEndDate.value != null ||
          controller.selectedCashier.value != null ||
          controller.selectedPlatform.value != null;

      if (!hasFilters) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          border: Border(bottom: BorderSide(color: AppColors.darkBorder)),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (controller.selectedStartDate.value != null)
              _buildFilterChip(
                'From: ${DateFormat('dd MMM yyyy').format(controller.selectedStartDate.value!)}',
                    () => controller.applyFilters(startDate: null),
              ),
            if (controller.selectedEndDate.value != null)
              _buildFilterChip(
                'To: ${DateFormat('dd MMM yyyy').format(controller.selectedEndDate.value!)}',
                    () => controller.applyFilters(endDate: null),
              ),
            if (controller.selectedCashier.value != null)
              _buildFilterChip(
                'Cashier: ${controller.cashiers.firstWhere((c) => c.id == controller.selectedCashier.value, orElse: () => controller.cashiers.first).name}',
                    () => controller.applyFilters(cashierId: null),
              ),
            if (controller.selectedPlatform.value != null)
              _buildFilterChip(
                'Platform: ${controller.selectedPlatform.value}',
                    () => controller.applyFilters(platform: null),
              ),
            TextButton.icon(
              onPressed: () => controller.clearFilters(),
              icon: const Icon(Icons.clear_all, size: 16),
              label: const Text('Clear All'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.errorColor,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFilterChip(String label, VoidCallback onDeleted) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onDeleted,
      backgroundColor: AppColors.primaryColor.withOpacity(0.2),
      side: BorderSide(color: AppColors.primaryColor),
    );
  }

  Widget _buildSalesStats() {
    return Obx(() {
      final totalSales = controller.salesList.fold(0.0, (sum, sale) => sum + sale.totalPrice);
      final totalOrders = controller.salesList.length;

      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: AppColors.cardDecoration(),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                'Total Sales',
                '\$${controller.formatCurrency(totalSales)}',
                Icons.attach_money,
                AppColors.successColor,
              ),
            ),
            Container(width: 1, height: 40, color: AppColors.darkBorder),
            Expanded(
              child: _buildStatItem(
                'Total Orders',
                totalOrders.toString(),
                Icons.shopping_cart,
                AppColors.primary,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildSalesList() {
    return Obx(() {
      if (controller.salesList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long, size: 64, color: AppColors.textTertiary),
              const SizedBox(height: 16),
              Text('No sales found', style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.salesList.length,
        itemBuilder: (context, index) {
          final sale = controller.salesList[index];
          return _buildSaleCard(sale);
        },
      );
    });
  }

  Widget _buildSaleCard(sale) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppColors.cardDecoration(),
      child: InkWell(
        onTap: () => _showSaleDetails(sale),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '#${sale.receiptNumber}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildPlatformBadge(sale.platform),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      AppConfig.getImageUrl(sale.cashier.avatar),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    sale.cashier.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    '\$${controller.formatCurrency(sale.totalPrice)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.successColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text(
                    controller.formatDate(sale.orderedAt),
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const Spacer(),
                  Text(
                    '${sale.details.length} items',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformBadge(String platform) {
    Color color;
    IconData icon;

    switch (platform.toLowerCase()) {
      case 'web':
        color = AppColors.infoColor;
        icon = Icons.web;
        break;
      case 'mobile':
        color = AppColors.successColor;
        icon = Icons.phone_android;
        break;
      default:
        color = AppColors.textSecondary;
        icon = Icons.devices;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(platform, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Obx(() {
      final pagination = controller.pagination.value;
      if (pagination == null || pagination.totalPage <= 1) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          border: Border(top: BorderSide(color: AppColors.darkBorder)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Page ${controller.currentPage.value} of ${pagination.totalPage}',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: controller.currentPage.value > 1
                      ? () => controller.changePage(controller.currentPage.value - 1)
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: controller.currentPage.value < pagination.totalPage
                      ? () => controller.changePage(controller.currentPage.value + 1)
                      : null,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void _showFilterDialog() {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filter Sales', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              // Add filter options here
              const Text('Date Range, Cashier, Platform filters...'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      controller.fetchSales();
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSaleDetails(sale) {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Sale #${sale.receiptNumber}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: sale.details.length,
                  itemBuilder: (context, index) {
                    final detail = sale.details[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          AppConfig.getImageUrl(detail.product.image),
                        ),
                      ),
                      title: Text(detail.product.name),
                      subtitle: Text('${detail.qty} x \$${controller.formatCurrency(detail.unitPrice)}'),
                      trailing: Text(
                        '\$${controller.formatCurrency(detail.subtotal)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    '\$${controller.formatCurrency(sale.totalPrice)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.successColor,
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
