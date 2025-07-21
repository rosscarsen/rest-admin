import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/product_add_or_edit_model.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_cell.dart';
import 'product_edit_controller.dart';

class ProductSetMealSource extends DataGridSource {
  ProductSetMealSource(this.controller) {
    updateDataSource();
  }

  final ProductEditController controller;

  void updateDataSource() {
    _dataGridRows = controller.setMeal.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(SetMeal e) {
    return DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'ID', value: e.mId),
        DataGridCell<String>(columnName: 'mBarcode', value: e.mBarcode),
        DataGridCell<String>(columnName: 'mName', value: e.mName),
        DataGridCell<String>(columnName: 'mQty', value: e.mQty),
        DataGridCell<String>(columnName: 'mPrice', value: e.mPrice),
        DataGridCell<String>(columnName: 'mPrice2', value: e.mPrice2),
        DataGridCell<String>(columnName: 'mStep', value: e.mStep),
        DataGridCell<int>(columnName: 'mDefault', value: e.mDefault),
        DataGridCell<int>(columnName: 'mSort', value: e.mSort),
        DataGridCell<String>(columnName: 'mRemarks', value: e.mRemarks),
        DataGridCell<SetMeal>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        if (e.columnName == "actions") {
          SetMeal row = e.value as SetMeal;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.edit.tr,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.editColor),
                    onPressed: () {
                      // controller.editOrAddProductBarcode(row: row);
                    },
                  ),
                ),
              ),
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.delete.tr,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                    onPressed: () {
                      // controller.deleteProductBarcode(row: row);
                    },
                  ),
                ),
              ),
            ],
          );
        }
        if (e.columnName == "nonEnable") {
          return CustomCell(data: e.value == 1 ? LocaleKeys.yes.tr : LocaleKeys.no.tr);
        }
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
