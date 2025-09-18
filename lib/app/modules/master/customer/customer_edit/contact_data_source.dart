import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/customer/customer_contact.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/custom_alert.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../widgets/custom_cell.dart';
import 'customer_edit_controller.dart';

class ContactDataSource extends DataGridSource {
  ContactDataSource(this.controller) {
    updateDataSource();
  }
  final CustomerEditController controller;

  List<DataGridRow> _dataGridRows = [];

  void updateDataSource() {
    _dataGridRows = controller.customerContactList.map(_createDataRow).toList();
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(CustomerContact e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'mName', value: e.mName),
        DataGridCell<String>(columnName: 'mEmail', value: e.mEmail),
        DataGridCell<String>(columnName: 'mMobilePhone', value: e.mMobilePhone),
        DataGridCell<String>(columnName: 'mFax', value: e.mFax),
        DataGridCell<String>(columnName: 'mDepartment', value: e.mDepartment),
        DataGridCell<CustomerContact>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    final index = _dataGridRows.indexOf(dataGridRow);

    return DataGridRowAdapter(
      // 设置行颜色
      cells: dataGridRow.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          final CustomerContact row = e.value as CustomerContact;
          return Row(
            children: [
              Flexible(
                child: Tooltip(
                  message: LocaleKeys.edit.tr,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.editColor),
                    onPressed: () => controller.editOrAddContact(row: row),
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
                        message: LocaleKeys.areYouSureToDelete.tr,
                        showCancel: true,
                        onConfirm: () async {
                          try {
                            controller.customerContactList.removeAt(index);
                            controller.customerContactList.asMap().forEach((index, element) {
                              element.mItem = "${index + 1}";
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

        // 其他列
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
