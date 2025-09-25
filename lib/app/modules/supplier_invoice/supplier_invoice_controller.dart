import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../config.dart';
import '../../model/supplierInvoice/supplier_invoice_api_model.dart';
import '../../routes/app_pages.dart';
import '../../service/dio_api_client.dart';
import '../../service/dio_api_result.dart';
import '../../translations/locale_keys.dart';
import '../../utils/custom_alert.dart';
import '../../utils/custom_dialog.dart';
import 'model/supplier_invoice_model.dart';
import 'supplier_invoice_data_source.dart';

class SupplierInvoiceController extends GetxController {
  final DataGridController dataGridController = DataGridController();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  static SupplierInvoiceController get to => Get.find();
  final isLoading = true.obs;
  final totalPages = 0.obs;
  final currentPage = 1.obs;
  final totalRecords = 0.obs;
  List<Invoice> dataList = [];
  final ApiClient apiClient = ApiClient();
  late SupplierInvoiceDataSource dataSource;
  RxBool hasPermission = true.obs;
  @override
  void onInit() {
    updateDataGridSource();
    super.onInit();
  }

  @override
  void onClose() {
    dataGridController.dispose();
    super.onClose();
  }

  /// 重载数据
  void reloadData() {
    FocusManager.instance.primaryFocus?.unfocus();
    totalPages.value = 0;
    currentPage.value = 1;
    updateDataGridSource();
  }

  /// 更新数据源
  void updateDataGridSource() {
    dataGridController.selectedRows = [];
    getList().then((_) {
      dataSource = SupplierInvoiceDataSource(this);
    });
  }

  /// 获取列表
  Future<void> getList() async {
    isLoading(true);
    dataList.clear();
    try {
      formKey.currentState?.saveAndValidate();
      final param = {'page': currentPage.value, ...formKey.currentState?.value ?? {}};
      final DioApiResult dioApiResult = await apiClient.get(Config.supplierInvoice, data: param);

      if (!dioApiResult.success) {
        if (!dioApiResult.hasPermission) {
          hasPermission.value = false;
        }
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (dioApiResult.data == null) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      hasPermission.value = true;
      //logger.f(dioApiResult.data);
      final resultModel = supplierInvoiceModelFromJson(dioApiResult.data.toString());

      dataList
        ..clear()
        ..addAll(resultModel.supplierInvoiceRet?.data ?? []);
      totalPages.value = (resultModel.supplierInvoiceRet?.lastPage ?? 0);
      totalRecords.value = (resultModel.supplierInvoiceRet?.total ?? 0);
    } catch (e) {
      CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
    } finally {
      isLoading(false);
    }
  }

  /// 编辑
  void edit({String? id}) async {
    Get.toNamed(Routes.SUPPLIER_INVOICE_EDIT, parameters: id == null ? null : {'id': id.toString()});
  }

  /// 删除单行数据
  void deleteRow({String? id}) async {
    CustomAlert.iosAlert(
      showCancel: true,
      message: LocaleKeys.deleteConfirmMsg.tr,
      onConfirm: () async {
        try {
          CustomDialog.showLoading(LocaleKeys.deleting.tr);
          final DioApiResult dioApiResult = await apiClient.get(Config.supplierInvoiceDelete, data: {"id": id});

          if (!dioApiResult.success) {
            CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
            return;
          }
          if (dioApiResult.data == null) {
            CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
            return;
          }
          final Map<String, dynamic> data = jsonDecode(dioApiResult.data!) as Map<String, dynamic>;
          switch (data['status']) {
            case 200:
              CustomDialog.successMessages(LocaleKeys.deleteSuccess.tr);
              dataList.removeWhere((element) => element.tSupplierInvoiceInId == id);
              dataSource.updateDataSource();
              break;
            case 201:
              CustomDialog.errorMessages(LocaleKeys.postedDataCannotBeDelete.tr);
              break;
            case 202:
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

  /// 过账
  Future<void> posting({String? id, String? flag}) async {
    final String type = (flag ?? '0') == "1" ? "0" : "1";
    CustomAlert.iosAlert(
      showCancel: true,
      message: "${type == "1" ? LocaleKeys.posting.tr : LocaleKeys.cancelPosting.tr}?",
      onConfirm: () async {
        try {
          CustomDialog.showLoading(LocaleKeys.operationInProgressPleaseWait.tr);
          final DioApiResult dioApiResult = await apiClient.get(
            Config.supplierInvoicePosting,
            data: {"id": id, "type": type},
          );

          if (!dioApiResult.success) {
            CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
            return;
          }
          if (dioApiResult.data == null) {
            CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
            return;
          }
          final Map<String, dynamic> data = jsonDecode(dioApiResult.data!) as Map<String, dynamic>;
          switch (data['status']) {
            case 200:
              final index = dataList.indexWhere((element) => element.tSupplierInvoiceInId == id);
              if (index != -1) {
                dataList[index].mFlag = dataList[index].mFlag == "1" ? "0" : "1";
              }
              dataSource.updateDataSource();
              break;
            case 201:
              CustomDialog.errorMessages(LocaleKeys.postedDataCannotBeDelete.tr);
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

  //打印发票
  Future<void> printInvoice({String? id}) async {
    if (id == null) {
      CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
      return;
    }
    Get.toNamed(Routes.PDF, parameters: {'type': 'supplierInvoice', 'id': id});
  }
}
