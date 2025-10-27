import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
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
import 'set_menu_controller.dart';

class SetMenuView extends GetView<SetMenuController> {
  const SetMenuView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      route: Routes.SET_MENU,
      title: LocaleKeys.setMeal.tr,
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
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.end,
                spacing: 5,
                runSpacing: 5,
                children: [
                  //导入
                  ElevatedButton(
                    onPressed: controller.hasPermission ? () => _buildImport() : null,
                    child: Text(LocaleKeys.import.tr),
                  ),
                  //导出
                  ElevatedButton(
                    onPressed: controller.hasPermission ? () => _buildExport() : null,
                    child: Text(LocaleKeys.export.tr),
                  ),
                  //新增
                  ElevatedButton(
                    onPressed: controller.hasPermission ? () => controller.edit() : null,
                    child: Text(LocaleKeys.add.tr),
                  ),
                ],
              ).paddingSymmetric(vertical: 2.0).paddingOnly(left: context.isPhoneOrLess ? 0 : 5),
            ),
          ),
        ],
      ),
    );
  }

  // 导入
  void _buildImport() async {
    final fileController = TextEditingController();
    File? excelFile;
    int overWrite = 0;
    try {
      await Get.defaultDialog(
        barrierDismissible: false,
        title: LocaleKeys.importParam.trArgs([LocaleKeys.setMeal.tr]),
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
            FormHelper.selectInput(
              name: "overWrite",
              labelText: LocaleKeys.overWrite.tr,
              initialValue: 0,
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
            await controller.import(file: excelFile!, query: {'overWrite': overWrite});
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

  // 导出
  void _buildExport() {
    final TextEditingController startCtl = TextEditingController();
    final TextEditingController endCtl = TextEditingController();
    Get.defaultDialog(
      barrierDismissible: false,
      title: LocaleKeys.exportParam.trArgs([LocaleKeys.setMeal.tr]),
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return SingleChildScrollView(
            child: Column(
              spacing: 8.0,
              children: <Widget>[
                FormHelper.openInput(
                  name: "startCode",
                  labelText: LocaleKeys.from.trArgs([LocaleKeys.setMeal.tr]),
                  controller: startCtl,
                  onPressed: () async {
                    var ret = await Get.toNamed(Routes.OPEN_SET_MEAL);
                    if (ret != null) {
                      startCtl.text = ret;
                    }
                  },
                ),
                FormHelper.openInput(
                  name: "endCode",
                  controller: endCtl,
                  labelText: LocaleKeys.from.trArgs([LocaleKeys.setMeal.tr]),
                  onPressed: () async {
                    var ret = await Get.toNamed(Routes.OPEN_SET_MEAL);
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
          await controller.export(
            query: {'startCode': startCtl.text, 'endCode': endCtl.text, 'isProductExport': false},
          );
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
            columnName: 'mDesc',
            label: CustomCell(data: LocaleKeys.name.tr),
          ),
          GridColumn(
            columnName: 'detail',
            label: CustomCell(data: LocaleKeys.detail.tr),
            columnWidthMode: ColumnWidthMode.fill,
            minimumWidth: 200,
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
    );
  }
}
