import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/admin_sales_controller.dart';

class AdminSalesView extends GetView<AdminSalesController> {
  const AdminSalesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkTextPrimary,
      appBar: AppBar(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
        backgroundColor: AppColors.darkTextPrimary,
        centerTitle: false,

        title: const Text(
          'Sales Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.primary,
          ),
        ),

        actions: [
          // FILTER BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: _showFilterDialog,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.filter_list,
                  size: 22,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          // REFRESH BUTTON
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: controller.refreshData,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.refresh,
                  size: 22,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),


      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return _errorState();
        }

        return Column(
          children: [
            _salesSummary(),
            Expanded(child: _salesList()),
            _paginationBar(),
          ],
        );
      }),
    );
  }

  // ===========================================================================
  // ERROR
  // ===========================================================================
  Widget _errorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.errorColor),
          const SizedBox(height: 16),
          Text(controller.errorMessage.value),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.fetchSales,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
// SALES SUMMARY (PRIMARY BACKGROUND)
// ===========================================================================
  Widget _salesSummary() {
    final totalSales = controller.salesList.fold<double>(
      0,
          (sum, s) => sum + s.totalPrice,
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary, // ✅ PRIMARY BACKGROUND
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _summaryItem(
            title: 'Total Orders',
            value: controller.salesList.length.toString(),
            icon: Icons.receipt_long,
          ),
          const Spacer(),
          _summaryItem(
            title: 'Total Sales',
            value: '\$${controller.formatCurrency(totalSales)}',
            icon: Icons.payments,
          ),
        ],
      ),
    );
  }

// ===========================================================================
// SUMMARY ITEM
// ===========================================================================
  Widget _summaryItem({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.85),
          ),
        ),
      ],
    );
  }


  // ===========================================================================
  // SALES LIST
  // ===========================================================================
  Widget _salesList() {
    return Obx(() {
      if (controller.salesList.isEmpty) {
        return const Center(child: Text('No sales found'));
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.salesList.length,
        itemBuilder: (_, i) => _saleCard(controller.salesList[i]),
      );
    });
  }

  // ===========================================================================
  // SALE CARD
  // ===========================================================================
  Widget _saleCard(sale) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppColors.cardDecoration(),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openActionSheet(sale),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // RECEIPT + PLATFORM
              Row(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '#${sale.receiptNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkTextPrimary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _platformBadge(sale.platform),
                ],
              ),

              const SizedBox(height: 10),

              // CASHIER + TOTAL
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage:
                    NetworkImage(AppConfig.getImageUrl(sale.cashier.avatar)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      sale.cashier.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
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

              const SizedBox(height: 6),

              // TIME + ITEMS
              Row(
                children: [
                  Icon(Icons.access_time,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    controller.formatDate(sale.orderedAt),
                    style:
                    TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const Spacer(),
                  Text(
                    '${sale.details.length} items',
                    style:
                    TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // ACTION BOTTOM SHEET
  // ===========================================================================
  void _openActionSheet(sale) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.darkTextPrimary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetHandle(),

              _sheetItem(
                icon: Icons.visibility,
                title: 'View Sale Detail',
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.SALE_DETAIL, arguments: sale.id);
                },
              ),

              // _sheetItem(
              //   icon: Icons.picture_as_pdf,
              //   title: 'View Receipt',
              //   onTap: () async {
              //     Get.back();
              //     final pdf =
              //     await controller.getOrderInvoice(sale.receiptNumber);
              //     if (pdf != null) {
              //       _openPdfPreview(pdf, sale.receiptNumber);
              //     }
              //   },
              // ),

              _sheetItem(
                icon: Icons.delete,
                title: 'Delete Sale',
                color: AppColors.errorColor,
                onTap: () {
                  Get.back();
                  _confirmDelete(sale.id);
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  // ===========================================================================
  // PAGINATION BAR
  // ===========================================================================
  Widget _paginationBar() {
    return Obx(() {
      final p = controller.pagination.value;
      if (p == null || p.totalPage <= 1) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.darkTextPrimary,
          border: Border(top: BorderSide(color: AppColors.primary, width: 0)),
        ),
        child: Row(
          children: [
            Text(
              'Page ${controller.currentPage.value} / ${p.totalPage}',
              style: TextStyle(color: AppColors.primary, fontSize: 14),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: controller.currentPage.value > 1
                  ? () => controller.changePage(
                controller.currentPage.value - 1,
              )
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: controller.currentPage.value < p.totalPage
                  ? () => controller.changePage(
                controller.currentPage.value + 1,
              )
                  : null,
            ),
          ],
        ),
      );
    });
  }


  // ===========================================================================
  // HELPERS
  // ===========================================================================
  Widget _sheetItem({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    final c = color ?? AppColors.primaryColor;
    return ListTile(
      leading: Icon(icon, color: c),
      title: Text(title,
          style: TextStyle(color: c, fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }

  Widget _sheetHandle() {
    return Container(
      width: 40,
      height: 5,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade600,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _platformBadge(String platform) {
    final p = platform.toLowerCase();
    final isWeb = p == 'web';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isWeb
            ? AppColors.infoColor
            : AppColors.successColor)
            .withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(
            isWeb ? Icons.language : Icons.phone_android,
            size: 12,
            color:
            isWeb ? AppColors.infoColor : AppColors.successColor,
          ),
          const SizedBox(width: 4),
          Text(
            platform,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isWeb
                  ? AppColors.infoColor
                  : AppColors.successColor,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // DELETE
  // ===========================================================================
  void _confirmDelete(int id) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Sale'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
            ),
            onPressed: () async {
              Get.back();
              await controller.deleteSale(id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PDF PREVIEW (TEMP)
  // ===========================================================================
  void _openPdfPreview(String base64Pdf, String receipt) {
    final bytes = base64Decode(base64Pdf);
    Get.to(
          () => Scaffold(
        appBar: AppBar(title: Text('Receipt #$receipt')),
        body: Center(
          child: Text(
            'PDF Loaded (${bytes.length} bytes)\n\n'
                'Integrate flutter_pdfview / Syncfusion here',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // FILTER PLACEHOLDER
  // ===========================================================================
  void _showFilterDialog() {
    Get.snackbar('Filter', 'Filter dialog coming next');
  }
}
