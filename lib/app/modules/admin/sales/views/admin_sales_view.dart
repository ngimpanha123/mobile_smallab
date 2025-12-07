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
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Sales Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, size: 26),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 26),
            onPressed: () => controller.refreshData(),
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return _buildErrorState();
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

  // ---------------------------------------------------------------------------
  // ERROR STATE
  // ---------------------------------------------------------------------------
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(controller.errorMessage.value,
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.fetchSales(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FILTER CHIPS
  // ---------------------------------------------------------------------------
  Widget _buildFilterChips() {
    return Obx(() {
      final hasFilters =
          controller.selectedStartDate.value != null ||
              controller.selectedEndDate.value != null ||
              controller.selectedCashier.value != null ||
              controller.selectedPlatform.value != null;

      if (!hasFilters) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
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
              // _buildFilterChip(
              //   'Cashier: ${controller.selectedCashierName}',
              //       () => controller.applyFilters(cashierId: null),
              // ),
            if (controller.selectedPlatform.value != null)
              _buildFilterChip(
                'Platform: ${controller.selectedPlatform.value}',
                    () => controller.applyFilters(platform: null),
              ),

            // CLEAR ALL
            TextButton.icon(
              onPressed: () => controller.clearFilters(),
              icon: const Icon(Icons.clear_all, size: 16),
              label: const Text("Clear All"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFilterChip(String label, VoidCallback onDeleted) {
    return Chip(
      labelPadding: const EdgeInsets.only(left: 10, right: 4),
      backgroundColor: AppColors.primary.withOpacity(0.12),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onDeleted,
      shape: StadiumBorder(
        side: BorderSide(color: AppColors.primary),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STATISTICS (TOP SUMMARY)
  // ---------------------------------------------------------------------------
  Widget _buildSalesStats() {
    return Obx(() {
      final totalSales =
      controller.salesList.fold(0.0, (sum, sale) => sum + sale.totalPrice);

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(18),
        decoration: AppColors.cardDecoration(),
        child: Row(
          children: [
            Expanded(
              child: _buildStatTile(
                label: "Total Sales",
                value: "\$${controller.formatCurrency(totalSales)}",
                icon: Icons.monetization_on,
                color: AppColors.success,
              ),
            ),
            Container(width: 1, height: 50, color: Colors.grey.shade300),
            Expanded(
              child: _buildStatTile(
                label: "Orders",
                value: controller.salesList.length.toString(),
                icon: Icons.receipt_long,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatTile({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SALES LIST
  // ---------------------------------------------------------------------------
  Widget _buildSalesList() {
    return Obx(() {
      if (controller.salesList.isEmpty) {
        return Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Icon(Icons.receipt_long, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text("No sales found",
                  style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: controller.salesList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          return _buildSaleCard(controller.salesList[index]);
        },
      );
    });
  }

  // ---------------------------------------------------------------------------
  // SALE CARD UI (Premium UI)
  // ---------------------------------------------------------------------------
  Widget _buildSaleCard(sale) {
    return Container(
      decoration: AppColors.cardDecoration(),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showSaleDetails(sale),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // RECEIPT NUMBER + PLATFORM BADGE
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primary.withOpacity(0.6)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "#${sale.receiptNumber}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildPlatformBadge(sale.platform),
                ],
              ),

              const SizedBox(height: 14),

              // CASHIER AVATAR + NAME + TOTAL PRICE
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      AppConfig.getImageUrl(sale.cashier.avatar),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    sale.cashier.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "\$${controller.formatCurrency(sale.totalPrice)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // TIME + ITEMS COUNT
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    controller.formatDate(sale.orderedAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const Spacer(),
                  Text(
                    "${sale.details.length} items",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PLATFORM BADGE
  // ---------------------------------------------------------------------------
  Widget _buildPlatformBadge(String platform) {
    final p = platform.toLowerCase();
    Color color = Colors.grey;
    IconData icon = Icons.devices;

    if (p == "web") {
      color = AppColors.infoColor;
      icon = Icons.language;
    } else if (p == "mobile") {
      color = AppColors.success;
      icon = Icons.phone_android;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            platform,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PAGINATION BAR
  // ---------------------------------------------------------------------------
  Widget _buildPagination() {
    return Obx(() {
      final p = controller.pagination.value;
      if (p == null || p.totalPage <= 1) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Page ${controller.currentPage.value} of ${p.totalPage}",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: controller.currentPage.value > 1
                      ? () => controller.changePage(controller.currentPage.value - 1)
                      : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                IconButton(
                  onPressed: controller.currentPage.value < p.totalPage
                      ? () => controller.changePage(controller.currentPage.value + 1)
                      : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // SALE DETAILS DIALOG
  // ---------------------------------------------------------------------------
  void _showSaleDetails(sale) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(22),
          width: 450,
          constraints: const BoxConstraints(maxHeight: 600),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  Text(
                    "Sale #${sale.receiptNumber}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),

              const Divider(height: 20),

              // ITEMS LIST
              Expanded(
                child: ListView.separated(
                  itemCount: sale.details.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (_, index) {
                    final d = sale.details[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          AppConfig.getImageUrl(d.product.image),
                        ),
                      ),
                      title: Text(d.product.name),
                      subtitle: Text(
                        "${d.qty} × \$${controller.formatCurrency(d.unitPrice)}",
                        style: const TextStyle(fontSize: 13),
                      ),
                      trailing: Text(
                        "\$${controller.formatCurrency(d.subtotal)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Divider(),

              // TOTAL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "TOTAL",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${controller.formatCurrency(sale.totalPrice)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FILTER DIALOG
  // ---------------------------------------------------------------------------
  void _showFilterDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Filter Sales",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 24),
              const Text("Date Range, Cashier, Platform filters..."),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      controller.fetchSales();
                    },
                    child: const Text("Apply"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
