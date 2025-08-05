import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../config.dart';
import '../../../../../translations/locale_keys.dart';
import '../../../../../utils/form_help.dart';
import '../../../../../utils/progresshub.dart';
import '../../../../../widgets/custom_cell.dart';
import '../../../../../widgets/data_pager.dart';
import '../../../../../widgets/no_record.dart';
import 'copy_product_set_meal_controller.dart';

class CopyProductSetMealView extends GetView<CopyProductSetMealController> {
  const CopyProductSetMealView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.copySetMeal.tr),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: LocaleKeys.refresh.tr,
            icon: Icon(Icons.refresh),
            onPressed: () {
              controller.reloadData();
            },
          ),
        ],
      ),
      body: GetX<CopyProductSetMealController>(
        init: CopyProductSetMealController(),
        builder: (controller) {
          return Column(
            spacing: Config.defaultGap,
            children: <Widget>[
              _buildSearch(context, controller),
              Expanded(child: _buildDataGrid(context, controller)),
              DataPager(
                totalPages: controller.totalPages,
                totalRecords: controller.totalRecords,
                currentPage: controller.currentPage,
                onPageChanged: (int pageNumber) {
                  controller.currentPage.value = pageNumber;
                  controller.updateDataGridSource();
                },
              ),
            ],
          ).paddingAll(Config.defaultPadding);
        },
      ),
    );
  }

  //数据表格
  Widget _buildDataGrid(BuildContext context, CopyProductSetMealController controller) {
    return ProgressHUD(
      child: controller.isLoading.value
          ? null
          : SelectionArea(
              child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  gridLineColor: Colors.grey.shade300,
                  currentCellStyle: DataGridCurrentCellStyle(
                    borderColor: Colors.transparent, // 避免选中单元格边框影响
                    borderWidth: 0,
                  ),
                ),
                child: SfDataGrid(
                  isScrollbarAlwaysShown: true,
                  controller: controller.dataGridController,
                  footerFrozenColumnsCount: 0,
                  frozenColumnsCount: 1,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  columnWidthMode: controller.dataSource.rows.isEmpty
                      ? context.isPhoneOrLess
                            ? ColumnWidthMode.fitByColumnName
                            : ColumnWidthMode.fill
                      : ColumnWidthMode.auto,
                  columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                  allowSorting: false,
                  source: controller.dataSource,
                  columns: <GridColumn>[
                    GridColumn(
                      columnName: "select",
                      label: CustomCell(data: LocaleKeys.select.tr),
                    ),
                    GridColumn(
                      columnName: "mCode",
                      label: CustomCell(data: LocaleKeys.code.tr),
                    ),
                    GridColumn(
                      columnName: 'mDesc1',
                      columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.auto : ColumnWidthMode.fill,
                      maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
                      label: CustomCell(data: LocaleKeys.name.tr),
                      minimumWidth: 200,
                    ),
                    GridColumn(
                      columnName: 'mDesc2',
                      columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.auto : ColumnWidthMode.fill,
                      maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
                      minimumWidth: 200,
                      label: CustomCell(data: LocaleKeys.kitchenList.tr),
                    ),
                    GridColumn(
                      columnName: 'mRemarks',
                      columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.auto : ColumnWidthMode.fill,
                      maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
                      minimumWidth: 200,
                      label: CustomCell(data: LocaleKeys.keyName.tr),
                    ),
                    GridColumn(
                      columnName: 'unit',
                      label: CustomCell(data: LocaleKeys.unit.tr),
                    ),
                    GridColumn(
                      columnName: 'category1',
                      label: CustomCell(data: "${LocaleKeys.category.tr}1"),
                    ),
                    GridColumn(
                      columnName: 'category2',
                      label: CustomCell(data: "${LocaleKeys.category.tr}2"),
                    ),
                    GridColumn(
                      columnName: 'mMeasurement',
                      label: CustomCell(data: LocaleKeys.productRemarks.tr),
                    ),
                    GridColumn(
                      columnName: 'mPCode',
                      label: CustomCell(data: LocaleKeys.setMeal.tr),
                      columnWidthMode: ColumnWidthMode.fitByColumnName,
                    ),
                  ],
                  placeholder: NoRecord(),
                ),
              ),
            ),
    );
  }

  //搜索框
  Widget _buildSearch(BuildContext context, CopyProductSetMealController controller) {
    return Skeletonizer(
      enabled: controller.isLoading.value,
      child: FormBuilder(
        key: controller.formKey,
        child: ResponsiveGridRow(
          children: [
            FormHelper.buildGridCol(
              child: ValueListenableBuilder(
                valueListenable: controller.keyWordController,
                builder: (BuildContext context, TextEditingValue value, Widget? child) {
                  final hasText = value.text.isNotEmpty;
                  return FormHelper.textInput(
                    controller: controller.keyWordController,
                    name: "keyWord",
                    labelText: LocaleKeys.keyWord.tr,
                    suffixIcon: hasText
                        ? IconButton(
                            onPressed: () {
                              controller.keyWordController.clear();
                            },
                            icon: Icon(Icons.cancel),
                          )
                        : null,
                  );
                },
              ),
            ),
            //类目1
            FormHelper.buildGridCol(
              child: FormHelper.selectInput(
                name: "mCategory1",
                labelText: "${LocaleKeys.category.tr}1",
                items: [
                  DropdownMenuItem(value: "", child: Text("")),
                  if (controller.category1.isNotEmpty)
                    ...controller.category1.map(
                      (e) => DropdownMenuItem(
                        value: e.mCategory.toString(),
                        child: Row(
                          spacing: 8.0,
                          children: [
                            Text(e.mCategory.toString()),
                            Flexible(child: Text(e.mDescription.toString())),
                          ],
                        ),
                      ),
                    ),
                ],
                onChanged: (String? category1) {
                  controller.generateCategory2(category1);
                },
              ),
            ),
            //类目2
            FormHelper.buildGridCol(
              child: FormHelper.selectInput(
                name: "mCategory2",
                labelText: "${LocaleKeys.category.tr}2",
                items: [
                  DropdownMenuItem(value: "", child: Text("")),
                  if (controller.category2.isNotEmpty)
                    ...controller.category2.map(
                      (e) => DropdownMenuItem(
                        value: e.mCategory,
                        child: Row(
                          spacing: 8.0,
                          children: [
                            Text(e.mCategory.toString()),
                            Flexible(child: Text(e.mDescription.toString())),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // 搜索
            FormHelper.buildGridCol(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.reloadData();
                  },
                  label: Text(LocaleKeys.search.tr),
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
