import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../model/product_remarks_model.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_dialog.dart';
import 'open_product_remarks_data_source.dart';

class OpenProductRemarksController extends GetxController {
  final DataGridController dataGridController = DataGridController();
  final TextEditingController searchController = TextEditingController();
  static OpenProductRemarksController get to => Get.find();
  final isLoading = true.obs;
  final totalPages = 0.obs;
  final currentPage = 1.obs;
  final totalRecords = 0.obs;
  List<ProductRemarksInfo> DataList = [];
  final ApiClient apiClient = ApiClient();
  late OpenProductRemarksDataSource dataSource;
  @override
  void onInit() {
    updateDataGridSource();
    super.onInit();
  }

  @override
  void onClose() {
    dataGridController.dispose();
    searchController.dispose();
    super.onClose();
  }

  //重载数据
  void reloadData() {
    FocusManager.instance.primaryFocus?.unfocus();
    totalPages.value = 0;
    currentPage.value = 1;
    updateDataGridSource();
  }

  //更新数据源
  void updateDataGridSource() {
    getData().then((_) {
      dataSource = OpenProductRemarksDataSource(this);
    });
  }

  ///获取产品列表
  Future<void> getData() async {
    isLoading(true);
    DataList.clear();
    try {
      Map<String, Object> search = {'page': currentPage.value};
      if (searchController.text.isNotEmpty) search['search'] = searchController.text;
      final DioApiResult dioApiResult = await apiClient.post(Config.openProductRemark, data: search);

      if (!dioApiResult.success) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (!dioApiResult.hasPermission) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.noPermission.tr);
        return;
      }
      if (dioApiResult.data == null) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      final productRemarksModel = productRemarksModelFromJson(dioApiResult.data!);
      if (productRemarksModel.status == 200) {
        final ProductRemarksResult? apiResult = productRemarksModel.apiResult;
        DataList = apiResult?.productRemarksInfo ?? [];
        totalPages.value = apiResult?.lastPage ?? 0;
        totalRecords.value = apiResult?.total ?? 0;
      }
    } finally {
      isLoading(false);
    }
  }
}
