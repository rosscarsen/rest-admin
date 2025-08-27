import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../routes/app_pages.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/form_help.dart';
import '../../../utils/progresshub.dart';
import '../../../widgets/custom_cell.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/data_grid_theme.dart';
import '../../../widgets/data_pager.dart';
import '../../../widgets/no_record.dart';
import 'category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      route: Routes.CATEGORY,
      title: LocaleKeys.category.tr,
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
              name: "search",
              labelText: LocaleKeys.keyWord.tr,
              onSubmitted: controller.hasPermission.value ? (value) => controller.reloadData() : null,
              suffixIcon: TextButton(
                onPressed: controller.hasPermission.value ? () => controller.reloadData() : null,
                child: Text(LocaleKeys.search.tr),
              ),
            ),
          ),
          //层数
          FormHelper.buildGridCol(
            child: FormHelper.selectInput(
              name: "tier",
              labelText: LocaleKeys.layer.tr,
              items: [
                DropdownMenuItem(value: "", child: Text("")),
                DropdownMenuItem(value: "1", child: Text("1")),
                DropdownMenuItem(value: "3", child: Text("3")),
                DropdownMenuItem(value: "5", child: Text("5")),
              ],
              onChanged: (value) => controller.hasPermission.value ? () => controller.reloadData() : null,
            ),
          ),
          //按钮
          FormHelper.buildGridCol(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: context.isPhoneOrLess ? Alignment.centerLeft : Alignment.centerRight,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: context.isPhoneOrLess ? WrapAlignment.start : WrapAlignment.end,
                spacing: 5,
                runSpacing: 5,
                children: [
                  //导入
                  ElevatedButton(
                    onPressed: controller.hasPermission.value ? () => _buildImport() : null,
                    child: Text(LocaleKeys.import.tr),
                  ),
                  //导出
                  ElevatedButton(
                    onPressed: controller.hasPermission.value ? () => controller.exportCategory() : null,
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
          ),
        ],
      ),
    );
  }

  // 产品导入
  void _buildImport() async {
    final TextEditingController fileController = TextEditingController();
    File? excelFile;
    await Get.defaultDialog(
      barrierDismissible: false,
      title: LocaleKeys.importProduct.tr,
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                allowMultiple: false,
                type: FileType.custom,
                allowedExtensions: ['xlsx', 'xls'],
                dialogTitle: LocaleKeys.selectFile.trArgs(["excel"]),
                lockParentWindow: true,
              );
              if (result != null) {
                setState(() {
                  PlatformFile platformFile = result.files.single;
                  excelFile = File(platformFile.path!);
                  fileController.text = platformFile.name;
                });
              } else {
                CustomDialog.showToast(LocaleKeys.userCanceledPicker.tr);
              }
            },
            child: AbsorbPointer(
              absorbing: fileController.text.isEmpty,
              child: TextField(
                readOnly: true,
                controller: fileController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.selectFile.trArgs(["excel"]),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  enabled: true,
                  prefixIcon: Icon(FontAwesomeIcons.fileExcel, color: AppColors.openColor),
                  suffixIcon: fileController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              excelFile = null;
                              fileController.clear();
                            });
                          },
                        )
                      : null,
                ),
              ),
            ),
          );
        },
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
          controller.importCategory(file: excelFile!);
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
        columnWidthMode: ColumnWidthMode.auto,
        columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
        showCheckboxColumn: false,
        selectionMode: SelectionMode.none,
        source: controller.dataSource,
        columns: <GridColumn>[
          GridColumn(
            columnName: "ID",
            visible: false,
            label: CustomCell(data: "ID"),
          ),
          GridColumn(
            columnName: "tier",
            label: CustomCell(data: LocaleKeys.layer.tr),
          ),
          GridColumn(
            columnName: 'mSort',
            label: CustomCell(data: LocaleKeys.sort.tr),
          ),
          GridColumn(
            columnName: 'mCategory',
            label: CustomCell(data: LocaleKeys.category.tr),
          ),
          GridColumn(
            columnName: 'mDescription',
            label: CustomCell(data: LocaleKeys.description.tr),
          ),
          GridColumn(
            columnName: 'mTimeStart',
            label: CustomCell(data: LocaleKeys.startTime.tr),
          ),
          GridColumn(
            columnName: 'mTimeEnd',
            label: CustomCell(data: LocaleKeys.endTime.tr),
          ),
          GridColumn(
            columnName: 'mHide',
            label: CustomCell(data: LocaleKeys.deactivate.tr),
          ),
          GridColumn(
            columnName: 'mCustomerSelfHelpHide',
            label: CustomCell(data: LocaleKeys.customerHide.tr),
          ),
          GridColumn(
            columnName: 'mTakeawayDisplay',
            label: CustomCell(data: LocaleKeys.takeawayHide.tr),
          ),
          GridColumn(
            columnName: 'mKiosk',
            label: CustomCell(data: LocaleKeys.kiosk.tr),
          ),
          GridColumn(
            allowSorting: false,
            columnName: 'actions',
            width: context.isPhoneOrWider ? 170 : 60,
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
