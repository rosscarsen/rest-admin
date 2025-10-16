import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/stock/stock_data.dart';
import '../../../model/supplier/supplier_data.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_cell.dart';
import 'stock_controller.dart';

class StockDataSource extends DataGridSource with WidgetsBindingObserver {
  StockDataSource(this.controller) {
    updateDataSource();
  }
  final StockController controller;

  void updateDataSource() {
    _dataGridRows = controller.dataList.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(StockData e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'mCode', value: e.mCode),
        DataGridCell<String>(columnName: 'mName', value: e.mName),
        DataGridCell<String>(columnName: 'mAttn', value: e.mAttn),
        DataGridCell<String>(columnName: 'mPhone', value: e.mPhone),
        DataGridCell<String>(columnName: 'mFax', value: e.mFax),
        DataGridCell<String>(columnName: 'mAddress', value: e.mAddress),
        DataGridCell<StockData>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          StockData row = e.value as StockData;
          return Row(
            children: [
              // 编辑
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.edit.tr,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.editColor),
                    onPressed: () => controller.edit(id: row.tStockId),
                  ),
                ),
              ),
              // 删除
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.delete.tr,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                    onPressed: () => controller.deleteRow(row.tStockId),
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
