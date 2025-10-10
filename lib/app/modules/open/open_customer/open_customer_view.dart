import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
import 'open_customer_controller.dart';

class OpenCustomerView extends GetView<OpenCustomerController> {
  const OpenCustomerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.choiceParam.trArgs([LocaleKeys.customer.tr])), centerTitle: true),
      body: Obx(() {
        return Column(
          spacing: Config.defaultGap,
          children: <Widget>[
            _buildToolBar(context),
            Expanded(child: ProgressHUD(child: controller.isLoading ? null : _buildDataGrid(context))),
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
              name: "keyword",
              labelText: LocaleKeys.keyWord.tr,
              onSubmitted: (value) => controller.reloadData(),
              suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: () => controller.reloadData()),
            ),
          ),
        ],
      ),
    );
  }

  //数据表格
  Widget _buildDataGrid(BuildContext context) {
    return DataGridTheme(
      child: SfDataGrid(
        isScrollbarAlwaysShown: true,
        controller: controller.dataGridController,
        footerFrozenColumnsCount: 0,
        frozenColumnsCount: 0,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
        columnWidthMode: ColumnWidthMode.auto,
        showCheckboxColumn: false,
        selectionMode: SelectionMode.none,
        source: controller.dataSource,
        columns: <GridColumn>[
          GridColumn(
            columnName: 'select',
            label: CustomCell(data: LocaleKeys.select.tr),
            width: 85,
          ),
          GridColumn(
            columnName: 'mCode',
            label: CustomCell(data: LocaleKeys.code.tr),
          ),
          GridColumn(
            columnName: 'mSimpleName',
            label: CustomCell(data: LocaleKeys.simpleName.tr),
            columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.auto : ColumnWidthMode.fill,
          ),
          GridColumn(
            columnName: 'mFullName',
            label: CustomCell(data: LocaleKeys.fullName.tr),
            columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.auto : ColumnWidthMode.fill,
          ),
          GridColumn(
            columnName: 'mPhoneNo',
            label: CustomCell(data: LocaleKeys.mobile.tr),
          ),
          GridColumn(
            columnName: 'mFaxNo',
            label: CustomCell(data: LocaleKeys.fax.tr),
          ),
          GridColumn(
            columnName: 'mStDiscount',
            label: CustomCell(data: LocaleKeys.discount.tr),
          ),
        ],
        placeholder: NoRecordPermission(msg: LocaleKeys.noRecordFound.tr),
      ),
    );
  }
}
