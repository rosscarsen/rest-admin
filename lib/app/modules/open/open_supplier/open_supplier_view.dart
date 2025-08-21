import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/progresshub.dart';
import '../../../widgets/custom_cell.dart';
import '../../../widgets/data_grid_theme.dart';
import '../../../widgets/data_pager.dart';
import '../../../widgets/no_record.dart';
import 'open_supplier_controller.dart';

class OpenSupplierView extends GetView<OpenSupplierController> {
  const OpenSupplierView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.selectSupplier.tr),
        centerTitle: true,
        actions: [IconButton(onPressed: () => controller.reloadData(), icon: Icon(Icons.refresh))],
      ),
      body: Column(
        spacing: Config.defaultGap,
        children: <Widget>[
          _buildSearch(context),
          Expanded(
            child: GetX<OpenSupplierController>(
              init: OpenSupplierController(),
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
    return DataGridTheme(
      child: SfDataGrid(
        isScrollbarAlwaysShown: true,
        controller: controller.dataGridController,
        footerFrozenColumnsCount: 0,
        frozenColumnsCount: 3,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columnWidthMode: controller.dataSource.rows.isEmpty
            ? context.isPhoneOrLess
                  ? ColumnWidthMode.fitByColumnName
                  : ColumnWidthMode.fill
            : ColumnWidthMode.auto,
        columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
        columnSizer: ColumnSizer(),
        allowSorting: false,
        showCheckboxColumn: false,
        source: controller.dataSource,
        columns: <GridColumn>[
          GridColumn(
            columnName: "T_Supplier_ID",
            visible: false,
            label: CustomCell(data: "ID"),
          ),
          GridColumn(
            columnName: 'select',
            label: CustomCell(data: LocaleKeys.select.tr),
            width: 85,
          ),
          GridColumn(
            columnName: "code",
            label: CustomCell(data: LocaleKeys.code.tr),
          ),
          GridColumn(
            columnName: 'simpleName',
            label: CustomCell(data: LocaleKeys.simpleName.tr),
            columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.auto : ColumnWidthMode.fill,
            maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
            minimumWidth: 200,
          ),
          GridColumn(
            columnName: 'fullName',
            label: CustomCell(data: LocaleKeys.fullName.tr),
            columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.fitByCellValue : ColumnWidthMode.fill,
            maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
            minimumWidth: 200,
          ),
          GridColumn(
            columnName: 'mobile',
            label: CustomCell(data: LocaleKeys.mobile.tr),
          ),
          GridColumn(
            columnName: 'fax',
            label: CustomCell(data: LocaleKeys.fax.tr),
          ),
        ],
        placeholder: NoRecordPermission(),
      ),
    );
  }

  //搜索框
  Widget _buildSearch(BuildContext context) {
    return ResponsiveGridRow(
      children: [
        ResponsiveGridCol(
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
