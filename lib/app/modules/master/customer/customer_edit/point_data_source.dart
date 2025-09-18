import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/customer/point_list.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/custom_alert.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../widgets/custom_cell.dart';
import 'customer_edit_controller.dart';

class PointDetailDataSource extends DataGridSource {
  PointDetailDataSource(this.controller) {
    updateDataSource();
  }
  final CustomerEditController controller;

  List<DataGridRow> _dataGridRows = [];

  void updateDataSource() {
    _dataGridRows = controller.pointList.map(_createDataRow).toList();
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(PointData e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'mRef_No', value: e.mRefNo),
        DataGridCell<String>(columnName: 'mDeposit_Date', value: e.mDepositDate),
        DataGridCell<String>(columnName: 'mAmount', value: e.mAmount),
        DataGridCell<String>(columnName: 'mRemark', value: e.mRemark),
        DataGridCell<PointData>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      // 设置行颜色
      cells: dataGridRow.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          final PointData row = e.value as PointData;
          return Row(
            children: [
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.edit.tr,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.editColor),
                    onPressed: () => controller.editOrAddPoint(row: row, isAdd: false),
                  ),
                ),
              ),
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.delete.tr,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                    onPressed: () async {
                      await CustomAlert.iosAlert(
                        message: LocaleKeys.areYouSureToDelete.tr,
                        showCancel: true,
                        onConfirm: () async {
                          await controller.deleteCustomerPoint(row: row);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }

        // 其他列
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
