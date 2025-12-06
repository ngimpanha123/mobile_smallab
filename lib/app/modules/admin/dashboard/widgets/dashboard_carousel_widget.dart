import 'package:flutter/material.dart';
import '../../../../data/models/admin/dashboard_model.dart';
import 'overall_sales_summary_widget.dart';
import 'detailed_statistics_widget.dart';

class DashboardCarouselWidget extends StatefulWidget {
  final Statistic statistic;
  final VoidCallback onDatePickerTap;

  const DashboardCarouselWidget({
    Key? key,
    required this.statistic,
    required this.onDatePickerTap,
  }) : super(key: key);

  @override
  State<DashboardCarouselWidget> createState() => _DashboardCarouselWidgetState();
}

class _DashboardCarouselWidgetState extends State<DashboardCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Swipeable Pages
        SizedBox(
          height: 410, // Adjust height as needed
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              // Option 1: Overall Sales Summary
              OverallSalesSummaryWidget(
                total: widget.statistic.total,
                percentageChange: widget.statistic.totalPercentageIncrease,
                saleIncreasePreviousDay: widget.statistic.saleIncreasePreviousDay,
                onDatePickerTap: widget.onDatePickerTap,
              ),

              // Option 2: Detailed Statistics
              DetailedStatisticsWidget(
                statistic: widget.statistic,
              ),
            ],
          ),
        ),

        // Page Indicator Dots
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            2,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(0xFF2596be)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
