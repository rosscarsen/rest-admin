import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:rest_admin/app/utils/custom_alert.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../translations/locale_keys.dart';
import '../../../../utils/form_help.dart';
import '../../../../utils/progresshub.dart';
import '../../../../widgets/custom_cell.dart';
import '../../../../widgets/data_grid_theme.dart';
import '../../../../widgets/no_record.dart';
import 'product_remarks_edit_controller.dart';
import 'product_remarks_fields.dart';

class ProductRemarksEditView extends GetView<ProductRemarksEditController> {
  const ProductRemarksEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: BackButton(
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
          ),
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
                        Tab(text: LocaleKeys.productRemarksDetail.tr),
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
      index: controller.tabIndex.value.clamp(0, 1),
      children: [_buildBasicInfo(context), _buildProductRemarksDetail(context)],
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
          child: ResponsiveGridRow(
            children: [
              //排序
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: ProductRemarksFields.mSort,
                  labelText: LocaleKeys.sort.tr,
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 0,
                ),
              ),
              //隐藏
              FormHelper.buildGridCol(
                child: FormHelper.checkbox(
                  initialValue: true,
                  name: ProductRemarksFields.mVisible,
                  labelText: LocaleKeys.hide.tr,
                ),
              ),
              //食品备注
              FormHelper.buildGridCol(
                sm: 12,
                md: 12,
                lg: 12,
                xl: 12,
                child: FormHelper.textInput(
                  name: ProductRemarksFields.mRemark,
                  labelText: LocaleKeys.productRemarks.tr,
                  enabled: controller.id == null,
                  maxLines: 2,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                    FormBuilderValidators.match(RegExp(r'^[^+]*$'), errorText: LocaleKeys.cannotContain.trArgs(['+'])),
                    FormBuilderValidators.match(RegExp(r'^[^&]*$'), errorText: LocaleKeys.cannotContain.trArgs(['&'])),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 食品备注详情
  Widget _buildProductRemarksDetail(BuildContext context) {
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
                        source: controller.dataSource,
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
}
