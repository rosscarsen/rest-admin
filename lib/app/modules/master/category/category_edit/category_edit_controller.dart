import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../../config.dart';
import '../../../../model/category/category_model.dart';
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
  String? id;
  // 加载标识
  final isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    final params = Get.parameters;
    if (params.isNotEmpty) {
      id = params['id'];
      if (id != null) {
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
      final CategoryModel resultModel = CategoryModel.fromJson(apiResult);

      formKey.currentState?.patchValue(
        Map.fromEntries(
          resultModel.toJson().entries.where((e) => e.value != null).map((e) => MapEntry(e.key, e.value.toString())),
        ),
      );
      FocusManager.instance.primaryFocus?.unfocus();
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
      final parentCtl = Get.find<CategoryController>();
      CustomDialog.showLoading(id == null ? LocaleKeys.adding.tr : LocaleKeys.updating.tr);
      final Map<String, dynamic> formData = {CategoryFields.T_Category_ID: id, ...formKey.currentState?.value ?? {}};
      if (id != null) {
        final oldRow = parentCtl.dataList.firstWhereOrNull((e) => e.tCategoryId.toString() == id);
        if (oldRow != null) {
          final isSame = Functions.compareMap(oldRow.toJson(), formData);
          if (isSame) {
            CustomDialog.dismissDialog();
            Get.back();
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
              parentCtl.reloadData();
              Get.back();
              return;
            }
            final resultModel = CategoryModel.fromJson(apiResult);
            if (id == null) {
              parentCtl.dataList.insert(0, resultModel);
            } else {
              final index = parentCtl.dataList.indexWhere((element) => element.tCategoryId.toString() == id);
              if (index != -1) {
                parentCtl.dataList[index] = resultModel;
              }
            }
            parentCtl.dataSource.updateDataSource();
            Get.back();
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
