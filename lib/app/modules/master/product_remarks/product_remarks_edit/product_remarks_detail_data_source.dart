import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/product_remarks_model.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/custom_alert.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../widgets/custom_cell.dart';
import 'product_remarks_edit_controller.dart';

class ProductRemarksDetailDataSource extends DataGridSource {
  ProductRemarksDetailDataSource(this.controller) {
    updateDataSource();
  }
  final ProductRemarksEditController controller;

  List<DataGridRow> _dataGridRows = [];
  int? _highlightRowIndex; // 高亮行索引
  Timer? _highlightTimer;
  void updateDataSource() {
    _dataGridRows = controller.dataList.map(_createDataRow).toList();
    notifyListeners();
  }

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
        DataGridCell<dynamic>(columnName: 'move', value: ""),
        DataGridCell<RemarksDetail>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    final index = _dataGridRows.indexOf(dataGridRow);

    return DataGridRowAdapter(
      // 设置行颜色
      color: index == _highlightRowIndex ? Colors.yellow.shade100 : null,
      cells: dataGridRow.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          final RemarksDetail row = e.value as RemarksDetail;
          return Row(
            children: [
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.edit.tr,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.editColor),
                    onPressed: () => controller.editOrAddDetail(row: row),
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
                        LocaleKeys.areYouSureToDelete.tr,
                        showCancel: true,
                        onConfirm: () async {
                          try {
                            controller.dataList.removeAt(index);
                            controller.dataList.asMap().forEach((index, element) {
                              element.mId = index + 1;
                            });
                            updateDataSource();
                          } catch (e) {
                            CustomDialog.errorMessages(LocaleKeys.exception.tr);
                          }
                        },
                      );
                    },
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
        }
        // 覆盖
        if (e.columnName == "overWrite") {
          return CustomCell(data: e.value == 0 ? LocaleKeys.no.tr : LocaleKeys.yes.tr);
        }
        // 移动
        if (e.columnName == "move") {
          return Align(
            alignment: Alignment.center,
            child: OverflowBar(
              alignment: MainAxisAlignment.center,
              overflowAlignment: OverflowBarAlignment.center,
              children: [
                if (index > 0)
                  IconButton(
                    tooltip: LocaleKeys.moveUp.tr,
                    icon: const Icon(Icons.arrow_upward, color: AppColors.editColor),
                    onPressed: () {
                      final temp = controller.dataList[index];
                      controller.dataList[index] = controller.dataList[index - 1];
                      controller.dataList[index - 1] = temp;
                      for (var i = 0; i < controller.dataList.length; i++) {
                        controller.dataList[i].mId = i + 1;
                      }
                      _highlightRowIndex = index - 1;
                      updateDataSource();
                      _highlightTimer?.cancel();
                      _highlightTimer = Timer(const Duration(seconds: 3), () {
                        _highlightRowIndex = null;
                        notifyListeners();
                      });
                    },
                  ),
                if (index < _dataGridRows.length - 1)
                  IconButton(
                    tooltip: LocaleKeys.moveDown.tr,
                    icon: const Icon(Icons.arrow_downward, color: AppColors.editColor),
                    onPressed: () {
                      final temp = controller.dataList[index];
                      controller.dataList[index] = controller.dataList[index + 1];
                      controller.dataList[index + 1] = temp;
                      for (var i = 0; i < controller.dataList.length; i++) {
                        controller.dataList[i].mId = i + 1;
                      }
                      _highlightRowIndex = index + 1;
                      updateDataSource();
                      _highlightTimer?.cancel();
                      _highlightTimer = Timer(const Duration(seconds: 3), () {
                        _highlightRowIndex = null;
                        notifyListeners();
                      });
                    },
                  ),
              ],
            ),
          );
        }
        // 其他列
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
