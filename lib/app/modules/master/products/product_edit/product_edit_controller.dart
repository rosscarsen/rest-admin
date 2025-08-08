import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../config.dart';
import '../../../../model/category_model.dart';
import '../../../../model/product_add_or_edit_model.dart';
import '../../../../model/products_model.dart';
import '../../../../model/unit_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../service/dio_api_client.dart';
import '../../../../service/dio_api_result.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/custom_alert.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../utils/form_help.dart';
import '../../../../utils/logger.dart';
import '../products_controller.dart';
import 'product_barcode_source.dart';
import 'product_edit_fields.dart';
import 'product_set_meal_limit_source.dart';
import 'product_set_meal_source.dart';
import 'product_stock_source.dart';

class ProductEditController extends GetxController with GetSingleTickerProviderStateMixin {
  final GlobalKey<FormBuilderState> productEditFormKey = GlobalKey<FormBuilderState>();
  final setMealController = TextEditingController();
  // 产品条码
  final DataGridController barcodeDataGridController = DataGridController();
  late ProductBarcodeSource productBarcodeSource;
  List<ProductBarcode> productBarcode = [];
  // 产品仓库
  final DataGridController stockDataGridController = DataGridController();
  late ProductStockSource productStockSource;
  List<ProductStock> productStock = [];
  // 套餐限制
  final DataGridController setMealLimitDataGridController = DataGridController();
  late SetMealLimitSource setMealLimitSource;
  List<SetMealLimit> productSetMealLimit = [];
  // 套餐
  final DataGridController setMealDataGridController = DataGridController();
  late ProductSetMealSource productSetMealSource;
  List<ProductSetMeal> productSetMeal = [];
  // Dio客户端
  final ApiClient apiClient = ApiClient();
  // 加载标识
  final isLoading = true.obs;
  // 页面标题
  final title = "".obs;
  // tab控制器
  late final TabController tabController;
  List<Tab> tabs = [
    Tab(text: LocaleKeys.product.tr),
    Tab(text: LocaleKeys.detail.tr),
    Tab(text: LocaleKeys.barcode.tr),
    Tab(text: LocaleKeys.shop.tr),
  ];
  final tabIndex = 0.obs;
  // 类目
  final category1 = <CategoryModel>[].obs;
  final category2 = <CategoryModel>[].obs;
  // 权限
  final hasPermission = true.obs;
  // 单位
  final units = <UnitModel>[].obs;
  // 全部类目用于多选类目
  final categories = <CategoryModel>[].obs;

  //产品ID
  int? productID;
  //多类
  RxList productCategory3 = [].obs;
  @override
  void onInit() {
    initParams();
    updateDataGridSource();
    super.onInit();
  }

  /// 重置状态
  void restState() {
    productEditFormKey.currentState?.reset();
  }

