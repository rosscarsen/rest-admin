import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/category/category_model.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_cell.dart';
import 'category_controller.dart';

class CategoryDataSource extends DataGridSource with WidgetsBindingObserver {
  CategoryDataSource(this.controller) {
    updateDataSource();
    WidgetsBinding.instance.addObserver(this);
  }
  PopupMenu? popupMenu;
  final CategoryController controller;

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

  DataGridRow _createDataRow(CategoryModel e) {
    return DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'ID', value: e.tCategoryId),
        DataGridCell<int>(columnName: 'tier', value: e.tier),
        DataGridCell<int>(columnName: 'mSort', value: e.mSort),
        DataGridCell<String>(columnName: 'mCategory', value: e.mCategory),
        DataGridCell<String>(columnName: 'mDescription', value: e.mDescription),
        DataGridCell<String>(columnName: 'mTimeStart', value: e.mTimeStart),
        DataGridCell<String>(columnName: 'mTimeEnd', value: e.mTimeEnd),
        DataGridCell<int>(columnName: 'mHide', value: e.mHide),
        DataGridCell<int>(columnName: 'mCustomerSelfHelpHide', value: e.mCustomerSelfHelpHide),
        DataGridCell<int>(columnName: 'mTakeawayDisplay', value: e.mTakeawayDisplay),
        DataGridCell<int>(columnName: 'mKiosk', value: e.mKiosk),
        DataGridCell<CategoryModel>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          CategoryModel row = e.value as CategoryModel;
          GlobalKey globalKey = GlobalKey();
          return Get.context!.isPhoneOrWider
              ? Row(
                  children: [
                    // 子分类
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.childrenCategory.tr,
                        child: IconButton(
                          icon: const Icon(Icons.category, color: Colors.blue),
                          onPressed: () => controller.openChildCategory(row),
                        ),
                      ),
                    ),
                    // 导出
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.export.tr,
                        child: IconButton(
                          icon: const Icon(Icons.file_open, color: AppColors.exportColor),
                          onPressed: () => controller.exportCategory(id: row.tCategoryId),
                        ),
                      ),
                    ),
                    // 编辑
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.edit.tr,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.editColor),
                          onPressed: () => controller.edit(id: row.tCategoryId),
                        ),
                      ),
                    ),
                    // 删除
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.delete.tr,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                          onPressed: () => controller.deleteRow(row.tCategoryId),
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
                          if (item.menuUserInfo == "childrenCategory") {
                            // 子分类
                            controller.openChildCategory(row);
                          } else if (item.menuUserInfo == "export") {
                            // 导出
                            controller.exportCategory(id: row.tCategoryId);
                          } else if (item.menuUserInfo == "edit") {
                            // 编辑
                            controller.edit(id: row.tCategoryId);
                          } else if (item.menuUserInfo == "delete") {
                            // 删除
                            controller.deleteRow(row.tCategoryId);
                          }
                        },
                        items: [
                          MenuItem(
                            title: LocaleKeys.childrenCategory.tr,
                            image: Icon(Icons.category, color: Colors.white),
                            userInfo: "childrenCategory",
                          ),
                          MenuItem(
                            title: LocaleKeys.export.tr,
                            image: Icon(Icons.file_open, color: Colors.white),
                            userInfo: "export",
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
        // 停用
        if (e.columnName == "mHide") {
          return CustomCell(data: e.value == 1 ? LocaleKeys.yes.tr : LocaleKeys.no.tr);
        }
        // 客户自助停用
        if (e.columnName == "mCustomerSelfHelpHide") {
          return CustomCell(data: e.value == 1 ? LocaleKeys.yes.tr : LocaleKeys.no.tr);
        }
        // 外卖显示
        if (e.columnName == "mTakeawayDisplay") {
          return CustomCell(data: e.value == 1 ? LocaleKeys.yes.tr : LocaleKeys.no.tr);
        }
        // 点餐台
        if (e.columnName == "mKiosk") {
          return CustomCell(data: e.value == 1 ? LocaleKeys.yes.tr : LocaleKeys.no.tr);
        }
        // 其他列
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
