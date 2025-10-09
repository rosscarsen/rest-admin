import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../config.dart';
import '../../routes/app_pages.dart';
import '../../translations/locale_keys.dart';
import '../../utils/form_help.dart';
import '../../utils/progress_hub.dart';
import '../../widgets/custom_cell.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/data_grid_theme.dart';
import '../../widgets/data_pager.dart';
import '../../widgets/no_record.dart';
import 'supplier_invoice_controller.dart';

class SupplierInvoiceView extends GetView<SupplierInvoiceController> {
  const SupplierInvoiceView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: LocaleKeys.supplierInvoice.tr,
      route: Routes.SUPPLIER_INVOICE,
      actions: [
        Tooltip(
          message: LocaleKeys.refresh.tr,
          child: IconButton(icon: const Icon(Icons.refresh), onPressed: () => controller.reloadData()),
        ),
      ],
      body: Obx(() {
        return Column(
          spacing: Config.defaultGap,
          children: <Widget>[
            _buildToolBar(context),
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

  //toolbar
  Widget _buildToolBar(BuildContext context) {
    return FormBuilder(
      key: controller.formKey,
      child: FormHelper.buildGridRow(
        children: [
          //关键字
          FormHelper.buildGridCol(
            child: FormHelper.textInput(
              enabled: controller.hasPermission,
              name: "mCode",
              labelText: LocaleKeys.code.tr,
              onSubmitted: (value) => controller.reloadData(),
            ),
          ),
          //开始日期
          FormHelper.buildGridCol(
            child: FormHelper.dateInput(
              name: "startDate",
              labelText: LocaleKeys.startDate.tr,
              enabled: controller.hasPermission,
              onChanged: (value) => controller.reloadData(),
            ),
          ),
          //结束日期
          FormHelper.buildGridCol(
            child: FormHelper.dateInput(
              name: "endDate",
              labelText: LocaleKeys.endDate.tr,
              enabled: controller.hasPermission,
              onChanged: (value) => controller.reloadData(),
            ),
          ),
          //其它
          FormHelper.buildGridCol(
            child: FormHelper.textInput(
              enabled: controller.hasPermission,
              name: "other",
              labelText: LocaleKeys.other.tr,
              onSubmitted: (value) => controller.reloadData(),
            ),
          ),

          //按钮
          FormHelper.buildGridCol(
            sm: 12,
            md: 8,
            lg: 8,
            xl: 8,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.end,
              spacing: 5,
              runSpacing: 5,
              children: [
                //搜索
                ElevatedButton(
                  onPressed: controller.hasPermission ? () => controller.reloadData() : null,
                  child: Text(LocaleKeys.search.tr),
                ),
                //新增
                ElevatedButton(
                  onPressed: controller.hasPermission ? () => controller.edit() : null,
                  child: Text(LocaleKeys.add.tr),
                ),
              ],
            ).paddingSymmetric(vertical: 2.0).paddingOnly(left: context.isPhoneOrLess ? 0 : 5),
          ),
        ],
      ),
    );
  }

  //数据表格
  Widget _buildDataGrid(BuildContext context) {
    return DataGridTheme(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SfDataGrid(
          isScrollbarAlwaysShown: true,
          controller: controller.dataGridController,
          footerFrozenColumnsCount: 1,
          frozenColumnsCount: 0,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
          showCheckboxColumn: false,
          selectionMode: SelectionMode.none,
          source: controller.dataSource,
          columns: <GridColumn>[
            GridColumn(
              columnName: 'mSupplierInvoiceInNo',
              label: CustomCell(data: LocaleKeys.receiptNo.tr),
              columnWidthMode: ColumnWidthMode.fill,
              minimumWidth: 150,
            ),
            GridColumn(
              columnName: 'mRevised',
              label: CustomCell(data: LocaleKeys.revised.tr),
            ),
            GridColumn(
              columnName: 'mSupplierInvoiceInDate',
              label: CustomCell(data: LocaleKeys.date.tr),
            ),
            GridColumn(
              columnName: 'mMoneyCurrency',
              label: CustomCell(data: LocaleKeys.currency.tr),
            ),
            GridColumn(
              columnName: 'mAmount',
              label: CustomCell(data: LocaleKeys.amount.tr),
            ),
            GridColumn(
              columnName: 'mSupplierCode',
              label: CustomCell(data: LocaleKeys.supplierCode.tr),
            ),
            GridColumn(
              columnName: 'mSupplierName',
              label: CustomCell(data: LocaleKeys.supplierName.tr),
            ),
            GridColumn(
              columnName: 'mFlag',
              label: CustomCell(data: LocaleKeys.flag.tr),
            ),
            GridColumn(
              allowSorting: false,
              columnName: 'actions',
              width: context.isPhoneOrWider ? 160 : 60,
              label: CustomCell(data: LocaleKeys.operation.tr),
            ),
          ],
          placeholder: NoRecordPermission(
            msg: controller.hasPermission ? LocaleKeys.noRecordFound.tr : LocaleKeys.noPermission.tr,
          ),
        ),
      ),
    );
  }
}