  /// 初始化参数
  void initParams() {
    final params = Get.parameters as Map<String, dynamic>?;
    productID = int.tryParse(params?["id"] ?? "");
    if (productID != null) {
      tabs.add(Tab(text: LocaleKeys.setMealLimit.tr));
      tabs.add(Tab(text: LocaleKeys.setMeal.tr));
    }
    title.value = productID == null
        ? "${LocaleKeys.add.tr}${LocaleKeys.product.tr}"
        : "${LocaleKeys.edit.tr}${LocaleKeys.product.tr}";

    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });
  }

  //更新数据源
  void updateDataGridSource() {
    barcodeDataGridController.selectedRows = [];
    stockDataGridController.selectedRows = [];
    setMealLimitDataGridController.selectedRows = [];
    setMealDataGridController.selectedRows = [];
    restState();
    productAddOrEdit().then((_) {
      productBarcodeSource = ProductBarcodeSource(this);
      productStockSource = ProductStockSource(this);
      setMealLimitSource = SetMealLimitSource(this);
      productSetMealSource = ProductSetMealSource(this);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    barcodeDataGridController.dispose();
    stockDataGridController.dispose();
    setMealLimitDataGridController.dispose();
    setMealDataGridController.dispose();
    super.onClose();
  }

  /// 生成二级类目
  void generateCategory2(String? selectCate1) {
    category2.clear();
    productEditFormKey.currentState?.fields[ProductEditFields.mCategory2]?.didChange("");
    if (selectCate1 == null || selectCate1.isEmpty) return;
    final parent = category1.firstWhereOrNull((e) => e.mCategory == selectCate1);
    if (parent != null && parent.children != null) {
      category2.assignAll(parent.children!);
    }
  }

  /// 获取单个产品数据
  Future<void> productAddOrEdit() async {
    isLoading(true);
    try {
      final DioApiResult dioApiResult = await apiClient.post(Config.productAddOrEdit, data: {'id': productID});

      if (!dioApiResult.success) {
        if (!dioApiResult.hasPermission) {
          hasPermission.value = false;
        }
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }

      if (dioApiResult.data == null) {
        CustomDialog.errorMessages(LocaleKeys.dataException.tr);
        return;
      }
      hasPermission.value = true;
      final result = productAddOrEditModelFromJson(dioApiResult.data!);
      final apiResult = result.apiResult;
      if (apiResult != null) {
        categories.value = apiResult.category ?? [];
        if (categories.isNotEmpty) {
          category1.assignAll(categories);
        }
        if (apiResult.productInfo != null) {
          final productInfo = apiResult.productInfo;
          if (productInfo != null) {
            productCategory3.value = productInfo.mCategory3?.split(",") ?? [];
            productEditFormKey.currentState?.patchValue(
              Map.fromEntries(productInfo.toJson().entries.where((e) => e.value != null)),
            );
          }
          productBarcode = apiResult.productBarcode ?? [];
          productStock = apiResult.productStock ?? [];
          productSetMealLimit = apiResult.setMealLimit ?? [];
          productSetMeal = apiResult.setMeal ?? [];
          units.assignAll(apiResult.units ?? []);
        }
      }
    } catch (e) {
      logger.i(e.toString());
      CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
    } finally {
      isLoading(false);
    }
  }

  /// 保存产品
  Future<void> productAddOrEditSave() async {
    if (productEditFormKey.currentState?.saveAndValidate() ?? false) {
      // 保存的時候要去除“平均成本”与“最后成本”
      // 创建与修改时间为当前时间

      final formData = Map<String, dynamic>.from(productEditFormKey.currentState!.value);

      final selectedMultipleCategory = formData.entries
          .where((e) => e.key.startsWith('multipleCategory_'))
          .expand((e) => e.value ?? [])
          .toList();

      formData['mCategory3'] = selectedMultipleCategory.isEmpty ? '' : selectedMultipleCategory.join(",");
      formData.removeWhere((key, value) => key.startsWith('multipleCategory_'));
      formData['T_Product_ID'] = productID;
      // 条码
      formData.addAll({'productBarcode': productBarcode});
      // 套餐限制
      formData.addAll({'productSetMealLimit': productSetMealLimit});
      try {
        CustomDialog.showLoading(LocaleKeys.saving.tr);
        final DioApiResult dioApiResult = await apiClient.post(Config.productAddOrEditSave, data: formData);
        if (!dioApiResult.success) {
          return CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        }
        final data = jsonDecode(dioApiResult.data) as Map<String, dynamic>;

        switch (data["status"]) {
          case 200:
            CustomDialog.successMessages(productID == null ? LocaleKeys.addSuccess.tr : LocaleKeys.editSuccess.tr);
            final apiData = data["apiResult"];
            final ProductData newProduct = ProductData.fromJson(apiData);
            final productCtl = Get.find<ProductsController>();
            if (productID == null) {
              productCtl.dataList.insert(0, newProduct);
            } else {
              final newID = newProduct.tProductId;
              final oldProduct = productCtl.dataList.firstWhereOrNull((element) => element.tProductId == newID);
              oldProduct?.copyForm(newProduct);
            }
            Get.back();
            productCtl.dataSource.updateDataSource();
            break;
          case 201:
            CustomDialog.errorMessages(
              LocaleKeys.codeExists.trArgs([productEditFormKey.currentState?.fields[ProductEditFields.mCode]?.value]),
            );
            break;
          case 202:
            CustomDialog.errorMessages(productID == null ? LocaleKeys.addFailed.tr : LocaleKeys.editFailed.tr);
            break;
          default:
            CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
            break;
        }
      } catch (e) {
        CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
      } finally {
        CustomDialog.dismissDialog();
      }
    } else {
      CustomDialog.errorMessages(LocaleKeys.theFormValidateFailed.tr);
    }
  }

  /// 编辑或添加产品条码
  Future<void> editOrAddProductBarcode({ProductBarcode? row}) async {
    final formKey = GlobalKey<FormState>();
    final bool isAdd = row == null;

    row ??= ProductBarcode(mProductCode: productEditFormKey.currentState?.fields[ProductEditFields.mCode]?.value);
    Get.defaultDialog(
      title: isAdd ? LocaleKeys.barcodeAdd.tr : LocaleKeys.barcodeEdit.tr,
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            TextFormField(
              initialValue: row.mCode,
              decoration: InputDecoration(labelText: LocaleKeys.code.tr),
              onChanged: (value) {
                row?.mCode = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.thisFieldIsRequired.tr;
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: row.mName,
              decoration: InputDecoration(labelText: LocaleKeys.name.tr),
              onChanged: (value) {
                row?.mName = value;
              },
            ),
            DropdownButtonFormField(
              value: row.mNonActived?.toString() ?? "0",
              decoration: InputDecoration(labelText: LocaleKeys.nonEnable.tr),
              items: [
                DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
              ],
              onChanged: (value) {
                row?.mNonActived = int.tryParse(value ?? "0");
              },
            ),
            TextFormField(
              initialValue: row.mRemarks,
              decoration: InputDecoration(labelText: LocaleKeys.remarks.tr),
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                row?.mRemarks = value;
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.closeDialog();
          },
          child: Text(LocaleKeys.cancel.tr),
        ),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState?.validate() ?? false) {
              CustomDialog.successMessages(isAdd ? LocaleKeys.addSuccess.tr : LocaleKeys.editSuccess.tr);
              if (isAdd) {
                row?.mNonActived ??= 0;
                productBarcode.insert(0, row!);
              }
              productBarcodeSource.updateDataSource();
              Get.closeDialog();
            }
          },
          child: Text(isAdd ? LocaleKeys.add.tr : LocaleKeys.edit.tr),
        ),
      ],
    );
  }

  /// 编辑产品套餐
  Future<void> editProductSetMeal({required ProductSetMeal row}) async {
    final ProductSetMeal oldRow = ProductSetMeal.fromJson(row.toJson());
    final formKey = GlobalKey<FormState>();
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        child: Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.setMealEdit.tr),
            leading: BackButton(
              onPressed: () {
                row.copyFrom(oldRow);
                Get.closeDialog();
              },
            ),
          ),

          persistentFooterButtons: [
            //取消
            ElevatedButton(
              onPressed: () {
                row.copyFrom(oldRow);
                Get.closeDialog();
              },
              child: Text(LocaleKeys.cancel.tr),
            ),
            //保存
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  final eq = const DeepCollectionEquality();
                  final isSame = eq.equals(row.toJson(), oldRow.toJson());
                  if (isSame) {
                    // 没有修改直接关闭
                    Get.closeDialog();
                    return;
                  }
                  CustomDialog.showLoading(LocaleKeys.saving.tr);
                  try {
                    final DioApiResult dioApiResult = await apiClient.post(
                      Config.productSetMealSave,
                      data: row.toJson(),
                    );
                    if (dioApiResult.success) {
                      if (dioApiResult.data != null) {
                        final data = jsonDecode(dioApiResult.data) as Map<String, dynamic>;
                        logger.e([data["status"], data["status"].runtimeType]);
                        if (data["status"] == 200) {
                          CustomDialog.successMessages(LocaleKeys.editSuccess.tr);
                          productSetMealSource.updateDataSource();
                          Get.closeDialog();
                        } else {
                          CustomDialog.errorMessages(LocaleKeys.editFailed.tr);
                        }
                      }
                    } else {
                      CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.editFailed.tr);
                    }
                  } catch (e) {
                    CustomDialog.errorMessages(e.toString());
                  } finally {
                    CustomDialog.dismissDialog();
                  }
                }
              },
              child: Text(LocaleKeys.save.tr),
            ),
          ],
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: ResponsiveGridRow(
                  children: [
                    //编号
                    FormHelper.buildGridCol(
                      child: FormHelper.textInput(
                        labelText: LocaleKeys.code.tr,
                        initialValue: row.mBarcode,
                        name: "mBarcode",
                        suffixIcon: IconButton(
                          onPressed: () {
                            Get.toNamed(Routes.OPEN_MULTIPLE_PRODUCT);
                          },
                          tooltip: LocaleKeys.selectProduct.tr,
                          icon: Icon(Icons.file_open, color: AppColors.openColor),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LocaleKeys.thisFieldIsRequired.tr;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          row.mBarcode = value;
                        },
                      ),
                    ),
                    //名称
                    FormHelper.buildGridCol(
                      child: FormHelper.textInput(
                        labelText: LocaleKeys.name.tr,
                        name: "mName",
                        enabled: false,
                        initialValue: row.mName,
                      ),
                    ),
                    //选项
                    FormHelper.buildGridCol(
                      child: FormHelper.selectInput(
                        labelText: LocaleKeys.option.tr,
                        name: "mStep",
                        initialValue: row.mStep?.toString() ?? "1",
                        items: List.generate(
                          9,
                          (index) =>
                              DropdownMenuItem(value: (index + 1).toString(), child: Text((index + 1).toString())),
                        ),
                        onChanged: (value) {
                          row.mStep = value;
                        },
                      ),
                    ),
                    //排序
                    FormHelper.buildGridCol(
                      child: FormHelper.textInput(
                        labelText: LocaleKeys.sort.tr,
                        name: "mSort",
                        keyboardType: TextInputType.number,
                        maxDecimalDigits: 0,
                        initialValue: row.mSort?.toString() ?? "0",
                        onChanged: (value) {
                          row.mSort = int.tryParse(value ?? "0");
                        },
                      ),
                    ),
                    //默认选择
                    FormHelper.buildGridCol(
                      child: FormHelper.checkbox(
                        name: "mDefault",
                        labelText: LocaleKeys.defaultSelect.tr,
                        initialValue: (row.mDefault?.toString() ?? "0") == "1",
                        onChanged: (value) {
                          if (value != null) {
                            row.mDefault = value ? 1 : 0;
                          }
                        },
                      ),
                    ),
                    //数量
                    FormHelper.buildGridCol(
                      child: FormHelper.textInput(
                        labelText: LocaleKeys.qty.tr,
                        name: "mQty",
                        keyboardType: TextInputType.number,
                        maxDecimalDigits: 2,
                        initialValue: row.mQty?.toString() ?? "0",
                        onChanged: (value) {
                          row.mQty = double.tryParse(value ?? "0")?.toStringAsFixed(2) ?? "0.00";
                        },
                      ),
                    ),
                    //价钱
                    FormHelper.buildGridCol(
                      child: FormHelper.textInput(
                        labelText: LocaleKeys.price.tr,
                        name: "mPrice",
                        keyboardType: TextInputType.number,
                        maxDecimalDigits: 2,
                        initialValue: row.mPrice?.toString() ?? "0",
                        onChanged: (value) {
                          row.mPrice = double.tryParse(value ?? "0")?.toStringAsFixed(2) ?? "0.00";
                        },
                      ),
                    ),
                    //撇數价钱
                    FormHelper.buildGridCol(
                      child: FormHelper.textInput(
                        labelText: LocaleKeys.scorePrice.tr,
                        name: "mPrice2",
                        keyboardType: TextInputType.number,
                        maxDecimalDigits: 2,
                        initialValue: row.mPrice2?.toString() ?? "0",
                        onChanged: (value) {
                          row.mPrice2 = double.tryParse(value ?? "0")?.toStringAsFixed(2) ?? "0.00";
                        },
                      ),
                    ),
                    //計鐘
                    FormHelper.buildGridCol(
                      child: FormHelper.selectInput(
                        labelText: LocaleKeys.scorePrice.tr,
                        name: "mFlag",
                        initialValue: row.mFlag?.toString() ?? "0",
                        onChanged: (value) {
                          row.mFlag = int.tryParse(value ?? "0");
                        },
                        items: [
                          DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                          DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                        ],
                      ),
                    ),
                    //售罄
                    FormHelper.buildGridCol(
                      child: FormHelper.selectInput(
                        labelText: LocaleKeys.soldOut.tr,
                        name: "Sold_out",
                        initialValue: row.soldOut?.toString() ?? "0",
                        items: [
                          DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                          DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                        ],
                        onChanged: (value) {
                          row.soldOut = int.tryParse(value ?? "0");
                        },
                      ),
                    ),
                    //备注
                    FormHelper.buildGridCol(
                      sm: 12,
                      md: 12,
                      xl: 12,
                      lg: 12,
                      child: FormHelper.textInput(
                        labelText: LocaleKeys.remarks.tr,
                        name: "mRemarks",
                        maxLines: 2,
                        initialValue: row.mRemarks,
                        onChanged: (value) {
                          row.mRemarks = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///批量删除套餐Item
  Future<void> batchDeleteSetMealItems() async {
    final selectedRows = setMealDataGridController.selectedRows;
    if (selectedRows.isEmpty) {
      CustomDialog.errorMessages(LocaleKeys.pleaseSelectOneDataOrMoreToDelete.tr);
      return;
    }
    await CustomAlert.iosAlert(
      LocaleKeys.deleteConfirmMsg.tr,

      showCancel: true,
      onConfirm: () async {
        // 选中ID
        final selectedIds = selectedRows
            .map((dataGridRow) {
              return dataGridRow.getCells().firstWhereOrNull((cell) => cell.columnName == 'ID')?.value;
            })
            .whereType<int>()
            .toList();
        await deleteSetMeal(selectedIds);
      },
    );
  }

  // 执行删除套餐
  Future<void> deleteSetMeal(List<int> ids) async {
    CustomDialog.showLoading(LocaleKeys.deleting.tr);
    try {
      final DioApiResult dioApiResult = await apiClient.post(Config.deleteProductSetMeal, data: {"mIds": ids});
      final Map<String, dynamic> data = jsonDecode(dioApiResult.data) as Map<String, dynamic>;
      if (data["status"] == 200) {
        CustomDialog.successMessages(LocaleKeys.deleteSuccess.tr);
        productSetMeal.removeWhere((rows) => ids.contains(rows.mId));
      } else {
        CustomDialog.errorMessages(LocaleKeys.deleteFailed.tr);
      }
    } catch (e) {
      CustomDialog.errorMessages(LocaleKeys.deleteFailed.tr);
    } finally {
      productSetMealSource.updateDataSource();
      CustomDialog.dismissDialog();
    }
  }

  // 从产品套餐复制
  Future<void> copyProductSetMeal(Map<String, dynamic> query) async {
    CustomDialog.showLoading(LocaleKeys.copying.tr);
    try {
      final DioApiResult dioApiResult = await apiClient.post(Config.copyProductSetMeal, data: query);
      final Map<String, dynamic> data = jsonDecode(dioApiResult.data) as Map<String, dynamic>;
      if (data["status"] == 200) {
        CustomDialog.successMessages(LocaleKeys.copySuccess.tr);
        productSetMeal
          ..clear()
          ..addAll((data["apiResult"] as List<dynamic>).map((e) => ProductSetMeal.fromJson(e)).toList());
        productSetMealSource.updateDataSource();
      } else {
        CustomDialog.errorMessages(LocaleKeys.copyFailed.tr);
      }
    } catch (e) {
      CustomDialog.errorMessages(LocaleKeys.copyFailed.tr);
    } finally {
      CustomDialog.dismissDialog();
    }
  }

  // 清除产品表setMenu栏位
  Future<void> updateSetMenu(String setMenu) async {
    CustomDialog.showLoading(LocaleKeys.saving.tr);
    try {
      final DioApiResult dioApiResult = await apiClient.post(
        Config.updateSetMenu,
        data: {"productID": productID, "setMenu": setMenu},
      );
      if (dioApiResult.success) {
        productEditFormKey.currentState?.fields[ProductEditFields.setMenu]?.didChange(setMenu);
        CustomDialog.successMessages(LocaleKeys.operationSuccess.tr);
      } else {
        CustomDialog.errorMessages(LocaleKeys.operationFailed.tr);
      }
    } catch (e) {
      CustomDialog.errorMessages(LocaleKeys.operationFailed.tr);
    } finally {
      CustomDialog.dismissDialog();
    }
  }

  // 按钮更新套餐
  Future<void> updateProductSetMeal() async {
    await CustomAlert.iosAlert(
      LocaleKeys.areYouSureToUpdate.tr,
      showCancel: true,
      onConfirm: () async {
        final String setMenu = setMealController.text;
        if (setMenu.isEmpty) {
          CustomDialog.errorMessages(LocaleKeys.dataIsEmptyDoNotOperation.tr);
          return;
        }
        final Map<String, dynamic> query = {"productID": productID, "setMenu": setMealController.text};
        try {
          final DioApiResult dioApiResult = await apiClient.post(Config.updateProductSetMeal, data: query);
          if (dioApiResult.success) {
            final data = jsonDecode(dioApiResult.data) as Map<String, dynamic>;
            switch (data["status"]) {
              case 200:
                CustomDialog.successMessages(LocaleKeys.operationSuccess.tr);
                final apiResult = data['apiResult'] as Map<String, dynamic>;
                final productSetMealLimitRet = apiResult['productSetMealLimit'] as List<dynamic>;
                productSetMealLimit
                  ..clear()
                  ..addAll(productSetMealLimitRet.map((e) => SetMealLimit.fromJson(e)).toList());
                productSetMealSource.updateDataSource();
                final productSetMealRet = apiResult['productSetMeal'] as List<dynamic>;
                productSetMeal
                  ..clear()
                  ..addAll(productSetMealRet.map((e) => ProductSetMeal.fromJson(e)).toList());
                productSetMealSource.updateDataSource();
                setMealLimitSource.updateDataSource();
                break;
              case 201:
                CustomDialog.errorMessages(LocaleKeys.dataIsEmptyDoNotOperation.tr);
                break;
              default:
                CustomDialog.errorMessages(LocaleKeys.updateFailed.tr);
                break;
            }
          } else {
            CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.operationFailed.tr);
          }
        } catch (e) {
          CustomDialog.errorMessages(LocaleKeys.operationFailed.tr);
        }
      },
    );
  }
}
