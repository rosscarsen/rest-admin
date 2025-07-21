import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../config.dart';
import '../../model/chart_model.dart';
import '../../routes/app_pages.dart';
import '../../translations/locale_keys.dart';
import '../../utils/form_help.dart';
import '../../utils/progresshub.dart';
import '../../widgets/custom_scaffold.dart';
import 'custom_bar_chart.dart';
import 'custom_line_chart.dart';
import 'custom_pie_chart.dart';
import 'custom_three_ratio.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      route: Routes.DASHBOARD,

      body: Padding(
        padding: EdgeInsets.all(Config.defaultPadding),
        child: Column(
          children: [
            // 搜索框
            FormBuilder(
              key: controller.formKey,
              child: ResponsiveGridRow(
                children: [
                  FormHelper.buildGridCol(
                    child: FormHelper.dateInput(
                      name: "startDate",
                      labelText: LocaleKeys.startDate.tr,
                      initialValue: DateTime.now().subtract(const Duration(days: 7)),
                      enabled: false,
                      canClear: false,
                    ),
                  ),
                  FormHelper.buildGridCol(
                    child: FormHelper.dateInput(
                      name: "endDate",
                      labelText: LocaleKeys.endDate.tr,
                      initialValue: DateTime.now().subtract(const Duration(days: 1)),
                      canClear: false,
                      onChanged: (String? value) {
                        if (value != null) {
                          final formatter = DateFormat('yyyy-MM-dd');
                          final endDate = DateTime.parse(value);
                          final startDate = endDate.subtract(Duration(days: 6));
                          controller.formKey.currentState?.fields['startDate']?.didChange(formatter.format(startDate));
                          // 触发搜索
                          controller.search.addAll({
                            "startDate": formatter.format(startDate),
                            "endDate": formatter.format(endDate),
                          });
                          controller.getChartData();
                        } else {
                          controller.formKey.currentState?.fields['startDate']?.didChange(null);
                        }
                      },
                    ),
                  ),
                  //搜索
                  FormHelper.buildGridCol(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: context.isPhoneOrWider ? 40 : 48),
                      child: Align(
                        alignment: context.isPhoneOrLess ? Alignment.centerRight : Alignment.centerLeft,
                        child: FilledButton(
                          child: Text(LocaleKeys.search.tr),
                          onPressed: () {
                            /*  controller.formKey.currentState?.saveAndValidate();
                            controller.search.addAll(controller.formKey.currentState!.value); */
                            controller.getChartData();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 内容
            _buildContent(),
          ],
        ),
      ),
      title: LocaleKeys.salesView.tr,
    );
  }

  // 构建内容
  Widget _buildContent() {
    return Expanded(
      child: Obx(
        () => ProgressHUD(
          child: controller.isLoading.value
              ? null
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                        child: Text(
                          LocaleKeys.saleViewMsg.tr,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      _buildChart(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // 构建图表
  Widget _buildChart() {
    const kHeaderBlue = Color(0xFF1e5b96);
    const kHeaderTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16);
    final apiResult = controller.apiResult;
    final salePlayRatio = apiResult.value.salePlayRatio;
    final sevenSale = apiResult.value.sevenSale;
    final threeRatio = apiResult.value.threeRatio;
    final monthEverySale = apiResult.value.monthEverySale;
    final topSaleQty = apiResult.value.topSaleQty;
    final topSaleAmount = apiResult.value.topSaleAmount;
    return ResponsiveGridRow(
      children: [
        // 饼图
        ResponsiveGridCol(
          xs: 12,
          sm: 4,
          md: 4,
          lg: 4,
          xl: 4,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              clipBehavior: Clip.antiAlias,
              height: 380,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    color: kHeaderBlue,
                    height: 40,
                    padding: EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Text(
                        "${LocaleKeys.sameDayPaymentMethodSalesRatio.tr}(*)",
                        style: kHeaderTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // _buildPieChart(salePlayRatio),
                  Expanded(child: CustomPieChart(pieChartData: salePlayRatio)),
                ],
              ),
            ),
          ),
        ),
        // 七日销售额柱状图
        ResponsiveGridCol(
          xs: 12,
          sm: 4,
          md: 4,
          lg: 4,
          xl: 4,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              clipBehavior: Clip.antiAlias,
              height: 380,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    color: kHeaderBlue,
                    height: 40,
                    padding: EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Text(
                        "${LocaleKeys.salesInTheLastSevenDays.tr}(*)",
                        style: kHeaderTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // _buildPieChart(salePlayRatio),
                  Expanded(child: CustomBarChart(barChartData: sevenSale)),
                ],
              ),
            ),
          ),
        ),
        // 七日销售额
        ResponsiveGridCol(
          xs: 12,
          sm: 4,
          md: 4,
          lg: 4,
          xl: 4,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              clipBehavior: Clip.antiAlias,
              height: 380,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    color: kHeaderBlue,
                    height: 40,
                    padding: EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Text(
                        "${LocaleKeys.yesterdayLastWeekLastMonth.tr}(*)",
                        style: kHeaderTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // _buildPieChart(salePlayRatio),
                  Expanded(child: CustomThreeRatio(threeRatio: threeRatio)),
                ],
              ),
            ),
          ),
        ),
        // 线图
        ResponsiveGridCol(
          xs: 12,
          sm: 12,
          md: 12,
          lg: 12,
          xl: 12,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              clipBehavior: Clip.antiAlias,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    color: kHeaderBlue,
                    padding: EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Text(
                        "${LocaleKeys.thisMonthSale.tr}(*)",
                        style: kHeaderTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // _buildPieChart(salePlayRatio),
                  Expanded(child: CustomLineChart(lineChartData: monthEverySale)),
                ],
              ),
            ),
          ),
        ),
        // top5销售数量
        ResponsiveGridCol(
          xs: 12,
          sm: 6,
          md: 6,
          lg: 6,
          xl: 6,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              clipBehavior: Clip.antiAlias,
              height: 350,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    color: kHeaderBlue,
                    padding: EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Text(
                        "Top5 ${LocaleKeys.saleQty.tr}(*)",
                        style: kHeaderTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // _buildPieChart(salePlayRatio),
                  Expanded(child: _buildTopSaleQty(topSaleQty)),
                ],
              ),
            ),
          ),
        ),
        // top5销售金额
        ResponsiveGridCol(
          xs: 12,
          sm: 6,
          md: 6,
          lg: 6,
          xl: 6,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              clipBehavior: Clip.antiAlias,
              height: 350,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    color: kHeaderBlue,
                    padding: EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Text(
                        "Top5 ${LocaleKeys.saleAmount.tr}(*)",
                        style: kHeaderTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // _buildPieChart(salePlayRatio),
                  Expanded(child: _buildTopSaleAmount(topSaleAmount)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // top5销售数量
  Widget _buildTopSaleQty(List<TopSaleQty>? topSaleQty) {
    if (topSaleQty == null || topSaleQty.isEmpty) {
      return Center(child: Text(LocaleKeys.noRecordFound.tr, style: TextStyle(fontSize: 16)));
    } else {
      final ScrollController horizontalScrollController = ScrollController();
      final ScrollController verticalScrollController = ScrollController();
      return Scrollbar(
        thumbVisibility: true, // 显示水平滚动条
        controller: horizontalScrollController,
        notificationPredicate: (_) => true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: horizontalScrollController,
          child: Scrollbar(
            thumbVisibility: true, // 显示垂直滚动条
            controller: verticalScrollController,
            notificationPredicate: (_) => true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: verticalScrollController,
              child: DataTable(
                columns: [
                  DataColumn(label: Text("#")),
                  DataColumn(label: Text(LocaleKeys.name.tr)),
                  DataColumn(label: Text(LocaleKeys.qty.tr)),
                  DataColumn(label: Text(LocaleKeys.unitPrice.tr)),
                  DataColumn(label: Text(LocaleKeys.amount.tr)),
                  DataColumn(label: Text(LocaleKeys.stockQty.tr)),
                ],
                rows: [
                  for (var entry in topSaleQty.asMap().entries)
                    DataRow(
                      cells: [
                        DataCell(Text("${entry.key + 1}")),
                        DataCell(Text(entry.value.mDesc1 ?? "")),
                        DataCell(Text(double.parse(entry.value.mQty ?? "0").toStringAsFixed(2))),
                        DataCell(Text(double.parse(entry.value.mPrice ?? "0").toStringAsFixed(2))),
                        DataCell(
                          Text(
                            (double.parse(entry.value.mQty ?? "0") * double.parse(entry.value.mPrice ?? "0"))
                                .toStringAsFixed(2),
                          ),
                        ),
                        DataCell(Text(double.parse(entry.value.mSQty ?? "0").toStringAsFixed(2))),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  // top5销售金额
  Widget _buildTopSaleAmount(List<TopSaleAmount>? topSaleAmount) {
    if (topSaleAmount == null || topSaleAmount.isEmpty) {
      return Center(child: Text(LocaleKeys.noRecordFound.tr, style: TextStyle(fontSize: 16)));
    } else {
      final ScrollController horizontalScrollController = ScrollController();
      final ScrollController verticalScrollController = ScrollController();
      return Scrollbar(
        thumbVisibility: true, // 显示水平滚动条
        controller: horizontalScrollController,
        notificationPredicate: (_) => true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: horizontalScrollController,
          child: Scrollbar(
            thumbVisibility: true, // 显示垂直滚动条
            controller: verticalScrollController,
            notificationPredicate: (_) => true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: verticalScrollController,
              child: DataTable(
                columns: [
                  DataColumn(label: Text("#")),
                  DataColumn(label: Text(LocaleKeys.name.tr)),
                  DataColumn(label: Text(LocaleKeys.amount.tr)),
                  DataColumn(label: Text(LocaleKeys.unitPrice.tr)),
                  DataColumn(label: Text(LocaleKeys.qty.tr)),
                  DataColumn(label: Text(LocaleKeys.stockQty.tr)),
                ],
                rows: [
                  for (var entry in topSaleAmount.asMap().entries)
                    DataRow(
                      cells: [
                        DataCell(Text("${entry.key + 1}")),
                        DataCell(Text(entry.value.mDesc1 ?? "")),
                        DataCell(Text(double.parse(entry.value.mAmount ?? "0").toStringAsFixed(2))),
                        DataCell(Text(double.parse(entry.value.mPrice ?? "0").toStringAsFixed(2))),
                        DataCell(Text(double.parse(entry.value.qty ?? "0").toStringAsFixed(2))),
                        DataCell(Text(double.parse(entry.value.mSQty ?? "0").toStringAsFixed(2))),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
