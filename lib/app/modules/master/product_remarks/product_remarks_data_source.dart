import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/product_remarks_model.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_cell.dart';
import 'product_remarks_controller.dart';

class ProductRemarksDataSource extends DataGridSource with WidgetsBindingObserver {
  ProductRemarksDataSource(this.controller) {
    updateDataSource();
    WidgetsBinding.instance.addObserver(this);
  }
  PopupMenu? popupMenu;
  final ProductRemarksController controller;

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

  DataGridRow _createDataRow(ProductRemarksInfo e) {
    final List<RemarksDetail>? detail = e.remarksDetails;
    final String detailStr = detail?.map((e) => e.mDetail).join(",") ?? "";
    return DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'mSort', value: e.mSort),
        DataGridCell<String>(columnName: 'mRemark', value: e.mRemark),
        DataGridCell<String>(columnName: 'mDetail', value: detailStr),
        DataGridCell<int>(columnName: 'mVisible', value: e.mVisible),
        DataGridCell<ProductRemarksInfo>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        // 操作列
        if (e.columnName == "actions") {
          ProductRemarksInfo row = e.value as ProductRemarksInfo;
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
                          onPressed: () => controller.copyProductRemark(row: row),
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
                            // 导出
                            controller.copyProductRemark(row: row);
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
        // 停用
        if (e.columnName == "mVisible") {
          return CustomCell(data: e.value == 1 ? LocaleKeys.no.tr : LocaleKeys.yes.tr);
        }
        // 其他列
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
