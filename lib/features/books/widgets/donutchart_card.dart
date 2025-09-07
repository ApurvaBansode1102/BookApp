import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookapp/features/utils/responsive.dart';

class DonutChartCard extends StatefulWidget {
  const DonutChartCard({super.key});

  @override
  State<DonutChartCard> createState() => _DonutChartCardState();
}

class _DonutChartCardState extends State<DonutChartCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // slide up
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final horizontalPadding = Responsive.padding(context, mobile: 20, tablet: 40);
    final cardPadding = Responsive.padding(context, mobile: 16, tablet: 28);
    final borderRadius = BorderRadius.circular(isTablet ? 28 : 20);
    final chartSize = isTablet ? 200.0 : 150.0;
    final legendFontSize = Responsive.fontSize(context, mobile: 11, tablet: 15);
    final legendSpacing = isTablet ? 14.0 : 8.0;
    final legendDotSize = isTablet ? 16.0 : 12.0;
    final titleFontSize = Responsive.fontSize(context, mobile: 13, tablet: 18);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: const Color(0xffeceecfe),
              borderRadius: borderRadius,
            ),
            child: Row(
              children: [
                // Donut Chart
                SizedBox(
                  height: chartSize,
                  width: chartSize,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: isTablet ? 40 : 30,
                      sections: [
                        PieChartSectionData(
                            color: const Color(0xFF3366FF),
                            value: 25,
                            title: '',
                            radius: isTablet ? 56 : 40), // Fiction
                        PieChartSectionData(
                            color: const Color(0xFF58D6D1),
                            value: 20,
                            title: '',
                            radius: isTablet ? 56 : 40), // Non-fiction
                        PieChartSectionData(
                            color: const Color(0xFF92E3A9),
                            value: 15,
                            title: '',
                            radius: isTablet ? 56 : 40), // Romance
                        PieChartSectionData(
                            color: const Color(0xFFB983FF),
                            value: 10,
                            title: '',
                            radius: isTablet ? 56 : 40), // Sci-fi
                        PieChartSectionData(
                            color: const Color(0xFFFFA500),
                            value: 10,
                            title: '',
                            radius: isTablet ? 56 : 40), // Thriller
                        PieChartSectionData(
                            color: const Color(0xFF6C63FF),
                            value: 10,
                            title: '',
                            radius: isTablet ? 56 : 40), // History
                        PieChartSectionData(
                            color: const Color(0xFF00B894),
                            value: 10,
                            title: '',
                            radius: isTablet ? 56 : 40), // Biography
                      ],
                    ),
                    swapAnimationDuration:
                        const Duration(milliseconds: 1000), // Pie slices animation
                    swapAnimationCurve: Curves.easeInOut,
                  ),
                ),
                SizedBox(width: isTablet ? 36 : 24),

                // Legends
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Genre distribution",
                          style: GoogleFonts.poppins(
                              fontSize: titleFontSize, fontWeight: FontWeight.w600)),
                      SizedBox(height: legendSpacing),
                      LegendTile(color: const Color(0xFF3366FF), label: "Fiction", fontSize: legendFontSize, dotSize: legendDotSize),
                      SizedBox(height: legendSpacing),
                      LegendTile(color: const Color(0xFF58D6D1), label: "Non-fiction", fontSize: legendFontSize, dotSize: legendDotSize),
                      SizedBox(height: legendSpacing),
                      LegendTile(color: const Color(0xFF92E3A9), label: "Romance", fontSize: legendFontSize, dotSize: legendDotSize),
                      SizedBox(height: legendSpacing),
                      LegendTile(color: const Color(0xFFB983FF), label: "Sci-fi", fontSize: legendFontSize, dotSize: legendDotSize),
                      SizedBox(height: legendSpacing),
                      LegendTile(color: const Color(0xFFFFA500), label: "Thriller", fontSize: legendFontSize, dotSize: legendDotSize),
                      SizedBox(height: legendSpacing),
                      LegendTile(color: const Color(0xFF6C63FF), label: "History", fontSize: legendFontSize, dotSize: legendDotSize),
                      SizedBox(height: legendSpacing),
                      LegendTile(color: const Color(0xFF00B894), label: "Biography", fontSize: legendFontSize, dotSize: legendDotSize),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LegendTile extends StatelessWidget {
  final Color color;
  final String label;
  final double fontSize;
  final double dotSize;

  const LegendTile({
    super.key,
    required this.color,
    required this.label,
    required this.fontSize,
    required this.dotSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: dotSize * 0.7),
        Text(label,
            style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.w400))
      ],
    );
  }
}
