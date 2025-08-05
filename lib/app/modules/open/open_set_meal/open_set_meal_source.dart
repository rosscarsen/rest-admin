import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/set_meal_model.dart';
import '../../../translations/locale_keys.dart';
import '../../../widgets/custom_cell.dart';
import 'open_set_meal_controller.dart';

class OpenSetMealSource extends DataGridSource {
  OpenSetMealSource(this.controller) {
    updateDataSource();
  }

  final OpenSetMealController controller;

  void updateDataSource() {
    _dataGridRows = controller.DataList.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(SetMealData e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'select', value: e.mCode ?? ""),
        DataGridCell<String>(columnName: 'mCode', value: e.mCode ?? ""),
        DataGridCell<String>(columnName: 'mDesc', value: e.mDesc ?? ""),
        DataGridCell<String>(columnName: 'detail', value: e.detail ?? ""),
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
                  Get.closeDialog(result: e.value.toString());
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
