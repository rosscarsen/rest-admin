import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../../config.dart';
import '../../../../model/product_remarks_model.dart';
import '../../../../service/dio_api_client.dart';
import '../../../../service/dio_api_result.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../utils/form_help.dart';
import '../../../../utils/functions.dart';
import '../../../../utils/logger.dart';
import '../product_remarks_controller.dart';
import 'product_remarks_detail_data_source.dart';
import 'product_remarks_fields.dart';

class ProductRemarksEditController extends GetxController with GetSingleTickerProviderStateMixin {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  // Dio客户端
  final ApiClient apiClient = ApiClient();
  final title = LocaleKeys.addProductRemarks.tr.obs;
  // 权限
  final hasPermission = true.obs;
  String? id;
  // 加载标识
  final isLoading = true.obs;
  late final TabController tabController = TabController(vsync: this, length: 2);
  final tabIndex = 0.obs;
  late ProductRemarksDetailDataSource dataSource;
  List<RemarksDetail> dataList = [];
  final productRemarksCtl = Get.find<ProductRemarksController>();
  @override
  void onInit() {
    super.onInit();
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });
    final params = Get.parameters;
    if (params.isNotEmpty) {
      id = params['id'];
      if (id != null) {
        title.value = LocaleKeys.editProductRemarks.tr;
      }
    }
    updateDataGridSource();
  }

  /// 更新数据源
  void updateDataGridSource() {
    addOrEdit().then((_) {
      dataSource = ProductRemarksDetailDataSource(this);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  /// 添加或编辑
  Future<void> addOrEdit() async {
    isLoading(true);
    try {
      final DioApiResult dioApiResult = await apiClient.post(Config.productRemarkAddOrEdit, data: {'id': id});
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
      final data = json.decode(dioApiResult.data!) as Map<String, dynamic>;
      final apiResult = data["apiResult"];
      if (apiResult == null) {
        return;
      }
      final ProductRemarksInfo resultModel = ProductRemarksInfo.fromJson(apiResult);
      dataList
        ..clear()
        ..addAll(resultModel.remarksDetails ?? []);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        formKey.currentState?.patchValue(
          Map.fromEntries(
            resultModel.toJson().entries.where((e) => e.value != null).map((e) {
              final key = e.key;
              var value = e.value;
              if (['mVisible'].contains(key)) {
                value = !(value == 1 || value == '1');
              } else if (value != null) {
                value = value.toString();
              }
              return MapEntry(key, value);
            }),
          ),
        );
      });
    } catch (e) {
      logger.i(e.toString());
      CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
    } finally {
      isLoading(false);
    }
  }

  /// 检测页面数据是否发生变化
  Object checkPageDataChange() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final Map<String, dynamic> formData = {
        ProductRemarksFields.mId: id,
        ...formKey.currentState?.value ?? {},
        ...{"remarksDetails": dataList.map((e) => e.toJson()).toList()},
      };
      formData.forEach((key, value) {
        if (key == ProductRemarksFields.mVisible) {
          formData[key] = value == "1" ? "0" : "1";
        }
      });
      if (id != null) {
        final oldRow = productRemarksCtl.dataList.firstWhereOrNull((e) => e.mId.toString() == id);
        if (oldRow != null) {
          final isSame = Functions.compareMap(oldRow.toJson(), formData);
          if (isSame) {
            return true;
          }
        }
      }
      return formData;
    } else {
      return id == null ? true : false;
    }
  }

  /// 食品备注保存
  Future<void> save() async {
    final checkResult = checkPageDataChange();
    if (checkResult is bool) {
      if (checkResult) {
        // 数据未发生变化
        Get.back();
      }
      // 表单未验证通过
      return;
    }

    if (checkResult is Map<String, dynamic>) {
      CustomDialog.showLoading(id == null ? LocaleKeys.adding.tr : LocaleKeys.updating.tr);
      try {
        final DioApiResult dioApiResult = await apiClient.post(Config.productRemarkSave, data: checkResult);
        if (!dioApiResult.success) {
          CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
          return;
        }
        final data = json.decode(dioApiResult.data!) as Map<String, dynamic>;
        switch (data["status"]) {
          case 200:
            CustomDialog.successMessages(id == null ? LocaleKeys.addSuccess.tr : LocaleKeys.updateSuccess.tr);
            final apiResult = data["apiResult"];
            if (apiResult == null) {
              productRemarksCtl.reloadData();
              Get.back();
              return;
            }
            final resultModel = ProductRemarksInfo.fromJson(apiResult);
            if (id == null) {
              productRemarksCtl.dataList.insert(0, resultModel);
            } else {
              final index = productRemarksCtl.dataList.indexWhere((element) => element.mId.toString() == id);
              if (index != -1) {
                productRemarksCtl.dataList[index] = resultModel;
              }
            }
            productRemarksCtl.dataSource.updateDataSource();
            Get.back();
            break;
          case 201:
            CustomDialog.errorMessages(
              LocaleKeys.codeExists.trArgs([formKey.currentState?.fields[ProductRemarksFields.mRemark]?.value]),
            );
            break;
          case 202:
            CustomDialog.errorMessages(id == null ? LocaleKeys.addFailed.tr : LocaleKeys.updateFailed.tr);
            break;
          default:
            CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
        }
      } catch (e) {
        CustomDialog.errorMessages(e.toString());
      } finally {
        CustomDialog.dismissDialog();
      }
    }
  }

  /// 编辑详情
  Future<void> editOrAddDetail({RemarksDetail? row}) async {
    final formKey = GlobalKey<FormState>();
    final bool isAdd = row == null;
    row ??= RemarksDetail(mType: 0, mOverwrite: 0, mDetail: "", mPrice: "0.00");
    final RemarksDetail oldRow = RemarksDetail.fromJson(row.toJson());
    Get.dialog(
      barrierDismissible: false,
      Scaffold(
        appBar: AppBar(
          title: Text(isAdd ? LocaleKeys.addProductRemarksDetail.tr : LocaleKeys.editProductRemarksDetail.tr),
          leading: BackButton(onPressed: () => Get.closeDialog()),
        ),
        persistentFooterButtons: [
          //取消
          FormHelper.cancelButton(onPressed: () => Get.closeDialog()),
          //保存
          FormHelper.saveButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final isSame = Functions.compareMap(row?.toJson() ?? {}, oldRow.toJson());
                if (isSame) {
                  Get.closeDialog();
                  return;
                }
                if (isAdd) {
                  final String mDetail = row?.mDetail?.trim() ?? "";
                  if (dataList.any((element) => element.mDetail == mDetail)) {
                    CustomDialog.errorMessages(LocaleKeys.codeExists.trArgs([mDetail]));
                    return;
                  }
                }
                if (isAdd && row != null) {
                  final maxId = dataList.map((e) => e.mId).nonNulls.maxOrNull ?? 0;
                  row.mId = maxId + 1;
                  dataList.add(row);
                } else {
                  row?.copyFrom(row);
                }
                sortData();
                Get.closeDialog();
              }
            },
          ),
        ],
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: FormHelper.buildGridRow(
                children: [
                  //明细
                  FormHelper.buildGridCol(
                    child: FormHelper.textInput(
                      labelText: LocaleKeys.detail.tr,
                      initialValue: row.mDetail ?? "",
                      name: "mDetail",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.thisFieldIsRequired.tr;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        row?.mDetail = value?.trim() ?? "";
                      },
                    ),
                  ),
                  //类型
                  FormHelper.buildGridCol(
                    child: Row(
                      spacing: 4.0,
                      children: [
                        Expanded(
                          child: FormHelper.selectInput(
                            labelText: LocaleKeys.type.tr,
                            name: "mType",
                            initialValue: row.mType,
                            items: [
                              DropdownMenuItem(value: 0, child: Text(LocaleKeys.addMoney.tr)),
                              DropdownMenuItem(value: 1, child: Text("${LocaleKeys.discount.tr}(%)")),
                              DropdownMenuItem(value: 2, child: Text("${LocaleKeys.multiple.tr}(*n)")),
                            ],
                            onChanged: (value) {
                              row?.mType = value;
                            },
                          ),
                        ),
                        Expanded(
                          child: FormHelper.textInput(
                            name: "mPrice",
                            labelText: "",
                            initialValue: row.mPrice,
                            onChanged: (value) {
                              row?.mPrice = value?.trim() ?? "0.00";
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  //分类
                  FormHelper.buildGridCol(
                    child: FormHelper.textInput(
                      name: "mRemarkType",
                      labelText: LocaleKeys.classification.tr,
                      initialValue: row.mRemarkType?.toString() ?? "",
                      onChanged: (value) {
                        row?.mRemarkType = int.tryParse(value ?? "0");
                      },
                      keyboardType: TextInputType.number,
                      maxDecimalDigits: 0,
                    ),
                  ),
                  //覆盖
                  FormHelper.buildGridCol(
                    child: FormHelper.checkbox(
                      labelText: LocaleKeys.overWrite.tr,
                      name: "mOverwrite",
                      initialValue: row.mOverwrite == 1,
                      onChanged: (value) {
                        row?.mOverwrite = value == true ? 1 : 0;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 表格数据排序
  void sortData() {
    dataList.asMap().forEach((index, element) {
      element.mId = index + 1;
    });
    dataSource.updateDataSource();
  }
}
