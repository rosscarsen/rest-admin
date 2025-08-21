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
import 'open_product_controller.dart';

class OpenProductView extends GetView<OpenProductController> {
  const OpenProductView({super.key});
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
          Expanded(
            child: GetX<OpenProductController>(
              init: OpenProductController(),
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
        columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
        allowSorting: false,
        showCheckboxColumn: false,
        source: controller.dataSource,
        columns: <GridColumn>[
          GridColumn(
            columnName: "T_Product_ID",
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
            columnName: 'name',
            columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.auto : ColumnWidthMode.fill,
            maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
            minimumWidth: 200,
            label: CustomCell(data: LocaleKeys.name.tr),
          ),
          GridColumn(
            columnName: 'mDesc2',
            columnWidthMode: ColumnWidthMode.fill,
            maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
            minimumWidth: 200,
            label: CustomCell(data: LocaleKeys.name.tr),
          ),
          GridColumn(
            columnName: 'mRemarks',
            columnWidthMode: ColumnWidthMode.fill,
            maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
            minimumWidth: 200,
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
          GridColumn(
            columnName: 'mMeasurement',
            label: CustomCell(data: LocaleKeys.productRemarks.tr),
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
