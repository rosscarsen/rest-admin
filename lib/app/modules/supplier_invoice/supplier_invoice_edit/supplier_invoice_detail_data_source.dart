import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/supplierInvoice/supplier_invoice_api_model.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_cell.dart';
import 'supplier_invoice_edit_controller.dart';

class SupplierInvoiceDetailDataSource extends DataGridSource with WidgetsBindingObserver {
  SupplierInvoiceDetailDataSource(this.controller) {
    updateDataSource();
  }

  final SupplierInvoiceEditController controller;

  void updateDataSource() {
    _dataGridRows = controller.invoiceDetail.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(InvoiceDetail e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'mStockCode', value: e.mStockCode),
        DataGridCell<String>(columnName: 'mProductCode', value: e.mProductCode),
        DataGridCell<String>(columnName: 'mProductName', value: e.mProductName),
        DataGridCell<String>(columnName: 'mQty', value: e.mQty),
        DataGridCell<String>(columnName: 'mPrice', value: e.mPrice),
        DataGridCell<String>(columnName: 'mDiscount', value: e.mDiscount),
        DataGridCell<String>(columnName: 'mAmount', value: e.mAmount),
        DataGridCell<String>(columnName: 'mRemarks', value: e.mRemarks),
        DataGridCell<InvoiceDetail>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    final int rowIndex = _dataGridRows.indexOf(dataGridRow);
    final row = dataGridRow.getCells().firstWhere((element) => element.columnName == "actions").value as InvoiceDetail;
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          return Tooltip(
            message: LocaleKeys.delete.tr,
            child: IconButton(
              icon: const Icon(Icons.delete, color: AppColors.deleteColor),
              onPressed: () {
                _dataGridRows.remove(dataGridRow);
                controller.invoiceDetail.remove(row);
                controller.tableHeight.value = controller.invoiceDetail.isNotEmpty
                    ? 100 + controller.invoiceDetail.length * 48
                    : 100;
                notifyListeners();
              },
            ),
          );
        }
        if (e.columnName == "mStockCode") {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextFormField(
              key: ValueKey('${rowIndex}_${e.value}'),
              initialValue: e.value?.toString() ?? "",
              onChanged: (value) {
                controller.invoiceDetail[rowIndex].mStockCode = value;
              },
            ),
          );
        }
        if (e.columnName == "mQty") {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextFormField(
              key: ValueKey('${rowIndex}_${e.value}'),
              initialValue: e.value?.toString() ?? "",
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*'))],
              onChanged: (value) {
                controller.invoiceDetail[rowIndex].mQty = value;
                controller.updateRowAmount(row: row);
              },
              keyboardType: TextInputType.number,
            ),
          );
        }

        if (e.columnName == "mPrice") {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextFormField(
              key: ValueKey('${rowIndex}_${e.value}'),
              initialValue: e.value?.toString() ?? "",
              onChanged: (value) {
                controller.invoiceDetail[rowIndex].mPrice = value;
                controller.updateRowAmount(row: row);
              },
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*'))],
              keyboardType: TextInputType.number,
            ),
          );
        }
        if (e.columnName == "mDiscount") {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextFormField(
              key: ValueKey('${rowIndex}_${e.value}'),
              initialValue: e.value?.toString() ?? "",
              onChanged: (value) {
                controller.invoiceDetail[rowIndex].mDiscount = value;
                controller.updateRowAmount(row: row);
              },
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*'))],
              keyboardType: TextInputType.number,
            ),
          );
        }
        if (e.columnName == "mRemarks") {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                fillColor: const Color(0xFFEEEEEE),
                filled: controller.formEnabled,
                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFBDBDBD))),
              ),
              key: ValueKey('${rowIndex}_${e.value}'),
              initialValue: e.value?.toString() ?? "",
              onChanged: (value) {
                controller.invoiceDetail[rowIndex].mRemarks = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          );
        }
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
