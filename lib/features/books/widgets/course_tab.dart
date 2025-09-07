import 'package:bookapp/features/books/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bookapp/features/utils/responsive.dart';

class CourseTab extends StatelessWidget {
  const CourseTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final isTablet = Responsive.isTablet(context);
    final tabMargin = isTablet ? 24.0 : 16.0;
    final tabPaddingH = isTablet ? 24.0 : 16.0;
    final tabPaddingV = isTablet ? 12.0 : 8.0;
    final tabFontSize = Responsive.fontSize(context, mobile: 14, tablet: 18);

    return Obx(() => Row(
      children: [
        _tabItem("All", 0, controller, tabMargin, tabPaddingH, tabPaddingV, tabFontSize),
        _tabItem("Popular", 1, controller, tabMargin, tabPaddingH, tabPaddingV, tabFontSize),
        _tabItem("New", 2, controller, tabMargin, tabPaddingH, tabPaddingV, tabFontSize),
        const Spacer(),
        // const Icon(Icons.grid_view_rounded),
      ],
    ));
  }

  Widget _tabItem(
    String title,
    int index,
    HomeController controller,
    double margin,
    double paddingH,
    double paddingV,
    double fontSize,
  ) {
    final isSelected = controller.selectedTab.value == index;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Container(
        margin: EdgeInsets.only(right: margin),
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff3D5CFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w500,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
