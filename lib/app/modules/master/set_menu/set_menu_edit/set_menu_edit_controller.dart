import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../config.dart';
import '../../../../mixin/loading_state_mixin.dart';
import '../../../../service/dio_api_client.dart';
import '../../../../service/dio_api_result.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/custom_alert.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../utils/form_help.dart';
import '../../../../utils/logger.dart';
import '../set_menu_controller.dart';
import 'model/set_menu_edit_model.dart';
import 'set_menu_detail_source.dart';
import 'set_menu_limit_source.dart';

class SetMenuEditController extends GetxController
    with GetSingleTickerProviderStateMixin, LoadingStateMixin<SetMenuEdit> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  late SetMenuLimitSource setMenuLimitSource;
  // 套餐
  final DataGridController setMealDataGridController = DataGridController();
  late SetMenuSetMealSource setMealDetailSource;
  // Dio客户端
  final ApiClient apiClient = ApiClient();

  // tab控制器
  late final TabController tabController;
  List<Tab> tabs = [Tab(text: LocaleKeys.setMealLimit.tr)];
  final tabIndex = 0.obs;

  // 套餐明细搜索广本
  String searchText = "";

  //ID
  String? id;
  //多类
  RxList productCategory3 = [].obs;
  @override
  void onInit() {
    super.onInit();
    initParams();
    updateDataGridSource();
  }

  /// 初始化参数
  void initParams() {
    title = LocaleKeys.addParam.trArgs([LocaleKeys.setMeal.tr]);
    final params = Get.parameters;
    if (params.isNotEmpty) {
      id = params['id'];
      if (id != null) {
        title = LocaleKeys.editParam.trArgs([LocaleKeys.setMeal.tr]);
      }
    }
    if (id != null) {
      tabs.add(Tab(text: LocaleKeys.setMeal.tr));
    }
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  //更新数据源
  void updateDataGridSource() {
    setMealDataGridController.selectedRows = [];
    addOrEdit().then((_) {
      setMenuLimitSource = SetMenuLimitSource(this);
      setMealDetailSource = SetMenuSetMealSource(this);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    setMealDataGridController.dispose();
    super.onClose();
  }

  /// 添加或编辑
  Future<void> addOrEdit() async {
    data = null;
    isLoading = true;
    try {
      final DioApiResult dioApiResult = await apiClient.get(Config.setMenuAddOrEdit, data: {'id': id});

      if (!dioApiResult.success) {
        if (!dioApiResult.hasPermission) {
          hasPermission = false;
        }
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }

      if (dioApiResult.data == null) {
        CustomDialog.errorMessages(LocaleKeys.dataException.tr);
        return;
      }
      hasPermission = true;
      final result = setMenuEditModelFromJson(dioApiResult.data!);
      final apiResult = result.apiResult;

      if (apiResult != null) {
        data = apiResult;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          formKey.currentState?.patchValue(
            Map.fromEntries(
              apiResult
                  .toJson()
                  .entries
                  .where((e) => (e.value?.toString() ?? "").trim().isNotEmpty)
                  .map((e) => MapEntry(e.key, e.value)),
            ),
          );
        });
      }
    } catch (e) {
      logger.i(e.toString());
      CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
    } finally {
      isLoading = false;
    }
  }

  /// 保存产品
  Future<void> save() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final formData = Map<String, dynamic>.from(formKey.currentState!.value)
        ..["id"] = id
        ..["setMenuLimit"] = data?.setLimit;

      try {
        CustomDialog.showLoading(LocaleKeys.saving.tr);
        final DioApiResult dioApiResult = await apiClient.post(Config.setMenuSave, data: formData);
        if (!dioApiResult.success) {
          return CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        }
        final data = jsonDecode(dioApiResult.data) as Map<String, dynamic>;

        switch (data["status"]) {
          case 200:
            CustomDialog.successMessages(id == null ? LocaleKeys.addSuccess.tr : LocaleKeys.editSuccess.tr);

            final preCtl = Get.find<SetMenuController>();
            Get.back();
            preCtl.reloadData();
            break;
          case 201:
            CustomDialog.errorMessages(LocaleKeys.codeExists.trArgs([LocaleKeys.code.tr]));
            break;
          case 202:
            CustomDialog.errorMessages(id == null ? LocaleKeys.addFailed.tr : LocaleKeys.editFailed.tr);
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
    }
  }

  /// 套餐明细搜索
  void setMenuDetailSearch(String? searchText) {
    setMealDetailSource.filter(searchText);
  }

  /// 编辑产品套餐
  Future<void> editSetMenuDetail({required SetMenuDetail row}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final SetMenuDetail oldRow = SetMenuDetail.fromJson(row.toJson());
    final formKey = GlobalKey<FormState>();
    Get.dialog(
      barrierDismissible: true,
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
                      Config.setMenuDetailSave,
                      data: row.toJson(),
                    );
                    if (dioApiResult.success) {
                      if (dioApiResult.data != null) {
                        final data = jsonDecode(dioApiResult.data) as Map<String, dynamic>;
                        if (data["status"] == 200) {
                          CustomDialog.successMessages(LocaleKeys.editSuccess.tr);
                          setMealDetailSource.filter(searchText);
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
                child: FormHelper.buildGridRow(
                  children: [
                    //编号
                    FormHelper.buildGridCol(
                      child: FormHelper.textInput(
                        labelText: LocaleKeys.code.tr,
                        initialValue: row.mBarcode,
                        name: "mBarcode",
                        readOnly: true,
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
                          row.mSort = value ?? "0";
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
                            row.mDefault = value ? "1" : "0";
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
                          row.mFlag = value ?? "0";
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
                          row.soldOut = value ?? "0";
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
  Future<void> batchDeleteItems() async {
    final selectedRows = setMealDataGridController.selectedRows;
    if (selectedRows.isEmpty) {
      CustomDialog.errorMessages(LocaleKeys.pleaseSelectOneDataOrMoreToDelete.tr);
      return;
    }
    await CustomAlert.iosAlert(
      message: LocaleKeys.deleteConfirmMsg.tr,
      showCancel: true,
      onConfirm: () async {
        // 选中ID
        final selectedIds = selectedRows
            .map((dataGridRow) {
              return dataGridRow.getCells().firstWhereOrNull((cell) => cell.columnName == 'ID')?.value;
            })
            .whereType<String>()
            .toList();
        logger.i("删除套餐明细ID: $selectedIds");
        await deleteItems(selectedIds);
      },
    );
  }

  // 执行删除套餐
  Future<void> deleteItems(List<String> ids) async {
    CustomDialog.showLoading(LocaleKeys.deleting.tr);
    try {
      final DioApiResult dioApiResult = await apiClient.post(Config.deleteMenuDetail, data: {"mIds": ids});
      final Map<String, dynamic> apiData = jsonDecode(dioApiResult.data) as Map<String, dynamic>;
      if (apiData["status"] == 200) {
        CustomDialog.successMessages(LocaleKeys.deleteSuccess.tr);
        data?.setMenuDetail?.removeWhere((rows) => ids.contains(rows.mId));
      } else {
        CustomDialog.errorMessages(LocaleKeys.deleteFailed.tr);
      }
    } catch (e) {
      CustomDialog.errorMessages(LocaleKeys.deleteFailed.tr);
    } finally {
      setMealDetailSource.updateDataSource();
      CustomDialog.dismissDialog();
    }
  }

  /// 复制套餐明细
  Future<void> copySetMenuDetail(String code) async {
    CustomDialog.showLoading(LocaleKeys.copying.tr);
    try {
      final DioApiResult dioApiResult = await apiClient.post(Config.copySetMenuDetail, data: {"code": code, "id": id});
      final Map<String, dynamic> apiData = jsonDecode(dioApiResult.data) as Map<String, dynamic>;
      if (apiData["status"] == 200) {
        if (apiData["apiResult"] == null) {
          return;
        }
        CustomDialog.successMessages(LocaleKeys.copySuccess.tr);
        (data?.setMenuDetail ?? [])
          ..clear()
          ..addAll((apiData["apiResult"] as List<dynamic>).map((e) => SetMenuDetail.fromJson(e)).toList());
        setMealDetailSource.filter(searchText);
      } else {
        CustomDialog.errorMessages(LocaleKeys.copyFailed.tr);
      }
    } catch (e) {
      CustomDialog.errorMessages(LocaleKeys.copyFailed.tr);
    } finally {
      CustomDialog.dismissDialog();
    }
  }

  /*// 从产品套餐复制
  /*  Future<void> copyProductSetMeal(Map<String, dynamic> query) async {
    CustomDialog.showLoading(LocaleKeys.copying.tr);
    try {
      final DioApiResult dioApiResult = await apiClient.post(Config.copyProductSetMeal, data: query);
      final Map<String, dynamic> data = jsonDecode(dioApiResult.data) as Map<String, dynamic>;
      if (data["status"] == 200) {
        if (data["apiResult"] == null) {
          return;
        }
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
 */
  */
  /*// 按钮更新套餐
  Future<void> updateProductSetMeal() async {
    await CustomAlert.iosAlert(
      message: LocaleKeys.areYouSureToUpdate.tr,
      showCancel: true,
      onConfirm: () async {
        final String setMenu = productEditFormKey.currentState?.fields[ProductEditFields.setMenu]?.value ?? "";
        if (setMenu.isEmpty) {
          CustomDialog.errorMessages(LocaleKeys.dataIsEmptyDoNotOperation.tr);
          return;
        }
        final Map<String, dynamic> query = {"productID": productID, "setMenu": setMenu};
        try {
          final DioApiResult dioApiResult = await apiClient.post(Config.updateProductSetMeal, data: query);
          if (dioApiResult.success) {
            final data = jsonDecode(dioApiResult.data) as Map<String, dynamic>;
            switch (data["status"]) {
              case 200:
                if (data['apiResult'] == null) {
                  return;
                }
                CustomDialog.successMessages(LocaleKeys.operationSuccess.tr);
                final apiResult = data['apiResult'] as Map<String, dynamic>;
                final productSetMealLimitRet = apiResult['productSetMealLimit'] is List<dynamic>
                    ? apiResult['productSetMealLimit'] as List<dynamic>
                    : [];
                productSetMealLimit
                  ..clear()
                  ..addAll(productSetMealLimitRet.map((e) => SetMealLimit.fromJson(e)).toList());
                final productSetMealRet = apiResult['productSetMeal'] is List<dynamic>
                    ? apiResult['productSetMeal'] as List<dynamic>
                    : [];
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
 */
}
