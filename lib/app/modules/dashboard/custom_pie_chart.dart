import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants.dart';

import '../../model/chart_model.dart';
import '../../translations/locale_keys.dart';

class CustomPieChart extends StatefulWidget {
  /// 饼图
  /// pieChartData: 饼图数据
  const CustomPieChart({super.key, this.pieChartData});
  final List<SalePlayRatio>? pieChartData;

  @override
  State<StatefulWidget> createState() => CustomPieChartState();
}

class CustomPieChartState extends State<CustomPieChart> {
  int touchedIndex = -1;
  static const double _defaultRadius = 125.0;
  static const double _touchedRadius = 130.0;
  static const double _defaultFontSize = 16.0;
  static const double _touchedFontSize = 25.0;
  @override
  Widget build(BuildContext context) {
    return (widget.pieChartData == null || widget.pieChartData!.isEmpty)
        ? Center(child: Text(LocaleKeys.noRecordFound.tr, style: TextStyle(fontSize: 16)))
        : Column(
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: widget.pieChartData!.map((item) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 12, height: 12, color: item.color),
                        const SizedBox(width: 4),
                        Text('${item.mPayType}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(height: 18),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection == null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 0,
                              centerSpaceRadius: 0,
                              sections: showingSections(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  // 显示每个扇区的内容
  List<PieChartSectionData> showingSections() {
    double totalAmount = 0.00;
    widget.pieChartData?.forEach((item) {
      totalAmount += double.tryParse(item.totalAmount ?? "0.00") ?? 0.00;
    });

    return List.generate(widget.pieChartData?.length ?? 0, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? _touchedFontSize : _defaultFontSize;
      final radius = isTouched ? _touchedRadius : _defaultRadius;

      final percentage = totalAmount > 0
          ? (double.tryParse(widget.pieChartData?[i].totalAmount ?? "0") ?? 0.0) / totalAmount * 100
          : 0.0;

      return PieChartSectionData(
        color: widget.pieChartData?[i].color ?? Colors.blue,
        value: percentage,
        title: '${percentage.toStringAsFixed(2)}%',
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
        badgeWidget: isTouched
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.customTextColor),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '${widget.pieChartData?[i].mPayType} \n\$${widget.pieChartData?[i].totalAmount}\n${percentage.toStringAsFixed(2)}%',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : null, // 默认不显示
      );
    });
  }
}
