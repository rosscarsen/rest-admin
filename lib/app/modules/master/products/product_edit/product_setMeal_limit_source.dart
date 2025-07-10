import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/product_add_or_edit_model.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../widgets/custom_cell.dart';
import 'product_edit_controller.dart';

class SetMealLimitSource extends DataGridSource {
  SetMealLimitSource(this.controller) {
    updateDataSource();
  }

  final ProductEditController controller;

  void updateDataSource() {
    _dataGridRows = controller.setMealLimit.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(SetMealLimit e) {
    return DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'setMealLimit', value: e.mStep),
        DataGridCell<int>(columnName: 'maxQty', value: e.limitMax),
        DataGridCell<int>(columnName: 'forceSelect', value: e.obligatory),
        DataGridCell<String>(columnName: 'chinese', value: e.zhtw),
        DataGridCell<String>(columnName: 'english', value: e.enus),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        if (e.columnName == "nonEnable") {
          return CustomCell(data: e.value == 1 ? LocaleKeys.yes.tr : LocaleKeys.no.tr);
        }
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
