import 'dart:math';

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
import '../../../utils/logger.dart';
import '../../../utils/progress_hub.dart';
import '../../../widgets/custom_cell.dart';
import '../../../widgets/data_grid_theme.dart';
import '../../../widgets/no_record.dart';
import '../supplier_invoice_fields.dart';
import 'supplier_invoice_edit_controller.dart';

class SupplierInvoiceEditView extends GetView<SupplierInvoiceEditController> {
  const SupplierInvoiceEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
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
        ),

        body: controller.hasPermission.value ? _buildMain() : NoRecordPermission(msg: LocaleKeys.noPermission.tr),
        persistentFooterButtons: [
          FormHelper.saveButton(
            onPressed: controller.isLoading.value || !controller.hasPermission.value ? null : () => controller.save(),
          ),
        ],
      ),
    );
  }

  /// 构建表单
  Widget _buildMain() {
    return Skeletonizer(
      enabled: controller.isLoading.value,
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
                  name: SupplierInvoiceFields.supplierInvoiceInDate,
                  labelText: LocaleKeys.date.tr,
                  inputType: DateInputType.date,
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
                  onChanged: (value) {
                    controller.selectStock = value;
                  },
                  items: controller.stock
                      .map((e) => DropdownMenuItem(value: e.mCode, child: Text('${e.mCode ?? ""} ${e.mName ?? ""}')))
                      .toList(),
                  prefixIcon: TextButton(
                    onPressed: () {
                      if (controller.selectStock != null) {
                        for (var element in controller.invoiceDetail) {
                          element.mStockCode = controller.selectStock;
                        }
                        logger.f(controller.invoiceDetail.map((e) => e.toJson()).toList());
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
                    child: Text(LocaleKeys.addParam.trArgs([LocaleKeys.item.tr])),
                    onPressed: () {},
                  ),
                ),
              ),
              //明细表格
              FormHelper.buildGridCol(
                sm: 12,
                md: 12,
                lg: 12,
                xl: 12,
                child: SizedBox(height: controller.tableHeight.value, child: _buildDataGrid()),
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
                  maxDecimalDigits: 2,
                  onChanged: (value) {
                    controller.totalDiscount = value ?? "0.00";
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
  Widget _buildDataGrid() {
    return ProgressHUD(
      child: controller.isLoading.value
          ? null
          : Theme(
              data: ThemeData(
                inputDecorationTheme: InputDecorationTheme(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
              ),
              child: DataGridTheme(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SfDataGrid(
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
                      ),
                      GridColumn(
                        columnName: 'mPrice',
                        label: CustomCell(data: LocaleKeys.price.tr),
                        width: 80,
                      ),
                      GridColumn(
                        columnName: 'mDiscount',
                        label: CustomCell(data: LocaleKeys.discount.tr),
                        width: 80,
                      ),
                      GridColumn(
                        columnName: 'mAmount',
                        label: CustomCell(data: LocaleKeys.amount.tr),
                      ),
                      GridColumn(
                        columnName: 'mRemarks',
                        label: CustomCell(data: LocaleKeys.remarks.tr),
                      ),
                      GridColumn(
                        allowSorting: false,
                        columnName: 'actions',
                        width: 60,
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
