import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/supplier/supplier_data.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_cell.dart';
import 'supplier_controller.dart';

class SupplierDataSource extends DataGridSource with WidgetsBindingObserver {
  SupplierDataSource(this.controller) {
    updateDataSource();
  }
  final SupplierController controller;

  void updateDataSource() {
    _dataGridRows = controller.dataList.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(SupplierData e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'mCode', value: e.mCode),
        DataGridCell<String>(columnName: 'mSimpleName', value: e.mSimpleName),
        DataGridCell<String>(columnName: 'mFullName', value: e.mFullName),
        DataGridCell<String>(columnName: 'mPhoneNo', value: e.mPhoneNo),
        DataGridCell<String>(columnName: 'mFaxNo', value: e.mFaxNo),
        DataGridCell<SupplierData>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          SupplierData row = e.value as SupplierData;
          return Row(
            children: [
              // 编辑
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.edit.tr,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.editColor),
                    onPressed: () => controller.edit(id: row.tSupplierId),
                  ),
                ),
              ),
              // 删除
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.delete.tr,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                    onPressed: () => controller.deleteRow(row.tSupplierId),
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
