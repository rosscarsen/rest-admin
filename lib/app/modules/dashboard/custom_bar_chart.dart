import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/chart_model.dart';
import '../../translations/locale_keys.dart';
import '../../utils/constants.dart';

class CustomBarChart extends StatefulWidget {
  /// 柱状图
  /// [barChartData] 柱状图数据
  const CustomBarChart({super.key, this.barChartData});
  final List<SevenSale>? barChartData;

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final barChartData = widget.barChartData;

    if (barChartData == null || barChartData.isEmpty) {
      return Center(child: Text(LocaleKeys.noRecordFound.tr, style: TextStyle(fontSize: 16)));
    }

    // Convert string amounts to double and filter out invalid data
    final validData = barChartData
        .where(
          (item) => item.invoiceDate != null && item.totalAmount != null && double.tryParse(item.totalAmount!) != null,
        )
        .toList();

    if (validData.isEmpty) {
      return Center(child: Text('Invalid Data Format', style: TextStyle(fontSize: 16)));
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barTouchData: BarTouchData(
              touchCallback: (FlTouchEvent event, response) {
                setState(() {
                  if (!event.isInterestedForInteractions || response == null || response.spot == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex = response.spot!.touchedBarGroupIndex;
                });
              },
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) => AppColors.customTextColor,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final date = validData[groupIndex].invoiceDate!;
                  final amount = double.parse(validData[groupIndex].totalAmount!);
                  final formatter = DateFormat('yyyy-MM-dd');
                  return BarTooltipItem(
                    '${LocaleKeys.date.tr}:${formatter.format(date)}\n${LocaleKeys.amount.tr}:${amount.toStringAsFixed(2)}',
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(value.toInt().toString(), style: const TextStyle(fontSize: 12, color: Colors.grey));
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < validData.length) {
                      final date = validData[index].invoiceDate!;
                      final formatter = DateFormat('MM/dd');
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(formatter.format(date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300, width: 1)),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: _calculateInterval(validData),
            ),
            barGroups: validData
                .asMap()
                .map((index, data) {
                  final amount = double.parse(data.totalAmount!);
                  final color = _getRandomColor(index);
                  final isTouched = index == touchedIndex;
                  return MapEntry(
                    index,
                    BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: amount,
                          color: isTouched ? color.lighten() : color,
                          width: 30,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: _getMaxAmount(validData) * 1.1,
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                      showingTooltipIndicators: isTouched ? [0] : [],
                    ),
                  );
                })
                .values
                .toList(),
          ),
        ),
      ),
    );
  }

  double _calculateInterval(List<SevenSale> data) {
    final maxAmount = _getMaxAmount(data);
    if (maxAmount <= 10000) return 2000;
    if (maxAmount <= 50000) return 5000;
    if (maxAmount <= 100000) return 10000;
    return 20000;
  }

  double _getMaxAmount(List<SevenSale> data) {
    final amounts = data.map((e) => double.parse(e.totalAmount!)).toList();
    return amounts.reduce((a, b) => a > b ? a : b);
  }

  Color _getRandomColor(int index) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple, Colors.teal, Colors.indigo];
    return colors[index % colors.length];
  }
}

extension ColorBrightness on Color {
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
