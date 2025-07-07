import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/chart_model.dart';
import '../../translations/locale_keys.dart';
import '../../utils/constants.dart';

class CustomLineChart extends StatefulWidget {
  /// 折线图
  /// [lineChartData] 折线图数据
  const CustomLineChart({super.key, this.lineChartData});
  final List<MonthEverySale>? lineChartData;

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  @override
  Widget build(BuildContext context) {
    final lineChartDate = widget.lineChartData;

    if (lineChartDate == null || lineChartDate.isEmpty) {
      return Center(child: Text(LocaleKeys.noRecordFound.tr, style: TextStyle(fontSize: 16)));
    }
    final format = DateFormat('yyyy-MM');
    final currentYearMonth = format.format(lineChartDate.first.dayLabel!);

    // Prepare data for the chart
    final spots = lineChartDate.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return FlSpot(index.toDouble(), double.parse(data.totalAmount ?? "0"));
    }).toList();

    // Get the labels for the x-axis
    final xLabels = lineChartDate.map((data) {
      if (data.formatDate != null) {
        return data.formatDate.toString();
      }
      // Extract day from dayLabel if formatDate is null
      final dateParts = data.dayLabel.toString().split('-');
      return dateParts.length > 2 ? dateParts[2].substring(0, 2) : '';
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => AppColors.customTextColor,
              tooltipBorderRadius: BorderRadius.circular(8),
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  final date = lineChartDate[touchedSpot.spotIndex].dayLabel;
                  final formattedDate = DateFormat(('yyyy-MM-dd')).format(date!);
                  final amount = touchedSpot.y;

                  return LineTooltipItem(
                    '$formattedDate\n',
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    children: [
                      TextSpan(
                        text: '${LocaleKeys.amount.tr}: ${amount.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameWidget: Text(currentYearMonth, style: TextStyle(fontSize: 12, color: Colors.black)),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < xLabels.length) {
                    return SideTitleWidget(
                      meta: meta,
                      space: 8,
                      child: Text(xLabels[index], style: const TextStyle(fontSize: 10, color: Colors.black)),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10, color: Colors.black));
                },
                reservedSize: 40,
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
          minX: 0,
          maxX: (lineChartDate.length - 1).toDouble(),
          minY: 0,
          maxY: lineChartDate.map((e) => double.parse(e.totalAmount ?? "0")).reduce((a, b) => a > b ? a : b) * 1.1,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xff55ce63),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: const Color(0xff55ce63),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
