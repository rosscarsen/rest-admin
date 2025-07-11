import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/product_add_or_edit_model.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_cell.dart';
import 'product_edit_controller.dart';

class ProductBarcodeSource extends DataGridSource {
  ProductBarcodeSource(this.controller) {
    updateDataSource();
  }

  final ProductEditController controller;

  void updateDataSource() {
    _dataGridRows = controller.productBarcode.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(ProductBarcode e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'barcode', value: e.mCode),
        DataGridCell<String>(columnName: 'name', value: e.mName),
        DataGridCell<int>(columnName: 'nonEnable', value: e.mNonActived),
        DataGridCell<String>(columnName: 'remarks', value: e.mRemarks),
        DataGridCell<ProductBarcode>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        if (e.columnName == "actions") {
          ProductBarcode row = e.value as ProductBarcode;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.edit.tr,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.editColor),
                    onPressed: () {
                      controller.editOrAddProductBarcode(row: row);
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
                      controller.deleteProductBarcode(row: row);
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
