import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../model/supplier_model.dart';
import '../../modules/open/open_supplier/open_supplier_controller.dart';
import '../../translations/locale_keys.dart';
import '../../widgets/custom_cell.dart';

class OpenSupplierDataSource extends DataGridSource {
  OpenSupplierDataSource(this.controller) {
    updateDataSource();
  }

  final OpenSupplierController controller;

  void updateDataSource() {
    _dataGridRows = controller.DataList.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(ApiData e) {
    return DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'T_Supplier_ID', value: e.tSupplierId),
        DataGridCell<String>(columnName: 'select', value: e.mCode.toString()),
        DataGridCell<String>(columnName: 'code', value: e.mCode),
        DataGridCell<String>(columnName: 'simpleName', value: e.mSimpleName),
        DataGridCell<String>(columnName: 'fullName', value: e.mFullName),
        DataGridCell<String>(columnName: 'mobile', value: e.mPhoneNo),
        DataGridCell<String>(columnName: 'fax', value: e.mFaxNo),
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
