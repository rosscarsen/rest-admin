import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../translations/locale_keys.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_cell.dart';
import 'model/set_menu_edit_model.dart';
import 'set_menu_edit_controller.dart';

class SetMenuSetMealSource extends DataGridSource {
  SetMenuSetMealSource(this.controller) {
    updateDataSource();
  }

  final SetMenuEditController controller;

  void filter(String? value) {
    updateDataSource(searchText: value);
  }

  void updateDataSource({String? searchText}) {
    final filteredList = (controller.data?.setMenuDetail ?? []).where((detail) {
      if (searchText?.isEmpty ?? true) return true;
      return detail.mStep?.toString().contains(searchText!) ?? false;
    }).toList();
    _dataGridRows = filteredList.map(_createDataRow).toList();
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(SetMenuDetail e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'ID', value: e.mId),
        DataGridCell<String>(columnName: 'mBarcode', value: e.mBarcode),
        DataGridCell<String>(columnName: 'mName', value: e.mName),
        DataGridCell<String>(columnName: 'mQty', value: e.mQty),
        DataGridCell<String>(columnName: 'mPrice', value: e.mPrice),
        DataGridCell<String>(columnName: 'mPrice2', value: e.mPrice2),
        DataGridCell<String>(columnName: 'mStep', value: e.mStep),
        DataGridCell<String>(columnName: 'mDefault', value: e.mDefault),
        DataGridCell<String>(columnName: 'mSort', value: e.mSort),
        DataGridCell<String>(columnName: 'mRemarks', value: e.mRemarks),
        DataGridCell<SetMenuDetail>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        if (e.columnName == "actions") {
          SetMenuDetail row = e.value as SetMenuDetail;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.setMealEdit.tr,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.editColor),
                    onPressed: () {
                      controller.editSetMenuDetail(row: row);
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
                      controller.deleteItems([row.mId ?? ""]);
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
