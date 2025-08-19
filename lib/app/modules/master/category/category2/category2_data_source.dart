import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/category/category_model.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_cell.dart';
import 'category2_controller.dart';

class Category2DataSource extends DataGridSource {
  Category2DataSource(this.controller) {
    updateDataSource();
  }
  final Category2Controller controller;

  void updateDataSource() {
    _dataGridRows = controller.dataList.map(_createDataRow).toList();

    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(CategoryModel e) {
    return DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'mSort', value: e.mSort),
        DataGridCell<String>(columnName: 'mCategory', value: e.mCategory),
        DataGridCell<String>(columnName: 'mParent', value: e.mParent),
        DataGridCell<String>(columnName: 'mDescription', value: e.mDescription),
        DataGridCell<String>(columnName: 'mTimeStart', value: e.mTimeStart),
        DataGridCell<String>(columnName: 'mTimeEnd', value: e.mTimeEnd),
        DataGridCell<int>(columnName: 'mHide', value: e.mHide),
        DataGridCell<String>(columnName: 'mPrinter', value: e.mPrinter),
        DataGridCell<String>(columnName: 'mBDLPrinter', value: e.mBdlPrinter),
        DataGridCell<int>(columnName: 'mContinue', value: e.mContinue),
        DataGridCell<int>(columnName: 'mCustomerSelfHelpHide', value: e.mCustomerSelfHelpHide),
        DataGridCell<CategoryModel>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          CategoryModel row = e.value as CategoryModel;
          return Row(
            children: [
              // 编辑
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.edit.tr,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.editColor),
                    onPressed: () => controller.edit(id: row.tCategoryId),
                  ),
                ),
              ),
              // 删除
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.delete.tr,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                    onPressed: () => controller.deleteRow(row.tCategoryId),
                  ),
                ),
              ),
            ],
          );
        }
        // 停用
        if (e.columnName == "mHide") {
          return CustomCell(data: e.value == 1 ? LocaleKeys.yes.tr : LocaleKeys.no.tr);
        }
        // 客户自助停用
        if (e.columnName == "mCustomerSelfHelpHide") {
          return CustomCell(data: e.value == 1 ? LocaleKeys.yes.tr : LocaleKeys.no.tr);
        }
        // 连续打印
        if (e.columnName == "mContinue") {
          return CustomCell(data: e.value == 1 ? LocaleKeys.yes.tr : LocaleKeys.no.tr);
        }
        // 其他列
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
