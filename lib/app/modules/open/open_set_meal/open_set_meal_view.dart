import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/form_help.dart';
import '../../../utils/progress_hub.dart';
import '../../../widgets/custom_cell.dart';
import '../../../widgets/data_pager.dart';
import '../../../widgets/no_record.dart';
import 'open_set_meal_controller.dart';

class OpenSetMealView extends GetView<OpenSetMealController> {
  const OpenSetMealView({super.key});
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.selectSetMeal.tr),
        centerTitle: true,
        actions: [IconButton(onPressed: () => controller.reloadData(), icon: Icon(Icons.refresh))],
      ),
      body: GetX<OpenSetMealController>(
        init: OpenSetMealController(),
        builder: (controller) {
          return Column(
            spacing: Config.defaultGap,
            children: <Widget>[
              _buildSearch(context, controller),
              Expanded(child: _buildDataGrid(context, controller)),
              DataPager(
                totalPages: controller.totalPages,
                currentPage: controller.currentPage,
                totalRecords: controller.totalRecords,
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
  Widget _buildDataGrid(BuildContext context, OpenSetMealController controller) {
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
                  columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                  columnSizer: ColumnSizer(),
                  allowSorting: false,
                  showCheckboxColumn: false,
                  source: controller.dataSource,
                  columns: <GridColumn>[
                    GridColumn(
                      columnName: 'select',
                      label: CustomCell(data: LocaleKeys.select.tr),
                      width: 85,
                    ),
                    GridColumn(
                      columnName: "mCode",
                      label: CustomCell(data: LocaleKeys.code.tr),
                    ),
                    GridColumn(
                      columnName: 'mDesc',
                      label: CustomCell(data: LocaleKeys.name.tr),
                    ),
                    GridColumn(
                      columnName: 'detail',
                      label: CustomCell(data: LocaleKeys.detail.tr),
                      columnWidthMode: ColumnWidthMode.fill,
                    ),
                  ],
                  placeholder: NoRecordPermission(),
                ),
              ),
            ),
    );
  }

  //搜索框
  Widget _buildSearch(BuildContext context, OpenSetMealController controller) {
    return Skeletonizer(
      enabled: controller.isLoading.value,
      child: FormHelper.buildGridRow(
        children: [
          FormHelper.buildGridCol(
            xs: 12,
            sm: 6,
            md: 4,
            lg: 3,
            xl: 2,
            child: TextField(
              controller: controller.searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => controller.reloadData(),
              decoration: InputDecoration(
                hintText: LocaleKeys.keyWord.tr,

                suffixIcon: TextButton(onPressed: () => controller.reloadData(), child: Text(LocaleKeys.search.tr)),
              ),
            ).paddingSymmetric(vertical: 2.0),
          ),
        ],
      ),
    );
  }
}
