import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../routes/app_pages.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/form_help.dart';
import '../../../utils/progresshub.dart';
import '../../../widgets/custom_cell.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/data_grid_theme.dart';
import '../../../widgets/data_pager.dart';
import '../../../widgets/no_record.dart';
import 'customer_controller.dart';

class CustomerView extends GetView<CustomerController> {
  const CustomerView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      route: Routes.CUSTOMER,
      title: LocaleKeys.customer.tr,
      actions: [
        Tooltip(
          message: LocaleKeys.refresh.tr,
          child: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.hasPermission.value ? () => controller.reloadData() : null,
          ),
        ),
      ],
      body: Obx(() {
        return Column(
          spacing: Config.defaultGap,
          children: <Widget>[
            _buildToolBar(context),
            Expanded(child: ProgressHUD(child: controller.isLoading.value ? null : _buildDataGrid(context))),
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
              enabled: controller.hasPermission.value,
              name: "keyword",
              labelText: LocaleKeys.keyWord.tr,
              onSubmitted: (value) => controller.reloadData(),
            ),
          ),
          //类型
          FormHelper.buildGridCol(
            child: FormHelper.selectInput(
              name: "mCustomer_Type",
              labelText: LocaleKeys.type.tr,
              enabled: controller.hasPermission.value,
              initialValue: "",
              items: [
                DropdownMenuItem(value: "", child: Text("")),
                ...controller.customerTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))),
              ],
              onChanged: (value) => controller.reloadData(),
            ),
          ),
          //类型
          FormHelper.buildGridCol(
            child: FormHelper.selectInput(
              name: "mInfoNA",
              labelText: LocaleKeys.status.tr,
              initialValue: "",
              items: [
                DropdownMenuItem(value: "", child: Text("")),
                DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
              ],
              enabled: controller.hasPermission.value,
              onChanged: (value) => controller.reloadData(),
            ),
          ),
          //按钮
          FormHelper.buildGridCol(
            sm: 12,
            md: 12,
            lg: 12,
            xl: 12,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: context.isPhoneOrLess ? WrapAlignment.start : WrapAlignment.end,
              spacing: 5,
              runSpacing: 5,
              children: [
                //搜索
                ElevatedButton(
                  onPressed: controller.hasPermission.value ? () => controller.reloadData() : null,
                  child: Text(LocaleKeys.search.tr),
                ),
                //导入
                ElevatedButton(
                  onPressed: controller.hasPermission.value ? () => _buildImport() : null,
                  child: Text(LocaleKeys.import.tr),
                ),
                //导出
                ElevatedButton(
                  onPressed: controller.hasPermission.value ? () => _buildExport() : null,
                  child: Text(LocaleKeys.export.tr),
                ),
                //新增
                ElevatedButton(
                  onPressed: controller.hasPermission.value ? () => controller.edit() : null,
                  child: Text(LocaleKeys.add.tr),
                ),
              ],
            ).paddingSymmetric(vertical: 2.0).paddingOnly(left: context.isPhoneOrLess ? 0 : 5),
          ),
        ],
      ),
    );
  }

  // 导出
  void _buildExport() {
    final TextEditingController startCtl = TextEditingController();
    final TextEditingController endCtl = TextEditingController();
    Get.defaultDialog(
      barrierDismissible: false,
      title: LocaleKeys.export.tr,
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return SingleChildScrollView(
            child: Column(
              spacing: 8.0,
              children: <Widget>[
                FormHelper.openInput(
                  name: "startCode",
                  labelText: LocaleKeys.from.trArgs([LocaleKeys.customer.tr]),
                  controller: startCtl,
                  onPressed: () async {
                    var ret = await Get.toNamed(Routes.OPEN_CUSTOMER);
                    if (ret != null) {
                      startCtl.text = ret;
                    }
                  },
                ),
                FormHelper.openInput(
                  name: "endCode",
                  controller: endCtl,
                  labelText: LocaleKeys.from.trArgs([LocaleKeys.customer.tr]),
                  onPressed: () async {
                    var ret = await Get.toNamed(Routes.OPEN_CUSTOMER);
                    if (ret != null) {
                      endCtl.text = ret;
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      cancel: ElevatedButton(
        onPressed: () {
          startCtl.dispose();
          endCtl.dispose();
          Get.closeDialog();
        },
        child: Text(LocaleKeys.cancel.tr),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          startCtl.dispose();
          endCtl.dispose();
          Get.closeDialog();
          await controller.exportExcel(query: {'startCode': startCtl.text, 'endCode': endCtl.text});
        },
        child: Text(LocaleKeys.confirm.tr),
      ),
    );
  }

  // 导入
  void _buildImport() {
    final TextEditingController fileController = TextEditingController();

    File? excelFile;
    int overWrite = 0;

    Get.defaultDialog(
      barrierDismissible: false,
      title: LocaleKeys.importProduct.tr,
      content: Column(
        spacing: 8,
        children: [
          FormHelper.openFileInput(
            name: "excel",
            labelText: LocaleKeys.selectFile.trArgs(["excel"]),
            controller: fileController,
            onFileSelected: (file) {
              excelFile = file;
            },
          ),
          FormHelper.selectInput(
            name: "overWrite",
            labelText: LocaleKeys.overWrite.tr,
            items: [
              DropdownMenuItem(value: 0, child: Text(LocaleKeys.no.tr)),
              DropdownMenuItem(value: 1, child: Text(LocaleKeys.yes.tr)),
            ],
            onChanged: (value) {
              overWrite = value!;
            },
          ),
        ],
      ),
      cancel: ElevatedButton(
        onPressed: () {
          fileController.dispose();
          excelFile = null;
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
          fileController.dispose();
          Get.closeDialog();
          await controller.importExcel(file: excelFile!, query: {'overWrite': overWrite});
          excelFile = null;
        },
        child: Text(LocaleKeys.confirm.tr),
      ),
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
        columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
        columnWidthMode: ColumnWidthMode.auto,
        showCheckboxColumn: false,
        selectionMode: SelectionMode.none,
        source: controller.dataSource,
        columns: <GridColumn>[
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
          GridColumn(
            allowSorting: false,
            columnName: 'actions',
            width: 80,
            label: CustomCell(data: LocaleKeys.operation.tr),
          ),
        ],
        placeholder: NoRecordPermission(
          msg: controller.hasPermission.value ? LocaleKeys.noRecordFound.tr : LocaleKeys.noPermission.tr,
        ),
      ),
    );
  }
}
