import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/product_add_or_edit_model.dart';
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
    final int index = _dataGridRows.indexOf(dataGridRow);
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        if (e.columnName == "maxQty") {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextFormField(
              key: ValueKey('maxQty_$index'),
              initialValue: e.value?.toString() ?? "",
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null) {
                  controller.setMealLimit[index].limitMax = parsed;
                }
              },
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            ),
          );
        }
        if (e.columnName == "forceSelect") {
          return Checkbox(
            value: e.value == 1,
            onChanged: (value) {
              controller.setMealLimit[index].obligatory = value == true ? 1 : 0;
            },
          );
        }
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
