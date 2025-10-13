import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/product/products_model.dart';
import '../../../widgets/custom_cell.dart';
import 'open_multiple_product_controller.dart';

class OpenMultipleProductsDataSource extends DataGridSource {
  OpenMultipleProductsDataSource(this.controller) {
    updateDataSource();
  }

  final OpenMultipleProductController controller;

  void updateDataSource() {
    _dataGridRows = controller.DataList.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(ProductData e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'code', value: e.mCode),
        DataGridCell<String>(columnName: 'name', value: e.mDesc1),
        DataGridCell<String>(columnName: 'unit', value: e.mUnit),
        DataGridCell<String>(columnName: 'category', value: e.mCategory1),
        DataGridCell<String>(columnName: 'price', value: e.mPrice),
        DataGridCell<String>(columnName: 'qty', value: e.mQty),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }

  DataGridRow? findRowByCode(String code) {
    return _dataGridRows.firstWhereOrNull(
      (row) => row.getCells().any((cell) => cell.columnName == 'code' && cell.value == code),
    );
  }
}
