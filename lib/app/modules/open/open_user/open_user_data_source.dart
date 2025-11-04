import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/user/user_data.dart';
import '../../../translations/locale_keys.dart';
import '../../../widgets/custom_cell.dart';
import 'open_user_controller.dart';

class OpenUserDataSource extends DataGridSource {
  OpenUserDataSource(this.controller) {
    updateDataSource();
  }

  final OpenUserController controller;

  void updateDataSource() {
    _dataGridRows = (controller.data ?? []).map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(UserData e) {
    return DataGridRow(
      cells: [
        DataGridCell<UserData>(columnName: 'select', value: e),
        DataGridCell<String>(columnName: 'code', value: e.mCode),
        DataGridCell<String>(columnName: 'mName', value: e.mName),
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
