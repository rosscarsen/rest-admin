import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../model/product/copy_product_set_meal.dart';
import '../../../../../translations/locale_keys.dart';
import '../../../../../widgets/custom_cell.dart';
import 'copy_product_set_meal_controller.dart';

class CopyProductSetMealDataSource extends DataGridSource {
  CopyProductSetMealDataSource(this.controller) {
    updateDataSource();
  }

  final CopyProductSetMealController controller;

  void updateDataSource() {
    _dataGridRows = controller.DataList.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(ProductSetMealData e) {
    return DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'select', value: e.tProductId),
        DataGridCell<String>(columnName: 'mCode', value: e.mCode),
        DataGridCell<String>(columnName: 'mDesc1', value: e.mDesc1),
        DataGridCell<String>(columnName: 'mDesc2', value: e.mDesc1),
        DataGridCell<String>(columnName: 'mRemarks', value: e.mDesc1),
        DataGridCell<String>(columnName: 'unit', value: e.mUnit),
        DataGridCell<String>(columnName: 'category1', value: e.mCategory1),
        DataGridCell<String>(columnName: 'category2', value: e.mCategory2),
        DataGridCell<String>(columnName: 'mMeasurement', value: e.mMeasurement),
        DataGridCell<String>(columnName: 'mPCode', value: e.mPCode),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        if (e.columnName == "select") {
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: FilledButton(
                onPressed: () {
                  Get.closeDialog(result: e.value);
                },
                child: Text(LocaleKeys.select.tr),
              ),
            ),
          );
        }
        if (e.columnName == "mPCode") {
          return CustomCell(data: (e.value?.toString() ?? "").isEmpty ? "N" : "Y");
        }
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
