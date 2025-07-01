import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/product_remarks_model.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/logger.dart';
import '../../../widgets/custom_cell.dart';
import 'open_product_remarks_controller.dart';

class OpenProductRemarksDataSource extends DataGridSource {
  OpenProductRemarksDataSource(this.controller) {
    updateDataSource();
  }

  final OpenProductRemarksController controller;

  void updateDataSource() {
    _dataGridRows = controller.DataList.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(ProductRemarksInfo e) {
    final List<RemarksDetail>? detail = e.remarksDetails;
    final String detailStr = detail?.map((e) => e.mDetail).join(",") ?? "";
    return DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'T_Supplier_ID', value: e.mId),
        DataGridCell<String>(columnName: 'select', value: e.mRemark ?? ""),
        DataGridCell<int>(columnName: 'sort', value: e.mSort ?? 0),
        DataGridCell<String>(columnName: 'remarks', value: e.mRemark ?? ""),
        DataGridCell<String>(columnName: 'detail', value: detailStr),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        if (e.columnName == "select") {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: FittedBox(
              child: FilledButton(
                onPressed: () {
                  Get.back(result: e.value.toString());
                },
                child: Text(LocaleKeys.select.tr),
              ),
            ),
          );
        }
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
