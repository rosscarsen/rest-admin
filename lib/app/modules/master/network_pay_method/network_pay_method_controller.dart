import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../config.dart';
import '../../../mixin/loading_state_mixin.dart';
import '../../../model/network_pay_method/network_pay_method_data.dart';
import '../../../model/network_pay_method/network_pay_method_page_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_alert.dart';
import '../../../utils/custom_dialog.dart';
import 'network_pay_method_data_source.dart';

class NetworkPayMethodController extends GetxController with LoadingStateMixin<List<NetworkPayMethodData>?> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final ApiClient apiClient = ApiClient();
  late NetworkPayMethodDataSource dataSource;
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
      dataSource = NetworkPayMethodDataSource(this);
    });
  }

  /// 获取列表
  Future<void> getList() async {
    isLoading = true;
    data?.clear();
    try {
      formKey.currentState?.saveAndValidate();
      final param = {'page': currentPage, ...formKey.currentState?.value ?? {}};
      final DioApiResult dioApiResult = await apiClient.get(Config.networkPaymentMethod, data: param);

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
      final resultModel = networkPayMethodPageModelFromJson(dioApiResult.data.toString());
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
    Get.toNamed(Routes.NET_WORK_PAY_METHOD_EDIT, parameters: id == null ? null : {'id': id.toString()});
  }

  /// 删除单行数据
  void deleteRow(String? id) async {
    CustomAlert.iosAlert(
      showCancel: true,
      message: LocaleKeys.deleteConfirmMsg.tr,
      onConfirm: () async {
        try {
          CustomDialog.showLoading(LocaleKeys.deleting.tr);
          final DioApiResult dioApiResult = await apiClient.get(Config.networkPaymentMethodDelete, data: {"id": id});

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
              data?.removeWhere((element) => element.id == id);
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
