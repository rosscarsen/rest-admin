import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/product_add_or_edit_model.dart';

import '../../../../widgets/custom_cell.dart';
import 'product_edit_controller.dart';

class ProductStockSource extends DataGridSource {
  ProductStockSource(this.controller) {
    updateDataSource();
  }

  final ProductEditController controller;

  void updateDataSource() {
    _dataGridRows = controller.productStock.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(ProductStock e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'mCode', value: e.mCode),
        DataGridCell<String>(columnName: 'mName', value: e.mName),
        DataGridCell<String>(columnName: 'qty', value: e.mQty),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
