import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/constants/color/color.dart';

class InvoicesLineChart extends StatelessWidget {
  final List<FlSpot> lineChartData;
  final List<String> dateLabels;
  final String filterType;

  const InvoicesLineChart({
    super.key,
    required this.lineChartData,
    required this.dateLabels,
    required this.filterType,
  });

  @override
  Widget build(BuildContext context) {

    if (filterType == AppConstants.thisQuarter ||
        filterType == AppConstants.lastQuarter ||
        filterType == AppConstants.thisYear ||
        filterType == AppConstants.lastYear) {
      debugPrint('SCROLL SHOULD ENABLE');

      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          },
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: dateLabels.length * 50,
            padding: const EdgeInsets.only(left: 10, right: 20, top: 10),
            child: LineChart(
              LineChartData(
                minY: 0,
                minX: 0,
                maxX: dateLabels.length.toDouble(),
                lineBarsData: [
                  LineChartBarData(
                    spots: lineChartData,
                    isCurved: true,
                    color: mainPurpleColor,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (p0, p1, p2, p3) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: mainPurpleColor,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                        show: true, color: mainPurpleColor.withOpacity(0.2)),
                    barWidth: 3,
                    preventCurveOverShooting: true,
                    show: true,
                  ),
                ],
                lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots
                          .map((e) => LineTooltipItem(
                                e.y.toString(),
                                const TextStyle(
                                  color: sWhite,
                                  // Dynamically changing text color
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                          .toList();
                    })),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < dateLabels.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(dateLabels[index],
                                style: const TextStyle(fontSize: 12)),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false),
              ),
            ),
          ),
        ),
      );
    } else {
      debugPrint('SCROLL SHOULD DISABLE');
      return LineChart(
        LineChartData(
          minY: 0,
          minX: 0,
          maxX: dateLabels.length.toDouble(),
          lineBarsData: [
            LineChartBarData(
              spots: lineChartData,
              isCurved: true,
              color: mainPurpleColor,
              dotData: FlDotData(
                show: true,
                getDotPainter: (p0, p1, p2, p3) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: mainPurpleColor,
                  );
                },
              ),
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        mainPurpleColor.withOpacity(0.7),
                        mainPurpleColor.withOpacity(0.5),
                        mainPurpleColor.withOpacity(0.2),
                      ])),
              barWidth: 2,
              preventCurveOverShooting: true,
              show: true,
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots
                  .map((e) => LineTooltipItem(
                        e.y.toString(),
                        const TextStyle(
                          color: sWhite, // Dynamically changing text color
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                  .toList();
            }),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  // print("Index value: $index");
                  // print("Date Labels: $dateLabels");
                  if (index >= 0 && index < dateLabels.length) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(dateLabels[index],
                          style: const TextStyle(fontSize: 10, color: grey_4)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(
              show: true, drawHorizontalLine: true, drawVerticalLine: false),
        ),
      );
    }
  }
}
