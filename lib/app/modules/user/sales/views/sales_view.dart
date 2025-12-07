import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../config/app_config.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../controllers/sales_controller.dart';

class SalesView extends GetView<SalesController> {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Sales History",
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchSales(),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.groupedSales.isEmpty) {
          return _emptyState();
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchSales(),
          child: ListView.builder(
            padding: EdgeInsets.all(AppSpacing.paddingM),
            itemCount: controller.groupedSales.length,
            itemBuilder: (_, index) {
              final group = controller.groupedSales[index];
              final date = group["date"];
              final items = group["items"];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 0) _buildTodayTotalCard(),
                  if (index == 0) SizedBox(height: AppSpacing.marginMedium),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      date,
                      style: TextStyle(
                        fontSize: AppFontSize.titleMedium,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                  ),

                  ...List.generate(
                    items.length,
                        (i) => _buildSaleCard(items[i]),
                  ),

                  SizedBox(height: AppSpacing.marginLarge),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  // ----------------------------- TODAY SALES CARD -----------------------------
  Widget _buildTodayTotalCard() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: AppColors.cardDecoration(),
        child: Row(
          children: [
            Icon(Icons.calendar_today,
                size: 30, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text(
              "Today's Sales",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              "${controller.totalToday.value} ៛",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 90, color: Colors.grey.shade300),
          SizedBox(height: AppSpacing.marginMedium),
          Text(
            "No Sales Found",
            style: TextStyle(
              fontSize: AppFontSize.titleMedium,
              color: AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------- SALE CARD (CLICK TO DETAIL) ----------------------
  Widget _buildSaleCard(sale) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.marginMedium),
      decoration: AppColors.cardDecoration(),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),

        /// ⭐⭐ UPDATED — GO TO SALE DETAIL PAGE ⭐⭐
        onTap: () => controller.openSaleDetail(sale.id),

        child: Padding(
          padding: EdgeInsets.all(AppSpacing.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // RECEIPT + PLATFORM
              Row(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "#${sale.receiptNumber}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildPlatformBadge(sale.platform),
                ],
              ),

              SizedBox(height: AppSpacing.marginMedium),

              // CASHIER
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      AppConfig.getImageUrl(sale.cashier.avatar),
                    ),
                  ),
                  SizedBox(width: AppSpacing.marginSmall),
                  Text(
                    sale.cashier.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${sale.totalPrice} ៛",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.marginSmall),

              Row(
                children: [
                  Icon(Icons.access_time,
                      size: 14, color: Colors.grey.shade600),
                  SizedBox(width: 4),
                  Text(
                    controller.formatTime(sale.orderedAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${sale.details.length} items",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
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

  Widget _buildPlatformBadge(String? platform) {
    if (platform == null) return const SizedBox();

    final p = platform.toLowerCase();
    Color color = AppColors.primary;
    IconData icon = Icons.devices;

    if (p == "mobile") {
      color = AppColors.success;
      icon = Icons.phone_android;
    } else if (p == "web") {
      color = AppColors.infoColor;
      icon = Icons.language;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
