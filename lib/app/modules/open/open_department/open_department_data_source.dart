import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/department/department_data.dart';
import '../../../translations/locale_keys.dart';
import '../../../widgets/custom_cell.dart';
import 'open_department_controller.dart';

class OpenDepartmentDataSource extends DataGridSource {
  OpenDepartmentDataSource(this.controller) {
    updateDataSource();
  }

  final OpenDepartmentController controller;

  void updateDataSource() {
    _dataGridRows = (controller.data ?? []).map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(DepartmentData e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'select', value: e.mBrand),
        DataGridCell<String>(columnName: 'mBrand', value: e.mBrand),
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
                  Get.back(result: e.value);
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
