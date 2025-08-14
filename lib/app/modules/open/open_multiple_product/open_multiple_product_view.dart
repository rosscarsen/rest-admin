import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/form_help.dart';
import '../../../utils/progresshub.dart';
import '../../../widgets/custom_cell.dart';
import '../../../widgets/data_pager.dart';
import '../../../widgets/no_record.dart';
import 'open_multiple_product_controller.dart';

class OpenMultipleProductView extends GetView<OpenMultipleProductController> {
  const OpenMultipleProductView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.selectProduct.tr),
        centerTitle: true,
        actions: [IconButton(onPressed: () => controller.reloadData(), icon: Icon(Icons.refresh))],
      ),
      body: Column(
        spacing: Config.defaultGap,
        children: <Widget>[
          _buildSearch(context),
          if (Get.parameters["isShowOption"] != null)
            ResponsiveGridRow(
              children: [
                FormHelper.buildGridCol(
                  child: FormHelper.selectInput(
                    labelText: LocaleKeys.option.tr,
                    name: "mStep",
                    initialValue: "1",
                    items: List.generate(
                      9,
                      (index) => DropdownMenuItem(value: (index + 1).toString(), child: Text((index + 1).toString())),
                    ),
                    onChanged: (value) {
                      controller.mStep = value ?? "1";
                    },
                  ),
                ),
              ],
            ),
          Expanded(
            child: GetX<OpenMultipleProductController>(
              init: OpenMultipleProductController(),
              builder: (_) {
                return ProgressHUD(child: controller.isLoading.value ? null : _buildDataGrid(context));
              },
            ),
          ),
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
      ).paddingAll(Config.defaultPadding),
    );
  }

  //数据表格
  Widget _buildDataGrid(BuildContext context) {
    return SelectionArea(
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
          showCheckboxColumn: true,
          selectionMode: SelectionMode.multiple,
          source: controller.dataSource,
          stackedHeaderRows: [
            StackedHeaderRow(
              cells: [
                StackedHeaderCell(
                  columnNames: ['code', 'name', 'unit', 'category', 'price', "qty"],
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: OverflowBar(
                      spacing: 8.0,
                      children: [
                        ElevatedButton(
                          child: Text(LocaleKeys.join.tr),
                          onPressed: () async => await controller.joinSetMeal(),
                        ),
                        ElevatedButton(
                          child: Text(LocaleKeys.leave.tr),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ],
                    ).paddingOnly(left: 8.0),
                  ),
                ),
              ],
            ),
          ],
          columns: <GridColumn>[
            GridColumn(
              columnName: "code",
              label: CustomCell(data: LocaleKeys.code.tr),
            ),
            GridColumn(
              columnName: 'name',
              columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.auto : ColumnWidthMode.fill,
              maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
              label: CustomCell(data: LocaleKeys.name.tr),
            ),
            GridColumn(
              columnName: 'unit',
              label: CustomCell(data: LocaleKeys.unit.tr),
            ),
            GridColumn(
              columnName: 'category',
              label: CustomCell(data: LocaleKeys.category.tr),
            ),
            GridColumn(
              columnName: 'price',
              label: CustomCell(data: LocaleKeys.price.tr),
            ),
            GridColumn(
              columnName: 'qty',
              label: CustomCell(data: LocaleKeys.qty.tr),
            ),
          ],
          placeholder: NoRecordPermission(),
        ),
      ),
    );
  }

  //搜索框
  Widget _buildSearch(BuildContext context) {
    return Obx(
      () => Skeletonizer(
        enabled: controller.isLoading.value,
        child: FormBuilder(
          key: controller.openMultipleProductFormKey,
          child: ResponsiveGridRow(
            children: [
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: "search", labelText: LocaleKeys.keyWord.tr),
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
      ),
    );
  }
}
