import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../config.dart';
import '../../../../model/category/category_model.dart';
import '../../../../service/dio_api_client.dart';
import '../../../../service/dio_api_result.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/custom_alert.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../model/category/category_page_model.dart';
import 'category2_data_source.dart';
import 'category2_edit/category2_edit_view.dart';

class Category2Controller extends GetxController {
  final DataGridController dataGridController = DataGridController();
  static Category2Controller get to => Get.find();
  final isLoading = true.obs;
  final totalPages = 0.obs;
  final currentPage = 1.obs;
  final totalRecords = 0.obs;
  List<CategoryModel> dataList = [];
  final ApiClient apiClient = ApiClient();
  late Category2DataSource dataSource;
  RxBool hasPermission = true.obs;

  // 第一类目编号
  String category1 = "";

  @override
  void onInit() {
    category1 = Get.parameters["mCategory"] ?? "";
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
    getCategory().then((_) {
      dataSource = Category2DataSource(this);
    });
  }

  /// 获取分类2列表
  Future<void> getCategory() async {
    isLoading(true);
    dataList.clear();
    try {
      final param = {'page': currentPage.value, 'category1': category1};
      final DioApiResult dioApiResult = await apiClient.post(Config.category2, data: param);
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
    Get.dialog(Category2EditView(id: id, category1: category1));
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
}
