import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../translations/locale_keys.dart';
import '../../../../utils/custom_alert.dart';
import '../../../../utils/form_help.dart';
import '../../../../utils/progress_hub.dart';
import '../../../../widgets/custom_cell.dart';
import '../../../../widgets/data_grid_theme.dart';
import '../../../../widgets/data_pager.dart';
import '../../../../widgets/no_record.dart';
import '../customer_fields.dart';
import 'customer_edit_controller.dart';

class CustomerEditView extends GetView<CustomerEditController> {
  const CustomerEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          /* leading: BackButton(
            onPressed: () async {
              final checkResult = controller.checkPageDataChange();
              if (checkResult is bool && checkResult == true) {
                Get.back();
                return;
              }
              if (checkResult is Map<String, dynamic>) {
                CustomAlert.iosAlert(
                  message: LocaleKeys.areYouLeave.tr,
                  showCancel: true,
                  confirmText: LocaleKeys.leave.tr,
                  onConfirm: () => Get.back(),
                );
              }
            },
          ) ,*/
          title: Text(controller.title.value),
          centerTitle: true,
          actions: controller.isLoading.value
              ? null
              : [
                  Tooltip(
                    message: LocaleKeys.refresh.tr,
                    child: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => controller.updateDataGridSource(),
                    ),
                  ),
                ],
          bottom: controller.hasPermission.value
              ? PreferredSize(
                  preferredSize: Size.fromHeight(48.0),
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: TabBar(
                      isScrollable: true,
                      controller: controller.tabController,
                      tabs: [
                        Tab(text: LocaleKeys.basicInfo.tr),
                        Tab(text: LocaleKeys.contact.tr),
                        Tab(text: LocaleKeys.deposit.tr),
                      ],
                      labelColor: Colors.blueAccent,
                      indicatorColor: Colors.blueAccent,
                      indicatorWeight: 2,
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: Colors.grey.shade600,
                      overlayColor: WidgetStateProperty.all(Colors.blue.withValues(alpha: 0.1)),
                      tabAlignment: TabAlignment.start,
                    ),
                  ),
                )
              : null,
        ),

        body: controller.hasPermission.value ? buildMain(context) : NoRecordPermission(msg: LocaleKeys.noPermission.tr),
        persistentFooterButtons: [
          FormHelper.saveButton(
            onPressed: controller.isLoading.value || !controller.hasPermission.value ? null : () => controller.save(),
          ),
        ],
      ),
    );
  }

  Widget buildMain(BuildContext context) {
    return IndexedStack(
      index: controller.tabIndex.value.clamp(0, 2),
      children: [_buildBasicInfo(context), _buildContact(context), _buildPoints(context)],
    );
  }

  /// 基本信息
  Widget _buildBasicInfo(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isLoading.value,
      child: FormBuilder(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: FormHelper.buildGridRow(
            children: [
              //名称
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  labelText: LocaleKeys.type.tr,
                  name: "mType",

                  items: [
                    DropdownMenuItem(value: 0, child: Text(LocaleKeys.addMoney.tr)),
                    DropdownMenuItem(value: 1, child: Text("${LocaleKeys.discount.tr}(%)")),
                    DropdownMenuItem(value: 2, child: Text("${LocaleKeys.multiple.tr}(*n)")),
                  ],
                ),
              ),
              //类型
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: CustomerFields.mCustomer_Type, labelText: LocaleKeys.type.tr),
              ),
              //编号
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: CustomerFields.mCode, labelText: LocaleKeys.code.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 联络人
  Widget _buildContact(BuildContext context) {
    return Container();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8.0,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(onPressed: () => controller.editOrAddDetail(), child: Text(LocaleKeys.add.tr)),
          ),
          Expanded(
            child: ProgressHUD(
              child: controller.isLoading.value
                  ? null
                  : DataGridTheme(
                      child: SfDataGrid(
                        isScrollbarAlwaysShown: true,
                        footerFrozenColumnsCount: 1,
                        frozenColumnsCount: 0,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                        showCheckboxColumn: false,
                        selectionMode: SelectionMode.none,
                        source: controller.depositDataSource,
                        columns: <GridColumn>[
                          GridColumn(
                            columnName: 'mSort',
                            label: CustomCell(data: LocaleKeys.sort.tr),
                          ),
                          GridColumn(
                            columnName: 'mDetail',
                            label: CustomCell(data: LocaleKeys.detail.tr),
                            columnWidthMode: ColumnWidthMode.fill,
                            maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
                          ),
                          GridColumn(
                            columnName: 'mType',
                            label: CustomCell(data: LocaleKeys.type.tr),
                          ),
                          GridColumn(
                            columnName: 'addMoney',
                            label: CustomCell(data: "${LocaleKeys.addMoney.tr}/${LocaleKeys.discount.tr}"),
                          ),
                          GridColumn(
                            columnName: 'classification',
                            label: CustomCell(data: LocaleKeys.classification.tr),
                          ),
                          GridColumn(
                            columnName: 'overWrite',
                            label: CustomCell(data: LocaleKeys.overWrite.tr),
                          ),
                          GridColumn(
                            width: 100,
                            columnName: 'move',
                            label: CustomCell(data: LocaleKeys.move.tr),
                          ),
                          GridColumn(
                            allowSorting: false,
                            columnName: 'actions',
                            width: 80,
                            label: CustomCell(data: LocaleKeys.operation.tr),
                          ),
                        ],
                        placeholder: NoRecordPermission(
                          msg: controller.hasPermission.value
                              ? LocaleKeys.noRecordFound.tr
                              : LocaleKeys.noPermission.tr,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// 积分
  Widget _buildPoints(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8.0,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(onPressed: () => controller.editOrAddDetail(), child: Text(LocaleKeys.add.tr)),
          ),
          Expanded(
            child: ProgressHUD(
              child: controller.isLoading.value
                  ? null
                  : DataGridTheme(
                      child: SfDataGrid(
                        isScrollbarAlwaysShown: true,
                        footerFrozenColumnsCount: 1,
                        frozenColumnsCount: 0,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                        columnWidthMode: ColumnWidthMode.fill,
                        showCheckboxColumn: false,
                        selectionMode: SelectionMode.none,
                        source: controller.depositDataSource,
                        columns: <GridColumn>[
                          GridColumn(
                            columnName: 'mRef_No',
                            label: CustomCell(data: LocaleKeys.invoiceNo.tr),
                            columnWidthMode: ColumnWidthMode.auto,
                          ),
                          GridColumn(
                            columnName: 'mDeposit_Date',
                            label: CustomCell(data: LocaleKeys.date.tr),
                          ),
                          GridColumn(
                            columnName: 'mAmount',
                            label: CustomCell(data: LocaleKeys.deposit.tr),
                          ),
                          GridColumn(
                            columnName: 'mRemark',
                            label: CustomCell(data: LocaleKeys.remarks.tr),
                          ),
                          GridColumn(
                            allowSorting: false,
                            columnName: 'actions',
                            width: 80,
                            label: CustomCell(data: LocaleKeys.operation.tr),
                          ),
                        ],
                        placeholder: NoRecordPermission(
                          msg: controller.hasPermission.value
                              ? LocaleKeys.noRecordFound.tr
                              : LocaleKeys.noPermission.tr,
                        ),
                      ),
                    ),
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
      ),
    );
  }
}
