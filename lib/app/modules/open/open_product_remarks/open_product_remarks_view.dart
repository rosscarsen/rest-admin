import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/form_help.dart';
import '../../../utils/progress_hub.dart';
import '../../../widgets/custom_cell.dart';
import '../../../widgets/data_grid_theme.dart';
import '../../../widgets/data_pager.dart';
import '../../../widgets/no_record.dart';
import 'open_product_remarks_controller.dart';

class OpenProductRemarksView extends GetView<OpenProductRemarksController> {
  const OpenProductRemarksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.selectProductRemarks.tr),
        centerTitle: true,
        actions: [IconButton(onPressed: () => controller.reloadData(), icon: Icon(Icons.refresh))],
      ),
      body: Column(
        spacing: Config.defaultGap,
        children: <Widget>[
          _buildSearch(context),
          Expanded(
            child: GetX<OpenProductRemarksController>(
              init: OpenProductRemarksController(),
              builder: (_) {
                return ProgressHUD(child: controller.isLoading.value ? null : _buildDataGrid(context));
              },
            ),
          ),
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
      ).paddingAll(Config.defaultPadding),
    );
  }

  //数据表格
  Widget _buildDataGrid(BuildContext context) {
    return DataGridTheme(
      child: SfDataGrid(
        isScrollbarAlwaysShown: true,
        controller: controller.dataGridController,
        footerFrozenColumnsCount: 0,
        frozenColumnsCount: 2,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
        columnSizer: ColumnSizer(),
        allowSorting: false,
        showCheckboxColumn: false,
        source: controller.dataSource,
        columns: <GridColumn>[
          GridColumn(
            columnName: "m_id",
            visible: false,
            label: CustomCell(data: "ID"),
          ),
          GridColumn(
            columnName: 'select',
            label: CustomCell(data: LocaleKeys.select.tr),
            width: 85,
          ),
          GridColumn(
            columnName: "sort",
            label: CustomCell(data: LocaleKeys.sort.tr),
          ),
          GridColumn(
            columnName: 'remarks',
            label: CustomCell(data: LocaleKeys.remarks.tr),
            columnWidthMode: ColumnWidthMode.fitByCellValue,
            maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
          ),
          GridColumn(
            columnName: 'detail',
            label: CustomCell(data: LocaleKeys.detail.tr),
            columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.fitByCellValue : ColumnWidthMode.fill,
            maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
            minimumWidth: 200,
          ),
        ],
        placeholder: NoRecordPermission(),
      ),
    );
  }

  //搜索框
  Widget _buildSearch(BuildContext context) {
    return FormHelper.buildGridRow(
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
    );
  }
}
