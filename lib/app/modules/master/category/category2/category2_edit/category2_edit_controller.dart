import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../../../config.dart';
import '../../../../../model/category/category_model.dart';
import '../../../../../model/printer/printer_all_model.dart';
import '../../../../../model/printer/printer_model.dart';
import '../../../../../service/dio_api_client.dart';
import '../../../../../service/dio_api_result.dart';
import '../../../../../translations/locale_keys.dart';
import '../../../../../utils/custom_dialog.dart';
import '../../../../../utils/functions.dart';
import '../../../../../utils/logger.dart';
import '../../category_edit/category_fields.dart';
import '../category2_controller.dart';

class Category2EditController extends GetxController {
  Category2EditController({this.id});
  final int? id;
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  // Dio客户端
  final ApiClient apiClient = ApiClient();
  final title = "${LocaleKeys.categoryAdd.tr}2".obs;
  // 权限
  final hasPermission = true.obs;
  // 加载标识
  final isLoading = true.obs;

  final printerList = <PrinterModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    if (id != null) {
      title.value = "${LocaleKeys.categoryEdit.tr}2";
    }

    addOrEdit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 刷新数据
  Future<void> refreshData() async {
    await addOrEdit();
  }

  /// 添加或编辑
  Future<void> addOrEdit() async {
    isLoading(true);
    try {
      final futures = [
        apiClient.post(Config.printer, data: {"checkPermission": false}),
        apiClient.post(Config.category2AddOrEdit, data: {'id': id}),
      ];

      final results = await Future.wait(futures);
      for (int i = 0; i < results.length; i++) {
        //打印机
        if (i == 0) {
          final DioApiResult printerDioApiResult = results[i];
          if (!printerDioApiResult.success) {
            if (!printerDioApiResult.hasPermission) {
              hasPermission.value = false;
            }
            CustomDialog.errorMessages(printerDioApiResult.error ?? LocaleKeys.unknownError.tr);
            continue;
          }
          final printerDioApiResultData = printerDioApiResult.data;
          if (printerDioApiResultData == null) {
            CustomDialog.errorMessages(LocaleKeys.dataException.tr);
            continue;
          }
          hasPermission.value = true;
          final printerAllModel = printerAllModelFromJson(printerDioApiResultData);
          if (printerAllModel.apiResult == null) {
            continue;
          }
          printerList.assignAll(printerAllModel.apiResult!);
        }
        //类目2详细信息
        if (i == 1) {
          final DioApiResult category2DioApiResult = results[i];
          if (!category2DioApiResult.success) {
            if (!category2DioApiResult.hasPermission) {
              hasPermission.value = false;
            }
            CustomDialog.errorMessages(category2DioApiResult.error ?? LocaleKeys.unknownError.tr);
            return;
          }
          final category2DioApiResultData = category2DioApiResult.data;
          if (category2DioApiResultData == null) {
            CustomDialog.errorMessages(LocaleKeys.dataException.tr);
            return;
          }
          hasPermission.value = true;
          final editData = json.decode(category2DioApiResultData) as Map<String, dynamic>;
          final apiResult = editData["apiResult"];
          if (apiResult == null) {
            return;
          }
          final CategoryModel category2Model = CategoryModel.fromJson(apiResult);
          formKey.currentState?.patchValue(
            Map.fromEntries(
              category2Model.toJson().entries.where((e) => e.value != null).map((e) {
                final key = e.key;
                var value = e.value;
                if (['mNonContinue', 'mContinue'].contains(key)) {
                  value = (value == 1 || value == '1');
                } else if (value != null) {
                  value = value.toString();
                }
                return MapEntry(key, value);
              }),
            ),
          );
          FocusManager.instance.primaryFocus?.unfocus();
        }
      }
    } catch (e) {
      logger.i(e.toString());
      CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
    } finally {
      isLoading(false);
    }
  }

  /// 保存
  Future<void> save() async {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final categoryCtl = Get.find<Category2Controller>();
      //CustomDialog.showLoading(id == null ? LocaleKeys.adding.tr : LocaleKeys.updating.tr);
      final Map<String, dynamic> formData = {CategoryFields.T_Category_ID: id, ...formKey.currentState?.value ?? {}};
      if (id != null) {
        final oldRow = categoryCtl.dataList.firstWhereOrNull((e) => e.tCategoryId.toString() == id.toString());

        if (oldRow != null) {
          final isSame = Functions.compareMap(oldRow.toJson(), formData);
          if (isSame) {
            CustomDialog.dismissDialog();
            Get.closeDialog();
            return;
          }
        }
      }
      try {
        final DioApiResult dioApiResult = await apiClient.post(Config.categorySave, data: formData);
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
              categoryCtl.reloadData();
              Get.closeDialog();
              return;
            }
            final categoryModel = CategoryModel.fromJson(apiResult);
            if (id == null) {
              categoryCtl.dataList.insert(0, categoryModel);
            } else {
              final index = categoryCtl.dataList.indexWhere((element) => element.tCategoryId == id);
              if (index != -1) {
                categoryCtl.dataList[index] = categoryModel;
              }
            }
            categoryCtl.dataSource.updateDataSource();
            Get.closeDialog();
            break;
          case 201:
            CustomDialog.errorMessages(
              LocaleKeys.codeExists.trArgs([formKey.currentState?.fields[CategoryFields.mCategory]?.value]),
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
}
