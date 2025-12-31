import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/department/department_data.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_cell.dart';
import 'department_controller.dart';

class DepartmentDataSource extends DataGridSource with WidgetsBindingObserver {
  DepartmentDataSource(this.controller) {
    updateDataSource();
  }
  final DepartmentController controller;

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
        DataGridCell<String>(columnName: 'mBrand', value: e.mBrand),
        DataGridCell<DepartmentData>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          DepartmentData row = e.value as DepartmentData;
          return Row(
            children: [
              // 编辑
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.edit.tr,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.editColor),
                    onPressed: () => controller.edit(id: row.tBrandId),
                  ),
                ),
              ),
              // 删除
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.delete.tr,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                    onPressed: () => controller.deleteRow(row.tBrandId),
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
