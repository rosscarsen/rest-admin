import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../model/customer/customer_data.dart';
import '../../../model/customer/customer_page_model.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_dialog.dart';
import 'open_customer_data_source.dart';

class OpenCustomerController extends GetxController {
  final DataGridController dataGridController = DataGridController();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  static DataGridController get to => Get.find();
  final isLoading = true.obs;
  final totalPages = 0.obs;
  final currentPage = 1.obs;
  final totalRecords = 0.obs;
  List<CustomerData> dataList = [];
  final ApiClient apiClient = ApiClient();
  late OpenCustomerDataSource dataSource;
  // 客户类型
  final customerTypes = <String>[].obs;
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
      dataSource = OpenCustomerDataSource(this);
    });
  }

  /// 获取列表
  Future<void> getList() async {
    isLoading(true);
    dataList.clear();
    try {
      formKey.currentState?.saveAndValidate();
      final param = {'page': currentPage.value, "checkPermission": false, ...formKey.currentState?.value ?? {}};

      final DioApiResult dioApiResult = await apiClient.post(Config.openCustomer, data: param);

      if (!dioApiResult.success) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (dioApiResult.data == null) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }

      final resultModel = customerPageModelFromJson(dioApiResult.data.toString());
      if (resultModel.status == 200) {
        dataList
          ..clear()
          ..addAll(resultModel.apiResult?.data ?? []);
        totalPages.value = (resultModel.apiResult?.lastPage ?? 0);
        totalRecords.value = (resultModel.apiResult?.total ?? 0);
      } else {
        CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
      }
    } finally {
      isLoading(false);
    }
  }
}
