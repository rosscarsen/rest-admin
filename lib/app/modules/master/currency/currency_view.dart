import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/data_grid_theme.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/form_help.dart';
import '../../../utils/progress_hub.dart';
import '../../../widgets/custom_cell.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/data_pager.dart';
import '../../../widgets/no_record.dart';
import 'currency_controller.dart';

class CurrencyView extends GetView<CurrencyController> {
  const CurrencyView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      route: Routes.CURRENCY,
      title: LocaleKeys.currency.tr,
      actions: [
        Tooltip(
          message: LocaleKeys.refresh.tr,
          child: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.hasPermission ? () => controller.reloadData() : null,
          ),
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
              name: "search",
              labelText: LocaleKeys.keyWord.tr,
              onSubmitted: (value) => controller.reloadData(),
              suffixIcon: TextButton(
                onPressed: controller.hasPermission ? () => controller.reloadData() : null,
                child: Text(LocaleKeys.search.tr),
              ),
            ),
          ),
          //按钮
          FormHelper.buildGridCol(
            sm: 6,
            md: 8,
            lg: 8,
            xl: 8,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: controller.hasPermission ? () => controller.edit() : null,
                child: Text(LocaleKeys.add.tr),
              ),
            ).paddingSymmetric(vertical: 2.0).paddingOnly(left: context.isPhoneOrLess ? 0 : 5),
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
            columnName: "mCode",
            label: CustomCell(data: LocaleKeys.code.tr),
          ),
          GridColumn(
            columnName: 'mDescription',
            label: CustomCell(data: LocaleKeys.description.tr),
            columnWidthMode: ColumnWidthMode.fill,
            minimumWidth: 100,
          ),
          GridColumn(
            columnName: 'mRate',
            label: CustomCell(data: LocaleKeys.rate.tr),
            columnWidthMode: ColumnWidthMode.fill,
            minimumWidth: 100,
          ),
          GridColumn(
            columnName: 'mDefault',
            label: CustomCell(data: LocaleKeys.defaultSet.tr),
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
