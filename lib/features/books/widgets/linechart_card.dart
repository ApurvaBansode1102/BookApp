import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookapp/features/utils/responsive.dart';

class LineChartCard extends StatefulWidget {
  const LineChartCard({super.key});

  @override
  State<LineChartCard> createState() => _LineChartCardState();
}

class _LineChartCardState extends State<LineChartCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _showFiction = false;
  bool _showNonFiction = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // from bottom
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start card animation
    _controller.forward().whenComplete(() async {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) setState(() => _showFiction = true);

      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) setState(() => _showNonFiction = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLegendDot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final horizontalPadding = Responsive.padding(context, mobile: 20, tablet: 40);
    final cardPadding = Responsive.padding(context, mobile: 20, tablet: 32);
    final borderRadius = BorderRadius.circular(isTablet ? 28 : 20);
    final titleFontSize = Responsive.fontSize(context, mobile: 14, tablet: 20);
    final legendFontSize = Responsive.fontSize(context, mobile: 10, tablet: 14);
    final legendDotSize = isTablet ? 16.0 : 12.0;
    final legendSpacing = isTablet ? 28.0 : 20.0;
    final chartHeight = isTablet ? 320.0 : 220.0;
    final axisFontSize = Responsive.fontSize(context, mobile: 10, tablet: 14);

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
              color: Colors.white,
              border: Border.all(color: const Color(0xffCCCCCC)),
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: isTablet ? 16 : 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Book Publishing Trend (2021–2025)",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: titleFontSize,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: isTablet ? 16 : 10),

                // Legend
                Row(
                  children: [
                    _buildLegendDot(Colors.teal, legendDotSize),
                    SizedBox(width: 6),
                    Text("Fiction",
                        style: GoogleFonts.poppins(
                            fontSize: legendFontSize, fontWeight: FontWeight.w500)),
                    SizedBox(width: legendSpacing),
                    _buildLegendDot(Colors.pinkAccent, legendDotSize),
                    SizedBox(width: 6),
                    Text("Non-fiction",
                        style: GoogleFonts.poppins(
                            fontSize: legendFontSize, fontWeight: FontWeight.w500)),
                  ],
                ),

                SizedBox(height: isTablet ? 28 : 20),

                // Chart
                SizedBox(
                  height: chartHeight,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: isTablet ? 48 : 36,
                            getTitlesWidget: (value, _) {
                              switch (value.toInt()) {
                                case 1:
                                  return Text("2021", style: GoogleFonts.poppins(fontSize: axisFontSize));
                                case 2:
                                  return Text("2022", style: GoogleFonts.poppins(fontSize: axisFontSize));
                                case 3:
                                  return Text("2023", style: GoogleFonts.poppins(fontSize: axisFontSize));
                                case 4:
                                  return Text("2024", style: GoogleFonts.poppins(fontSize: axisFontSize));
                                case 5:
                                  return Text("2025", style: GoogleFonts.poppins(fontSize: axisFontSize));
                              }
                              return const Text("");
                            },
                            interval: 1,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, _) => Text(
                              "${(value * 1000).toInt()}",
                              style: GoogleFonts.poppins(fontSize: axisFontSize),
                            ),
                            reservedSize: isTablet ? 56 : 48,
                          ),
                        ),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        if (_showFiction)
                          LineChartBarData(
                            isCurved: true,
                            spots: const [
                              FlSpot(1, 1),
                              FlSpot(2, 2),
                              FlSpot(3, 3),
                              FlSpot(4, 4),
                              FlSpot(5, 5),
                            ],
                            color: Colors.teal,
                            barWidth: isTablet ? 4 : 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: true),
                          ),
                        if (_showNonFiction)
                          LineChartBarData(
                            isCurved: true,
                            spots: const [
                              FlSpot(1, 1.5),
                              FlSpot(2, 2.2),
                              FlSpot(3, 2.8),
                              FlSpot(4, 3.8),
                              FlSpot(5, 4.5),
                            ],
                            color: Colors.pinkAccent,
                            barWidth: isTablet ? 4 : 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: true),
                          ),
                      ],
                      minX: 1,
                      maxX: 5,
                      minY: 0,
                      maxY: 6,
                    ),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeInOut,
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
