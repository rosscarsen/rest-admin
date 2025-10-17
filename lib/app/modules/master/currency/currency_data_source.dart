import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/currency/currency_data.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_cell.dart';
import 'currency_controller.dart';

class CurrencyDataSource extends DataGridSource with WidgetsBindingObserver {
  CurrencyDataSource(this.controller) {
    updateDataSource();
  }
  final CurrencyController controller;

  void updateDataSource() {
    _dataGridRows = controller.dataList.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(CurrencyData e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'mCode', value: e.mCode),
        DataGridCell<String>(columnName: 'mDescription', value: e.mDescription),
        DataGridCell<String>(columnName: 'mRate', value: e.mRate),
        DataGridCell<String>(columnName: 'mDefault', value: e.mDefault),
        DataGridCell<CurrencyData>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          CurrencyData row = e.value as CurrencyData;
          return Row(
            children: [
              // 编辑
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.edit.tr,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.editColor),
                    onPressed: () => controller.edit(id: row.tMoneyCurrencyId),
                  ),
                ),
              ),
              // 删除
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.delete.tr,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                    onPressed: () => controller.deleteRow(row.tMoneyCurrencyId),
                  ),
                ),
              ),
            ],
          );
        }
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
