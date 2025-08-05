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
    _dataGridRows = controller.productSetMeal.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(ProductSetMeal e) {
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
        DataGridCell<ProductSetMeal>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        if (e.columnName == "actions") {
          ProductSetMeal row = e.value as ProductSetMeal;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.setMealEdit.tr,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.editColor),
                    onPressed: () {
                      controller.editProductSetMeal(row: row);
                    },
                  ),
                ),
              ),
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.setMealDelete.tr,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                    onPressed: () {
                      controller.deleteSetMeal([row.mId ?? 0]);
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
