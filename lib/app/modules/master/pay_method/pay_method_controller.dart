import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../config.dart';
import '../../../mixin/loading_state_mixin.dart';
import '../../../model/pay_method/pay_method_data.dart';
import '../../../model/pay_method/pay_method_page_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_alert.dart';
import '../../../utils/custom_dialog.dart';
import 'pay_method_data_source.dart';

class PayMethodController extends GetxController with LoadingStateMixin<List<PayMethodData>?> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final ApiClient apiClient = ApiClient();
  late PayMethodDataSource dataSource;
  @override
  void onInit() {
    super.onInit();
    updateDataGridSource();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 重载数据
  void reloadData() {
    FocusManager.instance.primaryFocus?.unfocus();
    totalPages = 0;
    currentPage = 1;
    updateDataGridSource();
  }

  /// 更新数据源
  void updateDataGridSource() {
    getList().then((_) {
      dataSource = PayMethodDataSource(this);
    });
  }

  /// 获取列表
  Future<void> getList() async {
    isLoading = true;
    data?.clear();
    try {
      formKey.currentState?.saveAndValidate();
      final param = {
        'page': currentPage,
        ...formKey.currentState?.value ?? {},
        "lang": (Get.locale?.toString() ?? "zh_HK").toLowerCase(),
      };
      final DioApiResult dioApiResult = await apiClient.get(Config.paymentMethod, data: param);

      if (!dioApiResult.success) {
        if (!dioApiResult.hasPermission) {
          hasPermission = false;
        }
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (dioApiResult.data == null) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      hasPermission = true;
      //logger.f(dioApiResult.data);
      final resultModel = payMethodPageModelFromJson(dioApiResult.data.toString());
      if (resultModel.status == 200) {
        data = resultModel.apiResult?.data ?? [];
        totalPages = (resultModel.apiResult?.lastPage ?? 0);
        totalRecords = (resultModel.apiResult?.total ?? 0);
      } else {
        CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
      }
    } finally {
      isLoading = false;
    }
  }

  /// 编辑
  void edit({String? id}) async {
    Get.toNamed(Routes.PAY_METHOD_EDIT, parameters: id == null ? null : {'id': id.toString()});
  }

  /// 删除单行数据
  void deleteRow(String? id) async {
    CustomAlert.iosAlert(
      showCancel: true,
      message: LocaleKeys.deleteConfirmMsg.tr,
      onConfirm: () async {
        try {
          CustomDialog.showLoading(LocaleKeys.deleting.tr);
          final DioApiResult dioApiResult = await apiClient.get(Config.paymentMethodDelete, data: {"id": id});

          if (!dioApiResult.success) {
            CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
            return;
          }
          if (dioApiResult.data == null) {
            CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
            return;
          }
          final Map<String, dynamic> apiData = jsonDecode(dioApiResult.data!) as Map<String, dynamic>;
          switch (apiData['status']) {
            case 200:
              CustomDialog.successMessages(LocaleKeys.deleteSuccess.tr);
              data?.removeWhere((element) => element.tPayTypeId == id);
              dataSource.updateDataSource();
              break;
            case 201:
              CustomDialog.errorMessages(LocaleKeys.deleteFailed.tr);
              break;
            default:
              CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
          }
        } catch (e) {
          CustomDialog.errorMessages(LocaleKeys.deleteFailed.tr);
        } finally {
          CustomDialog.dismissDialog();
        }
      },
    );
  }
}
