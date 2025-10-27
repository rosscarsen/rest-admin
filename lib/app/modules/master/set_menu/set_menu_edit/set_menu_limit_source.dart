import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../widgets/custom_cell.dart';
import 'model/set_menu_edit_model.dart';
import 'set_menu_edit_controller.dart';

class SetMenuLimitSource extends DataGridSource {
  SetMenuLimitSource(this.controller) {
    updateDataSource();
  }

  final SetMenuEditController controller;

  void updateDataSource() {
    _dataGridRows = (controller.data?.setLimit ?? []).map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];
  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(SetLimit e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'setMealLimit', value: e.mStep),
        DataGridCell<String>(columnName: 'maxQty', value: e.limitMax),
        DataGridCell<String>(columnName: 'forceSelect', value: e.obligatory),
        DataGridCell<String>(columnName: 'chinese', value: e.zhtw),
        DataGridCell<String>(columnName: 'english', value: e.enus),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    final int rowIndex = _dataGridRows.indexOf(dataGridRow);
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().asMap().entries.map<Widget>((entry) {
        final int columnIndex = entry.key;
        final DataGridCell e = entry.value;
        if (e.columnName == "maxQty") {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextFormField(
              key: ValueKey('maxQty_$rowIndex'),
              initialValue: e.value?.toString() ?? "",
              decoration: InputDecoration(isDense: true),
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null) {
                  controller.data?.setLimit?[rowIndex].limitMax = parsed.toString();
                }
              },
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            ),
          );
        }
        if (e.columnName == "forceSelect") {
          return Checkbox(
            key: ValueKey("forceSelect_$rowIndex"),
            value: e.value == "1",
            onChanged: (value) {
              controller.data?.setLimit?[rowIndex].obligatory = value == true ? "1" : "0";
              dataGridRow.getCells()[columnIndex] = DataGridCell(
                columnName: "forceSelect",
                value: value == true ? "1" : "0",
              );
              notifyDataSourceListeners(rowColumnIndex: RowColumnIndex(rowIndex, columnIndex));
            },
          );
        }
        if (e.columnName == "chinese") {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextFormField(
              key: ValueKey('chinese_$rowIndex'),
              decoration: InputDecoration(isDense: true),
              initialValue: e.value?.toString() ?? "",
              onChanged: (value) {
                controller.data?.setLimit?[rowIndex].zhtw = value;
              },
            ),
          );
        }
        if (e.columnName == "english") {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextFormField(
              decoration: InputDecoration(isDense: true),
              key: ValueKey('english_$rowIndex'),
              initialValue: e.value?.toString() ?? "",
              onChanged: (value) {
                controller.data?.setLimit?[rowIndex].enus = value;
              },
            ),
          );
        }
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
