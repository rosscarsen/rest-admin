import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/product_barcode_model.dart';
import 'open_product_barcode_controller.dart';
import '../../../translations/locale_keys.dart';
import '../../../widgets/custom_cell.dart';

class OpenProductBarcodeDataSource extends DataGridSource {
  OpenProductBarcodeDataSource(this.controller) {
    updateDataSource();
  }

  final OpenProductBarcodeController controller;

  void updateDataSource() {
    _dataGridRows = controller.DataList.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(ProductBarcodeData e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'select', value: e.mCode.toString()),
        DataGridCell<String>(columnName: 'barcode', value: e.mCode),
        DataGridCell<String>(columnName: 'code', value: e.mProductCode),
        DataGridCell<String>(columnName: 'name', value: e.mName),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        if (e.columnName == "select") {
          return CustomCell(
            child: TextButton(
              onPressed: () {
                Get.back(result: e.value.toString());
              },
              child: Text(LocaleKeys.select.tr),
            ),
          );
        }
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
