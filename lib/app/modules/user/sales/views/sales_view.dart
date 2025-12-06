import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_font_size.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../constants/app_widget_size.dart';
import '../../../../widgets/sale_item.dart';
import '../controllers/sales_controller.dart';

class SalesView extends GetView<SalesController> {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ░░ TOP BAR (same as Ordering) ░░
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingM,
                vertical: AppSpacing.paddingS,
              ),
              child: Row(
                children: [
                  const Spacer(),

                  Text(
                    "Sale",
                    style: TextStyle(
                      fontSize: AppFontSize.titleLarge,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),

                  const Spacer(),

                  Icon(Icons.more_horiz,
                      size: AppWidgetSize.iconLarge,
                      color: AppColors.iconColor),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.marginSmall),

            // ░░ TOTAL SALES BLOCK ░░
            Obx(() {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.paddingM),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.black12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Today's total",
                      style: TextStyle(
                        fontSize: AppFontSize.bodyMedium,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.marginXS),
                    Text(
                      "${controller.totalToday.value} ៛",
                      style: TextStyle(
                        fontSize: AppFontSize.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              );
            }),

            SizedBox(height: AppSpacing.marginSmall),

            // ░░ SALES LIST ░░
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.sales.isEmpty) {
                  return Center(
                    child: Text(
                      "មិនមានប្រវត្តិការលក់",
                      style: TextStyle(
                        fontSize: AppFontSize.bodyLarge,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.groupedSales.length,
                  itemBuilder: (_, i) {
                    final group = controller.groupedSales[i];
                    final date = group['date'];
                    final list = group['items'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Header Date
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.paddingM,
                            vertical: AppSpacing.paddingS,
                          ),
                          color: AppColors.secondary,
                          child: Text(
                            date, // ex: "September 14"
                            style: TextStyle(
                              fontSize: AppFontSize.bodyLarge,
                              fontWeight: FontWeight.w600,
                              color: AppColors.lightTextPrimary,
                            ),
                          ),
                        ),

                        // Sales list under that date
                        ...List.generate(list.length, (index) {
                          return SaleItemWidget(
                            sale: list[index],
                            onTap: () => controller.openSaleDetail(list[index].id!),
                          );
                        }),
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
