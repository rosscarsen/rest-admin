import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/network_pay_method/network_pay_method_data.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/constants.dart';
import '../../../utils/logger.dart';
import '../../../widgets/custom_cell.dart';
import 'network_pay_method_controller.dart';

class NetworkPayMethodDataSource extends DataGridSource with WidgetsBindingObserver {
  NetworkPayMethodDataSource(this.controller) {
    updateDataSource();
  }
  final NetworkPayMethodController controller;

  void updateDataSource() {
    _dataGridRows = (controller.data ?? []).map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(NetworkPayMethodData e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'tSupplier', value: e.tSupplier),
        DataGridCell<String>(columnName: 'tPaytype', value: e.tPaytype),
        DataGridCell<NetworkPayMethodData>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          NetworkPayMethodData row = e.value as NetworkPayMethodData;
          return Row(
            children: [
              // 编辑
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.edit.tr,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.editColor),
                    onPressed: () => controller.edit(id: row.id),
                  ),
                ),
              ),
              // 删除
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.delete.tr,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                    onPressed: () => controller.deleteRow(row.id),
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
