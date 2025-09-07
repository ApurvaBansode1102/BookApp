// sales_overview_staggered.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookapp/features/utils/responsive.dart';

class SalesOverviewChart extends StatefulWidget {
  const SalesOverviewChart({super.key});

  @override
  State<SalesOverviewChart> createState() => _SalesOverviewChartState();
}

class _SalesOverviewChartState extends State<SalesOverviewChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _fadeAnimation;

  // Controls whether the chart widget is built (triggered after container animation)
  bool _showChart = false;

  @override
  void initState() {
    super.initState();

    // 1) container animation controller (slide + fade)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // start off-screen to right
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // start container animation, then show & animate chart when complete
    _controller.forward().whenComplete(() {
      // small extra delay so the container settles visually (optional)
      Future.delayed(const Duration(milliseconds: 120), () {
        if (mounted) setState(() => _showChart = true);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLegend(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final legendFontSize = Responsive.fontSize(context, mobile: 10, tablet: 14);
    final legendDotSize = isTablet ? 16.0 : 12.0;
    final legendSpacing = isTablet ? 28.0 : 20.0;

    return Row(
      children: [
        Container(
            width: legendDotSize,
            height: legendDotSize,
            decoration: const BoxDecoration(
                color: Color(0xFF3366FF), shape: BoxShape.circle)),
        SizedBox(width: legendDotSize * 0.5),
        Text("Fiction",
            style: GoogleFonts.poppins(fontSize: legendFontSize, fontWeight: FontWeight.w500)),
        SizedBox(width: legendSpacing),
        Container(
            width: legendDotSize,
            height: legendDotSize,
            decoration: const BoxDecoration(
                color: Color(0xFF58D6D1), shape: BoxShape.circle)),
        SizedBox(width: legendDotSize * 0.5),
        Text("Non-fiction",
            style: GoogleFonts.poppins(fontSize: legendFontSize, fontWeight: FontWeight.w500)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final horizontalPadding = Responsive.padding(context, mobile: 20, tablet: 40);
    final cardPadding = Responsive.padding(context, mobile: 16, tablet: 28);
    final borderRadius = BorderRadius.circular(isTablet ? 28 : 20);
    final titleFontSize = Responsive.fontSize(context, mobile: 13, tablet: 18);
    final chartHeight = isTablet ? 260.0 : 180.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _offsetAnimation,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8E9),
              borderRadius: borderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sales Overview (Monthly)",
                    style: GoogleFonts.poppins(
                        fontSize: titleFontSize, fontWeight: FontWeight.w600)),
                SizedBox(height: isTablet ? 16 : 10),
                _buildLegend(context),
                SizedBox(height: isTablet ? 28 : 20),

                // Chart placeholder vs real animated chart
                SizedBox(
                  height: chartHeight,
                  child: _showChart ? _animatedLineChart(context) : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build the actual LineChart — fl_chart will animate lines when it is first built
  Widget _animatedLineChart(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final axisFontSize = Responsive.fontSize(context, mobile: 10, tablet: 14);

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5,
              getTitlesWidget: (value, _) => Text(
                "${value.toInt()}k",
                style: GoogleFonts.poppins(fontSize: axisFontSize),
              ),
              reservedSize: isTablet ? 45 : 35,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) {
                const months = [
                  'Jan','Feb','Mar','Apr','May','Jun',
                  'Jul','Aug','Sep','Oct','Nov','Dec'
                ];
                final i = value.toInt();
                if (i >= 0 && i < months.length) {
                  return Text(months[i], style: GoogleFonts.poppins(fontSize: axisFontSize));
                }
                return const SizedBox();
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          // Fiction series (dummy monthly data)
          LineChartBarData(
            isCurved: true,
            curveSmoothness: 0.3,
            spots: const [
              FlSpot(0, 10),
              FlSpot(1, 12),
              FlSpot(2, 8),
              FlSpot(3, 15),
              FlSpot(4, 18),
              FlSpot(5, 14),
              FlSpot(6, 20),
              FlSpot(7, 17),
              FlSpot(8, 19),
              FlSpot(9, 16),
              FlSpot(10, 13),
              FlSpot(11, 21),
            ],
            color: const Color(0xFF3366FF),
            barWidth: isTablet ? 4 : 3,
            dotData: FlDotData(show: true),
            isStrokeCapRound: true,
          ),

          // Non-fiction series (dummy monthly data)
          LineChartBarData(
            isCurved: true,
            curveSmoothness: 0.3,
            spots: const [
              FlSpot(0, 8),
              FlSpot(1, 10),
              FlSpot(2, 7),
              FlSpot(3, 12),
              FlSpot(4, 14),
              FlSpot(5, 11),
              FlSpot(6, 16),
              FlSpot(7, 13),
              FlSpot(8, 15),
              FlSpot(9, 12),
              FlSpot(10, 10),
              FlSpot(11, 18),
            ],
            color: const Color(0xFF58D6D1),
            barWidth: isTablet ? 4 : 3,
            dotData: FlDotData(show: true),
            isStrokeCapRound: true,
          ),
        ],
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 25,
      ),

      // <<< chart animation parameters (use `duration` & `curve`, NOT swapAnimation*)
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeInOut,
    );
  }
}
