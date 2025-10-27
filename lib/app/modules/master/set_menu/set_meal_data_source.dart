import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/set_meal/set_meal_data.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_cell.dart';
import 'set_menu_controller.dart';

class SetMealDataSource extends DataGridSource with WidgetsBindingObserver {
  SetMealDataSource(this.controller) {
    WidgetsBinding.instance.addObserver(this);
    updateDataSource();
  }
  PopupMenu? popupMenu;
  final SetMenuController controller;

  void updateDataSource() {
    _dataGridRows = controller.data?.map(_createDataRow).toList() ?? [];
    notifyListeners();
  }

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

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  DataGridRow _createDataRow(SetMealData e) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'mCode', value: e.mCode ?? ""),
        DataGridCell<String>(columnName: 'mDesc', value: e.mDesc ?? ""),
        DataGridCell<String>(columnName: 'detail', value: e.detail ?? ""),
        DataGridCell<SetMealData>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          SetMealData row = e.value as SetMealData;
          GlobalKey globalKey = GlobalKey();
          return Get.context!.isPhoneOrWider
              ? Row(
                  children: [
                    //更新
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.update.tr,
                        child: IconButton(
                          icon: const Icon(Icons.update, color: Colors.teal),
                          onPressed: () => controller.updateSetMeal(row),
                        ),
                      ),
                    ),
                    //复制
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.copy.tr,
                        child: IconButton(
                          icon: const Icon(Icons.copy, color: AppColors.copyColor),
                          onPressed: () => controller.copy(id: row.tSetmenuId),
                        ),
                      ),
                    ),
                    // 编辑
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.edit.tr,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.editColor),
                          onPressed: () => controller.edit(id: row.tSetmenuId),
                        ),
                      ),
                    ),
                    // 删除
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.delete.tr,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                          onPressed: () => controller.deleteRow(row.tSetmenuId),
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
                          if (item.menuUserInfo == "update") {
                            controller.updateSetMeal(row);
                          } else if (item.menuUserInfo == "copy") {
                            controller.copy(id: row.tSetmenuId);
                          } else if (item.menuUserInfo == "edit") {
                            controller.edit(id: row.tSetmenuId);
                          } else if (item.menuUserInfo == "delete") {
                            controller.deleteRow(row.tSetmenuId);
                          }
                        },
                        items: [
                          MenuItem(
                            title: LocaleKeys.update.tr,
                            image: Icon(Icons.update, color: Colors.white),
                            userInfo: "update",
                          ),
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

        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
