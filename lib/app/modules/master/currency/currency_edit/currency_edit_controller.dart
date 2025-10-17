import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../../../config.dart';
import '../../../../mixin/loading_state_mixin.dart';
import '../../../../model/currency/currency_data.dart';
import '../../../../service/dio_api_client.dart';
import '../../../../service/dio_api_result.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../utils/functions.dart';
import '../../../../utils/logger.dart';
import '../../../../utils/storage_manage.dart';
import '../currency_controller.dart';
import 'model/currency_edit_model.dart';

class CurrencyEditController extends GetxController with LoadingStateMixin<CurrencyData> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final StorageManage storageManage = StorageManage();

  /// Dio客户端
  final ApiClient apiClient = ApiClient();

  String? id;
  //编辑前的数据
  CurrencyData? oldRow;

  @override
  void onInit() {
    super.onInit();
    title = LocaleKeys.addParam.trArgs([LocaleKeys.currency.tr]);
    final params = Get.parameters;
    if (params.isNotEmpty) {
      id = params['id'];
      if (id != null) {
        title = LocaleKeys.editParam.trArgs([LocaleKeys.currency.tr]);
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
      final DioApiResult dioApiResult = await apiClient.get(Config.currencyAddOrEdit, data: {'id': id});
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
      final resultModel = currencyEditModelFromJson(dioApiResult.data);

      if (resultModel.status == 200 && resultModel.apiResult != null) {
        oldRow = data = resultModel.apiResult;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final jsonMap = Map<String, dynamic>.from(data?.toJson() ?? {});
          final filteredMap = Map.fromEntries(
            jsonMap.entries
                .where((e) => (e.value?.toString() ?? "").trim().isNotEmpty)
                .map((e) => MapEntry(e.key, e.value is String ? e.value.toString() : e.value)),
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
      final preCtl = Get.find<CurrencyController>();
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
        final DioApiResult dioApiResult = await apiClient.post(Config.currencySave, data: requestData);
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
            final resultModel = CurrencyData.fromJson(apiResult);
            if (id == null) {
              preCtl.dataList.insert(0, resultModel);
            } else {
              final index = preCtl.dataList.indexWhere((element) => element.tMoneyCurrencyId.toString() == id);
              if (index != -1) {
                preCtl.dataList[index] = resultModel;
              }
            }
            preCtl.dataSource.updateDataSource();
            Get.back();
            break;
          case 201:
            CustomDialog.errorMessages(LocaleKeys.codeExists.trArgs([LocaleKeys.code.tr]));
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
        CustomDialog.dismissDialog();
      }
    }
  }
}
