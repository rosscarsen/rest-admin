import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../mixin/loading_state_mixin.dart';
import '../../../model/customer/customer_data.dart';
import '../../../model/customer/customer_page_model.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_dialog.dart';
import 'open_customer_data_source.dart';

class OpenCustomerController extends GetxController with LoadingStateMixin {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  static DataGridController get to => Get.find();
  List<CustomerData> dataList = [];
  final ApiClient apiClient = ApiClient();
  late OpenCustomerDataSource dataSource;
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
      dataSource = OpenCustomerDataSource(this);
    });
  }

  /// 获取列表
  Future<void> getList() async {
    isLoading = true;
    dataList.clear();
    try {
      formKey.currentState?.saveAndValidate();
      final param = {'page': currentPage, "checkPermission": false, ...formKey.currentState?.value ?? {}};

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
        totalPages = (resultModel.apiResult?.lastPage ?? 0);
        totalRecords = (resultModel.apiResult?.total ?? 0);
      } else {
        CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
      }
    } finally {
      isLoading = false;
    }
  }
}
