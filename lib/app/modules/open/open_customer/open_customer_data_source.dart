import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/customer/customer_data.dart';
import '../../../translations/locale_keys.dart';
import '../../../widgets/custom_cell.dart';
import 'open_customer_controller.dart';

class OpenCustomerDataSource extends DataGridSource {
  OpenCustomerDataSource(this.controller) {
    updateDataSource();
  }

  final OpenCustomerController controller;

  void updateDataSource() {
    _dataGridRows = controller.dataList.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(CustomerData e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'select', value: e.mCode.toString()),
        DataGridCell<String>(columnName: 'mCode', value: e.mCode),
        DataGridCell<String>(columnName: 'mSimpleName', value: e.mSimpleName),
        DataGridCell<String>(columnName: 'mFullName', value: e.mFullName),
        DataGridCell<String>(columnName: 'mPhoneNo', value: e.mPhoneNo),
        DataGridCell<String>(columnName: 'mFaxNo', value: e.mFaxNo),
        DataGridCell<String>(columnName: 'mStDiscount', value: e.mStDiscount),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        if (e.columnName == "select") {
          return Padding(
            padding: const EdgeInsets.all(6.0),
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
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
