import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../model/category/category_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_alert.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/file_storage.dart';
import '../../../utils/logger.dart';
import 'category_data_source.dart';
import '../../../model/category/category_page_model.dart';

class CategoryController extends GetxController {
  final DataGridController dataGridController = DataGridController();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  static CategoryController get to => Get.find();
  final isLoading = true.obs;
  final totalPages = 0.obs;
  final currentPage = 1.obs;
  final totalRecords = 0.obs;
  List<CategoryModel> dataList = [];
  final ApiClient apiClient = ApiClient();
  late CategoryDataSource dataSource;
  RxBool hasPermission = true.obs;
  @override
  void onInit() {
    updateDataGridSource();
    super.onInit();
  }

  @override
  void onClose() {
    dataGridController.dispose();
    dataSource.dispose();
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
      dataSource = CategoryDataSource(this);
    });
  }

  /// 获取列表
  Future<void> getList() async {
    isLoading(true);
    dataList.clear();
    try {
      formKey.currentState?.saveAndValidate();
      final param = {'page': currentPage.value, ...formKey.currentState?.value ?? {}};
      final DioApiResult dioApiResult = await apiClient.post(Config.categories, data: param);

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
      final categoryModel = CategoryPageModelFromJson(dioApiResult.data.toString());
      if (categoryModel.status == 200) {
        dataList
          ..clear()
          ..addAll(categoryModel.apiResult?.data ?? []);
        totalPages.value = (categoryModel.apiResult?.lastPage ?? 0);
        totalRecords.value = (categoryModel.apiResult?.total ?? 0);
      } else {
        CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
      }
    } finally {
      isLoading(false);
    }
  }

  /// 编辑
  void edit({int? id}) async {
    Get.toNamed(Routes.CATEGORY_EDIT, parameters: id == null ? null : {'id': id.toString()});
  }

  /// 删除单行数据
  void deleteRow(int? id) async {
    CustomAlert.iosAlert(
      showCancel: true,
      LocaleKeys.deleteConfirmMsg.tr,
      onConfirm: () async {
        try {
          CustomDialog.showLoading(LocaleKeys.deleting.tr);
          final DioApiResult dioApiResult = await apiClient.post(Config.categoryDelete, data: {"id": id});

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
              dataList.removeWhere((element) => element.tCategoryId == id);
              dataSource.updateDataSource();
              break;
            case 201:
              CustomDialog.errorMessages(LocaleKeys.ftpConnectFailed.tr);
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

  /// 导出类目
  Future<void> exportCategory({int? id}) async {
    CustomDialog.showLoading(LocaleKeys.generating.trArgs(["excel"]));
    try {
      final DioApiResult dioApiResult = await apiClient.generateExcel(
        Config.exportCategoryExcel,
        queryParameters: {"id": id},
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

  /// 导入类目
  Future<void> importCategory({required File file}) async {
    CustomDialog.showLoading(LocaleKeys.importing.tr);
    try {
      final DioApiResult dioApiResult = await apiClient.uploadFile(file: file, uploadUrl: Config.importCategoryExcel);
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

  /// 打开类目2
  void openChildCategory(CategoryModel? row) {
    Get.toNamed(
      Routes.CATEGORY2,
      parameters: {'mCategory': row?.mCategory ?? "", "categoryID": row?.tCategoryId?.toString() ?? ""},
    );
  }
}
