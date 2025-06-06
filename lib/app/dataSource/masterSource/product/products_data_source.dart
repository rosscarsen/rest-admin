import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/products_model.dart';
import '../../../modules/master/products/products_controller.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/constants.dart';
import '../../../utils/easy_loading.dart';
import '../../../widgets/custom_cell.dart';

class ProductsDataSource extends DataGridSource with WidgetsBindingObserver {
  ProductsDataSource(this.controller) {
    updateDataSource();
    WidgetsBinding.instance.addObserver(this);
  }
  PopupMenu? popupMenu;
  final ProductsController controller;

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

  DataGridRow _createDataRow(ProductData e) {
    return DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'ID', value: e.tProductId),
        DataGridCell<String>(columnName: 'code', value: e.mCode),
        DataGridCell<String>(columnName: 'name', value: e.mDesc1),
        DataGridCell<String>(columnName: 'kitchenList', value: e.mDesc2),
        DataGridCell<String>(columnName: 'keyName', value: e.mRemarks),
        DataGridCell<int>(columnName: 'soldOut', value: e.mSoldOut),
        DataGridCell<String>(columnName: 'category1', value: e.mCategory1),
        DataGridCell<String>(columnName: 'category2', value: e.mCategory2),
        DataGridCell<String>(columnName: 'price', value: e.mPrice),
        DataGridCell<String>(columnName: 'productRemarks', value: e.mMeasurement),
        DataGridCell<String>(columnName: 'discount', value: e.mDiscount),
        DataGridCell<String>(columnName: 'setMeal', value: e.mPCode),
        DataGridCell<int>(columnName: 'sort', value: e.sort),
        DataGridCell<String>(
          columnName: 'picture',
          value: (e.imagesPath?.isNotEmpty ?? false)
              ? "${e.imagesPath}?timestamp=${DateTime.now().millisecondsSinceEpoch}"
              : "",
        ),
        DataGridCell<ProductData>(columnName: 'actions', value: e),
      ],
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
      cells: dataGridRow.getCells().map<Widget>((e) {
        ValueNotifier<bool> isImageLoaded = ValueNotifier<bool>(false);
        // 操作列
        if (e.columnName == "actions") {
          ProductData row = e.value as ProductData;
          GlobalKey globalKey = GlobalKey();
          return Get.context!.isPhoneOrWider
              ? Row(
                  children: [
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.exportSetMeal.tr,
                        child: IconButton(
                          icon: const Icon(Icons.file_open, color: AppColors.exportColor),
                          onPressed: () => controller.exportSetMeal(row),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.copy.tr,
                        child: IconButton(
                          icon: const Icon(Icons.copy, color: AppColors.copyColor),
                          onPressed: () => controller.copy(row),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.edit.tr,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.editColor),
                          onPressed: () => controller.edit(row),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.delete.tr,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.deleteColor),
                          onPressed: () => controller.deleteRow(row),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Tooltip(
                        message: LocaleKeys.uploadPicture.tr,
                        child: IconButton(
                          icon: const Icon(Icons.cloud_upload, color: AppColors.uploadColor),
                          onPressed: () {
                            controller.uploadImage(row, Get.context!);
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: IconButton(
                    key: globalKey,
                    onPressed: () {
                      PopupMenu menu = PopupMenu(
                        context: Get.context!,
                        config: MenuConfig(
                          textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                          lineColor: Colors.white24,
                        ),
                        onClickMenu: (MenuItemProvider item) {
                          if (item.menuUserInfo == "exportSetMeal") {
                            controller.exportSetMeal(row);
                          } else if (item.menuUserInfo == "copy") {
                            controller.copy(row);
                          } else if (item.menuUserInfo == "edit") {
                            controller.edit(row);
                          } else if (item.menuUserInfo == "delete") {
                            controller.deleteRow(row);
                          } else if (item.menuUserInfo == "uploadPicture") {
                            controller.uploadImage(row, Get.context!);
                          }
                        },
                        items: [
                          MenuItem(
                            title: LocaleKeys.exportSetMeal.tr,
                            image: Icon(Icons.file_open, color: Colors.white),
                            userInfo: "exportSetMeal",
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
                          MenuItem(
                            title: LocaleKeys.uploadPicture.tr,
                            image: Icon(Icons.cloud_upload, color: Colors.white),
                            userInfo: "uploadPicture",
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
        // 图片
        if (e.columnName == "picture") {
          return ValueListenableBuilder<bool>(
            valueListenable: isImageLoaded,
            builder: (context, isLoaded, child) {
              return InkWell(
                onTap: () async {
                  if (isImageLoaded.value) {
                    await showImageViewer(
                      context,
                      Image.network(e.value).image,
                      useSafeArea: false,
                      swipeDismissible: false,
                      doubleTapZoomable: true,
                    );
                  } else {
                    errorMessages(LocaleKeys.pictureSourceError.tr);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
                    child: e.value.toString().isEmpty
                        ? Image.asset("assets/notfound.png")
                        : Image.network(
                            e.value ?? "",
                            webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  isImageLoaded.value = true;
                                });
                                return child;
                              } else {
                                return Center(child: CircularProgressIndicator());
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              // **在错误回调中更新状态**
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                isImageLoaded.value = false;
                              });
                              return Image.asset("assets/notfound.png");
                            },
                          ),
                  ),
                ),
              );
            },
          );
        }

        // 销售状态
        if (e.columnName == "soldOut") {
          return CustomCell(data: e.value == 1 ? "Y" : "N");
        }
        //套餐
        if (e.columnName == "setMeal") {
          return CustomCell(data: e.value != null ? "Y" : "N");
        }
        // 其他列
        return CustomCell(data: e.value?.toString() ?? "");
      }).toList(),
    );
  }
}
