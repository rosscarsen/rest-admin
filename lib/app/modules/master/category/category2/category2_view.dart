import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../config.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/progress_hub.dart';
import '../../../../widgets/custom_cell.dart';
import '../../../../widgets/data_grid_theme.dart';
import '../../../../widgets/data_pager.dart';
import '../../../../widgets/no_record.dart';
import 'category2_controller.dart';

class Category2View extends GetView<Category2Controller> {
  const Category2View({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${LocaleKeys.category.tr}2"),
        centerTitle: true,
        actions: [
          Tooltip(
            message: LocaleKeys.refresh.tr,
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: controller.hasPermission ? () => controller.reloadData() : null,
            ),
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          spacing: Config.defaultGap,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(onPressed: () => controller.edit(), child: Text(LocaleKeys.add.tr)),
            ),
            Expanded(child: ProgressHUD(child: controller.isLoading ? null : _buildDataGrid(context))),
            DataPager(
              totalPages: controller.totalPages,
              totalRecords: controller.totalRecords,
              currentPage: controller.currentPage,
              onPageChanged: (int pageNumber) {
                controller.currentPage = pageNumber;
                controller.updateDataGridSource();
              },
            ),
          ],
        ).paddingAll(Config.defaultPadding);
      }),
    );
  }

  //数据表格
  Widget _buildDataGrid(BuildContext context) {
    return DataGridTheme(
      child: SfDataGrid(
        isScrollbarAlwaysShown: true,
        controller: controller.dataGridController,
        footerFrozenColumnsCount: 1,
        frozenColumnsCount: 0,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columnWidthMode: ColumnWidthMode.auto,
        columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
        showCheckboxColumn: false,
        selectionMode: SelectionMode.none,
        source: controller.dataSource,
        columns: <GridColumn>[
          GridColumn(
            columnName: 'mSort',
            label: CustomCell(data: LocaleKeys.sort.tr),
          ),
          GridColumn(
            columnName: 'mCategory',
            label: CustomCell(data: LocaleKeys.category.tr),
          ),
          GridColumn(
            columnName: 'mParent',
            label: CustomCell(data: LocaleKeys.parentCategory.tr),
          ),
          GridColumn(
            columnName: 'mDescription',
            label: CustomCell(data: LocaleKeys.description.tr),
            columnWidthMode: ColumnWidthMode.fill,
            minimumWidth: 150,
          ),
          GridColumn(
            columnName: 'mTimeStart',
            label: CustomCell(data: LocaleKeys.startTime.tr),
          ),
          GridColumn(
            columnName: 'mTimeEnd',
            label: CustomCell(data: LocaleKeys.endTime.tr),
          ),
          GridColumn(
            columnName: 'mHide',
            label: CustomCell(data: LocaleKeys.deactivate.tr),
          ),
          GridColumn(
            columnName: 'mPrinter',
            label: CustomCell(data: LocaleKeys.kitchenBarPrinter.tr),
          ),
          GridColumn(
            columnName: 'mBDLPrinter',
            label: CustomCell(data: LocaleKeys.BDLPrinter.tr),
          ),
          GridColumn(
            columnName: 'mContinue',
            label: CustomCell(data: LocaleKeys.continuePrint.tr),
          ),
          GridColumn(
            columnName: 'mCustomerSelfHelpHide',
            label: CustomCell(data: LocaleKeys.customerHide.tr),
          ),
          GridColumn(
            allowSorting: false,
            columnName: 'actions',
            width: 80,
            label: CustomCell(data: LocaleKeys.operation.tr),
          ),
        ],
        placeholder: NoRecordPermission(
          msg: controller.hasPermission ? LocaleKeys.noRecordFound.tr : LocaleKeys.noPermission.tr,
        ),
      ),
    );
  }
}
