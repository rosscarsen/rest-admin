import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/data_grid_theme.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/form_help.dart';
import '../../../utils/open_file_input.dart';
import '../../../utils/progress_hub.dart';
import '../../../widgets/custom_cell.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/data_pager.dart';
import '../../../widgets/no_record.dart';
import 'tables_controller.dart';

class TablesView extends GetView<TablesController> {
  const TablesView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      route: Routes.TABLES,
      title: LocaleKeys.tables.tr,
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
    return Skeletonizer(
      enabled: controller.isLoading,
      child: FormBuilder(
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
              ),
            ),
            //店铺编号
            FormHelper.buildGridCol(
              child: FormHelper.selectInput(
                enabled: controller.hasPermission,
                name: "mStockCode",
                labelText: LocaleKeys.paramCode.trArgs([LocaleKeys.stock.tr]),
                items: [
                  DropdownMenuItem(value: "", child: Text("")),
                  ...controller.allStock.map(
                    (e) => DropdownMenuItem(value: e.mCode, child: Text("${e.mCode ?? ""} ${e.mName ?? ""}")),
                  ),
                ],
                onChanged: (value) => controller.hasPermission ? controller.reloadData() : null,
              ),
            ),
            //区域
            FormHelper.buildGridCol(
              child: FormHelper.textInput(
                enabled: controller.hasPermission,
                name: "mLayer",
                labelText: LocaleKeys.district.tr,
                onSubmitted: (value) => controller.reloadData(),
              ),
            ),
            //按钮
            FormHelper.buildGridCol(
              sm: 12,
              md: 12,
              lg: 12,
              xl: 12,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.end,
                  spacing: 5,
                  runSpacing: 5,
                  children: _buildButtonChildren(controller.hasPermission),
                ).paddingSymmetric(vertical: 2.0).paddingOnly(left: context.isPhoneOrLess ? 0 : 5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建按钮子组件列表，便于复用
  List<Widget> _buildButtonChildren(bool hasPermission) {
    return [
      //查询
      ElevatedButton(
        onPressed: hasPermission ? () => controller.reloadData() : null,
        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0)),
        child: Text(LocaleKeys.search.tr),
      ),
      //导入
      ElevatedButton(
        onPressed: hasPermission ? () => _buildImport() : null,
        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0)),
        child: Text(LocaleKeys.import.tr),
      ),
      //导出
      ElevatedButton(
        onPressed: hasPermission ? () => controller.export() : null,
        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0)),
        child: Text(LocaleKeys.export.tr),
      ),
      //新增
      ElevatedButton(
        onPressed: hasPermission ? () => controller.edit() : null,
        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0)),
        child: Text(LocaleKeys.add.tr),
      ),
    ];
  }

  // 导入
  void _buildImport() async {
    final fileController = TextEditingController();
    File? excelFile;
    try {
      await Get.defaultDialog(
        barrierDismissible: false,
        title: LocaleKeys.importParam.trArgs([LocaleKeys.productRemarks.tr]),
        content: Column(
          spacing: 8.0,
          children: <Widget>[
            OpenFileInput(
              name: "file",
              labelText: LocaleKeys.selectFile.trArgs(["excel"]),
              controller: fileController,
              onFileSelected: (file) {
                excelFile = file;
              },
            ),
          ],
        ),
        cancel: ElevatedButton(
          onPressed: () {
            Get.closeDialog();
          },
          child: Text(LocaleKeys.cancel.tr),
        ),
        confirm: ElevatedButton(
          onPressed: () async {
            if (excelFile == null) {
              CustomDialog.showToast(LocaleKeys.pleaseSelectFile.tr);
              return;
            }
            Get.closeDialog();
            await controller.import(file: excelFile!);
            excelFile = null;
          },
          child: Text(LocaleKeys.confirm.tr),
        ),
      );
    } catch (e, stack) {
      debugPrint('Dialog error: $e\n$stack');
    } finally {
      fileController.dispose();
    }
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
        columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
        showCheckboxColumn: false,
        columnWidthMode: ColumnWidthMode.auto,
        selectionMode: SelectionMode.none,
        source: controller.dataSource,
        columns: <GridColumn>[
          GridColumn(
            columnName: 'mTableNo',
            label: CustomCell(data: LocaleKeys.tableNo.tr),
            columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.auto : ColumnWidthMode.fill,
          ),
          GridColumn(
            columnName: 'mTableName',
            label: CustomCell(data: LocaleKeys.tableName.tr),
          ),
          GridColumn(
            columnName: 'mLayer',
            label: CustomCell(data: LocaleKeys.district.tr),
          ),
          GridColumn(
            columnName: 'mStockCode',
            label: CustomCell(data: LocaleKeys.paramCode.trArgs([LocaleKeys.stock.tr])),
          ),
          GridColumn(
            columnName: 'mShape',
            label: CustomCell(data: LocaleKeys.shape.tr),
          ),
          GridColumn(
            columnName: 'mServCharge',
            label: CustomCell(data: LocaleKeys.serviceCharge.tr),
          ),
          GridColumn(
            columnName: 'mDiscount',
            label: CustomCell(data: LocaleKeys.discount.tr),
          ),
          GridColumn(
            columnName: 'mByPerson',
            label: CustomCell(data: LocaleKeys.qtyByPeople.tr),
          ),
          GridColumn(
            columnName: 'mProductCode',
            label: CustomCell(data: LocaleKeys.paramCode.trArgs([LocaleKeys.product.tr])),
          ),
          GridColumn(
            columnName: 'mDept',
            label: CustomCell(data: LocaleKeys.department.tr),
          ),
          GridColumn(
            columnName: 'mToGo',
            label: CustomCell(data: LocaleKeys.mode.tr),
          ),
          GridColumn(
            allowSorting: false,
            columnName: 'actions',
            width: context.isPhoneOrWider ? 120 : 60,
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
