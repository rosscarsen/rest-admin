import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../mixin/loading_state_mixin.dart';
import '../../../model/customer/customer_data.dart';
import '../../../model/customer/customer_page_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_alert.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/file_storage.dart';
import '../../../utils/logger.dart';
import 'customer_data_source.dart';

class CustomerController extends GetxController with LoadingStateMixin {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  static CustomerController get to => Get.find();

  List<CustomerData> dataList = [];
  final ApiClient apiClient = ApiClient();
  late CustomerDataSource dataSource;
  // 客户类型
  final customerTypes = <String>[].obs;
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
      dataSource = CustomerDataSource(this);
    });
  }

  /// 获取列表
  Future<void> getList() async {
    isLoading = true;
    dataList.clear();
    try {
      formKey.currentState?.saveAndValidate();
      final param = {'page': currentPage, ...formKey.currentState?.value ?? {}};
      final futures = [apiClient.get(Config.customerType), apiClient.get(Config.customer, data: param)];
      final results = await Future.wait(futures);
      // 客户类型
      final DioApiResult customerTypeResult = results[0];
      if (customerTypeResult.success) {
        final customerTypeApiData = json.decode(customerTypeResult.data) as Map<String, dynamic>;
        final customerTypeApiResult = customerTypeApiData["apiResult"];
        if (customerTypeApiResult != null) {
          customerTypes.assignAll((customerTypeApiResult as List<dynamic>).map((e) => e.toString()).toList());
        }
      }
      // 客户列表
      final DioApiResult customerResult = results[1];
      if (!customerResult.success) {
        if (!customerResult.hasPermission) {
          hasPermission = false;
        }
        CustomDialog.errorMessages(customerResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (customerResult.data == null) {
        CustomDialog.errorMessages(customerResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      hasPermission = true;

      final resultModel = customerPageModelFromJson(customerResult.data.toString());
      if (resultModel.status == 200) {
        dataList
          ..clear()
          ..addAll(resultModel.apiResult?.data ?? []);
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
    Get.toNamed(Routes.CUSTOMER_EDIT, parameters: id == null ? null : {'id': id.toString()});
  }

  /// 删除单行数据
  void deleteRow(String? id) async {
    CustomAlert.iosAlert(
      showCancel: true,
      message: LocaleKeys.deleteConfirmMsg.tr,
      onConfirm: () async {
        try {
          CustomDialog.showLoading(LocaleKeys.deleting.tr);
          final DioApiResult dioApiResult = await apiClient.post(Config.customerDelete, data: {"id": id});

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
              dataList.removeWhere((element) => element.tCustomerId == id);
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

  /// 导出
  Future<void> exportExcel({required Map<String, dynamic> query}) async {
    CustomDialog.showLoading(LocaleKeys.generating.trArgs(["excel"]));
    try {
      final DioApiResult dioApiResult = await apiClient.generateExcel(
        Config.exportCustomerExcel,
        queryParameters: query,
      );
      if (!dioApiResult.success) {
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.noPermission.tr);
        return;
      }
      if (dioApiResult.data is Uint8List) {
        FileStorage.saveFileToDownloads(
          bytes: dioApiResult.data as Uint8List,
          fileName: dioApiResult.fileName!,
          fileType: DownloadFileType.Excel,
        );
      }
    } catch (e) {
      logger.i(e);
      CustomDialog.errorMessages(LocaleKeys.generateFileFailed.tr);
    } finally {
      CustomDialog.dismissDialog();
    }
  }

  /// 导入
  Future<void> importExcel({required File file, required Map<String, dynamic> query}) async {
    CustomDialog.showLoading(LocaleKeys.importing.tr);
    try {
      final DioApiResult dioApiResult = await apiClient.uploadFile(
        file: file,
        uploadUrl: Config.importCustomerExcel,
        extraData: query,
      );

      if (!dioApiResult.success) {
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.importFailed.tr);
        return;
      }
      reloadData();
      CustomDialog.successMessages(LocaleKeys.importFileSuccess.tr);
    } catch (e) {
      CustomDialog.showToast(LocaleKeys.importFailed.tr);
    } finally {
      CustomDialog.dismissDialog();
    }
  }
}
