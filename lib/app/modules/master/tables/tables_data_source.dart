import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/tables/tables_data.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_cell.dart';
import 'tables_controller.dart';

class TablesDataSource extends DataGridSource with WidgetsBindingObserver {
  TablesDataSource(this.controller) {
    updateDataSource();
    WidgetsBinding.instance.addObserver(this);
  }
  PopupMenu? popupMenu;
  final TablesController controller;

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
    _dataGridRows = (controller.data ?? []).map(_createDataRow).toList();

    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(TablesData e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'mTableNo', value: e.mTableNo),
        DataGridCell<String>(columnName: 'mTableName', value: e.mTableName),
        DataGridCell<String>(columnName: 'mLayer', value: e.mLayer),
        DataGridCell<String>(columnName: 'mStockCode', value: e.mStockCode),
        DataGridCell<String>(columnName: 'mShape', value: e.mShape),
        DataGridCell<String>(columnName: 'mServCharge', value: e.mServCharge),
        DataGridCell<String>(columnName: 'mDiscount', value: e.mDiscount),
        DataGridCell<String>(columnName: 'mByPerson', value: e.mByPerson),
        DataGridCell<String>(columnName: 'mProductCode', value: e.mProductCode),
        DataGridCell<String>(columnName: 'mDept', value: e.mDept),
        DataGridCell<String>(columnName: 'mToGo', value: e.mToGo),
        DataGridCell<TablesData>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          TablesData row = e.value as TablesData;
          GlobalKey globalKey = GlobalKey();
          return Get.context!.isPhoneOrWider
              ? Row(
                  children: [
                    // 复制
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.copy.tr,
                        child: IconButton(
                          icon: const Icon(Icons.copy, color: AppColors.copyColor),
                          onPressed: () => controller.copy(id: row.mId),
                        ),
                      ),
                    ),
                    // 编辑
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.edit.tr,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.editColor),
                          onPressed: () => controller.edit(id: row.mId),
                        ),
                      ),
                    ),
                    // 删除
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.delete.tr,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                          onPressed: () => controller.deleteRow(row.mId),
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
                          maxColumn: 2,
                        ),
                        onClickMenu: (MenuItemProvider item) {
                          if (item.menuUserInfo == "copy") {
                            // 复制
                            controller.copy(id: row.mId);
                          } else if (item.menuUserInfo == "edit") {
                            // 编辑
                            controller.edit(id: row.mId);
                          } else if (item.menuUserInfo == "delete") {
                            // 删除
                            controller.deleteRow(row.mId);
                          }
                        },
                        items: [
                          MenuItem(
                            title: LocaleKeys.copy.tr,
                            image: Icon(Icons.copy, color: Colors.white),
                            userInfo: "copy",
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
        // 形状
        if (e.columnName == "mShape") {
          switch (e.value) {
            case "0":
              return CustomCell(data: LocaleKeys.square.tr);
            case "1":
              return CustomCell(data: LocaleKeys.circle.tr);
            case "2":
              return CustomCell(data: LocaleKeys.rhombus.tr);
            default:
              return CustomCell(data: "");
          }
        }
        //数量依人数
        if (e.columnName == "mByPerson") {
          return CustomCell(data: e.value == "1" ? LocaleKeys.yes.tr : LocaleKeys.no.tr);
        }
        //模式
        if (e.columnName == "mToGo") {
          switch (e.value) {
            case "1":
              return CustomCell(data: LocaleKeys.takeOut.tr);
            case "2":
              return CustomCell(data: LocaleKeys.fastFood.tr);
            case "3":
              return CustomCell(data: LocaleKeys.appOrder.tr);
            default:
              return CustomCell(data: LocaleKeys.none.tr);
          }
        }
        // 其他列
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
