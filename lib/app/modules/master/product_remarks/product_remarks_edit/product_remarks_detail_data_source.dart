import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/product_remarks_model.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_cell.dart';
import 'product_remarks_edit_controller.dart';

class ProductRemarksDetailDataSource extends DataGridSource {
  ProductRemarksDetailDataSource(this.controller) {
    updateDataSource();
  }
  final ProductRemarksEditController controller;

  void updateDataSource() {
    _dataGridRows = controller.dataList.map(_createDataRow).toList();

    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(RemarksDetail e) {
    return DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'mSort', value: e.mId),
        DataGridCell<String>(columnName: 'mDetail', value: e.mDetail),
        DataGridCell<int>(columnName: 'mType', value: e.mType),
        DataGridCell<String>(columnName: 'addMoney', value: e.mPrice),
        DataGridCell<int>(columnName: 'classification', value: e.mRemarkType),
        DataGridCell<int>(columnName: 'overWrite', value: e.mOverwrite),
        DataGridCell<RemarksDetail>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          final RemarksDetail row = e.value as RemarksDetail;
          return Row(
            children: [
              // 编辑
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.edit.tr,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.editColor),
                    onPressed: null, //() => controller.edit(id: row.tCategoryId),
                  ),
                ),
              ),
              // 删除
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.delete.tr,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                    onPressed: null, //() => controller.deleteRow(row.tCategoryId),
                  ),
                ),
              ),
            ],
          );
        }
        // 类型
        if (e.columnName == "mType") {
          return CustomCell(
            data: e.value == 0
                ? LocaleKeys.addMoney.tr
                : e.value == 1
                ? LocaleKeys.discount.tr
                : LocaleKeys.multiple.tr,
          );
        } // 覆盖
        if (e.columnName == "overWrite") {
          return CustomCell(data: e.value == 0 ? LocaleKeys.no.tr : LocaleKeys.yes.tr);
        }
        // 其他列
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
