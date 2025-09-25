import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../model/supplierInvoice/supplier_invoice_api_model.dart';
import '../../translations/locale_keys.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_cell.dart';
import 'supplier_invoice_controller.dart';

class SupplierInvoiceDataSource extends DataGridSource with WidgetsBindingObserver {
  SupplierInvoiceDataSource(this.controller) {
    updateDataSource();
    WidgetsBinding.instance.addObserver(this);
  }
  PopupMenu? popupMenu;
  final SupplierInvoiceController controller;

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (popupMenu?.isShow == true) {
      popupMenu?.dismiss();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void updateDataSource() {
    _dataGridRows = controller.dataList.map(_createDataRow).toList();

    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(Invoice e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'mSupplierInvoiceInNo', value: e.mSupplierInvoiceInNo),
        DataGridCell<String>(columnName: 'mRevised', value: e.mRevised),
        DataGridCell<String>(columnName: 'mSupplierInvoiceInDate', value: e.mSupplierInvoiceInDate),
        DataGridCell<String>(columnName: 'mMoneyCurrency', value: e.mMoneyCurrency),
        DataGridCell<String>(columnName: 'mAmount', value: e.mAmount),
        DataGridCell<String>(columnName: 'mSupplierCode', value: e.mSupplierCode),
        DataGridCell<String>(columnName: 'mSupplierName', value: e.mSupplierName),
        DataGridCell<String>(columnName: 'mFlag', value: e.mFlag),
        DataGridCell<Invoice>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          Invoice row = e.value as Invoice;
          final GlobalKey globalKey = GlobalKey();
          return Get.context!.isPhoneOrWider
              ? Row(
                  children: [
                    Flexible(
                      child: Tooltip(
                        message: (row.mFlag ?? "0") != "1" ? LocaleKeys.posting.tr : LocaleKeys.cancelPosting.tr,
                        child: IconButton(
                          icon: Icon(
                            (row.mFlag ?? "0") != "1" ? Icons.lock : Icons.lock_open,
                            color: Colors.teal.shade500,
                          ),
                          onPressed: () => controller.posting(id: row.tSupplierInvoiceInId, flag: row.mFlag),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.print.tr,
                        child: IconButton(
                          icon: const Icon(Icons.print, color: AppColors.copyColor),
                          onPressed: () => controller.printInvoice(id: row.tSupplierInvoiceInId),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.edit.tr,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.editColor),
                          onPressed: () => controller.edit(id: row.tSupplierInvoiceInId),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.delete.tr,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                          onPressed: () => controller.deleteRow(id: row.tSupplierInvoiceInId),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: IconButton(
                    tooltip: LocaleKeys.moreOperation.tr,
                    key: globalKey,
                    onPressed: () {
                      PopupMenu menu = PopupMenu(
                        context: Get.context!,
                        config: MenuConfig(
                          textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                          lineColor: Colors.white24,
                        ),
                        onClickMenu: (MenuItemProvider item) {
                          if (item.menuUserInfo == "posting") {
                            controller.posting(id: row.tSupplierInvoiceInId, flag: row.mFlag);
                          } else if (item.menuUserInfo == "print") {
                            controller.printInvoice(id: row.tSupplierInvoiceInId);
                          } else if (item.menuUserInfo == "edit") {
                            controller.edit(id: row.tSupplierInvoiceInId);
                          } else if (item.menuUserInfo == "delete") {
                            controller.deleteRow(id: row.tSupplierInvoiceInId);
                          }
                        },
                        items: [
                          MenuItem(
                            title: (row.mFlag ?? "0") != "1" ? LocaleKeys.posting.tr : LocaleKeys.cancelPosting.tr,
                            image: Icon((row.mFlag ?? "0") != "1" ? Icons.lock : Icons.lock_open, color: Colors.white),
                            userInfo: "posting",
                          ),
                          MenuItem(
                            title: LocaleKeys.print.tr,
                            image: Icon(Icons.print, color: Colors.white),
                            userInfo: "print",
                          ),
                          MenuItem(
                            title: LocaleKeys.edit.tr,
                            image: Icon(Icons.edit, color: Colors.white),
                            userInfo: "edit",
                          ),
                          MenuItem(
                            title: LocaleKeys.delete.tr,
                            image: Icon(Icons.delete, color: Colors.white),
                            userInfo: "delete",
                          ),
                        ],
                      );
                      menu.show(widgetKey: globalKey);
                      popupMenu = menu;
                    },
                    icon: Icon(Icons.more_vert),
                  ),
                );
        }

        //套餐
        if (e.columnName == "mFlag") {
          return CustomCell(data: e.value == "0" ? LocaleKeys.no.tr : LocaleKeys.yes.tr);
        }
        // 其他列
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
