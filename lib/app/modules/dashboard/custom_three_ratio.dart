import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/chart_model.dart';
import '../../translations/locale_keys.dart';

class CustomThreeRatio extends StatelessWidget {
  /// 三比三
  /// [threeRatio] 三比三数据
  const CustomThreeRatio({super.key, this.threeRatio});
  final ThreeRatio? threeRatio;

  @override
  Widget build(BuildContext context) {
    const double padding = 4;
    const Color bgColor = Color.fromARGB(255, 212, 212, 212);
    const double radius = 5;
    const TextStyle titleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 96, 96, 96),
    );
    const TextStyle amountStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 97, 97, 97),
    );
    const Color activeColor = Colors.green;
    const Color disableColor = Colors.red;
    const double spacing = 4;

    if (threeRatio == null) {
      return Center(child: Text(LocaleKeys.noRecordFound.tr, style: TextStyle(fontSize: 16)));
    } else {
      final formatter = NumberFormat("#,##0.00");
      final List<DayResult>? dayResult = threeRatio!.dayResult;
      final double yesterdaySale = double.parse(dayResult?[1].totalAmount ?? "0");
      final double todaySale = double.parse(dayResult?[2].totalAmount ?? "0");
      final double yesterGrowthRate = double.parse(dayResult?[1].growthRate ?? "0");
      final double todayGrowthRate = double.parse(dayResult?[2].growthRate ?? "0");

      final List<WeekResult>? weekResult = threeRatio!.weekResult;
      final double lastWeekSale = double.parse(weekResult?[1].totalAmount ?? "0");
      final double thisWeekSale = double.parse(weekResult?[2].totalAmount ?? "0");
      final double lastWeekGrowthRate = double.parse(weekResult?[1].growthRate ?? "0");
      final double thisWeekGrowthRate = double.parse(weekResult?[2].growthRate ?? "0");
      final List<MonthResult>? monthResult = threeRatio!.monthResult;
      final double lastMonthSale = double.parse(monthResult?[1].totalAmount ?? "0");
      final double thisMonthSale = double.parse(monthResult?[2].totalAmount ?? "0");
      final double lastMonthGrowthRate = double.parse(monthResult?[1].growthRate ?? "0");
      final double thisMonthGrowthRate = double.parse(monthResult?[2].growthRate ?? "0");

      return Padding(
        padding: const EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: Column(
            spacing: 4,
            children: <Widget>[
              // 前日销售 当日销售
              Row(
                spacing: spacing,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(radius)),
                      child: Text(LocaleKeys.yesterdaySale.tr, textAlign: TextAlign.center, style: titleStyle),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(radius)),
                      child: Text(LocaleKeys.todaySale.tr, textAlign: TextAlign.center, style: titleStyle),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: spacing,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
                      child: Text(formatter.format(yesterdaySale), textAlign: TextAlign.center, style: amountStyle),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
                      child: Text(formatter.format(todaySale), textAlign: TextAlign.center, style: amountStyle),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: spacing,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
                      child: Text(
                        "${formatter.format(yesterGrowthRate)}%",
                        textAlign: TextAlign.center,
                        style: amountStyle.copyWith(
                          color: yesterGrowthRate == 0
                              ? null
                              : yesterGrowthRate > 0
                              ? activeColor
                              : disableColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
                      child: Text(
                        "${formatter.format(todayGrowthRate)}%",
                        textAlign: TextAlign.center,
                        style: amountStyle.copyWith(
                          color: yesterGrowthRate == 0
                              ? null
                              : todayGrowthRate > 0
                              ? activeColor
                              : disableColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //上周销售 本周销售
              Row(
                spacing: spacing,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(radius)),
                      child: Text(LocaleKeys.lastWeekSale.tr, textAlign: TextAlign.center, style: titleStyle),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(radius)),
                      child: Text(LocaleKeys.thisWeekSale.tr, textAlign: TextAlign.center, style: titleStyle),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: spacing,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
                      child: Text(formatter.format(lastWeekSale), textAlign: TextAlign.center, style: amountStyle),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
                      child: Text(formatter.format(thisWeekSale), textAlign: TextAlign.center, style: amountStyle),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: spacing,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
                      child: Text(
                        "${formatter.format(lastWeekGrowthRate)}%",
                        textAlign: TextAlign.center,
                        style: amountStyle.copyWith(
                          color: lastWeekGrowthRate == 0
                              ? null
                              : lastWeekGrowthRate > 0
                              ? activeColor
                              : disableColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
                      child: Text(
                        "${formatter.format(thisWeekGrowthRate)}%",
                        textAlign: TextAlign.center,
                        style: amountStyle.copyWith(
                          color: thisWeekGrowthRate == 0
                              ? null
                              : thisWeekGrowthRate > 0
                              ? activeColor
                              : disableColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //上月销售 本月销售
              Row(
                spacing: spacing,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(radius)),
                      child: Text(LocaleKeys.lastMonthSale.tr, textAlign: TextAlign.center, style: titleStyle),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(radius)),
                      child: Text(LocaleKeys.thisMonthSale.tr, textAlign: TextAlign.center, style: titleStyle),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: spacing,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
                      child: Text(formatter.format(lastMonthSale), textAlign: TextAlign.center, style: amountStyle),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
                      child: Text(formatter.format(thisMonthSale), textAlign: TextAlign.center, style: amountStyle),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: spacing,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
                      child: Text(
                        "${formatter.format(lastMonthGrowthRate)}%",
                        textAlign: TextAlign.center,
                        style: amountStyle.copyWith(
                          color: lastMonthGrowthRate == 0
                              ? null
                              : lastMonthGrowthRate > 0
                              ? activeColor
                              : disableColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
                      child: Text(
                        "${formatter.format(thisMonthGrowthRate)}%",
                        textAlign: TextAlign.center,
                        style: amountStyle.copyWith(
                          color: thisMonthGrowthRate == 0
                              ? null
                              : thisMonthGrowthRate > 0
                              ? activeColor
                              : disableColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
