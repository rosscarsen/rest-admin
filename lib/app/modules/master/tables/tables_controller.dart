import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../config.dart';
import '../../../mixin/loading_state_mixin.dart';
import '../../../model/stock/stock_data.dart';
import '../../../model/tables/tables_data.dart';
import '../../../model/tables/tables_page_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_alert.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/file_storage.dart';
import 'tables_data_source.dart';

class TablesController extends GetxController with LoadingStateMixin<List<TablesData>?> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final ApiClient apiClient = ApiClient();
  final List<StockData> allStock = [];
  late TablesDataSource dataSource;
  @override
  void onInit() {
    super.onInit();
    updateDataGridSource();
  }

  @override
  void onClose() {
    allStock.clear();
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
      dataSource = TablesDataSource(this);
    });
  }

  /// 获取列表
  Future<void> getList() async {
    isLoading = true;
    data?.clear();
    try {
      formKey.currentState?.saveAndValidate();
      final param = {'page': currentPage, ...formKey.currentState?.value ?? {}};
      final DioApiResult dioApiResult = await apiClient.get(Config.tables, data: param);

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
      final resultModel = tablesPageModelFromJson(dioApiResult.data.toString());
      if (resultModel.status == 200) {
        data = resultModel.apiResult?.data ?? [];
        allStock
          ..clear()
          ..addAll(resultModel.apiResult?.allStock ?? []);
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
    Get.toNamed(Routes.TABLE_EDIT, parameters: id == null ? null : {'id': id.toString()});
  }

  /// 复制
  /// [id] 表ID
  void copy({String? id}) async {
    if (id == null) {
      CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
      return;
    }
    Get.toNamed(Routes.TABLE_EDIT, parameters: {'id': id.toString(), "copy": "Y"});
  }

  /// 删除单行数据
  void deleteRow(String? id) async {
    CustomAlert.iosAlert(
      showCancel: true,
      message: LocaleKeys.deleteConfirmMsg.tr,
      onConfirm: () async {
        try {
          CustomDialog.showLoading(LocaleKeys.deleting.tr);
          final DioApiResult dioApiResult = await apiClient.get(Config.tablesDelete, data: {"id": id});

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
              data?.removeWhere((element) => element.mId == id);
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
  Future<void> export() async {
    CustomDialog.showLoading(LocaleKeys.generating.trArgs(["excel"]));
    try {
      final DioApiResult dioApiResult = await apiClient.generateExcel(Config.exportTablesExcel);
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
      CustomDialog.errorMessages(LocaleKeys.generateFileFailed.tr);
    } finally {
      CustomDialog.dismissDialog();
    }
  }

  /// 导入
  Future<void> import({required File file}) async {
    CustomDialog.showLoading(LocaleKeys.importing.tr);
    try {
      final DioApiResult dioApiResult = await apiClient.uploadFile(file: file, uploadUrl: Config.importTablesExcel);
      if (!dioApiResult.success) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.importFailed.tr);
        return;
      }
      reloadData();
      CustomDialog.successMessages(LocaleKeys.importFileSuccess.tr);
    } catch (e) {
      CustomDialog.errorMessages(LocaleKeys.importFailed.tr);
    } finally {
      CustomDialog.dismissDialog();
    }
  }
}
