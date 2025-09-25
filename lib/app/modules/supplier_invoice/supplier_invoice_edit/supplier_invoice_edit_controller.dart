import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:rest_admin/app/service/dio_api_client.dart';

import '../../../config.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/logger.dart';
import '../model/supplier_invoice_edit_model.dart';

class SupplierInvoiceEditController extends GetxController {
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
      final DioApiResult dioApiResult = await apiClient.post(Config.supplierInvoiceAddOrEdit, data: {'id': id});
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
      final resultModel = supplierInvoiceEditModelFromJson(dioApiResult.data);
      final SupplierInvoiceEditResult? apiData = resultModel.apiResult;
      if (apiData == null) {
        return;
      }

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
    FocusManager.instance.primaryFocus?.unfocus();
    /* if (formKey.currentState?.saveAndValidate() ?? false) {
      CustomDialog.showLoading(LocaleKeys.saving.tr);
      final formData = Map<String, dynamic>.from(formKey.currentState?.value ?? {})
        ..addAll({"T_Customer_ID": id})
        ..addAll({"customerContact": customerContactList})
        ..addAll({"customerDiscount": customerDiscountList});
      logger.f(formData);
      try {
        final DioApiResult dioApiResult = await apiClient.post(Config.customerSave, data: formData);
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
              CustomerController.to.reloadData();
              Get.back();
              return;
            }
            final resultModel = CustomerData.fromJson(apiResult);
            final customerCtl = Get.find<CustomerController>();
            if (id == null) {
              customerCtl.dataList.insert(0, resultModel);
            } else {
              final index = customerCtl.dataList.indexWhere((element) => element.tCustomerId.toString() == id);
              if (index != -1) {
                customerCtl.dataList[index] = resultModel;
              }
            }
            customerCtl.dataSource.updateDataSource();
            Get.back();
            break;
          case 201:
            CustomDialog.errorMessages(LocaleKeys.codeExists.trArgs([LocaleKeys.code.tr]));
            break;
          case 202:
            CustomDialog.errorMessages(LocaleKeys.codeExists.trArgs([LocaleKeys.mobile.tr]));
            break;
          default:
            CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
        }
      } catch (e) {
        CustomDialog.errorMessages(e.toString());
      } finally {
        CustomDialog.dismissDialog();
      }
    } */
  }
}
