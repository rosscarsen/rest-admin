import 'package:fl_chart/fl_chart.dart';
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
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
    return CustomScaffold(
      route: Routes.DASHBOARD,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          /* onPressed: () {
            final StorageManage storageManage = StorageManage();
            storageManage.erase();
          }, */
          onPressed: controller.hasPermission.value ? () => controller.getChartData() : null,
        ),
      ],
      body: Padding(
        padding: EdgeInsets.all(Config.defaultPadding),
        child: Column(
          children: [
            FormBuilder(
              key: formKey,
              child: ResponsiveGridRow(
                children: [
                  FormHelper.dateInput(
                    name: "startDate",
                    labelText: LocaleKeys.startDate.tr,
                    initialValue: DateTime.now().subtract(const Duration(days: 7)),
                    enabled: false,
                  ),
                  FormHelper.dateInput(
                    name: "endDate",
                    labelText: LocaleKeys.endDate.tr,
                    initialValue: DateTime.now().subtract(const Duration(days: 1)),
                    canClear: false,
                    onChanged: (String? value) {
                      if (value != null) {
                        final formatter = DateFormat('yyyy-MM-dd');
                        final endDate = DateTime.parse(value);
                        final startDate = endDate.subtract(Duration(days: 6));
                        formKey.currentState?.fields['startDate']?.didChange(formatter.format(startDate));
                      } else {
                        formKey.currentState?.fields['startDate']?.didChange(null);
                      }
                    },
                  ),
                  ResponsiveGridCol(
                    xs: 12,
                    sm: 6,
                    md: 3,
                    lg: 3,
                    xl: 4,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 44),
                      child: Align(
                        alignment: context.isPhoneOrLess ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: context.isPhoneOrLess
                              ? EdgeInsets.zero
                              : EdgeInsets.only(left: Config.defaultPadding),
                          child: ElevatedButton(
                            child: Text(LocaleKeys.search.tr),
                            onPressed: () {
                              formKey.currentState?.saveAndValidate();
                              controller.search.addAll(formKey.currentState!.value);
                              controller.getChartData();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildContent(),
          ],
        ),
      ),
      title: LocaleKeys.salesView.tr,
    );
  }

  // 构建内容
  Widget _buildContent() {
    return Expanded(child: Obx(() => ProgressHUD(child: controller.isLoading.value ? null : _buildChart())));
  }

  // 构建图表
  Widget _buildChart() {
    final apiResult = controller.apiResult;
    final salePlayRatio = apiResult.value.salePlayRatio;
    /*  final sevenSale = apiResult.value.sevenSale;
    final threeRatio = apiResult.value.threeRatio;
    final monthEverySale = apiResult.value.monthEverySale;
    final topSaleQty = apiResult.value.topSaleQty;
    final topSaleAmount = apiResult.value.topSaleAmount; */
    return SingleChildScrollView(
      child: ResponsiveGridRow(
        children: [
          ResponsiveGridCol(
            xs: 12,
            sm: 4,
            md: 4,
            lg: 4,
            xl: 4,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 260, minWidth: 260),
              child: CustomPieChart(pieChartData: salePlayRatio),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            sm: 4,
            md: 4,
            lg: 4,
            xl: 4,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 200),
              child: Container(color: Colors.blue),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            sm: 4,
            md: 4,
            lg: 4,
            xl: 4,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 200),
              child: Container(color: Colors.green),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            sm: 12,
            md: 12,
            lg: 12,
            xl: 12,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 200),
              child: Container(color: Colors.amber),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            sm: 6,
            md: 6,
            lg: 6,
            xl: 6,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 200),
              child: Container(color: Colors.blue),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            sm: 6,
            md: 6,
            lg: 6,
            xl: 6,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 200),
              child: Container(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPieChart extends StatefulWidget {
  const CustomPieChart({super.key, required this.pieChartData});
  final List<SalePlayRatio>? pieChartData;

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<CustomPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final List<SalePlayRatio>? pieChartData = widget.pieChartData;

    return pieChartData?.isEmpty ?? true
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.thumb_down_alt_outlined, size: 30),
                SizedBox(height: 8),
                Text(LocaleKeys.noRecordFound.tr, style: TextStyle(fontSize: 16)),
              ],
            ),
          )
        : AspectRatio(
            aspectRatio: 1.0,
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                /*  PieChartData(sections: pieChartData.map(toElement)), */
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
          );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 90.0 : 80.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.black,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.blue,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.cyan,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.deepOrangeAccent,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: isSquare ? BoxShape.rectangle : BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        ),
      ],
    );
  }
}
