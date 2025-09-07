import 'package:bookapp/features/books/widgets/donutchart_card.dart';
import 'package:bookapp/features/books/widgets/line_graph.dart';
import 'package:bookapp/features/books/widgets/linechart_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookapp/features/auth/controller/auth_controller.dart';
import 'package:bookapp/features/utils/responsive.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: Responsive.padding(context, mobile: 20, tablet: 40),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blue Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.padding(context, mobile: 20, tablet: 40),
                vertical: Responsive.padding(context, mobile: 40, tablet: 60),
              ),
              decoration: const BoxDecoration(color: Color(0xFF3D5CFF)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, ${Get.find<AuthController>().user.value?.displayName ?? "User"}",
                          style: GoogleFonts.poppins(
                            fontSize: Responsive.fontSize(context, mobile: 22, tablet: 32),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: Responsive.padding(context, mobile: 4, tablet: 8)),
                        Text(
                          "Let's start learning",
                          style: GoogleFonts.poppins(
                            fontSize: Responsive.fontSize(context, mobile: 14, tablet: 20),
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/Avatar.png'),
                    radius: 24,
                  ),
                ],
              ),
            ),

            SizedBox(height: Responsive.padding(context, mobile: 10, tablet: 20)),

            // Donut Chart Card
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.padding(context, mobile: 20, tablet: 40),
              ),
              child: DonutChartCard(),
            ),
            SizedBox(height: Responsive.padding(context, mobile: 20, tablet: 40)),

            // Line Chart Card
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.padding(context, mobile: 20, tablet: 40),
              ),
              child: LineChartCard(),
            ),

            SizedBox(height: Responsive.padding(context, mobile: 20, tablet: 40)),

            // Sales Overview Chart
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.padding(context, mobile: 20, tablet: 40),
              ),
              child: SalesOverviewChart(),
            ),

            SizedBox(height: Responsive.padding(context, mobile: 20, tablet: 40)),

            // Meetup Card
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.padding(context, mobile: 20, tablet: 40),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(Responsive.padding(context, mobile: 20, tablet: 32)),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EDFF),
                  borderRadius: BorderRadius.circular(isTablet ? 32 : 20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Meetup",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: Responsive.fontSize(context, mobile: 18, tablet: 26),
                              color: const Color(0xff440687),
                            ),
                          ),
                          SizedBox(height: Responsive.padding(context, mobile: 8, tablet: 16)),
                          Text(
                            "Off-line exchange of learning experiences",
                            style: GoogleFonts.poppins(
                              fontSize: Responsive.fontSize(context, mobile: 12, tablet: 18),
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff440687),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: Responsive.padding(context, mobile: 12, tablet: 24)),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: const AssetImage('assets/group1.png'),
                          radius: isTablet ? 28 : 20,
                        ),
                        SizedBox(height: Responsive.padding(context, mobile: 8, tablet: 12)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: const AssetImage('assets/group2.png'),
                              radius: isTablet ? 20 : 14,
                            ),
                            SizedBox(width: Responsive.padding(context, mobile: 8, tablet: 12)),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: const AssetImage('assets/group3.png'),
                              radius: isTablet ? 20 : 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------
// ✅ Legend Widget
// ------------------------

class LegendTile extends StatelessWidget {
  final Color color;
  final String label;

  const LegendTile({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          color: color,
          margin: const EdgeInsets.only(right: 6),
        ),
        Text(label, style: GoogleFonts.poppins(fontSize: Responsive.fontSize(context, mobile: 12, tablet: 16))),
      ],
    );
  }
}
