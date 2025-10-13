import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/supplier/supplier_data.dart';
import '../../../routes/app_pages.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/form_help.dart';
import '../../../utils/progress_hub.dart';
import '../../../widgets/custom_cell.dart';
import '../../../theme/data_grid_theme.dart';
import '../../../widgets/no_record.dart';
import '../../../theme/table_input_theme.dart';
import '../supplier_invoice_fields.dart';
import 'supplier_invoice_edit_controller.dart';

class SupplierInvoiceEditView extends GetView<SupplierInvoiceEditController> {
  const SupplierInvoiceEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(controller.title),
          centerTitle: true,
          actions: controller.isLoading
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
        ),

        body: controller.hasPermission ? _buildMain(context) : NoRecordPermission(msg: LocaleKeys.noPermission.tr),
        persistentFooterButtons: [
          FormHelper.saveButton(
            onPressed: controller.formEnabled && !controller.isLoading && controller.hasPermission
                ? () => controller.save()
                : null,
          ),
        ],
      ),
    );
  }

  /// 构建表单
  Widget _buildMain(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isLoading,
      child: FormBuilder(
        enabled: controller.formEnabled,
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: FormHelper.buildGridRow(
            children: [
              //供应商发票编号
              FormHelper.buildGridCol(
                child: Row(
                  spacing: 8.0,
                  children: [
                    Expanded(
                      child: FormHelper.textInput(
                        name: SupplierInvoiceFields.supplierInvoiceInNo,
                        labelText: LocaleKeys.paramCode.trArgs([LocaleKeys.supplierInvoice.tr]),
                        enabled: controller.id == null,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                        ]),
                      ),
                    ),
                    Expanded(
                      child: FormHelper.textInput(
                        name: SupplierInvoiceFields.revised,
                        labelText: LocaleKeys.revised.tr,
                      ),
                    ),
                  ],
                ),
              ),
              //日期
              FormHelper.buildGridCol(
                child: FormHelper.dateInput(
                  initialValue: DateTime.now(),
                  name: SupplierInvoiceFields.supplierInvoiceInDate,
                  labelText: LocaleKeys.date.tr,
                  inputType: DateInputType.date,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                    FormBuilderValidators.date(errorText: LocaleKeys.invalidFormatParam.trArgs([LocaleKeys.date.tr])),
                  ]),
                ),
              ),
              //過賬
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: SupplierInvoiceFields.flag,
                  labelText: LocaleKeys.flag.tr,
                  enabled: false,
                  initialValue: "0",
                  items: [
                    DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                  ],
                ),
              ),
              //货币
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: SupplierInvoiceFields.moneyCurrency,
                  labelText: LocaleKeys.currency.tr,
                  initialValue: "HKD",
                  items: controller.currency
                      .map((e) => DropdownMenuItem(value: e.mCode, child: Text(e.mCode ?? "")))
                      .toList(),
                ),
              ),
              //兑换率
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: SupplierInvoiceFields.exRatio,
                  labelText: LocaleKeys.rate.tr,
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 4,
                  initialValue: "1.0000",
                ),
              ),
              //供应商
              FormHelper.buildGridCol(
                child: Row(
                  spacing: 3.0,
                  children: [
                    Expanded(
                      child: FormHelper.openInput(
                        name: SupplierInvoiceFields.supplierCode,
                        labelText: LocaleKeys.supplier.tr,
                        onPressed: () async {
                          var result = await Get.toNamed(Routes.OPEN_SUPPLIER);
                          if (result != null && result is SupplierData) {
                            controller.formKey.currentState?.patchValue({
                              SupplierInvoiceFields.supplierCode: result.mCode ?? "",
                              SupplierInvoiceFields.supplierName: result.mSimpleName ?? "",
                            });
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: FormHelper.textInput(
                        name: SupplierInvoiceFields.supplierName,
                        labelText: LocaleKeys.supplierName.tr,
                      ),
                    ),
                  ],
                ),
              ),
              //默认仓库
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: "defaultStock",
                  labelText: LocaleKeys.defaultStock.tr,

                  items: controller.stock
                      .map((e) => DropdownMenuItem(value: e.mCode, child: Text('${e.mCode ?? ""} ${e.mName ?? ""}')))
                      .toList(),
                  prefixIcon: TextButton(
                    onPressed: () {
                      final selectStock = controller.formKey.currentState?.fields["defaultStock"]?.value;
                      if (selectStock != null) {
                        for (var element in controller.invoiceDetail) {
                          element.mStockCode = selectStock;
                        }
                        controller.dataSource.updateDataSource();
                      }
                    },
                    child: Text(LocaleKeys.applyToAllItem.tr),
                  ),
                ),
              ),
              // 创建人
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: SupplierInvoiceFields.createdBy,
                  labelText: LocaleKeys.createBy.tr,
                  enabled: false,
                ),
              ),
              //创建日期
              FormHelper.buildGridCol(
                child: FormHelper.dateInput(
                  name: SupplierInvoiceFields.createdDate,
                  labelText: LocaleKeys.createDate.tr,
                  inputType: DateInputType.date,
                  enabled: false,
                ),
              ),
              //修改人
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: SupplierInvoiceFields.lastModifiedBy,
                  labelText: LocaleKeys.modifyBy.tr,
                  enabled: false,
                ),
              ),
              //修改日期
              FormHelper.buildGridCol(
                child: FormHelper.dateInput(
                  name: SupplierInvoiceFields.lastModifiedDate,
                  labelText: LocaleKeys.modifyDate.tr,
                  inputType: DateInputType.date,
                  enabled: false,
                ),
              ),
              //添加项目
              FormHelper.buildGridCol(
                sm: 12,
                md: 12,
                lg: 12,
                xl: 12,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: controller.formEnabled
                        ? () async {
                            await Get.toNamed(
                              Routes.OPEN_MULTIPLE_PRODUCT,
                              parameters: {
                                "target": "supplierInvoiceAddItem",
                                "defaultStock": controller.formKey.currentState?.fields["defaultStock"]?.value,
                              },
                            );
                          }
                        : null,
                    child: Text(LocaleKeys.addParam.trArgs([LocaleKeys.item.tr])),
                  ),
                ),
              ),
              //明细表格
              FormHelper.buildGridCol(
                sm: 12,
                md: 12,
                lg: 12,
                xl: 12,
                child: SizedBox(height: controller.tableHeight.value, child: _buildDataGrid(context)),
              ),
              //备注
              FormHelper.buildGridCol(
                sm: 12,
                md: 12,
                lg: 12,
                xl: 12,
                child: FormHelper.textInput(
                  name: SupplierInvoiceFields.remarks,
                  labelText: LocaleKeys.remarks.tr,
                  maxLines: 2,
                ),
              ),
              //折扣
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: SupplierInvoiceFields.discount,
                  labelText: "${LocaleKeys.discount.tr}(0-100)",
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 4,
                  onChanged: (value) {
                    controller.updateTotalAmount();
                  },
                ),
              ),
              //金额
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: SupplierInvoiceFields.amount,
                  labelText: LocaleKeys.amount.tr,
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 2,
                  readOnly: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //数据表格
  Widget _buildDataGrid(BuildContext context) {
    return ProgressHUD(
      child: controller.isLoading
          ? null
          : Theme(
              data: ThemeData(
                inputDecorationTheme: tableInputTheme.copyWith(
                  fillColor: const Color(0xFFEEEEEE),
                  filled: !controller.formEnabled,
                  focusedBorder: !controller.formEnabled
                      ? OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFBDBDBD)))
                      : null,
                ),
              ),
              child: DataGridTheme(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SfDataGrid(
                    allowFiltering: true,
                    headerRowHeight: 56,
                    rowHeight: 48,
                    isScrollbarAlwaysShown: true,
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
                        columnName: 'mStockCode',
                        label: CustomCell(data: LocaleKeys.stock.tr),
                      ),
                      GridColumn(
                        columnName: 'mProductCode',
                        label: CustomCell(data: LocaleKeys.paramCode.trArgs([LocaleKeys.product.tr])),
                        allowFiltering: true,
                      ),
                      GridColumn(
                        columnName: 'mProductName',
                        label: CustomCell(data: LocaleKeys.paramName.trArgs([LocaleKeys.product.tr])),
                        columnWidthMode: ColumnWidthMode.fill,
                        minimumWidth: 150,
                      ),
                      GridColumn(
                        columnName: 'mQty',
                        label: CustomCell(data: LocaleKeys.qty.tr),
                        width: 80,
                        allowFiltering: false,
                      ),
                      GridColumn(
                        columnName: 'mPrice',
                        label: CustomCell(data: LocaleKeys.price.tr),
                        width: 80,
                        allowFiltering: false,
                      ),
                      GridColumn(
                        columnName: 'mDiscount',
                        label: CustomCell(data: LocaleKeys.discount.tr),
                        width: 80,
                        allowFiltering: false,
                      ),
                      GridColumn(
                        columnName: 'mAmount',
                        label: CustomCell(data: LocaleKeys.amount.tr),
                        allowFiltering: false,
                      ),
                      GridColumn(
                        columnName: 'mRemarks',
                        label: CustomCell(data: LocaleKeys.remarks.tr),
                        allowFiltering: false,
                      ),
                      GridColumn(
                        allowSorting: false,
                        columnName: 'actions',
                        width: 60,
                        allowFiltering: false,
                        label: CustomCell(data: LocaleKeys.operation.tr),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
