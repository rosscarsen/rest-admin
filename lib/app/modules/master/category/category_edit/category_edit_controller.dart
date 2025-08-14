import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../../config.dart';
import '../../../../model/category_model.dart';
import '../../../../service/dio_api_client.dart';
import '../../../../service/dio_api_result.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../utils/functions.dart';
import '../../../../utils/logger.dart';
import '../category_controller.dart';
import 'category_fields.dart';

class CategoryEditController extends GetxController {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  // Dio客户端
  final ApiClient apiClient = ApiClient();
  final title = LocaleKeys.categoryAdd.tr.obs;
  // 权限
  final hasPermission = true.obs;
  int? id;
  // 加载标识
  final isLoading = true.obs;
  CategoryModel? oldRow;
  @override
  void onInit() {
    super.onInit();
    final params = Get.parameters;
    if (params.isNotEmpty) {
      final oldRowString = params['row'];

      if (oldRowString != null) {
        oldRow = CategoryModel.fromJson(json.decode(utf8.decode(base64.decode(oldRowString))));
        id = oldRow?.tCategoryId;
        title.value = LocaleKeys.categoryEdit.tr;
      }
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
      final DioApiResult dioApiResult = await apiClient.post(Config.categoryAddOrEdit, data: {'id': id});
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
      final CategoryModel categoryModel = CategoryModel.fromJson(apiResult);

      formKey.currentState?.patchValue(
        Map.fromEntries(
          categoryModel.toJson().entries.where((e) => e.value != null).map((e) => MapEntry(e.key, e.value.toString())),
        ),
      );
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
      CustomDialog.showLoading(oldRow == null ? LocaleKeys.adding.tr : LocaleKeys.updating.tr);
      final Map<String, dynamic> formData = {CategoryFields.T_Category_ID: id, ...formKey.currentState?.value ?? {}};
      if (oldRow != null) {
        final isSame = Functions.compareMap(oldRow!.toJson(), formData);
        if (isSame) {
          CustomDialog.dismissDialog();
          Get.back();
          return;
        }
      }
      try {
        final DioApiResult dioApiResult = await apiClient.post(Config.categorySave, data: formData);
        if (!dioApiResult.success) {
          CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
          return;
        }
        final data = json.decode(dioApiResult.data!) as Map<String, dynamic>;
        logger.e(data);
        switch (data["status"]) {
          case 200:
            final categoryCtl = Get.find<CategoryController>();
            CustomDialog.successMessages(oldRow == null ? LocaleKeys.addSuccess.tr : LocaleKeys.updateSuccess.tr);
            final apiResult = data["apiResult"];
            if (apiResult == null) {
              categoryCtl.reloadData();
              Get.back();
              return;
            }
            final categoryModel = CategoryModel.fromJson(apiResult);
            if (oldRow == null) {
              categoryCtl.dataList.insert(0, categoryModel);
            } else {
              final index = categoryCtl.dataList.indexWhere((element) => element.tCategoryId == oldRow?.tCategoryId);
              if (index != -1) {
                categoryCtl.dataList[index] = categoryModel;
              }
            }
            categoryCtl.dataSource.updateDataSource();
            Get.back();
            break;
          case 201:
            CustomDialog.errorMessages(
              LocaleKeys.codeExists.trArgs([formKey.currentState?.fields[CategoryFields.mCategory]?.value]),
            );
            break;
          case 202:
            CustomDialog.errorMessages(oldRow == null ? LocaleKeys.addFailed.tr : LocaleKeys.updateFailed.tr);
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
