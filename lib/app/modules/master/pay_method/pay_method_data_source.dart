import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/pay_method/pay_method_data.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_cell.dart';
import 'pay_method_controller.dart';

class PayMethodDataSource extends DataGridSource with WidgetsBindingObserver {
  PayMethodDataSource(this.controller) {
    updateDataSource();
  }
  final PayMethodController controller;

  void updateDataSource() {
    _dataGridRows = (controller.data ?? []).map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(PayMethodData e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'mPayType', value: e.mPayType),
        DataGridCell<String>(columnName: 'tPaytypeOnline', value: e.tPaytypeOnline),
        DataGridCell<String>(columnName: 'mSort', value: e.mSort),
        DataGridCell<String>(columnName: 'mPrePaid', value: e.mPrePaid),
        DataGridCell<String>(columnName: 'mCom', value: e.mCom),
        DataGridCell<String>(columnName: 'mCardType', value: e.mCardType),
        DataGridCell<String>(columnName: 'mNoDrawer', value: e.mNoDrawer),
        DataGridCell<String>(columnName: 'mHide', value: e.mHide),
        DataGridCell<PayMethodData>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        //预支付
        if (e.columnName == "mPrePaid") {
          return CustomCell(data: e.value == "1" ? LocaleKeys.yes.tr : LocaleKeys.no.tr);
        }
        //不弹柜
        if (e.columnName == "mNoDrawer") {
          return CustomCell(data: e.value == "1" ? LocaleKeys.yes.tr : LocaleKeys.no.tr);
        }
        //隐藏
        if (e.columnName == "mHide") {
          return CustomCell(data: e.value == "1" ? LocaleKeys.yes.tr : LocaleKeys.no.tr);
        }
        // 操作列
        if (e.columnName == "actions") {
          PayMethodData row = e.value as PayMethodData;
          return Row(
            children: [
              // 编辑
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.edit.tr,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.editColor),
                    onPressed: () => controller.edit(id: row.tPayTypeId),
                  ),
                ),
              ),
              // 删除
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.delete.tr,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                    onPressed: () => controller.deleteRow(row.tPayTypeId),
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
