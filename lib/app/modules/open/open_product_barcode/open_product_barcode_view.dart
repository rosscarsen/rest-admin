import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/form_help.dart';
import '../../../utils/progress_hub.dart';
import '../../../widgets/custom_cell.dart';
import '../../../theme/data_grid_theme.dart';
import '../../../widgets/data_pager.dart';
import '../../../widgets/no_record.dart';
import 'open_product_barcode_controller.dart';

class OpenProductBarcodeView extends GetView<OpenProductBarcodeController> {
  const OpenProductBarcodeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.selectProductBarcode.tr),
        centerTitle: true,
        actions: [IconButton(onPressed: () => controller.reloadData(), icon: Icon(Icons.refresh))],
      ),
      body: Column(
        spacing: Config.defaultGap,
        children: <Widget>[
          _buildSearch(context),
          Expanded(
            child: GetX<OpenProductBarcodeController>(
              init: OpenProductBarcodeController(),
              builder: (_) {
                return ProgressHUD(child: controller.isLoading ? null : _buildDataGrid(context));
              },
            ),
          ),
          Obx(
            () => DataPager(
              totalPages: controller.totalPages,
              totalRecords: controller.totalRecords,
              currentPage: controller.currentPage,
              onPageChanged: (int pageNumber) {
                controller.currentPage = pageNumber;
                controller.updateDataGridSource();
              },
            ),
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
            columnName: "barcode",
            label: CustomCell(data: LocaleKeys.barcode.tr),
          ),
          GridColumn(
            columnName: 'code',
            label: CustomCell(data: LocaleKeys.code.tr),

            //maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
          ),

          GridColumn(
            columnName: 'name',
            label: CustomCell(data: LocaleKeys.name.tr),
            columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.auto : ColumnWidthMode.fill,
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
