import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/products_model.dart';
import '../../../widgets/custom_cell.dart';
import 'open_product_controller.dart';
import '../../../translations/locale_keys.dart';

class OpenProductsDataSource extends DataGridSource {
  OpenProductsDataSource(this.controller) {
    updateDataSource();
  }

  final OpenProductController controller;

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
        DataGridCell<int>(columnName: 'T_Product_ID', value: e.tProductId),
        DataGridCell<String>(columnName: 'select', value: e.mCode.toString()),
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
        if (e.columnName == "select") {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: FittedBox(
              child: FilledButton(
                onPressed: () {
                  Get.back(result: e.value.toString());
                },
                child: Text(LocaleKeys.select.tr),
              ),
            ),
          );
        }

        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(e.value?.toString() ?? "", overflow: TextOverflow.ellipsis),
        );
      }).toList(),
    );
  }
}
