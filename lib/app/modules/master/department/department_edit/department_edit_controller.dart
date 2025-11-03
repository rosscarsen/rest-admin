import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../../../config.dart';
import '../../../../mixin/loading_state_mixin.dart';
import '../../../../model/department/department_data.dart';
import '../../../../model/department/department_edit_model.dart';
import '../../../../service/dio_api_client.dart';
import '../../../../service/dio_api_result.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../utils/functions.dart';
import '../../../../utils/logger.dart';
import '../../../../utils/storage_manage.dart';
import '../department_controller.dart';

class DepartmentEditController extends GetxController with LoadingStateMixin<DepartmentData> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final StorageManage storageManage = StorageManage();

  /// Dio客户端
  final ApiClient apiClient = ApiClient();

  String? id;
  //编辑前的数据
  DepartmentData? oldRow;

  @override
  void onInit() {
    super.onInit();
    title = LocaleKeys.addParam.trArgs([LocaleKeys.department.tr]);
    final params = Get.parameters;
    if (params.isNotEmpty) {
      id = params['id'];
      if (id != null) {
        title = LocaleKeys.editParam.trArgs([LocaleKeys.department.tr]);
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
    oldRow = null;
    super.onClose();
  }

  /// 刷新数据
  Future<void> refreshData() async {
    await addOrEdit();
  }

  /// 添加或编辑
  Future<void> addOrEdit() async {
    isLoading = true;
    data = null;
    oldRow = null;
    try {
      final DioApiResult dioApiResult = await apiClient.get(Config.departmentAddOrEdit, data: {'id': id});
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
      final resultModel = departmentEditModelFromJson(dioApiResult.data);

      if (resultModel.status == 200 && resultModel.apiResult != null) {
        oldRow = data = resultModel.apiResult;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final jsonMap = Map<String, dynamic>.from(data?.toJson() ?? {});
          final filteredMap = Map.fromEntries(
            jsonMap.entries
                .where((e) => (e.value?.toString() ?? "").trim().isNotEmpty)
                .map((e) => MapEntry(e.key, e.value is PhoneNumber ? e.value : e.value.toString())),
          );
          formKey.currentState?.patchValue(filteredMap);
        });
      }
    } catch (e) {
      CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
    } finally {
      isLoading = false;
    }
  }

  /// 保存
  Future<void> save() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final preCtl = Get.find<DepartmentController>();
      final formData = formKey.currentState?.value ?? {};
      //如果是编辑检测一下数据是否有变化
      if (id != null) {
        final oldJson = (oldRow?.toJson() ?? {}).map(
          (key, value) => MapEntry(
            key,
            value is PhoneNumber
                ? value.nsn.isNotEmpty
                      ? '+${value.countryCode}${value.nsn}'
                      : ""
                : value,
          ),
        );
        final isSame = Functions.compareMap(oldJson, formData);
        if (isSame) {
          Get.back();
          return;
        }
      }
      //发送网络保存请求
      CustomDialog.showLoading(LocaleKeys.saving.tr);
      final requestData = {...formData, "id": id};
      try {
        final DioApiResult dioApiResult = await apiClient.post(Config.departmentSave, data: requestData);
        logger.f(dioApiResult);
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
              preCtl.reloadData();
              Get.back();
              return;
            }
            final resultModel = DepartmentData.fromJson(apiResult);
            if (id == null) {
              preCtl.data?.insert(0, resultModel);
            } else {
              final index = preCtl.data?.indexWhere((element) => element.tBrandId.toString() == id) ?? -1;
              if (index != -1) {
                preCtl.data?[index] = resultModel;
              }
            }
            preCtl.dataSource.updateDataSource();
            Get.back();
            break;
          case 201:
            CustomDialog.errorMessages(LocaleKeys.codeExists.trArgs([LocaleKeys.department.tr]));
            break;
          case 202:
            CustomDialog.errorMessages(LocaleKeys.saveFailed.tr);
            break;
          default:
            CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
        }
      } catch (e) {
        CustomDialog.errorMessages(e.toString());
      } finally {
        requestData.clear();
        CustomDialog.dismissDialog();
      }
    }
  }
}
